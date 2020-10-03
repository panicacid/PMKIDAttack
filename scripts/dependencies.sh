#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sd/lib:/sd/usr/lib
export PATH=$PATH:/sd/usr/bin:/sd/usr/sbin

TIMESTAMP=`date "+[%Y-%m-%d %H:%M:%S]"`

if [[ -e /sd ]]; then
LOGFILE="/sd/modules/PMKIDAttack/pmkidattack.log"
touch /sd/modules/PMKIDAttack/scripts/ipk/
else
LOGFILE="/pineapple/modules/PMKIDAttack/pmkidattack.log"
touch /pineapple/modules/PMKIDAttack/scripts/ipk/
fi

function add_log {
    echo $TIMESTAMP $1 >> $LOGFILE
}

if [[ "$1" == "" ]]; then
	add_log "Argument to script missing! Run with \"dependencies.sh [install|remove]\""
	exit 1
fi

add_log "Starting dependencies script with argument: $1"

touch /tmp/PMKIDAttack.progress

if [[ "$1" = "install" ]]; then



	add_log "Updating opkg"

	if [[ -e /sd ]]; then
		add_log "Installing on sd"
		cd /sd/modules/PMKIDAttack/scripts/ipk/
		
		wget "https://github.com/adde88/hcxtools-hcxdumptool-openwrt/raw/openwrt-19.07/bin/packages/mips_24kc/custom/hcxtools-custom_6.1.2-1_mips_24kc.ipk"

	        opkg --dest sd install "/sd/modules/PMKIDAttack/scripts/ipk/hcxtools-custom_6.1.2-1_mips_24kc.ipk" --force-overwrite
		
		add_log $?
		
		if [[ $? -ne 0 ]]; then

			add_log "ERROR: opkg --dest sd install hcxtools-custom_6.1.2-1_mips_24kc.ipk to sd failed"
			
			exit 1
		fi
		
		cd /sd/modules/PMKIDAttack/scripts/ipk/
		
		wget "https://github.com/adde88/hcxtools-hcxdumptool-openwrt/raw/openwrt-19.07/bin/packages/mips_24kc/custom/hcxdumptool-custom_6.1.2-1_mips_24kc.ipk"

	        opkg --dest sd install "/sd/modules/PMKIDAttack/scripts/ipk/hcxdumptool-custom_6.1.2-1_mips_24kc.ipk" --force-overwrite
		
		add_log $?
		
		if [[ $? -ne 0 ]]; then
		
			add_log "ERROR: opkg --dest sd install hcxdumptool-custom_6.1.2-1_mips_24kc.ipk to sd failed"
			
			exit 1
		fi
	else
		add_log "Installing on disk"
		
		cd /pineapple/modules/PMKIDAttack/scripts/ipk/

		wget "https://github.com/adde88/hcxtools-hcxdumptool-openwrt/raw/openwrt-19.07/bin/packages/mips_24kc/custom/hcxtools-custom_6.1.2-1_mips_24kc.ipk"

                opkg install /pineapple/modules/PMKIDAttack/scripts/ipk/hcxtools-custom_6.1.2-1_mips_24kc.ipk --force-overwrite

		add_log $?

		if [[ $? -ne 0 ]]; then
		
			add_log "ERROR: opkg install hcxtools-custom_6.1.2-1_mips_24kc.ipk to disk failed"
			
			exit 1
		fi
		
		cd /pineapple/modules/PMKIDAttack/scripts/ipk/
		
		wget "https://github.com/adde88/hcxtools-hcxdumptool-openwrt/raw/openwrt-19.07/bin/packages/mips_24kc/custom/hcxdumptool-custom_6.1.2-1_mips_24kc.ipk"

		opkg install /pineapple/modules/PMKIDAttack/scripts/ipk/hcxdumptool-custom_6.1.2-1_mips_24kc.ipk --force-overwrite

		add_log $?

		if [[ $? -ne 0 ]]; then
		
			add_log "ERROR: opkg install hcxdumptool-custom_6.1.2-1_mips_24kc.ipk to disk failed"
			
			exit 1
		fi
	fi

	add_log "Installation complete!"

	touch /etc/config/pmkidattack

	echo "config pmkidattack 'settings'" > /etc/config/pmkidattack
	echo "config pmkidattack 'module'" >> /etc/config/pmkidattack
	echo "config pmkidattack 'attack'" >> /etc/config/pmkidattack

	uci set pmkidattack.module.installed=1
	uci commit pmkidattack.module.installed
fi

if [[ "$1" = "remove" ]]; then
	add_log "Removing a module"

    rm -rf /etc/config/PMKIDAttack

	opkg remove hcxtools
	opkg remove hcxdumptool

	add_log "Removing complete!"
fi

rm /tmp/PMKIDAttack.progress

