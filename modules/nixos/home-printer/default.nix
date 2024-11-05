{ pkgs, ... }:

{

  # Printer at home
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  programs.system-config-printer.enable = true;

  hardware.printers.ensurePrinters = [
    {
      name = "home";
      description = "Home Printer HP Color LaserJet 2600n";
      location = "Gothenburg, Sweden";
      deviceUri = "socket://192.168.10.233:9100";
      model = "drv:///hp/hpcups.drv/hp-color_laserjet_2600n.ppd";
    }
  ];

}
