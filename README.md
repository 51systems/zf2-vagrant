#Vagrant Setup

##Configuration
Vagrant is configured using Chef-Solo.

Some of the cookbooks are taken from https://github.com/r8/vagrant-lamp

###Vagrant Chef configuration
Some of the cookbooks require the most recent version of Chef (v11, I'm looking at you, build-essentials).
Install the vagrant-omnibus plugin
    vagrant plugin install vagrant-omnibus

###Chef Cookbooks
Vagrant configuration cookbooks are managed using librarian

From the data/vm directory

Install librarian if necessary
    sudo gem install librarian-chef

Init Librarian in the data/vm directory
    librarian-chef init

Verify the existence of the Cheffile with the cat
    cat Cheffile

Add the dependencies to the Cheffile. Eg:
    cookbook 'apache2', '>=1.0.0'

Update the dependencies
    librarian-chef install