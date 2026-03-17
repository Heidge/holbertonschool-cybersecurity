#!/bin/bash
ss -4ltnp "sport = :$1" | awk 'NR>1 { print $NF }' | grep -oP 'users:\(\("\K[^"]+'
