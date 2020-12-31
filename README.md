# AllPocsFromHackerOne
#### Work in progress!

This script grabs public report from hacker one and download all JSON files to be grepable

The main goal is make easy categorize vulns by technique

# - Requirements
## Gron
```
go get -u github.com/tomnomnom/gron
```
# - Tree
## Weakness
All weakness categorized
## jsonReports
All json files from disclosed reports from hackerone. Already downloaded.
## reportLinksHackerOne file  
All ids from hackerOne disclosed reports
## Utils Folder
### searchIntoJson.sh (gron required)
Script helping you finding keys and values into JSON
### buildRepo.sh
Do your own jsonReports folder, downloading all disclosed reports from hackerone 

Test
https://github.com/bminossi/AllVideoPocsFromHackerOne/blob/main/weakness/Cross-site Scripting (XSS) - DOM/index.md
