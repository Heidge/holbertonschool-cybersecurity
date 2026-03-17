#!/bin/bash
sudo chattr -i "$1" && rm "$1"
