#!/bin/bash
ps -eo state,pid | awk '$1 == "Z" { print $2 }'
