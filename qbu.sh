#!/bin/bash
# First off, there's probably nothing extraordinarily quick about this
USB=$1

backupdir="/mnt/$(hostname)/$(date +"%Y")"

help() {
	echo "must provide usb device"
	exit 1
}

[ -z $USB ] && [ ! -b $USB ] || help

su -c "mount $USB /mnt && mkdir -p $backupdir && chown -R $USER:$USER $backupdir"

excludeopts=""
# pronounced dudes
dudirs=""
timestamp=`date +"%m%dT%H%M%SZ"`


for f in `ls -A $HOME`; do
	# Exclude any dot files that are not .vim
	if [[ "$f" =~ ^\. && ! "$f" =~ ^\.vim ]]; then
		excludeopts+="--exclude=$f "
	else
		dudirs+=" \"$HOME/$f\""
	fi
done


echo "Archiving the following directories"
#--exclude-backups
#   Exclude backup and lock files.  This option causes exclusion of
#   files that match the following shell globbing patterns:
#
#   .#*
#   *~
#   #*#
duexcludes="--exclude=.#* --exclude=*~ --exclude=#*#"
du -sh $dudirs $duexcludes
sum=`du -bs $dudirs $duexcludes | awk 'BEGIN{sum=0} {sum+=$1} END{print sum}'`
echo "Approx: $sum B"

echo
echo "Starting at $timestamp"
echo

cd /home

tar czvf "$backupdir/$USER.$timestamp.tgz" --exclude-backups $excludeopts $USER 
sha256sum "$backupdir/$USER.$timestamp.tgz" > "$backupdir/$USER.$timestamp.tgz.shasum"

su -c 'umount /mnt'
