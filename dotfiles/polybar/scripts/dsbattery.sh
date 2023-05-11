if [ -e /sys/class/power_supply/ps-controller-battery-a0:ab:51:89:94:65/capacity ]
then
    cat /sys/class/power_supply/ps-controller-battery-a0:ab:51:89:94:65/capacity | awk '{print"  "$0"%"}'
else
  echo ''
fi
