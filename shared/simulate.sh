#!/bin/bash

while [ 1 ]
do
    max=$(( ( RANDOM % 99 )  + 1 ))
    curl -H "apikey:systemAsecret" -s "http://localhost:8000/leaderboard/player/[1-$max]" "http://localhost:8000/leaderboard/player?[1-$max]"
    curl -H "apikey:webappsecret" -s "http://localhost:8000/leaderboard/player/[1-$max]" "http://localhost:8000/leaderboard/player?[1-$max]"
    sleep .5
done