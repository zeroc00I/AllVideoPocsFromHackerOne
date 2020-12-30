#!/bin/bash


helper(){
	usage="Helping you finding keys and values into JSON \n$(basename "$0") [-h] [-s] [-k] -- 
	\nwhere:
	\n-h  show this help text\n-s  search 'key' 'value' into JSON files
	\n-k  list all keys available
	\n e.g: ./script search weakness.name ssrf"
	echo -e $usage;
	exit
}


rawSearch(){
	find $(dirname $(pwd)) -name "*.json" |
	xargs -I@ sh -c "gron "@" 2>&1 |
	grep -qEi '$1 = .*$2.*' && echo @"
}

main(){
	case "$1" in
		search|-s) rawSearch "$2" "$3" ;;
		keys|-k) cat allKeys; exit ;;
		help|-h) helper ;;
		*) echo "Invalid Option. Type ./script help" ;;
	esac
}

main "$1" "$2" "$3"
