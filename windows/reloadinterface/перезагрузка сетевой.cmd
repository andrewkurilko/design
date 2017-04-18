echo off
chcp 1251

echo ������ � ����������� *.cmd ��������� � ������� ��������������

echo ������ "Ethernet" �� �������� ����� ������� ����� 
set network_interface=Ethernet

echo timeout - ����� �������� � ����������� ��������� ����������
set timeout=10

echo dst_address - ����������� IP/�����
set dst_address=8.8.8.8

echo num_packet - ���������� ������������ ������� �������� ping
set num_packet=5

:start
echo ���������� ������� ����� %network_interface%
netsh interface set interface name=%network_interface% admin=disabled

 
TIMEOUT /T %timeout% /NOBREAK
echo ��������� ������� ����� %network_interface%
netsh interface set interface name=%network_interface% admin=enabled
ping %dst_address% -n %num_packet%
goto start

