#🧠 Introduction to Networking
🎯 Why This Matters for Offensive Security

Networking knowledge allows you to:

Understand what is reachable

Interpret scan results

Know why an exploit works or fails

Avoid blind exploitation

Enumeration without networking knowledge is guessing.

##🌐 TCP/IP Model (OffSec View)

You don’t need to memorize all layers — only how attacks map.

Layer	What Matters
Application	HTTP, HTTPS, SSH, SMB
Transport	TCP vs UDP
Network	IP routing
Data Link	Rarely relevant
📡 TCP vs UDP
TCP

Reliable

Ordered

Connection-oriented

Used by: HTTP, HTTPS, SSH, SMB

UDP

Fast

Connectionless

Used by: DNS, SNMP, NTP

##🧠 OSCP reality: Most exploitable services are TCP.

🔌 Common Ports (Must Know)
21   FTP
22   SSH
23   Telnet
25   SMTP
53   DNS
80   HTTP
443  HTTPS
445  SMB
3306 MySQL
3389 RDP


If 80/443 is open → web attack surface exists.

##📍 IP Addressing Basics

IPv4 format: x.x.x.x

Private ranges:

10.0.0.0/8

172.16.0.0/12

192.168.0.0/16

Internal IPs often appear after initial foothold.

##🧱 Firewalls (Attacker View)

Firewalls:

Filter by IP/port

Rarely understand application logic

Common bypasses:

Allowed ports (80/443)

Tunneling

Port forwarding

🧠 Enumeration Mindset

Always ask:

What ports are open?

What services are exposed?

What versions?

What can I talk to?
