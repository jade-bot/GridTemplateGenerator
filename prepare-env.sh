#!/bin/bash

# Configuration flags.
actual_step=0
configure_bower=false
configure_gem=false
configure_heroku=false
configure_npm=false
heroku_created=false

if [ ! $1 ]
then
    configure_bower=true
    configure_gem=true
    configure_heroku=true
    configure_npm=true
fi

until [ -z $1 ]
do
    case $1 in
        bower) configure_bower=true; shift;;
        gem) configure_gem=true; shift;;
        heroku) configure_heroku=true; shift;;
        npm) configure_npm=true; shift;;
        (-- | -*) shift;;
        (*) break;;
    esac
done

echo "\nPreparing enviromnent\n======================"

# Heroku configuration.
if $configure_heroku
then
    actual_step=`expr $actual_step + 1`

    echo "\n$actual_step - Heroku configuration\n--------------------"
    echo "Validating Heroku configuration..."

    # Validate if the heroku remote exists.
    if git ls-remote heroku > /dev/null 2>&1
    then
        echo "--> Heroku is already configured.\n"
        heroku_created=true
    else
        read -p "There's not Heroku configuration. Do you want to use Heroku to deploy the application? (y/n): "

        if [ $REPLY == 'y' ]
        then

            # If the user already created the Heroku app, then add it.
            read -p "--> Did you already created the Heroku app? (y/n): "

            if [ $REPLY == 'y' ]
            then
                function addHerokuUrl {
                    git remote rm heroku > /dev/null 2>&1
                    read -p "----> What is your application's git url?: "
                    git remote add heroku $REPLY

                    if git ls-remote heroku > /dev/null 2>&1
                    then
                        echo "------> SUCCESS! The remote was created successfully."
                        heroku_created=true
                    else
                        echo "------> ERROR: The remote url appears to be invalid!\n"
                        addHerokuUrl
                    fi
                }

                addHerokuUrl

            # If the user hasn't created the Heroku app, then create it.
            else
                function createHerokuApp {
                    read -p "----> What will be your application's name?: "
                    if heroku apps:create $REPLY
                    then
                        echo '------> The application was successfully created.'
                        heroku_created=true
                    else
                        createHerokuApp
                    fi
                }

                createHerokuApp
            fi
        fi
    fi
fi

# Install node packages.
if $configure_npm
then
    actual_step=`expr $actual_step + 1`

    echo "\n$actual_step- Installing Node packages\n---------------------------"
    sudo npm install
    echo "Done."
fi

# Install bower packages.
if $configure_bower
then
    actual_step=`expr $actual_step + 1`

    echo "\n$actual_step- Installing Bower packages\n------------------------------"
    bower install
    echo "Done."
fi

# Install Gems.
if $configure_gem
then
    actual_step=`expr $actual_step + 1`

    echo "\n$actual_step- Installing Ruby gems\n------------------------------"
    bundle install
    echo "Done."
fi