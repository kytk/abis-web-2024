#!/bin/bash
# Script to prepare split files of L4N for distribution

set -x

# Specify working directory
wd=/mnt/data1/VM_appliance

if [ $# -lt 1 ]; then
  echo "Please specify ova files and Ubuntu version!"
  echo "Usage: $0 OVA"
  exit 1
fi

vm=$1

splitbase="L4N-2204-ABiS-split-"

cd ${wd}
[ ! -d ${vm%.ova} ] && mkdir ${wd}/${vm%.ova}
cp ${vm}* ${wd}/${vm%.ova}
pushd ${wd}/${vm%.ova}
echo "split -n 30 -d ${vm} ${splitbase}"
split -n 30 -d ${vm} ${splitbase}
for f in ${splitbase}*; do openssl md5 $f > ${f}.md5; done

echo "Done"

exit

####
# sftp user@ftpsite
# cd www/klab/l4n-abis
# put L4N-2204-ABiS-2023????.ova*
# mkdir L4N-2204-ABiS-2023????-split
# cd L4N-2204-ABiS-2023????-split
# put L4N-2204-ABiS-split-*
#####

