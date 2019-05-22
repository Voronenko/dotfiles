#!/bin/bash

echo "This action will kill and suppress any apt-daily update runs. Use only on one-time test environments. (ctrl-c to abort)?" && read

systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

# systemctl mask apt-daily.service apt-daily-upgrade.service
