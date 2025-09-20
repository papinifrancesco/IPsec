# IPsec

## A poor's man solution ;-) 

Tested on Rocky Linux 9.6 with Libreswan 4.15

To make sure all traffic is encrypted between a few VMs, we can use PSK. Certificates and RSA keys are better solutions, but they take much longer to set up.

Just modify ipsec_generator.sh for your IP range and then run it.

The ipsec.secrets file will be generated with all the combinations (permutations are not needed).

The IPsec rules, the .conf files, will be generated as well

Then place everything in /etc/ipsec.d/ and restart IPsec.
