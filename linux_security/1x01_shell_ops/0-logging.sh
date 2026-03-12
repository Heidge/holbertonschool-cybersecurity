#!/bin/bash
{ echo "Starting Task"; echo "Doing Work"; echo "Error: Work Failed" >&2; } > execution.log 2>&1
