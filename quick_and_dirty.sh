#!/bin/bash
#  quick  and dirty way to decryt and replace strings in properties file
#  the algo is not efficient and  will be optimised . this is just a demo...
#  using openssl symmetic encryption
#  example  echo "shegoj" | openssl aes-256-cbc -salt -a -e   -iter 1000   -k pass
#  this gives U2FsdGVkX1/eQDl8jDaf0eAmzU6GZqyWPWCVKgfFzGE=
#  example  echo "four" | openssl aes-256-cbc -salt -a -e   -iter 1000   -k pass
#  this gives U2FsdGVkX1+uM4CujcILo4pcdWKU89DR46OGFE+NE0Y=


for file in `ls *.properties`  ## targetting properties file in current directory
  do
    echo "processing $file"
    for i in `sed -e 's# ##g' $file | grep "enc("`   ## only work on the file if  there is some decryptions to be done
      do
        val=`echo "$i" | sed 's#\(^.*enc(\)\(.*\))$#\2#g'` ## get encrypted text
        echo "encrypted $val"
        decrypted_val=`echo "$val" | openssl aes-256-cbc -a -d -salt -k pass -iter 1000` ### this is showing how to decrypt ... should be replaced with appropriate method
        line="$i"
        lhs=`echo "$i" | sed 's#\(^.*\)=enc.*$#\1#g'`
        sed  -i -e 's# ##g' -e "s#$line#$lhs=$decrypted_val#g"  $file
      done
    done
