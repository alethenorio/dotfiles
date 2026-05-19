/**
 * Status Line Extension for Pi
 *
 * Inspired by claudeline (https://github.com/fredrikaverpil/claudeline)
 * Displays context usage, total cost, token counts, and model info in a custom footer.
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  // Track session stats
  let turnCount = 0;
  let isStreaming = false;

  pi.on("session_start", async (_event, ctx) => {
    turnCount = 0;
    isStreaming = false;

    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsub,
        invalidate() {},
        render(width: number): string[] {
          // Calculate token usage from session
          let inputTokens = 0;
          let outputTokens = 0;
          let cacheReadTokens = 0;
          let cacheWriteTokens = 0;
          let totalCost = 0;

          for (const entry of ctx.sessionManager.getBranch()) {
            if (
              entry.type === "message" &&
              entry.message.role === "assistant"
            ) {
              const msg = entry.message as AssistantMessage;
              inputTokens += msg.usage.input;
              outputTokens += msg.usage.output;
              cacheReadTokens += msg.usage.cacheRead ?? 0;
              cacheWriteTokens += msg.usage.cacheWrite ?? 0;
              totalCost += msg.usage.cost.total;
            }
          }

          // Get context usage (tokens used vs model limit)
          const contextUsage = ctx.getContextUsage();
          const contextTokens = contextUsage?.tokens ?? 0;
          const contextLimit =
            contextUsage?.limit ?? ctx.model?.contextWindow ?? 200000;
          const contextPercent =
            contextLimit > 0 ? (contextTokens / contextLimit) * 100 : 0;

          // Format helpers
          const fmt = (n: number): string => {
            if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
            if (n >= 1_000) return `${(n / 1_000).toFixed(1)}k`;
            return `${n}`;
          };

          const fmtCost = (n: number): string => {
            if (n >= 1) return `$${n.toFixed(2)}`;
            if (n >= 0.01) return `$${n.toFixed(3)}`;
            return `$${n.toFixed(4)}`;
          };

          // Separator
          const sep = theme.fg("dim", " │ ");

          // Model name (light blue via accent)
          const modelStr = theme.fg("accent", ctx.model?.id ?? "no-model");

          // Choose context bar color based on usage
          let contextColor: "success" | "warning" | "error" | "muted" = "muted";
          if (contextPercent >= 90) contextColor = "error";
          else if (contextPercent >= 75) contextColor = "warning";
          else if (contextPercent >= 50) contextColor = "success";

          // Build context bar (visual representation)
          const barWidth = 10;
          const filledWidth = Math.round((contextPercent / 100) * barWidth);
          const emptyWidth = barWidth - filledWidth;
          const contextBar =
            theme.fg(contextColor, "█".repeat(filledWidth)) +
            theme.fg("dim", "░".repeat(emptyWidth));

          // Context usage bar and percentage
          const contextInfo = `${contextBar} ${theme.fg(contextColor, `${contextPercent.toFixed(0)}%`)} ${theme.fg("muted", `(${fmt(contextTokens)}/${fmt(contextLimit)})`)}`;

          // Token stats
          const tokenStats = theme.fg(
            "muted",
            `↑${fmt(inputTokens)} ↓${fmt(outputTokens)}`,
          );

          // Cache info (if any)
          const cacheInfo =
            cacheReadTokens > 0 || cacheWriteTokens > 0
              ? theme.fg(
                  "muted",
                  `📖${fmt(cacheReadTokens)} 📝${fmt(cacheWriteTokens)}`,
                )
              : "";

          // Cost
          const costInfo = theme.fg("success", fmtCost(totalCost));

          // Git branch
          const branch = footerData.getGitBranch();
          const branchStr = branch ? theme.fg("muted", branch) : "";

          // Turn indicator
          const turnIndicator = isStreaming
            ? theme.fg("warning", `● T${turnCount}`)
            : turnCount > 0
              ? theme.fg("success", `✓ T${turnCount}`)
              : "";

          // Assemble the footer with pipe separators
          // Left: model | context bar | tokens | cache (if any) | cost
          const leftParts = [modelStr, contextInfo, tokenStats];
          if (cacheInfo) leftParts.push(cacheInfo);
          leftParts.push(costInfo);
          const left = leftParts.join(sep);

          // Right: turn indicator | git branch
          const rightParts: string[] = [];
          if (turnIndicator) rightParts.push(turnIndicator);
          if (branchStr) rightParts.push(branchStr);
          const right = rightParts.join(sep);

          const leftWidth = visibleWidth(left);
          const rightWidth = visibleWidth(right);
          const padding = Math.max(1, width - leftWidth - rightWidth);

          return [truncateToWidth(left + " ".repeat(padding) + right, width)];
        },
      };
    });
  });

  // Track turn progress
  pi.on("turn_start", async (_event, _ctx) => {
    turnCount++;
    isStreaming = true;
  });

  pi.on("turn_end", async (_event, _ctx) => {
    isStreaming = false;
  });

  // Command to toggle the footer on/off
  pi.registerCommand("statusline", {
    description: "Toggle the custom status line footer",
    handler: async (_args, ctx) => {
      // Toggle by checking if we have a custom footer
      // Since we always set it on session_start, toggling means restoring default
      ctx.ui.setFooter(undefined);
      ctx.ui.notify("Status line disabled. Restart pi to re-enable.", "info");
    },
  });
}
