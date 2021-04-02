#cd ~/the/script/folder
#chmod +x ./woo-init.sh

#TODO Ask the name for the project directory and then make the directory
# PROJECT DIRECTORY
DIR="$(pwd)"
HASWP="wp-admin"
PLUGINDIR="wp-content/plugins"
THEMEDIR=""
## COMPUTER TALKS IN YELLOW
YELLOW=`tput setaf 3`


wp_install () 
{ 
    wp core download --path=$1;
    cd $1;
    read -p 'name the database:' dbname;
    wp config create --dbname=$dbname --dbuser=root --dbpass=awoods --dbhost=localhost;
    wp db create;
    wp core install --prompt
}

wp_plugin_install () {
    echo "${YELLOW}This folder has WordPress installed. Continuiing with installing plugins and themes..."
    # wp plugin install --activate https://github.com/afragen/github-updater/archive/master.zip
    # echo "${YELLOW}Github updater has been installed... next..."
    wp plugin --activate install https://github.com/wp-premium/advanced-custom-fields-pro/archive/master.zip
    echo "${YELLOW}ACF Has been installed... next..."
    wp plugin --deactivate uninstall hello
    echo "${YELLOW}Hello has been uninstalled"
    wp plugin --deactivate uninstall akismet
    echo "${YELLOW}Akismet has been uninstalled"
}

# IF WORDPRESS EXISTS (IT CHECKS IT BY SIMPLY CHECKING THE FOLDERS)
if [ -d "$HASWP" ]; then
    wp_plugin_install
    # echo "${YELLOW}All the themes have been deactivated and uninstalled, let's get to work!"
    ## NAME YOUR PROJECT
    echo "What is the name of your project? This will be your themename too"
    read projectname
    echo "Alright. I will make a theme named ${projectname}"
    ## CD into theme folder and makes the child theme for this project
    cd ./wp-content/themes && mkdir ${projectname}
    ## it would be better to just pull in my woo-blanktheme repo and then cd into that
     
else
    echo "There is no WordPress installed. I will install it"
    wp core download --path=$1;
    read -p 'name the database:' dbname;
    #FIXME IT CANNOT CREATE THE DATABASE BECAUSE OF ROOT ISSUES
    wp config create --dbname=$dbname --dbuser=root --dbpass=root --dbhost=localhost:8889;
    wp core install --prompt --url=${dbname}.maggie
    wp_plugin_install
    echo "What is the name of your project? This will be your themename too"
    read projectname
    echo "Alright. I will make a theme named ${projectname}"
    cd wp-content/themes && mkdir ${projectname}
    cd ${projectname}
    echo "# gpm" >> README.md
    git init
    git commit -m "first commit"
    git branch -M master
    git remote add origin https://github.com/BluePraise/${projectname}.git
    git push -u origin master

fi
