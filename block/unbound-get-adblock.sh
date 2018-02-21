#!/bin/sh

#Change it.
WorkingDir=${UPDATE_BLOCK_LIST_WORK_DIR:-.}

echo "Working dir: " $WorkingDir
NOW=$(date +"%Y-%m-%d %H:%M:%S")
echo 'Update ad-block config' $NOW

if [ ! -d "$WorkingDir/tmp" ]; then
    mkdir $WorkingDir/tmp
fi

if [ ! -d "$WorkingDir/lists" ]; then
    mkdir $WorkingDir/lists
fi
 
wget -q -N  -O $WorkingDir/lists/ban1 http://someonewhocares.org/hosts/hosts
wget -q -N  -O $WorkingDir/lists/ban2 https://adaway.org/hosts.txt
wget -q -N  -O $WorkingDir/lists/ban3 http://winhelp2002.mvps.org/hosts.txt
wget -q -N  -O $WorkingDir/lists/ban4 http://hosts-file.net/ad_servers.txt
wget -q -N  -O $WorkingDir/lists/ban5 "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
wget -q -N  -O $WorkingDir/lists/ban6 http://www.malwaredomainlist.com/hostslist/hosts.txt

banFileList=""
for file in $WorkingDir/lists/ban*
do
banFileList="$banFileList $file"
done

grep -v -h '^$\|^#\|^\s*\#' $banFileList | grep -v "^[[:space:]]*$" > $WorkingDir/tmp/list.step.1
awk '{print $2}' $WorkingDir/tmp/list.step.1 > $WorkingDir/tmp/list.step.2
grep -v -E "^(localhost|broadcasthost|local|localhost.localdomain)$" $WorkingDir/tmp/list.step.2 > $WorkingDir/tmp/list.step.3
tr -d '\r' < $WorkingDir/tmp/list.step.3 > $WorkingDir/tmp/list.step.4
awk '{print "local-data: \"" $1 " A 0.0.0.0\""}' $WorkingDir/tmp/list.step.4 > $WorkingDir/tmp/list.step.5

echo '#Create date' $NOW > $WorkingDir/tmp/create.date
cat $WorkingDir/tmp/create.date $WorkingDir/tmp/list.step.5 > $WorkingDir/block.conf

rm -r $WorkingDir/tmp
rm -r $WorkingDir/lists

