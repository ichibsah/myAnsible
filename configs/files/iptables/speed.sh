#!/bin/bash 
INTERFACE=enp2s0f1

#awk '...' \
#  <(grep $INTERFACE /proc/net/dev) \
#  <(sleep 1; grep $INTERFACE /proc/net/dev)

echo "$INTERFACE  down (KiB/s)   up (KiB/s)"
while :
do
  awk '{
  if (rx) {
    printf ("  %.0f    %.0f\n", ($2-rx)/1024, ($10-tx)/1024)
  } else {
    rx=$2; tx=$10;
  }
}' \
    <(grep $INTERFACE /proc/net/dev) \
    <(sleep 1; grep $INTERFACE /proc/net/dev)
  sleep 2;
done
