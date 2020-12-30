# Nothing special.
# Just some draft used

#head -n1 ../weakness/allWeaknessFormated | xargs -I@ bash -c './searchIntoJson.sh search weakness.name "@" | xargs -I "%" cp -n "%" ../weakness/"@"/'

#cat ../weakness/allWeaknessFormated | 
#xargs -P10 -I@ bash -c './searchIntoJson.sh normal "@" | xargs -I "%" cp -n "%" ../weakness/"@"/'
