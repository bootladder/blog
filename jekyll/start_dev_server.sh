#!/bin/bash
while true
do
sleep 1
bundle exec jekyll serve &
sleep 100
echo exiting
kill %1
kill %1
done
