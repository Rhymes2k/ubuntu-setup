#!/bin/bash

# root-setup.sh
# Dimitrios Paraschas (paraschas@gmail.com)

# run as root to setup sudo for the specified user

### install sudo
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if [ ! command -v sudo >/dev/null 2>&1 ]; then
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
    elif id -u $USERNAME >/dev/null 2>&1; then
        # http://stackoverflow.com/questions/12375722/how-do-i-test-in-one-line-if-command-output-contains-a-certain-string
        if [[ $(groups $USERNAME) == *sudo* ]]; then
            echo "user \"$USERNAME\" already belongs to the group sudo"
            break
        else
            # add the user to the group sudo
            # http://askubuntu.com/questions/7477/how-can-i-add-a-new-user-as-sudoer-using-the-command-line
            adduser "$USERNAME" sudo
            if [ $? == 0 ]; then
                echo "the user \"$USERNAME\" was added to the group sudo"
            else
                echo "an error occurred while adding the user \"$USERNAME\" to the group sudo"
            fi
            break
        fi
    else 
        echo "the user \"$USERNAME\" doesn't exist"
    fi
done

### alternative method
# add the user dp to the sudoers file
#sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) ALL/' /etc/sudoers
# add the user dp to the sudoers file, don't require password on sudo
#sed -i 's/^root\tALL=(ALL:ALL) ALL$/&\ndp\tALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
