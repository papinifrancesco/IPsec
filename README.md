# IPsec

## A poor's man solution ;-) 

To make sure all of the traffic is encrypted between a few VMs we can use PSK : certs and RSA keys are better solutions but way longer to set up.

Just modify ipsec.secrets_generator.sh for your IP range and the run it : ipsec.secrets will be generated with all the combinations (permutations are not needed).

Then put ipsec.secrets in /etc/ipsec.d/ and create the rules using VM1-VM2.conf as template
