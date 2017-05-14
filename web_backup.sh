#!/bin/sh
# THIS FILE IS PART OF LibreBoot PROJECT NMTech0x90
# web_backup.sh - 采用定期备份、md5文件值校验、邮件接收日志及报警等。持续更新中.....
# THIS PROGRAM IS FREE SOFTWARE, web_backup.sh, IS LICENSED UNDER NMTech0x90.
# YOU SHOULD HAVE RECEIVED A COPY OF GNU General Public License v3.0, IF NOT Please delete immediately 
# Copyright (c) 2017 Pasta NMTech0x90
# Author Mail:NMTech@Aliyun.Com

# Backup Dir
BACKUP_NAME="/Backup_Web"
# Data Dir
DATADIR="/var/www/html"

# File First Name 
Name="Web"

#Please do not modify!
Name=$Name"_`date +%Y_%m_%d_%H_%M`"
File="$Name.tar.gz"
BACKDIR_Root=$BACKUP_NAME
BACKDIR="$BACKDIR_Root/`date +%Y_%m`"
BACKDIR_Log="$BACKDIR_Root/log"

# Log File
Log="$BACKDIR_Log/md5_$Name"

# Backup
if [ ! -d "$BACKDIR" ];then
	mkdir -p $BACKDIR
	if [ ! -d "$BACKDIR_Log" ];then
		mkdir -p $BACKDIR_Log 
	fi
fi
chmod -R 600 $BACKDIR_Root
umask 077 $BACKDIR
tar zcfP $BACKDIR/$File $DATADIR

# MD5 File Verification Results
if [ -z `grep "$BACKDIR/$File" "$BACKDIR_Root/Files_List.txt"` ];then
	echo "$BACKDIR/$File" >>"$BACKDIR_Root/Files_List.txt"
fi
md5sum "$BACKDIR/$File" >$Log
i=0
for T in `cat $BACKDIR_Root/Files_List.txt`
do
	i=$(($i+1))
	List[$i]=${T}
done
i=0
echo "Here is MD5 File Verification Results:"
for Check in `ls $BACKDIR_Log`
do
	md5_check="$BACKDIR_Log/${Check}"
	i=$(($i+1))
	if [ "`md5sum ${List[$i]}`" == "`cat $md5_check`" ]; then
		echo "$md5_check | Check MD5 Value Success"
	else
	#	echo "Error MD5 Value!"
		echo "$md5_check | Error MD5 Value!"
	fi
done
echo -e "\nThis is New Backup log:$Log\n`cat $Log`"
