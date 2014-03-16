#!/bin/sh

# This is a modified version for Synology NAS of the NXT install script by j0b. 
# Original located here: https://github.com/jobbet/nxt

# This has been tested on a DS213j.

# Send me some NXT coins if you find this useful. 
# NXT: 5382956979630465590

# dmmh

wget_bin=$(which wget);
unzip_bin=$(which unzip);
openssl_bin=$(which openssl);
if [[ -e "nxt.conf" ]]; then
	source "nxt.conf"
else
	source "/etc/nxt/nxt.conf"
fi
c=`pwd`

if [[ -z "$wget_bin" ]] || [[ -z "$unzip_bin" ]] || [[ -z "$openssl_bin" ]]; then
	echo "Unsatisfied binary dependencies.";
	if [[ -z "$wget_bin" ]]; then
		echo "This script uses the following binary: wget";
	fi
	if [[ -z "$unzip_bin" ]]; then
	echo "This script uses the following binary: unzip";
	fi
	if [[ -z "$openssl_bin" ]]; then
		echo "This script uses the following binary: openssl";
	fi
	echo "These applications must be installed in order to run this script.";
	exit 1;
fi

install(){

	if [[ ! -d "$cfg_dir" ]]; then
		echo -n "Creating configuration directory for NXT client.. ";
		mkdir -p $cfg_dir && echo "done." || { echo "Could not create NXT client configuration directory." ; exit 1;}
		cp $c/nxt.conf $cfg_dir
	fi
	
	if [[ ! -d "$install_dir" ]]; then    
		echo -n "Creating NXT client root directory.. ";
		mkdir -p $install_dir && echo "done." || { echo "Could not create NXT client root directory." ; exit 1;}
	fi

	if [[ "$1" != "update" ]] && [[ "$(ls $install_dir | wc -l)" -gt 0 ]]; then
		echo "NXT client root directory contain files. If you want to overwrite this, issue an update.";
		exit 0;
	fi

	if ! id -u nxt >/dev/null 2>&1; then
		echo -n "Adding nxt user.. ";
		adduser -H -D -h /usr/local/bin -s /sbin/nologin nxt >/dev/null 2>&1 && echo "done." ||
		{ echo "Could not add nxt user.  Add it manually after this installation has finished." && exit 1;}
	fi

	if [[ -z "$2" ]]; then
		client_zip=$($wget_bin -q -O -  http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep -v "(e.zip|e.sha256|changelog.txt)" | egrep '(zip$)' | tail -n 1);
		client_sign_file=$($wget_bin -q -O -  http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep -v "(e.zip|e.sha256|changelog.txt)" | egrep '(sha256.txt.asc$)' | tail -n 1);
	else
		client_zip=$2;
	fi

	echo -n "Downloading $client_zip from http://download.nxtcrypto.org...";
	
	$wget_bin -P $tmp_dir -q http://download.nxtcrypto.org/$client_zip > /dev/null 2>&1 ||
	{ echo "could not download NXT client. Exiting installation."; exit 1; }

	echo " Done.";

	client_sign=$($wget_bin -q -O - http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep $client_sign_file | grep "asc")

	if [[ -n "$client_sign" ]]; then
		echo -n "Downloading $client_zip shasum signature...";
		$wget_bin -P $tmp_dir -q http://download.nxtcrypto.org/$client_sign > /dev/null 2>&1 || 
		{ echo "could not download NXT client shasum signature. Exiting installation." ; exit 1;}
		echo "done.";
	fi

	if [[ "$1" != "update" ]]; then
		cp $c/nxtclient.sh $script_dir > /dev/null 2>&1 || { echo "Could not copy NXT client init script into" $script_dir; exit 1; }
		cp $c/install.sh $cfg_dir > /dev/null 2>&1 || { echo "Could not copy NXT client install script into" $cfg_dir; exit 1; }
	fi
	
	sha=$(grep "$client_zip" $tmp_dir/$client_sign_file | awk {'print $1'});

	echo "sha:" $sha;

	if [[ -n "$sha" ]]; then
		zip_sha=$($openssl_bin dgst -sha256 $tmp_dir/$client_zip | awk {'print $2'});
		echo "zip sha:" $zip_sha;
		if [[ "$sha" == "$zip_sha" ]]; then
			echo "Done."
			touch $current_version
			echo "$client_zip" > $current_version
			if [[ -f "$install_dir"/conf/nxt-default.properties ]]; then
				echo -n "Backing up configuration file...";
				cp $install_dir/conf/nxt-default.properties /volume1/@tmp || 
				{ echo "Could not backup configuration file."; exit 1; }
				echo "done.";
			fi
			echo -n "Unzipping NXT client files...";
			$unzip_bin -oq $tmp_dir/$client_zip -d $nxt_bin_dir && rm $tmp_dir/$client_sign_file && rm $tmp_dir/$client_zip && chown -R nxt:nxt $install_dir > /dev/null 2>&1 || 
			{ echo "Could not extract files into NXT client root directory."; exit 1; }	
			echo "done."
			if [[ -f "$install_dir"/conf/nxt-default.properties ]]; then
				echo -n "Restoring configuration file...";
				cp /volume1/@tmp/nxt-default.properties $install_dir/conf || 
				{ echo "Could not restore configuration file."; exit 1; }
				echo "done.";
			fi	
		else
			echo "CRITICAL: The shasum does not match!. Installation aborted.";
			exit 1;
		fi
	fi
}

update(){
	version=`cat $current_version`	
	echo "Current installed version: $version";
	if [[ -n "$1" ]]; then
		asked_version=$1;
		if [[ "$version" != "$asked_version" ]]; then
			client_zip=$($wget_bin -q -O -  http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep -v "(e.zip|e.sha256|changelog.txt)" | egrep '(zip$)' | grep "$asked_version");

			if [[ -z "$client_zip" ]]; then
				echo "$asked_version does not exist in current location.";
				exit 1;
			else
				$script_dir/nxtclient.sh stop
				install update $client_zip
				$script_dir/nxtclient.sh start
			fi
		else
			echo "NXT client is up to date, nothing to do..."
		fi
    else
	    client_zip=$($wget_bin -q -O -  http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep -v "(e.zip|e.sha256|changelog.txt)" | egrep '(zip$)' | tail -n 1);
		if [[ "$version" != "$client_zip" ]]; then
			echo "Available version: $client_zip"
			$script_dir/nxtclient.sh stop
			install update
			$script_dir/nxtclient.sh start
		else
			echo "NXT client is up to date, nothing to update."
		fi
	fi
}

host(){
	vi $install_dir/conf/nxt-default.properties
}

case "$1" in

	install)
		if [[ -n "$2" ]]; then
			install $2
		else
			install
		fi

		echo "Installation done. Start NXT client with $ $script_dir/nxtclient.sh start, then browse to https://localhost:7875";
		echo "Or reboot and NXT client will start itself."
		echo "Be sure to accept incoming TCP traffic to port 7874, or the NXT client will not be able to communicate with it's network.";
		echo "If you get a screen saying \"The Matrix has you...\", run $ $cfg_dir/install.sh host and add your computer's IP to the allowedUserHosts XML field and restart the NXT client.";
	;;
	update)
		if [[ -n "$2" ]]; then
			update $2
		else
			update
        fi

		echo "Update done.";        
	;;
	host)
		echo "Opening file to edit allowedUserHosts"; 
		host
	;;
	*)

	N=${0##*/}
	echo "Usage: $N {install|update|host}" >&2
	exit 1
	;;
esac

exit 0


# ORIGINAL LICENSE:
#  ----------------------------------------------------------------------------
#  "THE NXT-WARE LICENSE" NXT: 13570469120032392161 (Revision: 25519)
#  j0b <gemeni@gmail.com> wrote this file. As long as you retain this notice you
#  can do whatever you want with this stuff. IF you think this stuff is worth it, 
#  you can send me NXT, my public key is above.
#  ----------------------------------------------------------------------------
