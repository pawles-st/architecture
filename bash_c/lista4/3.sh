#!/bin/bash

webcat=`curl 'https://api.thecatapi.com/v1/images/search?format=json' | jq '.[0].url'`
#echo `curl 'https://api.thecatapi.com/v1/images/search?format=json'`
curl `echo $webcat | tr -d '"'` > imgcat.jpg
webjoke=`curl https://api.chucknorris.io/jokes/random | jq '.value'`
img2txt -f utf8cr -W 200 imgcat.jpg
#img2txt -W 200 imgcat.jpg
echo $webjoke
