df -i > inode_usage.txt
du --inodes -x / | sort -nr | head -10 >> inode_usage.txt
find / -xdev -type d -exec sh -c 'echo "{}"; ls -U "{}" | wc -l' \; >> inode_usage.txt

#find / -xdev -type d -exec sh -c 'echo "{}"; ls -U "{}" | wc -l' \; >> inode_usage.txt
#find / -xdev -type d -exec sh -c 'count=$(ls -U "{}" | wc -l); [ $count -gt 100000 ] && echo "{}: $count"' \; >> inode_usage.txt

##Cleanup
#find /var/log -type f -mtime +30 -delete
#tar czf old_mail.tar.gz /var/spool/mail/*
#rm -f /var/spool/mail/*
#find / -type f -empty -delete



