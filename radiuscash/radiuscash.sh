#!/bin/bash
USERMAN_IP="192.168.10.66"
USERMAN_LOGIN="mikbill"
USERMAN_PASSWORD="mikbill"

#RADIUS_TYPE="hotspot"
RADIUS_TYPE="ppp"

UPLOAD="userman.rsc"
PATH_CONFIG=/var/www/mikbill/admin/app/etc/config.xml
DB_USER=$(cat $PATH_CONFIG| grep  username | awk '{ gsub("<username>"," "); print }' | awk '{ gsub("</username>"," "); print }' | awk '{print $1}')
DB_PASSWORD=$(cat $PATH_CONFIG| grep  password | awk '{ gsub("<password>"," "); print }' | awk '{ gsub("</password>"," "); print }' | awk '{print $1}')
DB_NAME=$(cat $PATH_CONFIG | grep dbname | awk '{ gsub("<dbname>"," "); print }' | awk '{ gsub("</dbname>"," "); print }'| awk '{print $1}')

HOME_DIR=$(cd $(dirname $0)&& pwd)

case "$RADIUS_TYPE" in
"hotspot") 
INQUIRY="SELECT local_mac FROM users WHERE credit >= ABS (deposit) and blocked=0"
MAC=`mysql -D $DB_NAME -u $DB_USER -p$DB_PASSWORD -e "$INQUIRY" 2>/dev/null`
MAC=${MAC:10:${#MAC}}
;;
"ppp")
INQUIRY="SELECT user, password FROM users WHERE credit >= ABS (deposit) and blocked=0;"
MAC=`mysql -D $DB_NAME -u $DB_USER -p$DB_PASSWORD -e "$INQUIRY" 2>/dev/null`
#MAC=${MAC:10:${#MAC}}
;;
esac

echo "$MAC"

echo "/tool user-manager user remove [find]" > $HOME_DIR/$UPLOAD
for i in $MAC; do
echo "/tool user-manager user add customer=admin username=$i" >>$HOME_DIR/$UPLOAD
done
echo "/tool user-manager user create-and-activate-profile profile=admin customer=admin numbers=[find]" >> $HOME_DIR/$UPLOAD


curl --upload-file $HOME_DIR/$UPLOAD  ftp://$USERMAN_LOGIN:$USERMAN_PASSWORD@$USERMAN_IP/
CMD="/import file=$UPLOAD"
ssh $USERMAN_LOGIN@$USERMAN_IP "${CMD}" > /dev/null

# version 1
# tested mikrotik 6.34.1
# wget https://github.com/mikbill/design/raw/master/radiuscash/radiuscash.sh
# ssh-keygen
