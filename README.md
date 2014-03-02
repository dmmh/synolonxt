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

The NXT client needs Java to work, so this script assumes you have installed the beta Synology application Java Manager.
Get it here: http://www.synology.com/en-uk/support/beta_dsm_5_0

This README assumes you have git installed via optware, and the command below to install it WILL NOT WORK on a default Synology installation.
The script itself also uses optware which isn't installed by default.

INSTALL

1. 	Install this script: 	$ cd /volume1/@tmp && git clone https://github.com/dmmh/synolonxt && chmod -R 755 synolonxt && cd synolonxt

2. 	Install NXT client: 	$ install.sh install
	This will install the latest version of NXT client
	The client is downloaded from the public source for NXT client software.
	During install the script validates against known sha256sum hash.

3. 	Installation done. 

4. 	$ reboot to start the client on boot (or from a SSH client start NXT client with: $ /usr/local/etc/rc.d/nxtclient.sh start). 
	You need to modify this line in the Nxt client configuration file: nxt.uiServerHost=127.0.0.1 to nxt.uiServerHost=0.0.0.0. 
	(use $ /etc/nxt/install.sh host to open the configuration file)
	Find out the local IP address of your NAS, then type http://ipadress:7875 in your browser to connect to the client. 

UPDATE

1. This script auto updates the NXT client when a newer version is available. It will only do so when starting or stopping the NXT client with this script though. 	

dmmh

ORIGINAL LICENSE:
  ----------------------------------------------------------------------------
  "THE NXT-WARE LICENSE" NXT: 13570469120032392161 (Revision: 25519)
  j0b <gemeni@gmail.com> wrote this file. As long as you retain this notice you
  can do whatever you want with this stuff. IF you think this stuff is worth it, 
  you can send me NXT, my public key is above.
  ----------------------------------------------------------------------------
