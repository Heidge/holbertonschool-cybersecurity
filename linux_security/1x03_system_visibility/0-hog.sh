#!/bin/bash
ps -eo pid,%cpu,comm --sort=-%cpu | awk 'NR==2 {print $1, $3}'
