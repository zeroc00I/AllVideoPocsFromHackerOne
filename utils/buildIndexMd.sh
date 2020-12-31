#!/bin/bash
dir=$(dirname "$1")
cat "$1" |
jq -r '"# Title\n"+.title,"# URL \n"+.url,"# Reporter \n"+.reporter.username+"\n"' | anew "$dir"/index.md
