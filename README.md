synolonxt
=========

NXT client for Synology NAS

This is a modified version of the NXT install script by j0b for Synology NAS. 
Original located here: https://github.com/jobbet/nxt

This has been tested on a DS213j.

Send me some NXT coins if you find this useful. 
NXT: 5382956979630465590

thanks,
dmmh

ORIGINAL LICENSE:
  ----------------------------------------------------------------------------
  "THE NXT-WARE LICENSE" NXT: 13570469120032392161 (Revision: 25519)
  j0b <gemeni@gmail.com> wrote this file. As long as you retain this notice you
  can do whatever you want with this stuff. IF you think this stuff is worth it, 
  you can send me NXT, my public key is above.
  ----------------------------------------------------------------------------

The NXT client needs Java to work, so this script assumes you have installed the beta Synology application Java Manager.
Get it here: http://www.synology.com/en-uk/support/beta_dsm_5_0

This README assumes you have git installed via optware, and the command below to install it WILL NOT WORK on a default Synology installation.
You can of course manually download the 3 files, and run the script.

INSTALL

1. 	Install this script: 	$ cd /volume1/@tmp && git clone https://github.com/dmmh/synolonxt && chmod -R 755 synolonxt && cd synolonxt

2. 	Install NXT client: 	$ install.sh install
	This will install the latest version of NXT client
	If you want a different version, specify that as second argument, e.g. $ /volume1/@tmp/synolonxt/install.sh install 0.5.7
	The client is downloaded from the public source for NXT client software.
	During install the client software validates against known sha256sum hash.

3. Installation done. 

4. Start client with: $ /usr/local/etc/rc.d/nxtclient.sh start

UPDATE

1. This script auto updates the nxt client when a newer version is available. It will only do so when starting or stopping the NXT client though. 	

dmmh

