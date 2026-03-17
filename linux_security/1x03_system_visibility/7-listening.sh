#!/bin/bash
ss -lnt4 | tail -n +2 | awk '{print $4}' | awk -F: '{print $NF}' | sort -nu
