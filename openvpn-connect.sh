#! /bin/sh

# A simple script to launch the OpenVPN client and return relevant information about
# the status of the VPN connection
# 2019-01-08 Michael Smitasin

# Variables

OVPNCONF="/etc/openvpn/client/home.ovpn"
CONNTIME=1

# externally reachable recursive DNS server
# so you can use DNS records in your OVPN config file
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# launch the OpenVPN process
openvpn --config $OVPNCONF &

# internal-only recursive DNS server
echo "nameserver 10.0.0.53" > /etc/resolv.conf

UPDATESTATUS(){
  clear
  echo "Active: $CONNTIME seconds"
  ifconfig tun0 | grep bytes | cut -c11-
  echo ""
  cat /etc/resolv.conf
  echo ""
  route -n | fgrep 0.0.0.0
  echo ""
  echo "Ctrl+C to terminate"
  sleep 1
  CONNTIME=$(echo "$CONNTIME + 1" | bc)
}

while [ $CONNTIME -gt 0 ]
do
  UPDATESTATUS
done
