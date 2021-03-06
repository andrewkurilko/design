#!/bin/bash
HOME_DIR=$(cd $(dirname $0)&& pwd)
source $HOME_DIR/radcash.conf

INQUIRY="SELECT MAX( uid ) FROM users"
MAX=`mysql -D $DB_NAME -u $DB_USER -p$DB_PASSWORD -e "$INQUIRY" 2>/dev/null`
MAX=${MAX:11:${#MAX}}

echo "/tool user-manager user remove [find]" > $UPLOAD

if [ "$RADIUS_HOTSPOT" -ne 0 ]
then
INQUIRY="SELECT local_mac, gid FROM users WHERE credit >= ABS (deposit) and blocked=0"
SQL=`mysql -D $DB_NAME -u $DB_USER -p$DB_PASSWORD -e "$INQUIRY" 2>/dev/null`
SQL=${SQL:14:${#SQL}}

n=0
for i in $SQL; do
ARRAY_SQL[$n]=$i
let n=n+1
done

n=$(( MAX*2 ))
for (( i=0; i < $n; i=i+2 ))
do
if [[ ${ARRAY_SQL[$i]} != NULL && ${ARRAY_SQL[$i]} != "" ]]
then
echo "/tool user-manager user add customer=admin username=${ARRAY_SQL[$i]}" >>$UPLOAD
echo "/tool user-manager user create-and-activate-profile profile=${ARRAY_SQL[$i+1]} customer=admin numbers=[find]" >>$UPLOAD
fi
done




for i in $SQL; do
if [[ $i != NULL && $i != "" ]]
then
echo "/tool user-manager user add customer=admin username=$i" >>$UPLOAD
fi
done
fi

if [ "$RADIUS_PPP" -ne 0 ]
then
INQUIRY="SELECT user, password FROM users WHERE credit >= ABS (deposit) and blocked=0;"
SQL=`mysql -D $DB_NAME -u $DB_USER -p$DB_PASSWORD -e "$INQUIRY" 2>/dev/null`
SQL=${SQL:14:${#SQL}}

NUM=0
for i in $SQL; do
LOGIN_PASS[$NUM]=$i
let "NUM=NUM+1"
done

for((i=0;i!=NUM;i+=2))
do
echo "/tool user-manager user add customer=admin username=${LOGIN_PASS[$i]} password=${LOGIN_PASS[$i+1]}" >>$UPLOAD
done
fi


#SSH
for (( i=0;i!=$CONNECT_SUM;i++ )); do

scp -P $USERMAN_SSH_PORT $UPLOAD $USERMAN_LOGIN@$USERMAN_IP:/
STATUS=$?
if [ $STATUS -ne 0 ]; then
sleep $CONNECT_INTERVAL
else

CMD="/import file=$(basename $UPLOAD)"
for (( i=0;i!=$CONNECT_SUM;i++ )); do
ssh -p $USERMAN_SSH_PORT $USERMAN_LOGIN@$USERMAN_IP "${CMD}" > /dev/null
STATUS=$?
if [ $STATUS -ne 0 ]; then
sleep $CONNECT_INTERVAL
fi

done
break
fi

done

# version 1.2
# tested mikrotik 6.34.1
# wget https://github.com/mikbill/design/raw/master/radiuscash/radiuscash.sh
# ssh-keygen
