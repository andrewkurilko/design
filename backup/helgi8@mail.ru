# version 14
# wget https://github.com/mikbill/design/raw/master/backup/SYS_backup.conf
SERVER_NAME="ServerName"
LOG=/var/log/backup.log
HOME_DIR=$(cd $(dirname $0)&& pwd)
#HOME_DIR=/home/backup
#----------------------------------------------
BACKUP_MYSQL=1
BACKUP_FILES=0
BACKUP_TO_WEBDISK=1
DIFF_FILES=0
LOG_IN_TERMINAL=0
#-BACKUP TO DISK-------------------------------------
#Путь для бэкапа на диске
PACH_FOR_BACKUP_TO_DISK=$HOME_DIR/files
#Количество дней для ротации файлов
LIFE_TIME_FILE_ON_DISk=20
# MySQL (На сервере с биллингом логин/пароль можно не указывать тут)-------
PATH_MIKBILL=/var/www/mikbill/admin/
DB_USER=""
DB_PASSWORD=""
DB_NAME="mikbill"
# Шифрование------------------------------------------
ENCRYPTION=0
ENCRYPTION_ID_USER="admin"
#-WEBDISK---------------------------------------------
#Точка монтирования 
#Yandex
MOUNT_POINT=https://webdav.yandex.ru
#Cubby
#MOUNT_POINT=https://webdav.cubby.com

#Путь для WEBDISK
PACH_FOR_WEBDISK=$HOME_DIR/webdisk
DIR_BACKUP_FOR_WEBDISK=backups
#Время ротации файлов
LIFE_TIME_FILE_ON_WEBDISK=20
#Удаление старых файлов при нехватке места для новых файлов
FREESPACE_WEBDISK=0
#Размонтирование диска после выполнения действий (UMOUNT_WEBDISK=0 не размонтировать)
UMOUNT_WEBDISK=0
#-FILES---------------------------------------------
TAR_INCLUDE_LIST=$HOME_DIR/tar.include.list
TAR_EXCLUDE_LIST=$HOME_DIR/tar.exclude.list
#-DIFF---------------------------------------------
DIFF_BACKUP=$HOME_DIR/diff-$SERVER_NAME.tar.gz
DIFF_INCLUDE_LIST=$HOME_DIR/diff.include.list
DIFF_EXCLUDE_LIST=$HOME_DIR/diff.exclude.list
DIFF_DIR_NEW=$HOME_DIR/diff.new
DIFF_DIR_OLD=$HOME_DIR/diff.old
DIFF_DIR_TEMP=$HOME_DIR/diff.temp
#-EMAIL---------------------------------------------
SEND_EMAIL=0
EMAIL=mail@mail.com
EMAIL_SERVICE=postfix

SEND_EMAIL_2=0
EMAIL_2=mail@mail.com
#----------------------------------------------------
DATE=`date +%Y-%m-%d_%Hh%Mm`
LOG_LINK=$HOME_DIR/backup.log


# Secret: 
# mcedit /etc/davfs2/secrets
# Mount:
# mount -t davfs https://webdav.yandex.ru /home/backup/webdisk
# Umount:
# umount /home/backup/webdisk
