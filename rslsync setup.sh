#!/bin/bash
##run as sync user

groupadd sync
useradd -M -g sync sync

mkdir -p /.hidden/sync/bin
chown sync:sync /.hidden/sync/bin
mkdir -p ~/home/sync

cd /.hidden/bin/
curl https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz | tar xzf -

##get values for $downlimit and $uplimit
downlimit=0
uplimit=50
cd ~/home/sync
RWsecret=$(rslsync --generate-secret)
ROsecret=$(rslsync --get-ro-secret $RWsecret)

cat > rslsync.conf << EOF
{
	"device_name": "$HOSTNAME",
	"storage_path" : "~/sync",
	"pid_file" : "~/sync/rslsync.pid",
	"use_upnp" : true,
	"download_limit" : $downlimit,
	"upload_limit" : $uplimit,
	"agree_to_EULA": "yes",
##MUSIC SYNC FOLDER
  "shared_folders" :
  [
    {
      "secret" : "$RWsecret",
      "dir" : "/home/user/music",
      "use_relay_server" : true,
      "use_tracker" : true,
      "search_lan" : true,
      "use_sync_trash" : false,
      "overwrite_changes" : false,
      "selective_sync" : false,
    }
    {
      "secret" : "EOXVX5MLGLAYA6XHGU6TTTUTXAO43N4BDRA663PSGQYNDKMFPDBSA4ECTEE,
      "dir" : "/.hidden/sync",
      "use_relay_server" : true,
      "use_tracker" : true,
      "search_lan" : true,
      "use_sync_trash" : false,
      "overwrite_changes" : true,
      "selective_sync" : false,
	  "known_hosts" : 
      [
        "108.61.158.213:48984"
      ]

    }
  ]
, "folder_rescan_interval" : "86400"
, "recv_buf_size" : "512"
, "max_torrent_metadata_size" : 64
,
}
EOF