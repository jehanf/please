# PLEASE #
A polite and human automatic project creator for vagrant boxes.  
Version 0.1

### ###

## Why **Please** and what is it? ##

This script has been created for automatically create Symfony, WordPress or even Angular2 (and more to come) projects in a Vagrant Box, by running a simple command in the terminal and answering a bunch of questions.
And since command line is a bit austere, I tried to add a bit of humanity in it.

Here is what **Please** will do for you :

* Creating your project's folder
* Configuring the Virtual Host (e.g. my-project.dev)
* Creating a database (optional)
* Installing your framework (WordPress, Symfony, Laravel...) so you can start working quickly

## SETUP GUIDE ##

### Get & configure a Vagrant Box ###

First of all, you must install a great Vagrant Box, such as my slighly modified scotch.io box.  
Why this box is better than an other one, you ask? **Because it works**. It's great enough for me.  

```bash
$ git clone  https://github.com/jehanf/please-box.git  my-folder
$ cd my-folder
$ vagrant up
```

**Important** : for the Virtual Hosts to work properly, you must install the [Vagrant Hosts Updater](https://github.com/cogitatio/vagrant-hostsupdater) plugin by running this simple command :

```bash
$ vagrant plugin install vagrant-hostsupdater
```  

Phewww, I'm sure you are exhausted now!

### Installing **Please** ###

Very hard, once again :

```bash
$ git clone  https://github.com/jehanf/please.git
$ sudo chmod +x please/please
$ sudo mv please/please /usr/local/bin/please && sudo rm -R please
```

Let me just explain the last two lines :  
`sudo chmod +x please/please` : Makes the bash script executable.  
`sudo mv please/please /usr/local/bin/please && sudo rm -R please` : Moves the bash script into /usr/local/bin/ folder for easy use and remove the folder downloaded via git (now only containing the readme file you are currently reading)

### Using **Please** ###

First, do a small :
```bash
$ please create
```
to start the creation of your new project, no matter what is it, I'll only ask you a couple of questions that needs to be answered.

You can also do a simple `$ please create wordpress` (or replace wordpress by the correct framework you want to use).

At the moment, only the following services are available (shorthand command) :
- Simple Custom Domain (domain)
- WordPress (wordpress)
- Symfony (symfony)
- Laravel (laravel)
- Angular2 (angular2)

And the second option, very easy to understand : 

```bash
$ please delete
```
to delete a project. Same here, a couple of questions and that's it.

Whoa! It's finished!

## Who do I talk to? ##

* I'm Jehan Fillat, a french freelance PHP developper, for any questions : [contact@jehanfillat.com](mailto:contact@jehanfillat.com)
* I also run a music label called **Apathia Records**, feel free to take a look if you like experimental, metal or a bunch of electronic music : [apathiarecords.com](http://www.apathiarecords.com)
