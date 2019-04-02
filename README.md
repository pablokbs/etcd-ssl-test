# etcd-ssl-test

How to run:

Create certs:

`make certs`

Start the cluster:

`make up`

It should show errors like:

`etcd1.local | 2019-04-02 18:29:05.514387 I | embed: rejected connection from "172.30.0.13:32802" (error "remote error: tls: bad certificate", ServerName "")`

But if you go into any container with: `make exec`, you can install dig and run a reverse search to the ip:

```
$ apk --update add bind-tools && dig -x 172.30.0.13

; <<>> DiG 9.12.3 <<>> -x 172.30.0.13
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51983
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;13.0.30.172.in-addr.arpa.      IN      PTR

;; ANSWER SECTION:
13.0.30.172.in-addr.arpa. 600   IN      PTR     etcd3.local.etcd_main.

;; Query time: 0 msec
;; SERVER: 127.0.0.11#53(127.0.0.11)
;; WHEN: Tue Apr 02 18:25:40 UTC 2019
;; MSG SIZE  rcvd: 101

/ # ping etcd3.local.etcd_main
PING etcd3.local.etcd_main (172.30.0.13): 56 data bytes
64 bytes from 172.30.0.13: seq=0 ttl=64 time=0.113 ms
```
