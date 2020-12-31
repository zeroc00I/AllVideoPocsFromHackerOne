#!/bin/bash
dir=$(dirname "$1")
cat "$1" |
jq -r '"### Title\n"+.title,"#### URL \n"+.url,"#### Severity score",.severity.score,"#### Reporter \n"+.reporter.username+"\n### Bounty paid",.formatted_bounty,"\n\n---\n\n"' >> "$dir"/index.md
