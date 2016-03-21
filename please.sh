#!/usr/bin/env bash

#
# Please - A polite and human automatic project creator for vagrant boxes.
# By Jehan Fillat <contact@jehanfillat.com>
#
# Version 0.1
#
#
# This script automates the creation & deletion of new sites on webservers
#
# Copyright (C) 2016 Jehan Fillat
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.1.6.0
#
version_number=0.1

about() {
    echo ""
    echo ""
    echo -e " \e[34m    ██████╗ ██╗     ███████╗ █████╗ ███████╗███████╗"
    echo -e " \e[34m    ██╔══██╗██║     ██╔════╝██╔══██╗██╔════╝██╔════╝"
    echo -e " \e[34m    ██████╔╝██║     █████╗  ███████║███████╗█████╗  "
    echo -e " \e[34m    ██╔═══╝ ██║     ██╔══╝  ██╔══██║╚════██║██╔══╝  "
    echo -e " \e[34m    ██║     ███████╗███████╗██║  ██║███████║███████╗"
    echo -e " \e[34m    ╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝"                                  
    echo ""
    echo -e " \e[34m    A polite and human automatic project creator for vagrant boxes.\e[0m"
    echo -e " \e[34m    Author : Jehan Fillat <contact@jehanfillat.com>\e[0m"
    echo -e " \e[34m    GitHub : https://github.com/JehanApathia \e[0m"
    echo ""
    echo ""
}

mkdomain() {
   
    echo -e "\e[1mPlease wait. \e[0mI'm creating the Directory for $sitename.dev..."
    if mkdir -p /var/www/public/$sitename.dev ; then
    echo "$sitename.dev" > /var/www/public/$sitename.dev/custom-hosts
    echo -e "\e[1;32mHooray!\e[0m Directory created successfully."
    fi
    
}

mkvhost() {
    
    echo -e "\e[1mHold on please. \e[0mI'm creating the Virtual Host config for $siteame.dev..."
    if sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$sitename.dev.conf ; then
    sudo sed -i s,"#ServerName www.example.com","ServerName $sitename.dev",g /etc/apache2/sites-available/$sitename.dev.conf
    sudo sed -i s,/var/www/public,/var/www/public/$sitename.dev,g /etc/apache2/sites-available/$sitename.dev.conf
    sudo a2ensite $sitename.dev.conf
    echo -e "\e[1;32mHooray!\e[0m Virtual Host is ready."
    fi
    
}

create_domain() {
    
    echo -e "\e[1;96mPlease, give me some informations for your new domain \e[0m"
    
    # accept the name of our website
    read -e -p "Site name (your dev url will be [sitename].dev): " sitename
    read -e -p "Do you want me to create an empty MySQL database ? (y/n) " site_db
    
    echo ""
    echo -e "\e[34mPlease, double-check your informations before I begin to work. \e[0m"
    echo ""
    echo -e "\e[1m Site name : \e[96m$sitename \e[0m"
    [[ "$site_db" = "y" ]] && echo -e "\e[1m Create a database : \e[1;32m Yes please.\e[0m" || echo -e "\e[1m Create a database : \e[1;31m No thanks.\e[0m"
    echo ""
    
    # add a simple yes/no confirmation before we proceed
    read -e -p "Do you want me to run the installation procedure? (y/n): " run

    # if the user didn't say no, then go ahead an install
    if [ "$run" == n ] ; then
    exit
    else

    mkdomain

    mkvhost
    
    if [ $site_db = "y" ] ; then
        echo -e "\e[1mSorry to disturb you sir\e[0m, but I will need your MySQL credentials :"
        read -e -p "Enter your mysql username... " mysql_user
        read -e -p "...and your mysql password : " mysql_password
        echo -e "\e[1mPlease wait. \e[0mCreating database for $sitename.dev..."
        if mysqladmin -u$mysql_user -p$mysql_password create $sitename.dev ; then
            echo -e "\e[1;32mHooray!\e[0m Database $sitename.dev created successfully."
        fi
    fi

    echo -e "\e[1mHold on please, \e[0mI'm restarting Apache"
    sudo service apache2 restart

    echo ""
    echo "================================================================="
    echo ""
    echo -e "\e[1mYour Domain is \e[1;96mready\e[0m!"
    echo ""
    echo -e "Enjoy your new website : \e[94mhttp://$sitename.dev\e[0m"
    echo ""
    echo "================================================================="
    echo ""

    fi
    
}

create_wordpress() {
    
    echo -e "\e[1;96mPlease, give me some informations for your new WordPress installation \e[0m"
    
    # accept the name of our website
    read -e -p "Site name (your url will be [sitename].dev): " sitename
    read -e -p "Admin Username: " username
    read -s -p "Admin Password: " password
    echo ""
    read -e -p "Admin Email address: " email
    
    echo ""
    echo -e "\e[34mPlease, double-check your informations before I begin to work. \e[0m"
    echo ""
    echo -e "\e[1m Site name : \e[96m$sitename.dev\e[0m"
    echo -e "\e[1m Admin Username : \e[96m$sitename\e[0m"
    echo -e "\e[1m Admin Email address : \e[96m$sitename\e[0m"
    echo ""
    
    # add a simple yes/no confirmation before we proceed
    read -e -p "Do you want me to run the installation procedure? (y/n): " run

    # if the user didn't say no, then go ahead an install
    if [ "$run" == n ] ; then
    exit
    else

    mkdomain

    mkvhost

    echo -e "\e[1mHold on please, \e[0mI'm restarting Apache"
    sudo service apache2 restart

    # download the WordPress core files
    wp core download --path="/var/www/public/$sitename.dev"

    # create the wp-config file with our standard setup
    wp core config --path="/var/www/public/$sitename.dev" --dbname=$sitename.dev --dbuser=root --dbpass=root --extra-php <<PHP
    define( 'WP_DEBUG', true );
    define( 'DISALLOW_FILE_EDIT', true );
PHP

    # create database, and install WordPress
    echo -e "\e[1mPlease wait. \e[0mI'm creating the WordPress database"
    wp db create --path="/var/www/public/$sitename.dev"
    echo -e "\e[1mI know this is getting boring\e[0m, but I have almost finished! I'm installing WordPress right now..."
    wp core install --url="http://$sitename.dev" --title="$sitename" --admin_user="$username" --admin_password="$password" --admin_email="$email" --path="/var/www/public/$sitename.dev" --skip-email

    # set pretty urls
    wp rewrite structure '/%postname%/' --hard --path="/var/www/public/$sitename.dev"
    wp rewrite flush --hard --path="/var/www/public/$sitename.dev"

    # delete akismet and hello dolly
    wp plugin delete akismet --path="/var/www/public/$sitename.dev"
    wp plugin delete hello --path="/var/www/public/$sitename.dev"

    echo ""
    echo "================================================================="
    echo ""
    echo -e "\e[1mYour WordPress is \e[96mready\e[0m!"
    echo ""
    echo -e "Enjoy your new website : \e[94mhttp://$sitename.dev\e[0m"
    echo -e "Head to your WordPress admin : \e[94mhttp://$sitename.dev/wp-admin\e[0m"
    echo ""
    echo "================================================================="
    echo ""

    fi
    
}

create_symfony() {
    
    echo -e "\e[1;96mPlease, give me some informations for your new Symfony project \e[0m"
    
    read -e -p "Site name (your dev url will be [sitename].dev): " sitename
    read -e -p "Which version do you want to install ? (number or \"lts\"): " symfony_version
    
    xdebug=$(php -m | grep -i xdebug)
    if [ -z "$xdebug" ] ; then
            read -e -p "I see that the php xdebug extension is not installed, do you want me to install it? (y/n): " xdebug_install
    fi
    
    apc=$(php -m | grep -i apc) 
    if [ -z "$apc" ] ; then
            read -e -p "APC Cache doesn't seems to installed, do you want me to install it? (y/n): " apc_install
    fi
    
    echo ""
    echo -e "\e[34mPlease, double-check your informations before I begin to work. \e[0m"
    echo ""
    echo -e "\e[1m Site name : \e[96m$sitename.dev\e[0m"
    echo -e "\e[1m Symfony version : \e[96m$symfony_version\e[0m"
    [[ "$xdebug_install" = "y" ]] && echo -e "\e[1m Install PHP xdebug : \e[1;32m Yes please.\e[0m" || echo -e "\e[1m Install PHP xdebug : \e[1;34m Already installed.\e[0m"
    [[ "$apc_install" = "y" ]] && echo -e "\e[1m Install APC : \e[1;32m Yes please.\e[0m" || echo -e "\e[1m Install APC : \e[1;34m Already installed.\e[0m"
    echo ""
    
    # add a simple yes/no confirmation before we proceed
    read -e -p "Do you want me to run the installation procedure? (y/n): " run

    # if the user didn't say no, then go ahead an install
    if [ "$run" == n ] ; then
    exit
    else
    
    if [ ! -d "/usr/local/bin/symfony" ]; then
        echo -e "\e[1mSymfony does not seems to be installed. \e[0mBegin installation..."
        sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
        sudo chmod a+x /usr/local/bin/symfony
    fi
    
    if [ "$xdebug_install" == "y" ] ; then
        echo -e "\e[1mI'm installing xdebug. \e[0mPlease wait a few seconds..."
        sudo apt-get update -q
        sudo apt-get install php5-dev php-pear -y
        sudo pecl install xdebug
        xdebug_path=$(find / -name 'xdebug.so')
    fi
    
    echo -e "\e[1mPlease wait. \e[0mI'm creating your new Symfony project..."
    (cd /var/www/public && symfony new $sitename.dev $symfony_version)
    
    mkvhost
    
}

create_angular() {
    
    echo -e "\e[1;96mPlease, give me some informations for your new Angular2 App \e[0m"
    
    # accept the name of our website
    read -e -p "Site name (your dev url will be [sitename].dev): " sitename
    read -e -p "Maybe you want to update node & npm while you go grab a coffee? (y/n) " node_npm_update
    read -e -p "Run Angular2 TypeScript compiler right after installation? (y/n): " tsc
    
    echo ""
    echo -e "\e[34mPlease, double-check your informations before I begin to work. \e[0m"
    echo ""
    echo -e "\e[1m Site name : \e[96m$sitename \e[0m"
    [[ "$node_npm_update" = "y" ]] && echo -e "\e[1m Update node & npm : \e[32m Yes please.\e[0m" || echo -e "\e[1m Update node & npm : \e[31m No thanks.\e[0m"
    echo ""
    
    # add a simple yes/no confirmation before we proceed
    read -e -p "Do you want me to run the installation procedure? (y/n): " run

    # if the user didn't say no, then go ahead an install
    if [ "$run" == n ] ; then
    exit
    else

    echo -e "\e[1mPlease wait. \e[0mI'm importing a quickstart Angular2 App from GitHub Repo in $sitename.dev directory..."
    if git clone https://github.com/angular/quickstart /var/www/public/$sitename.dev ; then
    sudo sed -i s,"Angular 2 QuickStart","$sitename.dev",g /var/www/public/$sitename.dev/index.html
    # THE FOLLOWING LINE IS A FIX FOR THE "ReferenceError: System is not defined" ERROR
    sudo sed -i s,"<script src=\"node_modules/systemjs/dist/system.src.js\"></script>","<script src=\"https://code.angularjs.org/tools/system.js\"></script>",g /var/www/public/$sitename.dev/index.html
    sudo sed -i s,"angular2-quickstart","$sitename.dev",g /var/www/public/$sitename.dev/package.json
    echo "$sitename.dev" > /var/www/public/$sitename.dev/custom-hosts
    echo -e "\e[1;32mHooray!\e[0m Angular2 App imported successfully. It's a wonderful little girl! Take care of her or it's gonna be veeery very bad for you. Please."
    fi

    mkvhost
    
    if [ "$node_npm_update" == "y" ] ; then
        if sudo npm cache clean -f ; then
            echo -e "\e[1msudo npm cache clean -f : \e[1;32mok \e[0m"
        fi
        if sudo npm install -g n ; then
            echo -e "\e[1msudo npm install -g n : \e[1;32mok \e[0m"
        fi
        if sudo n stable ; then
            echo -e "\e[1msudo n stable : \e[1;32mok \e[0m"
        fi
        if sudo n stable ; then
           echo -e "\e[1msudo npm install npm -g : \e[1;32mok \e[0m"
        fi
    fi

    echo -e "\e[1mHold on please, \e[0mI'm restarting Apache"
    sudo service apache2 restart
    
    echo -e "\e[1mI'm doing a possibly-not-so-quick \"npm install\", \e[0m, sorry about that."
    (cd /var/www/public/$sitename.dev && npm install  --ignore-scripts --quiet)
    (cd /var/www/public/$sitename.dev && typings install)
    
    if [ "$tsc" == "y" ] ; then
        echo -e "\e[1mI launch the TypeScript Compiler immediately\e[0m, as you requested."
        (cd /var/www/public/$sitename.dev && npm run tsc:w)
    fi

    echo ""
    echo "================================================================="
    echo ""
    echo -e "\e[1mYour new Angular2 App is \e[1;96mready\e[0m!"
    echo ""
    echo -e "Enjoy it here : \e[94mhttp://$sitename.dev\e[0m"
    echo ""
    echo "================================================================="
    echo ""

    fi
    
}

create() {
    
    echo -e "\e[1;96mPlease select the type of project you want me to create : \e[0m"
    
    PS3='Please enter your choice: '
    options=("Simple Domain" "WordPress" "Symfony" "Angular2" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Simple Domain")
                create_domain
                break
                ;;
            "WordPress")
                create_wordpress
                break
                ;;
            "Symfony")
                create_symfony
                break
                ;;
            "Angular2")
                create_angular
                break
                ;;
            "Quit")
                break
                ;;
            *) echo invalid option;;
        esac
    done
    
}

delete() {
    
    echo ""
    echo -e "\e[1mAlright. \e[0mI hope it's not my fault..."
    echo ""
    
    read -e -p "Which site do you want me to delete (add the .dev extension please) : " sitename

    read -e -p "Are you sure? You will throw $sitename into limbo. His soul will be lost forever. (y/n): " run

    # if the user didn't say no, then go ahead and remove
    if [ "$run" == n ] ; then
        exit
    else
    
        echo "-------------------------------------------------"
        echo -e "† \e[1m$sitename ut requiescant in pace. †"
        echo "-------------------------------------------------"
        
        echo -e "\e[1mPlease wait\e[0m, I'm checking if there's a database to remove."
        if mysql -e "use $sitename" ; then
            echo -e "\e[1mSorry to disturb you sir\e[0m, but I will need your MySQL credentials :"
            read -e -p "Enter your mysql username : " mysql_user
            read -e -p "And your mysql password : " mysql_password
            echo "Hold on please, I'm removing database for $sitename..."
            if mysqladmin -u$mysql_user -p$mysql_password drop $sitename ; then
            echo -e "\e[1;32mHooray!\e[0m database removed"
            fi
        else 
            echo "No database found. I'm going on."
        fi
        

        echo -e "\e[1mPlease wait. \e[0mI'm removing $sitename directory ..."
        if rm -R /var/www/public/$sitename ; then
        echo -e "\e[1;32mHooray!\e[0m Directory removed successfully."
        fi

        echo -e "\e[1mHold on please, \e[0mI'm deleting $sitename Virtual Host..."
        if sudo a2dissite $sitename.conf ; then
        sudo rm /etc/apache2/sites-available/$sitename.conf
        echo -e "\e[1;32mHooray!\e[0m Virtual Host deleted"
        fi

        echo -e "\e[1mPlease wait \e[0m, I'm restarting Apache"
        sudo service apache2 restart
        
        echo ""
        echo -e "Your $sitename was sucessfully \e[1;96merased\e[0m!"
        echo ""

    fi
    
}

main() {
	
    if [ -z "$1" ]; then
	    about
	fi
    
    if [ "$1" = "create" ]; then
    	create
    fi
    
    if [ "$1" = "delete" ]; then
    	delete
    fi

}

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	main "$@"
fi