#!/bin/bash

# Rev 1.0 Create Log Directory
mkdir -p /home/zplanner/logs

# Rev 1.1 Create log cleanup job and run the throughput table script retro actively
logs=$(crontab -l | grep -ic logs)
if [ $logs = 1 ]
then
        echo "Log cleanup already installed"
else
        echo Installing log cleanup job
        line="@daily /usr/bin/find /home/zplanner/logs -mtime +7 -type f -delete"
        (crontab -u zplanner -l; echo "$line") | crontab -u zplanner -
fi
/usr/bin/pwsh /home/zplanner/zplanner/dashboards/Import_Dashboards.ps1

/usr/bin/php /home/zplanner/zplanner/loaders/throughputtable.php

# Rev 1.2 Add nightly update scripts
nightly=$(crontab -l | grep -ic nightly)
if [ $nightly = 1 ]
then
        echo "Nightly Update job already installed"
else
        echo Installing nightly update  job
        line="@daily /bin/bash /home/zplanner/modules/nightlyupdate.sh"
        (crontab -u zplanner -l; echo "$line") | crontab -u zplanner -
fi

sudo /sbin/reboot
