#!/bin/sh

# This is a modified version of the NXT install script by j0b for Synology NAS. 
# Original located here: https://github.com/jobbet/nxt

# This has been tested on a DS213j.

# Send me some NXT coins if you find this useful. 
# NXT: 5382956979630465590

# thanks,
# dmmh

# ORIGINAL LICENSE:
#  ----------------------------------------------------------------------------
#  "THE NXT-WARE LICENSE" NXT: 13570469120032392161 (Revision: 25519)
#  j0b <gemeni@gmail.com> wrote this file. As long as you retain this notice you
#  can do whatever you want with this stuff. IF you think this stuff is worth it, 
#  you can send me NXT, my public key is above.
#  ----------------------------------------------------------------------------

# NXT-Client configuration
source "/etc/nxt/nxt.conf"
log=$install_dir/nxt.log
wget_bin=$(which wget);
java_bin=$(which java);

if [[ -z "$pidfile" ]] || [[ -z "$nxtuser" ]] || [[ -z "$javapath" ]] ||
   [[ -z "$client_start_args" ]] || [[ -z "$client_stop_args" ]]; then

    echo "Missing configuration in nxt.conf";
    exit 0
fi

if [[ "$java_bin" == "" ]]; then
	echo "Java is not installed. Please install Java first. Easiest way is using Synology beta Java Manager, get it here: http://www.synology.com/en-uk/support/beta_dsm_5_0"
    exit 0
fi

start() {
	echo "Starting NXT-Client..."
    c=`pwd`
	if [ -e $pidfile ] ; then
        echo "NXT-Client is already running. PID=`cat $pidfile`"
        exit 0;
    fi
	if [[ -e $log ]]; then
		rm $log
	fi
	touch $log
	cd $install_dir
    "$javapath" $client_start_args >>$log 2>&1 & pid=$!
    touch $pidfile && chown $nxtuser:$nxtuser $pidfile
	echo $pid > $pidfile
    cd $c
	status
	echo "It might take 1-15 minutes or so before you will be able to access the NXT client via your browser...be patient."
	echo "You can watch the NXT client's output by using $ "$script_dir"/nxtclient.sh log";
	echo "If your blockchain is corrupted, you can restore the virgin state of blocks and transactions by using: $ "$script_dir"/nxtclient.sh init";
}

stop() {
    c=`pwd`
	echo "Trying to stop NXT-Client..."
	if [ -e $pidfile ] ; then
		#kill `cat $pidfile`
		cd $install_dir
        "$javapath" $client_stop_args >>$log 2>&1;
		cd $c
        rm $pidfile		
		status
    else
        echo "NXT client is not running. No PID file."
    fi
}

init() {
    stop
	echo "Restoring NXT client virgin state..."
	if [ -e $install_dir/blocks.nxt ] ; then
		rm $install_dir/blocks.nxt
	fi
	if [ -e $install_dir/blocks.nxt.bak ] ; then
		rm $install_dir/blocks.nxt.bak
	fi
	if [ -e $install_dir/transactions.nxt ] ; then	
		rm $install_dir/transactions.nxt
	fi
	if [ -e $install_dir/transactions.nxt.bak ] ; then
		rm $install_dir/transactions.nxt.bak
	fi
	start
}

status() {
    touch $current_version
	version=`cat $current_version`
	client_version=$($wget_bin -q -O -  http://download.nxtcrypto.org | sed 's/\(>\|<\)/ /g' | awk {'print $3 '} | egrep -v "(e.zip|e.sha256|changelog.txt)" | egrep '(zip$)' | tail -n 1);
	if [[ "$version"] != '' ]]; then
		if [[ "$version" != "$client_version" ]]; then 
			echo "A newer version of NXT client is available. Current version: $version, version available: $client_version".
			echo "Trying to updating NXT client..."
			$cfg_dir/install.sh update
		fi
	fi
	if [ -e $pidfile ] ; then
		echo "NXT-Client is running!"
    else
		echo "NXT-Client stopped."
	fi
}   

log() {
	cat $log
} 

case "$1" in

    start)
        start
    ;;
    stop)
        stop
    ;;
	init)
        init
    ;;
    status)
        status
    ;;
	log)
        log
    ;;
    *)

    N=$script_dir/${0##*/}
    echo "Usage: $N {start|stop|status|init|log}" >&2
    exit 1
    ;;
esac

exit 0
