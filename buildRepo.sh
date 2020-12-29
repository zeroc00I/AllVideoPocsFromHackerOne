#!/bin/bash



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
	maxPagNobdd=$(getMaxPaginationFromNobdd)
	
	interval=$(seq 0 20 $maxPagNobdd) 
	
	echo -e "$interval" | tr " "  "\n"
}

getReportsIdsFromNobdd(){
	paginationRange=$(generatePaginationToNobddWebsite)
	echo -e "$paginationRange" | 
	xargs -I@ -P10 curl -sf 'http://h1.nobbd.de/index.php?start=@' 
}

getOnlyHackeroneReportLinks(){

	resultFromNobdd=$(getReportsIdsFromNobdd)

	echo -e "$resultFromNobdd" |
	tr '")' '\n' | 
	tr "'" " " | 
	awk -F '/' '/https:\/\/hackerone.com\/reports/{print $NF}' |
	tr -d ' ' |
	grep -E '^[0-9]{1,}$'
	anew reportLinksHackerOne
}

getHackerOneReportJson(){
	jsonReponse=$(
		echo -e "$allReportsId" | xargs -I@ wget -P jsonReports/ "https://hackerone.com/reports/@.json"
	)

	echo $jsonReponse
}

main(){

[[ ! -d "jsonReports" ]] && 
mkdir jsonReports || 
echo '[INFO] Json Output Folder already exist. Using It ...'

[[ -f "reportLinksHackerOne" ]] &&
echo '[INFO] HackerOne report id files found. Using it ...';
allReportsId=`cat reportLinksHackerOne`
 getHackerOneReportJson "$allReportsId" ||
echo '[INFO] Extracting all disclosed id reports from H1'
#getOnlyHackeroneReportLinks
allReportsId=`getOnlyHackeroneReportLinks`
getHackerOneReportJson "$allReportsId"
}

main	