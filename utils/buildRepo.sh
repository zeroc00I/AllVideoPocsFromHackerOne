#!/bin/bash

GREEN=`tput setaf 2`
NONCOLOR=`tput sgr0`

getMaxPaginationFromNobdd(){
	result=$(
		curl -sf 'http://h1.nobbd.de/' | 
		tr '"' '\n' |
		grep '?start' |
		tr "\n" ' ' |
		awk -F= '{print $NF}'
	)
	echo -e "$result" | xargs
}

generatePaginationToNobddWebsite(){
	echo -e "$GREEN[INFO]$NONCOLOR Getting Max page from Nobdd with curls ... [2/3]\n"
	maxPagNobdd=$(getMaxPaginationFromNobdd)
	echo -e "$GREEN[INFO]$NONCOLOR Processing Max pages from Nobdd ... [3/3]\n"
	interval=$(seq 0 20 $maxPagNobdd) 
	
	echo -e "$interval" | tr " "  "\n"
}

getReportsIdsFromNobdd(){
	paginationRange=$(generatePaginationToNobddWebsite)
	echo -e "$paginationRange" | 
	xargs -I@ -P10 curl -sf 'http://h1.nobbd.de/index.php?start=@' 
}

getOnlyHackeroneReportLinks(){
	echo -e "$GREEN[INFO]$NONCOLOR Starting Max pages from Nobdd process ... [1/3]\n"
	resultFromNobdd=`getReportsIdsFromNobdd`

	echo -e "$resultFromNobdd" |
	tr '")' '\n' | 
	tr "'" " " | 
	awk -F '/' '/https:\/\/hackerone.com\/reports/{print $NF}' |
	tr -d ' ' |
	grep -E '^[0-9]{1,}$' |
	tee -a reportLinksHackerOne
}

getHackerOneReportJson(){
	echo -e "$GREEN[INFO]$NONCOLOR Downloading reports from Hackerone with wget ...\n"
	jsonReponse=$(
		echo -e "$allReportsId" | sort -u | xargs -I@ wget -nv -P jsonReports/ "https://hackerone.com/reports/@.json"
	)

	echo $jsonReponse
}

main(){

	[[ ! -d "jsonReports" ]] && 
		mkdir jsonReports || 
		echo "$GREEN[INFO] Json Output Folder already exist. Using It ..."

	[[ -f "reportLinksHackerOne" ]] &&
		echo "$GREEN[INFO]$NONCOLOR HackerOne report id files found. Using it ..." &&
		allReportsId=`cat reportLinksHackerOne` &&
		getHackerOneReportJson "$allReportsId" ||
		echo -e "$GREEN[INFO]$NONCOLOR Extracting all disclosed id reports from H1" &&
		allReportsId=`getOnlyHackeroneReportLinks` &&
		getHackerOneReportJson "$allReportsId"
}

main	