#!/bin/bash

set -eu

getMaxPaginationFromNobdd(){
	curl -sf 'http://h1.nobbd.de/' | 
	tr '"' '\n' |
	grep '?start' |
	tr '\n' ' ' |
	awk -F= '{print $NF}'
}

generatePaginationToNobddWebsite(){
	maxPagNobdd=`getMaxPaginationFromNobdd`
	echo {0..$maxPagNobdd..20} | 
	tr ' ' '\n'
}

getReportsIdsFromNobdd(){
	paginationRange=generatePaginationToNobddWebsite
	echo -e "$paginationRange" | 
	xargs -I@ -P10 curl -sf 'http://h1.nobbd.de/index.php?start=@'
}

getOnlyHackeroneReportLinks(){
	resultFromNobdd=`getReportsIdsFromNobdd`

	echo -e "$resultFromNobdd" |
	tr '")' '\n' | 
	tr -d "'" | 
	awk -F '/' '/https:\/\/hackerone.com\/reports/{print $NF}' |
	sort -u
}

getHackerOneReportJson(){
	jsonReponse=`echo -e "$allReportsId" | xargs -I@ wget -P jsonReports/ https://hackerone.com/reports/@.json`
	echo $jsonReponse
}

main(){

[[ ! -d "jsonReports" ]] && 
mkdir jsonReports || 
echo '[INFO] Json Output Folder already exist. Using It ...'

allReportsId=`getOnlyHackeroneReportLinks`
getHackerOneReportJson "$allReportsId"
}

main	