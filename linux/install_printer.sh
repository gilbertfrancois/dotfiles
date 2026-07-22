#!/bin/bash

# if first argument is zero, show all printers
if [ -z "$1"]; then
    echo "Available printers:"
    echo ""
    lpstat -e

    echo ""
    echo "Set default printer: $0 [printer name]"
    exit 0
fi

lpadmin -d $1
lpoptions -p $1 -o sides=two-sided-long-edge
