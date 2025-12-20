# 🌐 Web Requests
🎯 Why This Matters

Web Requests knowledge is mandatory for:

Burp Suite

curl

ffuf

Web exploitation

OSCP

If it’s in the request, you can change it.

## 🧾 HTTP Request Structure
METHOD /path HTTP/1.1
Host:
Headers
Cookies

Body


Everything above is attacker-controlled.

## 🔄 HTTP Methods
Method	Purpose	Attack Use
GET	Retrieve	URL parameters
POST	Submit	Forms & APIs
PUT	Update	Unauthorized overwrite
DELETE	Remove	Access control flaws
📥 HTTP Response Codes
200 OK          – Success
301 / 302       – Redirect
401 Unauthorized
403 Forbidden
404 Not Found
500 Server Error


💡 500 errors often reveal backend behavior.

## 🍪 Cookie-Based Authentication (Sessions)
What a cookie actually is

A cookie is usually NOT credentials.
It is a session identifier.

Example:

Set-Cookie: PHPSESSID=abc123xyz


The cookie value:

Does NOT contain username/password

Does NOT contain role

Is meaningless by itself

The server maps it internally:

PHPSESSID → user=admin, role=admin

How cookie auth works (step-by-step)

User logs in

POST /login.php
username=admin&password=admin


Server validates credentials

Server creates a session

Server sends session ID

Set-Cookie: PHPSESSID=abc123xyz


Browser automatically sends it

Cookie: PHPSESSID=abc123xyz


Server looks it up and authorizes

## 🔁 Session Reuse (HTB / OSCP Pattern)
Step 1 — Obtain a session cookie
curl -i -X POST http://<SERVER_IP>:<PORT>/login.php \
  -d "username=admin&password=admin"


Copy:

PHPSESSID=abc123xyz

Step 2 — Reuse cookie on another endpoint
curl -X POST http://<SERVER_IP>:<PORT>/search.php \
  -H "Cookie: PHPSESSID=abc123xyz" \
  -H "Content-Type: application/json" \
  -d '{"search":"flag"}'


🧠 This works because authentication persists across endpoints.

## 🔑 Authorization Header (Token / Credential Auth)
⚠️ NOT a cookie

Example:

Authorization: Basic YWRtaW46YWRtaW4=


Decoded:

admin:admin


This is:

HTTP Authorization header

Basic Authentication

Base64-encoded credentials

Stateless

Not encrypted

Not a session

How Basic Auth works

Client sends credentials every request

Server decodes header

Server validates credentials

No session is stored

## 🍪 Cookies vs 🔑 Authorization Header (Critical Difference)
Aspect	Cookies	Authorization Header
What it contains	Session ID	Credentials or token
Where identity lives	Server	Client
Server state	Required	Not required
Auto-sent	Yes	No
Expiration	Often	Often never
Replay attack	Session hijack	Credential/token replay
🧠 Mental Model (Burn This In)

Cookies store “who I am” on the server.
Authorization headers send “who I am” with the request.

Both can be:

Copied

Replayed

Modified

Abused

## 🧪 curl – Web Requests Cheat Sheet
Basic GET
curl http://target/

Verbose (see headers)
curl -v http://target/

Headers only
curl -I http://target/

Follow redirects
curl -L http://target/

Custom User-Agent
curl -A "Mozilla/5.0" http://target/

GET with parameters
curl "http://target/page?id=1"

POST (form)
curl -X POST http://target/login \
  -d "username=admin&password=admin"

POST (JSON)
curl -X POST http://target/api \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}'

PUT
curl -X PUT http://target/resource -d "data=test"

DELETE
curl -X DELETE http://target/resource

Send cookie (copy/paste)
curl -b "PHPSESSID=abc123xyz" http://target/dashboard

Multiple cookies
curl -b "session=abc123; role=user" http://target/admin

Basic Auth (automatic)
curl http://admin:admin@target/

Basic Auth (manual)
curl -H "Authorization: Basic YWRtaW46YWRtaW4=" http://target/

Generate Base64 token
echo -n "admin:admin" | base64

Custom headers
curl -H "X-Forwarded-For: 127.0.0.1" http://target/

Change Host header
curl -H "Host: admin.target" http://target/

Upload file
curl -X POST http://target/upload \
  -F "file=@shell.php"

Download file
curl -O http://target/file.txt

Ignore SSL errors
curl -k https://target/

OPTIONS (allowed methods)
curl -X OPTIONS http://target/

Timing-based testing
curl -w "%{time_total}\n" -o /dev/null -s http://target/

## 🔑 OSCP One-Line Rule (Memorize)

If authentication is in a cookie or header, replay it and test authorization logic.
