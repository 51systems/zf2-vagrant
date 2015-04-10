#Vagrant Setup

##Configuration
Vagrant is configured using Chef-Zero.

Some of the cookbooks are taken from https://github.com/r8/vagrant-lamp

###Vagrant Chef configuration
Some of the cookbooks require the most recent version of Chef (v11, I'm looking at you, build-essentials).
Install the vagrant-omnibus plugin
```shell
vagrant plugin install vagrant-omnibus
```

###Chef Cookbooks
Vagrant configuration cookbooks are managed using librarian

From the vagrant directory

Install librarian if necessary
```shell
sudo gem install librarian-chef
```

Init Librarian in the data/vm directory
```shell
librarian-chef init
```

Verify the existence of the Cheffile with the cat
```shell
cat Cheffile
```

Add the dependencies to the Cheffile. Eg:
```shell
cookbook 'apache2', '>=1.0.0'
```

Update the dependencies
```shell
librarian-chef install
```