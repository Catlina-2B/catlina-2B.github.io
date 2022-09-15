#!/bin/bash

time=date %Y%M%d %H%M%S
git add .
git commit -m "add files at ${time}"
git pull origin master
git push origin master