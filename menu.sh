#!/bin/bash
##########################################################
#
# Info and Config Menu for zPlanner Appliance
#
##########################################################
while true
do
  # get network information (get each time in case it changes)
  interface=$(python3 /home/zplanner/zplanner/modules/netinfo.py interface)
  ipinfo=$(python3 /home/zplanner/zplanner/modules/netinfo.py address)
  ipgw=$(ip route | grep -i "default" | awk '{ print $3 }')

  # start menu output
  clear
  echo "=================================================="
  echo "=   zPlanner Info and Config menu  v5.0.0 Beta   ="
  echo "=================================================="
  echo "Current Network Config:"
  echo "   Interface Name: $interface"
  echo "   Details: $ipinfo"
  echo "   Default Gateway: $ipgw"
  echo "=================================================="
  echo -e "Select an action from the menu below\n"
  echo "1.) Update zPlanner        2.) Configure Network Settings"
  echo "3.) Config Hypervisor Info 4.) Test Hypervisor Connectivity"
  echo "5.) Generate VM List       6.) Start Scheduled Jobs"
  echo "7.) Config Auto Login      8.) Delete Scheduled Jobs"
  echo "9.) Bash Shell             0.) Quit"
  read choice
  case "$choice" in
          1) # Update zPlanner Scripts from Github
              clear
	      echo "Updating zPlanner from github"
	      (cd /home/zplanner/zplanner/ && git reset --hard HEAD && git pull http://www.github.com/recklessop/zplanner/)
	      echo "Running Update Helper Script"
	      (/bin/bash /home/zplanner/zplanner/updates.sh)
	      ;;
          2) # Config Network Settings
	      clear
	      echo "====================="
	      echo "Network Config Wizard"
	      echo -e "=====================\n"
	      (sudo python3 /home/zplanner/zplanner/modules/netplan-cfg.py)
              echo "Running Netplan Generate & Netplan Apply"
              (sudo netplan generate)
              (sudo netplan apply)
              ;;
          3) # Config Customer Information
	      clear
	      echo "========================"
	      echo "Hypervizor Config Wizard"
	      echo -e "========================\n"
              /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-setenv.ps1
              ;;
          4) # Test Hypervisor connectivity
	      clear
	      echo "==============================="
	      echo "Testing Hypervizor Connectivity"
	      echo -e "===============================\n"
              /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-testenv.ps1
	      echo "If an error occured please run Hypervisor Configuration Wizard"
              ;;
          5) # Config Customer Information
	      clear
	      echo "========================"
	      echo "Generating List of VMs"
	      echo -e "========================\n"
              /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-getvms.ps1
              ;;
	  6) # Schedule Cron Jobs
	      clear
	      echo "====================="
	      echo "Job Scheduling Wizard"
	      echo -e "=====================\n"
	      echo "Generating Crontab configuration..."

	      #Add Line to gather CPU and Memory information
	      line="@daily /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-vminfo.ps1"
	      (crontab -u zplanner -l; echo "$line" ) | crontab -u zplanner -

	      #Add cron for gathering statistics every 5 minutes
	      echo "5" > /home/zplanner/include/interval.txt
	      line="*/5 * * * * /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-getio.ps1"
	      (crontab -u zplanner -l; echo "$line" ) | crontab -u zplanner -

	      #Add Log cleanup to run once per day
	      line="@daily /usr/bin/find /home/zplanner/logs -mtime +7 -type f -delete"
	      (crontab -u zplanner -l; echo "$line" ) | crontab -u zplanner -

	      crontab -l
              ;;
          7) # Config Auto Login
	      enacfgfile=/etc/systemd/system/getty@tty1.service.d/override.conf
	      discfgfile=/etc/systemd/system/getty@tty1.service.d/override.conf.disabled
	      # see if override.conf is in place
	      if [ -f "$enacfgfile" ]
	      then
		echo "Enabled"
		login="Enabled"
		nigol="Disabled"
	      else
		echo "Disabled"
		login="Disabled"
		nigol="Enabled"
	      fi
	      echo "Current Autologin status: $login"

	      echo "Would you like to change this? (Y/N):"
      	      read autologin
	        case "$autologin" in
	             "y" | "Y") # switch autologin status 
			echo "Reconfiguring Auto Login from $login to $nigol"
		     	if [ "$login" == "Enabled" ]
	      	     	then
			    sudo mv $enacfgfile $discfgfile
			    echo "Disabling Auto Login Completed"
	      	        else
			    sudo mv $discfgfile $enacfgfile
			    echo "Enabling Auto Login Completed"
	      	        fi
			;;
	             *) # do nothing
			echo "Nothing to do..."
			;;
	        esac
              ;;
          8) # Kill all exisint CronJobs
	      clear
	      echo "=============================="
	      echo "Existing Cron jobs "
	      echo "=============================="
	      crontab -l
	      echo "=========== WARNING =========="
	      echo "Remove all existing Cron Jobs? (Y/N)"
      	      read crondel
	        case "$crondel" in
	             "y" | "Y") # delete crontab
			crontab -r
	  	        #Add Log cleanup to run once per day
	      	 	line="@daily /usr/bin/find /home/zplanner/logs -mtime +7 -type f -delete"
	      	 	(crontab -u zplanner -l; echo "$line" ) | crontab -u zplanner -
	  	        #Add auto update to run once per day
	      	 	line="@daily /bin/bash /home/zplanner/modules/nightlyupdate.sh"
	      	 	(crontab -u zplanner -l; echo "$line" ) | crontab -u zplanner -

			;;
	             *) # do nothing
			;;
	        esac
              ;;
          9) # enter bash shell prompt
              clear
	      /bin/bash
              ;;
          0) # exit the menu script
              exit
              ;;
          A) # Advanced Menu
      	      while true
	      do
                clear
		echo "=============================="
	      	echo "Advanced Menu "
	      	echo "=============================="
	      	echo -e "Select an action from the menu below\n"
  	      	echo "1.) Manually Run VMInfo Script"
	      	echo "2.) Dump SQL DB to zplanner FTP"
  	      	echo "3.) Reserved"
   	      	echo "4.) Reserved"
  	      	echo "0.) Back to Main Menu"
  	      	read adv
  	      	case "$adv" in
          		1) # Manually run VMInfo Script
			   /usr/bin/pwsh /home/zplanner/zplanner/workers/vm-vminfo.ps1
              	   	   ;;
          		2) # Dump SQL DB to zplanner FTP
			   echo "==================================="
			   echo "Dumping database to file"
			   #do some db dump stuff here
              	   	   ;;
          		3) # reserved
			   break
              	   	   ;;
          		4) # reserved
			   break
              	   	   ;;
			0) # go back to main menu
			   break
			   ;;
          		*) echo "invalid option try again";;
      		esac
	      done
	      ;;
          *) echo "invalid option try again";;
      esac
      echo "Press any key to Continue..."
      read input
done
done

