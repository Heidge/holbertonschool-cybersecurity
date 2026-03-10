#!/bin/bash
mkdir -p "$1" && chgrp "$2" "$1" && chmod 3725 "$1"
