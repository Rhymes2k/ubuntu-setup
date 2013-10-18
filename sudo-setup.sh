#!/bin/bash

# sudo-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# run as root to setup sudo for the specified user

### install sudo
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! command -v sudo &> /dev/null; then
    #apt-get install -y sudo
    apt-get install sudo
fi

# TODO the code needs review

### add the specified user to the group sudo
echo ""
echo "### setup sudo for a user ###"
echo ""
while true; do
    # request the username of the user
    # http://stackoverflow.com/questions/226703/how-do-i-prompt-for-input-in-a-linux-shell-script
    read -p "username of the user, enter to exit: " USERNAME
    if [ "$USERNAME" == "" ]; then
        echo ""
        echo "read the source file for an alternative method to setup sudo for a user"
        break
    # http://superuser.com/questions/336275/find-out-if-user-name-exists
    elif id -u $USERNAME &> /dev/null; then
        # http://stackoverflow.com/questions/12375722/how-do-i-test-in-one-line-if-command-output-contains-a-certain-string
        if [[ $(groups $USERNAME) == *sudo* ]]; then
            echo "user \"$USERNAME\" already belongs to the group sudo"
            #SUCCESS=1;
            break
        else
            # add the user to the group sudo
            # http://askubuntu.com/questions/7477/how-can-i-add-a-new-user-as-sudoer-using-the-command-line
            adduser "$USERNAME" sudo
            if [ $? == 0 ]; then
                echo "the user \"$USERNAME\" was added to the group sudo"
                #SUCCESS=1;
            else
                echo "an error occurred while adding the user \"$USERNAME\" to the group sudo"
            fi
            break
        fi
    else
        echo "the user \"$USERNAME\" doesn't exist"
    fi
done

### don't require password on sudo
# TODO this doesn't cover all cases
#while [ $SUCCESS ]; do
#    echo ""
#    read -p "do you want to use sudo without entering a password? (y/n): " PASSWORDLESS
#    case $PASSWORDLESS in
#        [Yy]* )
#            echo "original entry for user $USERNAME in sudoers file:"
#            cat /etc/sudoers | grep $USERNAME
#            sed -i "s/$USERNAME\tALL=(ALL:ALL) ALL$/$USERNAME\tALL=(ALL:ALL) NOPASSWD: ALL/" /etc/sudoers
#            echo "updated entry:"
#            cat /etc/sudoers | grep $USERNAME
#            break
#            ;;
#        [Nn]* )
#            break
#            ;;
#        * )
#            echo "please enter \"y\" for yes or \"n\" for no"
#            ;;
#    esac
#done

### don't require password on sudo
#sed -i 's/$USERNAME\tALL=(ALL:ALL) ALL$/$USERNAME\tALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

### alternative method
# add the user dp to the sudoers file
#sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) ALL/' /etc/sudoers
# add the user dp to the sudoers file, don't require password on sudo
#sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
