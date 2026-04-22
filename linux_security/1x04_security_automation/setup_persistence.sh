#!/bin/bash
cp sentinel.service sentinel.timer /etc/systemd/system/
systemctl daemon-reload
systemctl start sentinel.timer
