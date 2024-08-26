#!/bin/bash

while true; do
    OPTION=$(whiptail --title "Do you agree to integrate VirusTotal with your Wazuh?" --menu "Choose an option:" 20 70 13 \
                    "1" "Yes, integrate" 3>&1 1>&2 2>&3)
    # Script version 1.0 updated 15 November 2023
    # Depending on the chosen option, execute the corresponding command
    case $OPTION in
    1)
        nusantara=$(sudo find /home -type d -name "nusantara")
        cat add-config.conf >> $nusantara/wazuh/config/wazuh_cluster/wazuh_manager.conf
        cat add-rules.xml >> $nusantara/wazuh/custom-integrations/local_rules.xml
        cd $nusantara && sudo cp ./wazuh/custom-integrations/local_rules.xml /var/lib/docker/volumes/wazuh_wazuh_etc/_data/rules/local_rules.xml
        sudo docker exec -ti wazuh-wazuh.manager-1 chown wazuh:wazuh /var/ossec/etc/rules/local_rules.xml
        sudo docker exec -ti wazuh-wazuh.manager-1 chmod 550 /var/ossec/etc/rules/local_rules.xml
        cd $nusantara/wazuh && sudo docker compose restart
        ;;
    esac

    # Give option to go back to the previous menu or exit
    if (whiptail --title "Exit" --yesno "Do you want to exit the script?" 8 78); then
        break
    else
        continue
    fi
done
