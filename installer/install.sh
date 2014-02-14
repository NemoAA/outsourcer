#!/bin/bash
############################################################################################################################
#
# Outsourcer install script.
#
############################################################################################################################

# make sure executing as root
if [ "`whoami`" != root ]; then
        echo "You MUST run install as root"
	echo Exiting
	exit 1
fi

# get the version number
if [ -f version.sh ]; then
	source version.sh
else
        echo "version.sh not found!"
        echo Exiting
        exit 1
fi

# make sure zip file is found
if [ ! -f $os_version.zip ]; then
	echo "Zip file not found!"
	echo Exiting
	exit 1
fi

# make backups of Oracle and SQL Server Jar files if exists
#Microsoft Jar
if [ -z $MSJAR ]; then
	MSJAR=/usr/local/os/jar/sqljdbc4.jar
fi

if [ -f $MSJAR ]; then
	cp $MSJAR .
fi

#Oracle Jar
if [ -z $OJAR ]; then
	OJAR=/usr/local/os/jar/ojdbc6.jar
fi

if [ -f $OJAR ]; then
	cp $OJAR .
fi

# remove this version if it already exists
rm -rf /usr/local/$os_version

# remove old symbolic link
rm /usr/local/os

# unzip new version
unzip os.zip -d /usr/local/$os_version/

# create new symbolic link
ln -s /usr/local/$os_version /usr/local/os 

# change ownership to gpadmin
chown -R gpadmin /usr/local/$os_version

# set permissions
chmod 755 /usr/local/os/bin/*
chmod 755 /usr/local/os/os_install.sh
chmod 755 /usr/local/os/os_path.sh

# copy SQL Server and Oracle jar files back
for i in $( ls *.jar 2> /dev/null ); do
	echo cp $i /usr/local/os/jar/
	cp $i /usr/local/os/jar/
done

echo "##################################################################"
echo "Outsourcer operating system installation complete"
echo "##################################################################"
echo

echo "##################################################################"
echo "Installing database components as gpadmin"
echo "##################################################################"

su - gpadmin -c '/usr/local/os/os_install.sh'

echo "Installation Complete!"
