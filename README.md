# IPsec

## A poor's man solution ;-) 

To make sure all traffic is encrypted between a few VMs, we can use PSK. Certificates and RSA keys are better solutions, but they take much longer to set up.

Just modify ipsec.secrets_generator.sh for your IP range and then run it. The ipsec.secrets file will be generated with all the combinations (permutations are not needed).

Then place ipsec.secrets in /etc/ipsec.d/ and create the rules using VM1-VM2.conf as a template.
