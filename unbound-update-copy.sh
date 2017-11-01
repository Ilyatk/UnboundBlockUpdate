#!/bin/bash
/home/ilya/ad-block/unbound-get-adblock.sh
cp /home/ilya/ad-block/block.conf /etc/unbound/block.conf
sudo systemctl restart unbound.service



