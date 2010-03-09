From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: arping and ipoib question
Date: Tue, 09 Mar 2010 12:59:24 -0700
Message-ID: <4B96A89C.1040503@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm trying to build a failover setup for multiple ib-ethernet gateways 
(routing IP) and I was wondering how/if the linux "arping" utility works 
with ipoib. I would like to send a gratuitous ARP to the ipoib subnet to 
announce a change of IP ownership, but it doesn't seem to be working 
like it does on ethernet.

So I have host labfs01 and labfs03. They are plugged in to an SDR switch 
with opensm managing the fabric. I can see them on the IB fabric, I can 
see them in ibnetdiscover and I can perfquery their port counters from 
each other. So I'm sure the IB fabric is okay.

Here's what I see when I try to send a gratuitous ARP from labfs03:

[root@labfs03 ~]# arping -c 3 -A -I ib0 172.17.30.7
ARPING 172.17.30.7 from 172.17.30.7 ib0
Sent 3 probes (3 broadcast(s))
Received 0 response(s)
[root@labfs03 ~]#

And here's some output from  labfs01 before, while, and after I send the 
gARP:

[root@labfs01 ~]# ip neigh s
192.168.0.13 dev bond1 lladdr 00:02:b3:90:a9:3e REACHABLE
192.168.0.10 dev bond1 lladdr 00:50:45:00:b8:aa REACHABLE
172.17.6.1 dev bond0 lladdr 00:16:9c:54:80:00 REACHABLE
192.168.0.14 dev bond1  FAILED
172.17.6.32 dev bond0 lladdr 00:50:45:00:bc:2c REACHABLE
172.17.6.31 dev bond0 lladdr 00:50:45:00:be:de REACHABLE
192.168.0.12 dev bond1 lladdr 00:02:b3:cc:1c:e2 REACHABLE
[root@labfs01 ~]#
[root@labfs01 ~]# tcpdump -i ib0
tcpdump: WARNING: arptype 32 not supported by libpcap - falling back to 
cooked socket
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ib0, link-type LINUX_SLL (Linux cooked), capture size 96 bytes
12:54:15.912672 arp reply 172.17.30.7 is-at 
80:00:04:04:fe:80:00:00:00:00:00:00:00:02:c9:02:00:24:34:8d hardware #32
12:54:16.913677 arp reply 172.17.30.7 is-at 
80:00:04:04:fe:80:00:00:00:00:00:00:00:02:c9:02:00:24:34:8d hardware #32
12:54:17.914625 arp reply 172.17.30.7 is-at 
80:00:04:04:fe:80:00:00:00:00:00:00:00:02:c9:02:00:24:34:8d hardware #32

3 packets captured
3 packets received by filter
0 packets dropped by kernel
[root@labfs01 ~]# ip neigh sh
192.168.0.13 dev bond1 lladdr 00:02:b3:90:a9:3e REACHABLE
192.168.0.10 dev bond1 lladdr 00:50:45:00:b8:aa REACHABLE
172.17.6.1 dev bond0 lladdr 00:16:9c:54:80:00 REACHABLE
192.168.0.14 dev bond1  FAILED
172.17.6.32 dev bond0 lladdr 00:50:45:00:bc:2c REACHABLE
172.17.6.31 dev bond0 lladdr 00:50:45:00:be:de REACHABLE
192.168.0.12 dev bond1 lladdr 00:02:b3:cc:1c:e2 REACHABLE



So we can see the gARP packets making it to labfs01, but the ARP cache 
in labfs01 is not being updated by the gARP.

If I just do a ping from labfs01 to labfs03, the ARP entry shows up.

Is this something that ipoib can do? Is there a better way to approach this?

Tom


-- 
--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
