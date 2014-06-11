synolonxt
=========

NXT client script for Synology NAS

This is a modified version for Synology NAS of the NXT install script by j0b. 
Original located here: https://github.com/jobbet/nxt

This has been tested on a DS213j.

Send me some NXT coins if you find this useful. 
NXT: 5382956979630465590

thanks,
dmmh

The NXT client needs Java to work, on Synology it's easy to install it with the application Java Manager.
Get it here: http://www.synology.com/en-uk/dsm/app_packages/JavaManager

This README assumes you have git installed via optware, and the command below to install it WILL NOT WORK on a default Synology installation.
The script itself also uses optware which isn't installed by default.

INSTALL

1. 	Install this script: 	$ cd /volume1/@tmp && git clone https://github.com/dmmh/synolonxt && chmod -R 755 synolonxt && cd synolonxt

2. 	Install NXT client: 	$ sh install.sh install
	This will install the latest version of NXT client
	The client is downloaded from the public source for NXT client software.
	During install the script validates against known sha256sum hash.

3. 	Installation done. 

4. 	You need to modify some values in the configuration file to be able to connect to the NXT client.
	Read the post install instructions in how to do this.

UPDATE

1. 	This script auto updates the NXT client when a newer version is available. 
	It will only do so when starting or stopping the NXT client with this script though. 	

dmmh

ORIGINAL LICENSE:
  ----------------------------------------------------------------------------
  "THE NXT-WARE LICENSE" NXT: 13570469120032392161 (Revision: 25519)
  j0b <gemeni@gmail.com> wrote this file. As long as you retain this notice you
  can do whatever you want with this stuff. IF you think this stuff is worth it, 
  you can send me NXT, my public key is above.
  ----------------------------------------------------------------------------
