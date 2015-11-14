#!/bin/bash

if [ -f /.fix_group-installed ]; then
    echo "Group permissions should already be fixed"
    exit 0
fi

# Modify the www-data group id to match the group id of the local workstation.
usermod -u 1000 www-data
groupmod -g 1000 www-data


echo "=> Done!"
touch /.fix_group-installed