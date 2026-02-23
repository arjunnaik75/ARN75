find / -xdev -type d -exec sh -c 'echo "{}"; ls -U "{}" | wc -l' \; > toomanyfiles.txt
