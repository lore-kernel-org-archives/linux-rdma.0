From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: rdma_cm unable to find route on sub-table
Date: Wed, 17 May 2017 17:00:43 -0600
Message-ID: <CAANLjFrZAcshGheQCqKYktd0MfmcUqGFbr=XjdjYVf+B_AMbFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are having problems getting an RDMA connection when the route is on
a sub-table. We can reproduce this on RoCE and IB. Here are the steps
we are taking to replicate the problem. I think this is a bug.

Test #1
-------
Using ConnectX-3 and Infiniband with two hosts back to back.

Server
------

# systemctl start opensm

# ip -6 addr add dev ib0 fd00::13/64

# ip link set ib0 up

# rping -s -a ::0
server DISCONNECT EVENT...
wait for RDMA_READ_ADV state 10


Client
------

# ip -6 addr add dev ib0 fd00::14/64

# ip link set ib0 up

# ping6 fd00::13
PING fd00::13(fd00::13) 56 data bytes
64 bytes from fd00::13: icmp_seq=1 ttl=64 time=0.927 ms
64 bytes from fd00::13: icmp_seq=2 ttl=64 time=0.134 ms
^C
--- fd00::13 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.134/0.530/0.927/0.397 ms

# rping -c -a fd00::13
^C

Results #1
----------
Tests complete successfully


Test #2
-------
Built upon the configuration of Test #1

Server
------
# rping -s -a ::0

Client
------
# echo "100 r0" >> /etc/iproute2/rt_tables

# ip -6 route del fd00::/64 dev ib0

# ip -6 rule add from fd00::14 table r0

# ip -6 route add fd00::/64 dev ib0 table r0

# ping6 fd00::13
PING fd00::13(fd00::13) 56 data bytes
64 bytes from fd00::13: icmp_seq=1 ttl=64 time=0.158 ms
64 bytes from fd00::13: icmp_seq=2 ttl=64 time=0.136 ms
^C
--- fd00::13 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1020ms
rtt min/avg/max/mdev = 0.136/0.147/0.158/0.011 ms

# rping -c -a fd00::13
rdma_resolve_addr: Network is unreachable

Results #2
----------
rping is unable to find a route to use


----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
