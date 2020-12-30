#!/bin/bash

find -name "*.json" |
xargs -I@ sh -c "gron "@" 2>&1 |
grep -qEi '$1 = .*$2.*' && echo @"
