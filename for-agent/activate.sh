#!/bin/bash

while true; do
    OPTION=$(whiptail --title "Do you agree to activate malware active response for your Wazuh Agent?" --menu "Choose an option:" 20 70 13 \
                    "1" "Yes, activate" 3>&1 1>&2 2>&3)
    # Script version 1.0 updated 15 November 2023
    # Depending on the chosen option, execute the corresponding command
    case $OPTION in
    1)
        sudo cat add-config.conf >> /var/ossec/etc/ossec.conf
        sudo apt update
        sudo apt -y install jq
        sudo cp ./remove-threat.sh /var/ossec/active-response/bin/
        sudo chmod 750 /var/ossec/active-response/bin/remove-threat.sh
        sudo chown root:wazuh /var/ossec/active-response/bin/remove-threat.sh
        sudo systemctl restart wazuh-agent
        ;;
    esac

    # Give option to go back to the previous menu or exit
    if (whiptail --title "Exit" --yesno "Do you want to exit the script?" 8 78); then
        break
    else
        continue
    fi
done