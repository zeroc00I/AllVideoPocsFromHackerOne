# AllVideoPocsFromHackerOne

This script grabs public report from hacker one and makes some folders with POC videos  

# Work in progress!

Currently, I'm testing dump all JSON from disclosed reports.

These JSON will be used to categorize by vulnerabilities.

Other filters can be made.

## Please remove jsonReports folder

I'm just uploading here if someone would like to use this JSONs to another purpose / tool

## Drafts

- Download all attachments from report

```
curl -sf https://hackerone.com/reports/1026752.json | 
jq -r '.attachments|.[]|.expiring_url' | xargs -I@ -P5 wget @
```
