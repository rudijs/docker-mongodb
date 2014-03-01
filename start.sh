#!/bin/sh

###########################################################
# Create a 'user' user account if it does not already exist
###########################################################

# SSH user account name
USERNAME=user

# Get username entries
USER=`getent passwd $USERNAME`

if [ -z "$USER" ] ; then
  SSH_USERPASS=`pwgen -c -n -1 24`
  useradd -c 'Generic User Account' -d /home/$USERNAME -m -G sudo -s /bin/bash $USERNAME
  echo $USERNAME:$SSH_USERPASS | chpasswd
  echo "ssh $USERNAME password: $SSH_USERPASS"
else
  echo "Account '$USERNAME' exists"
fi

##################################
# Configure MongoDB database files
##################################

# mongod will run as user mongodb, see: supervisord_mongodb.conf
# Update db/ folder and file permissions to match this

DATA_DB=/data/db
DATA_DB_OWNER=`stat -c %U $DATA_DB`
DATA_DB_USERNAME=mongodb

if [ $DATA_DB_OWNER != $DATA_DB_USERNAME ]; then
chown -R $DATA_DB_USERNAME.$DATA_DB_USERNAME $DATA_DB
fi

##############
# Run services
##############

supervisord -n
