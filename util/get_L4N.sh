#!/bin/bash
# ABiS チュートリアル用スクリプト
# 2024年1-3月用のLin4Neuroを入手します

#For Debug
#set -x

# variable ################
baseurl="https://www.nemotos.net/l4n-abis/L4N-2204-ABiS-20231214-split"
base="L4N-2204-ABiS-split"
L4N="L4N-2204-ABiS-20231214.ova"
L4Ndir="L4N-2204-ABiS-20231214"
L4Nmd5="MD5(L4N-2204-ABiS-20231214.ova)= 1dbb0b839715d3cc131ab96cf735be9b"
nfiles=29 # n-1
###########################

#cd ~/Downloads
[ ! -d ${L4Ndir} ] && mkdir ${L4Ndir}
cd ${L4Ndir}


echo "チュートリアル用のLin4Neuroをダウンロードします"
echo ""

echo "${L4N}があるか確認します"
if [ ! -e ${L4N} ]; then
  echo "L4N分割データを確認し、なければダウンロードします"
  for n in $(seq -w 00 $nfiles);
  do
    if [ ! -e ${base}-${n} ]; then
      curl -O ${baseurl}/${base}-${n}.md5
      curl -O ${baseurl}/${base}-${n}
    fi 
    echo "${base}-${n}のファイルサイズを確認します"
    openssl md5 ${base}-${n} | cmp ${base}-${n}.md5 -
    while [ $? -ne 0 ]; do
      echo "ファイルサイズが一致しません"
      echo "再度ダウンロードします"
      rm ${base}-${n}.md5 ${base}-${n}
      curl -O ${baseurl}/${base}-${n}.md5
      curl -O ${baseurl}/${base}-${n}
      openssl md5 ${base}-${n} | cmp ${base}-${n}.md5 -
    done
  echo "ファイルサイズが一致しました"
  done
    
  echo "${L4N} を生成します"
  cat ${base}-?? > ${L4N}
fi

echo "${L4N} を検証します"
echo ${L4Nmd5} > ${L4N}.md5

openssl md5 ${L4N} | cmp ${L4N}.md5 -
while [ $? -ne 0 ]; do
  echo "ファイルサイズが一致しません"
  echo "再度結合します"
  cat ${base}-?? > ${L4N}
  openssl md5 ${L4N} | cmp ${L4N}.md5 -
done
echo "正しく${L4N}が生成されました"

#Delete temporary files
[ -e ${base}-00 ] && rm ${base}-*

echo ""
echo "L4Nの準備が完了しました。"
echo "${L4Ndir}フォルダの中にある${L4N}をVirtualBoxにインポートしてください"
sleep 10

exit

