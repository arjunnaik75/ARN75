# Find Files Less than 10MB in Size
mkdir -p /findings
find /mydir -type f -size -10M -exec cp {} /findings/ \;
find /mydir -type f -size -10M -exec cp {} /findings/ \; 2>&1 | tee -a /findings/findings.log
# OR
find /mydir -type f -size -10M -exec cp -t /findings/ {} +
find /mydir -type f -size -10M -exec cp -t /findings/ {} + 2>&1 | tee -a /findings/findings.log

find /mydir -type f -size -10M \
  -exec sh -c 'cp "$1" /findings/ 2>&1 | tee -a /findings/findings.log' _ {} \;

# Find Files More than 10MB in Size
find /mydir -type f -size +10M -exec cp {} /findings/ \;
# OR
find /mydir -type f -size +10M -exec cp -t /findings/ {} +

# Find Files More than 10MB & Less than 50MB in Size
find /mydir -type f -size +10M -size -50M -exec cp {} /findings/ \;
# OR
find /mydir -type f -size +10M -size -50M -exec cp -t /findings/ {} +

# By Name
find /mydir -type f -name "test.txt" -exec cp {} /findings/ \;
find /mydir -type f -name "test.txt" -exec cp -t /findings/ {} +

# Search for files ending with digits, print and append
find /mydir -type f -regex '.*[0-9]$' | tee -a /findings/digit_file1 #Destination_File_Path ##Matches_Like #file0 #file1 #file3  
find /mydir -type f -regex '.*/[0-9]$' | tee -a /findings/digit_file1 #Only_File_Names_Like #0 #1 #2

# Find multiple patterns
find /etc -type f \( -name "*.conf" -o -name "*.cfg" -o -name "*.service" \) > /findings/conf_list.txt
# Append and also show on screen
find /etc -type f \( -name "*.conf" -o -name "*.cfg" -o -name "*.service" \) | tee -a /findings/conf_list.txt
find /etc -type f '(' -name "*.conf" -o -name "*.cfg" -o -name "*.service" ')' | tee -a /findings/conf_list.txt
find /etc -type f -regex '.*\.\(conf\|cfg\|service\|ini\)$' | tee -a /findings/conf_list.txt
find /etc -type f -regex '.*\.\(conf\|cfg\|service\|ini\)$' -exec cp -t /findings/ {} +

# Tests with AND / OR
find / -name smb.conf -a -type f
find / \(-name smb.conf -o -name nmb.conf \) -type f
find / '(' -name smb.conf -o -name nmb.conf ')' -type f

sudo find /var/log -type f -size +500M -exec ls -lh {} \;
sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | \
    awk '{print $5, $9}' | sort -hr | head -n 10
    
# Find and Delete Files
find /mydir -type f -name "*.bak" -exec rm -f {} \;
find /mydir -type f -name "*.bak" -exec rm -f {} +
# Find and Delete
sudo find /var/log -type f -name "*.log" -size +1G -exec rm -i {} \;


# Directory
find / -user anaik -type d > /findings/
find / -uid 1006 > /findings/uid1006

du -sm --max-depth=1 /mydir | awk '$1 > 100 {print $2}'
du -h --max-depth=1 /mydir | awk '$1 ~ /M/ && $1+0 > 100 {print $2}' # ~ match regex
du -h --max-depth=3 /mydir | awk '$1 ~ /M/ && $1+0 > 100 {print $2}'


# Copying Directories Recursively
for dir in $(du -sm /mydir/* | awk '$1 > 100 {print $2}'); do
    cp -r "$dir" /findings/large_dirs/
done

# OR
for dir in $(du -sm /mydir/* | awk '$1 > 100 {print $2}') 
do
    cp -r "$dir" /findings/large_dirs/
done

# Preserves permissions, symlinks, etc #for backups, synchronization, or repeated transfers
for dir in $(du -sm /mydir/* | awk '$1 > 100 {print $2}'); do
    rsync -a "$dir" /findings/large_dirs/
done

###########################################################################
#Which command will find the word “error” in all .log files in a directory?
grep -i "error" *.log
grep -r "error" --include="*.log" /mydir
find /mydir -name "*.log" -type f -exec grep -Hi "error" {} \;
find /mydir -name "*.log" -type f -exec grep -Hi "error" {} +

