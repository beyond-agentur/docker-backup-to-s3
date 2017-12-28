#!/bin/bash

set -e

dateISO() {
    date -j -f "%s" $started -u  +"%Y-%m-%dT%H:%M:%SZ"
}

started=$(date +%s)
startedAt=$(date -u -d @$started  +"%Y-%m-%dT%H:%M:%SZ")

if [ "$PREFIX" ]; then
    name="$PREFIX-$startedAt.tgz"
else
    name="$startedAt.tgz"
fi

s3name=$name

#echo "Starting backup from:$DATA_PATH to $S3_PATH/$s3name" 

tar czf /tmp/$name  -C $DATA_PATH .

output=$(s3cmd put -m application/octet-stream $PARAMS /tmp/$s3name "$S3_PATH" 2>&1 | tr '\n' ';' )
code=$?

if [ $code ]; then
    result=ok
else
    result="error:$code"
fi

rm -f /tmp/$name
rm -f /tmp/$s3name

finished=$(date +%s)
duration=$(( finished - started ))

printf "{\"backup\": { \"startedAt\":\"%s\", \"duration\":\"PT%is\", \"name\":\"%s/%s\", \"result\":\"%s\", \"output\":\"%s\"}}\n" "$startedAt" "$duration" "$S3_PATH" "$s3name" "$result" "$output"
