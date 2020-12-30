#!/bin/bash


helper(){
	usage="Helping you finding keys and values into JSON \n\n$(basename "$0") [-h] [-s] [-k] [-r]  
	\n\n[Commands]\n
	\n-h  show this help text
	\n-s search 'key' 'value' into JSON files 
	\n and return all files that match [Output: filenames]
	\n-r raw search [Output: Value from all JSON keys]
	\n-k list all keys available
	\n\n[e.g]\n ./script search weakness.name ssrf
	\n ./script raw weakness.name"
	echo -e $usage;
	exit
}

normalSearch(){
	find $(dirname $(pwd)) -name "*.json" |
	xargs -P50 -I@ sh -c "grep -l '\"$1\"' '@' 2>&1"
}

rawSearch(){
	find $(dirname $(pwd)) -name "*.json" |
	xargs -P50 -I@ sh -c "gron "@" 2>&1 |
	grep -Ei '$1 = .*$2.*'"
}

searchFiles(){
	find $(dirname $(pwd)) -name "*.json" |
	xargs -P50 -I@ sh -c "gron "@" 2>&1 |
	grep -qEi '$1 = $2' && echo @"
}

main(){
	case "$1" in
		search|-s) searchFiles "$2" "$3" ;;
		raw|-r) rawSearch "$2" "$3" ;;
		normal|-n) normalSearch "$2" ;;
		keys|-k) cat allKeys; exit ;;
		help|-h) helper ;;
		*) helper;exit ;;
	esac
}

main "$1" "$2" "$3"
