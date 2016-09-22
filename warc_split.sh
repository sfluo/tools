files=`find /home/user/bowl/commcrawl/ -name *.warc.gz`

#!/bin/sh

for f in $files
do
        # decompress
        echo "decompressing $f ... "
        gunzip -d $f
        filepath=`dirname $f`
        filename=`basename $f | cut -d . -f1-4`

        # extract html page
        echo "Extracting html pages from $filename ... "
        mkdir -p "/home/user/data/commcrawl/$filename"
        csplit -q -z -f "/home/user/data/commcrawl/$filename/c37_" "$filepath/$filename" '/HTTP\/[0-1].[0-1] 200 OK/' {*}

        # clean pages
        echo "Cleaning pages extracted from $filename ... "
        cfiles=`find "/home/user/data/commcrawl/$filename/" -name c37_*`
        for cf in $cfiles
        do
                awk '/^HTTP\//,/^WARC\/1.0/ {print}' $cf >> "$cf.txt"
                rm $cf
        done

        # remove decompressed file
        echo "deleting $filepath/$filename ..."
        # rm -rf "$filepath/$filename"
done
~      
