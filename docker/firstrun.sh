#!/bin/bash

if [ ! -f /.fix_group-installed ]; then
    /fix_group.sh
fi

if [ ! -f /.mysql_admin_created ]; then
    /create_mysql_admin_user.sh
fi

if [ ! -f /.webgrind-installed ]; then
    /install_webgrind.sh
fi

if [ ! -f /.composer-installed ]; then
    /install_composer.sh
fi
