#!/bin/bash
ps -o ppid -p "$1" | tail -n 1 | tr -d ' '
