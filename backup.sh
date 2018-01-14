#!/bin/bash
TODAY=$(date +%F)
PPPPASS="990924"
if [ -z "$1" ];then
        echo Needed Usage arguments. Please Use --help to get more infomation.
        exit 1
fi

test -f /etc/profile && ./etc/profile >/dev/null 2>&1
zip --version >/dev/null || yum install -y zip || apt-get install zip -y
ZIP=$(which zip)
MYSQLDUMP=$(which mysqldump)

if [ "$1" == "db" ];then
        domain=$2
        dbname=$3
        mysqluser=$4
        mysqlpd=$5
        back_path=$6
        test -d "$back_path" || (mkdir -p "$back_path" || echo "$back_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        cd "$back_path" || exit
        $MYSQLDUMP -u"$mysqluser" -p"$mysqlpd" "$dbname" --skip-lock-tables>"$back_path"/"$domain"\_db_"$TODAY"\.sql
        test -f "$back_path"/"$domain"\_db_"$TODAY"\.sql || (echo "MysqlDump failed! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        $ZIP -P"$PPPPASS" -m "$back_path"/"$domain"\_db_"$TODAY"\.zip "$domain"\_db_"$TODAY"\.sql
elif [ "$1" == "file" ];then
        domain=$2
        site_path=$3
        back_path=$4
        test -d "$site_path" || (echo "$site_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        test -d "$back_path" || (mkdir -p "$back_path" || echo "$back_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        test -f "$back_path"/"$domain"\_"$TODAY"\.zip && rm -f "$back_path"/"$domain"\_"$TODAY"\.zip
        $ZIP -P"$PPPPASS" -9r "$back_path"/"$domain"\_"$TODAY"\.zip "$site_path"
elif [ "$1" == "--help" ];then
        clear
        echo =====================================Help infomation=========================================
        echo 1. Use For Backup database:
        echo The \$1 must be \[db\]
        echo \$2: \[domain\]
        echo \$3: \[dbname\]
        echo \$4: \[mysqluser\]
        echo \$5: \[mysqlpassword\]
        echo \$6: \[back_path\]
        echo
        echo For example:./backup.sh db zhangge.net zhangge_db zhangge 123456 /home/wwwbackup/zhangge.net
        echo
        echo 2. Use For Backup webfile:
        echo The \$1 must be \[file\]:
        echo \$2: \[domain\]
        echo \$3: \[site_path\]
        echo \$4: \[back_path\]
        echo
        echo For example:./backup.sh file zhangge.net /home/wwwroot/zhangge.net /home/wwwbackup/zhangge.net
        echo =====================================End of Help==============================================
        exit 0
else
        echo "Error!Please Usage --help to get help infomation!"
        exit 2
fi
