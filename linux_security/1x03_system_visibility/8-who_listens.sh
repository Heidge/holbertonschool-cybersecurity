#!/bin/bash
lsof -i :"$1" -s TCP:LISTEN | awk 'NR==2 {print $1}'
