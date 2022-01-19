---
date: "2018-01-01"
draft: false
lastmod: "2022-01-19"
publishdate: "2022-01-19"
tags:
- shell
- linux
title: shell example
---
**Spring version : V4.2** 

## 1. Shell example

定期压缩并删除前N天的日志文件脚本

```
#!/bin/bash
start=`date '+%Y-%m-%d %H:%M:%S'`
echo 'executed at [' $start ']ready to compress the log (the original log file will be deleted after compressed successfully)>>>>>>>>>>';
skippedDays=()

skippedDaysCount=$1
defaultSkippedDaysCount=10
if [[ ! -n ${skippedDaysCount} ]]; then
	skippedDaysCount=$defaultSkippedDaysCount
fi
echo 'latest '$skippedDaysCount 'days log file will be ignore'

for (( i = 0; i < $skippedDaysCount; i++ )); do
	skippedDays[i]=`date +%Y-%m-%d --date $i' days ago'`
done

echo ${skippedDays[@]}

totalCount=0
compressFiles=()
for file in `ls`; do
	if [[ -d $file ]]; then  # skip directory
		continue
	fi

	skipped=1 # default false
	matchedLogFile=$(echo $file|grep '.log$')
	if [[ "$matchedLogFile" != ""  ]]; then
		echo 'log file => '$file
		for skippedDay in ${skippedDays[@]}; do
			matchedSkippedLogFile=$(echo $file|grep $skippedDay)
			if [[ "$matchedSkippedLogFile" != "" ]]; then
				skipped=0
				echo 'xxx skipped xxx'
				break
			fi
		done

		if [[ $skipped == 1 ]]; then
			compressFiles[totalCount]=$matchedLogFile
			totalCount=`expr $totalCount + 1`
		fi
	fi
done

# comfirm to compress
echo '-------------------------- summary : final matched file ------------------------'
for compressFile in ${compressFiles[@]}; do
	echo $compressFile
done
echo '-----------------------------------------------------------'
echo 'total : ' $totalCount

# start to compress
echo 'start compress files >>>>>>>>>>>>>>>>>>>'
for compressFile in ${compressFiles[@]}; do
	zip -r $compressFile.zip $compressFile
	if [[ $? -eq 0 ]]; then
		echo $compressFile 'compressed successfully, start delete now...'
		rm $compressFile
		if [[ $? -eq 0 ]]; then
			echo $compressFile 'delete successfully'
		fi
	fi
done
end=`date '+%Y-%m-%d %H:%M:%S'`
echo 'compress files finished at ['$end']<<<<<<<<<<<<<<<<<<'
```

避坑：注意查看当前使用的shell是否为B Shell (使用sh执行可能会报各种怪异的错误，解决方式： bash + 脚本名)
