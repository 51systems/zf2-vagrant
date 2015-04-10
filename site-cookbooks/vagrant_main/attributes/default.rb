override['mysql']['server_root_password'] = 'root'

override['mysql']['version'] = '5.5'
override['mysql']['port'] = '3306'

include_attribute 'vagrant_main::php'