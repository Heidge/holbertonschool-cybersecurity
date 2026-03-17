#!/bin/bash
ss -4Hltn | awk '{print $4}' | awk -F: '{print $NF}' | sort -nu
