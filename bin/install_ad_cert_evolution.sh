#!/bin/bash

hash onecn || PATH=$PATH:/opt/elx/bin

onecn -i -s || exit 1 

CERT_DIR=$(mktemp -d)

klist -s || { zenity --text-info --filename=/opt/elx/share/evolution-add-cert/message_1 --title="No valid kerberos ticket" --width=400 --height=200 2> /dev/null ; exit ; }

MY_USER="unknown"
MY_OBJECT=$(zenity --entry --title="Get User Certificate" --entry-text=$MY_USER --text="Enter valid e-mail address or signum in lower case:" 2>/dev/null)

regex_signum="^[a-zA-Z\-]{5,9}$"
regex_mail="(.+@.+)$"

if [[ "$MY_OBJECT" =~ $regex_mail ]]; then 
  ATTR=mail
elif [[ "$MY_OBJECT" =~ $regex_signum ]]; then
  ATTR=cn
else
  exit -1
fi

BINDDN='-D DC=company,DC=se'
BASE='-b DC=company,DC=se'
URI='-H ldap://ldapname.company.se'

ldapsearch -LLL $BASE $BINDDN -T ${CERT_DIR} -t -Y GSSAPI $URI -Q -N "($ATTR=$MY_OBJECT)" userCertificate >/dev/null 2>&1

cd ${CERT_DIR}

NOW=$(date +"%s")

for i in $(ls); do
  NOT_AFTER=$(date -d "$(openssl x509 -inform der -in $i -noout -dates | grep notAfter | cut -d= -f2)" +"%s")
  if [ $((( $NOT_AFTER - $NOW ) / 86400 )) -gt 0 ]; then
    EMAIL=$(openssl x509 -inform der  -in $i  -noout -subject | sed "s/.*emailAddress=//" | cut -d/ -f1)
    mv -f $i ${EMAIL}.der
  fi
done

zenity --warning --text "This will close evolution and add the found certificates" 2>/dev/null
RET=$?

if [ $RET -eq 0 ]; then
  evolution --force-shutdown 2>/dev/null || true
#  pkill evolution 2> /dev/null || pkill -9 evolution 2> /dev/null || true
  for i in $(ls); do
    certutil -A -n "${i%.der}" -t "p,p,p" -i $i -d $HOME/.local/share/evolution/
    zenity --info --text="Certificate: ${i%.der} added" --title="Certificate" 2>/dev/null
  done
fi
cd
rm -rf ${CERT_DIR}
sync 
