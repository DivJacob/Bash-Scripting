#!/bin/bash
#checking if .myipaddr exists
if [ -e ".myipaddr" ];
then 
	echo "IP READ FROM CACHE"
else
	echo "CALLING API TO QUERY MY IP"
#calling IP Address Location API
	curl -s ipinfo.io > .myipaddr
fi	

API_KEY=19873f376d734a118561c1b2cf3fb3d4
#filtering out the loc field 
location="$(cat .myipaddr | jq '.loc' )" 
latitude=`echo $location | tr -d '"' | cut -d "," -f 1`
longitude=`echo $location | tr -d '"' | cut -d "," -f 2`

echo "Forecast for my lat=$latitude°, lon=$longitude°"
#Calling weatherbit API 
weather=`curl -s "https://api.weatherbit.io/v2.0/forecast/daily?key=$API_KEY&lat=$latitude&lon=$longitude" | jq '.data'`
for row in `echo $weather | jq -r '.[] | [.datetime, .max_temp, .min_temp] | @csv'` ; do
	arr=($(echo $row | tr "," " "))
	date=`echo ${arr[0]} | tr -d '"'`
	echo "Forecast for $date HI: ${arr[1]}°c LOW: ${arr[2]}°c"
done


