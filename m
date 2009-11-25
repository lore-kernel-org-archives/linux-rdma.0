From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Subject: QoS settings not mapped correctly per pkey ?
Date: Wed, 25 Nov 2009 11:57:54 +0100
Message-ID: <4B0D0DB2.6080802@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: BOURDE CELINE <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>, Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Following the QoS experiments I carried out yesterday, I wanted to set
up 3 IP networks, each one bound to a particular pkey, in order to
achieve QoS for each network.
Unfortunately, it seems that something is not mapped properly in the ULP
layers (vlarb tables are fine).

The settings are as follows:

opensm.conf:
------------

qos_max_vls    8
qos_high_limit 1
qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0
qos_vlarb_low  0:8,1:1,2:1,3:4,4:0,5:0
qos_sl2vl      0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

The corresponding VLArb tables are fine on both the server (pichu16) and
the client (pichu22):

[root@pichu22 network-scripts]# smpquery vlarb -D 0
# VLArbitration tables: DR path slid 65535; dlid 65535; 0 port 0 LowCap
8 HighCap 8
# Low priority VL Arbitration Table:
VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x0 |0x0 |
WEIGHT: |0x8 |0x1 |0x1 |0x4 |0x0 |0x0 |0x0 |0x0 |
# High priority VL Arbitration Table:
VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x0 |0x0 |
WEIGHT: |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |

[root@pichu16 ~]# smpquery vlarb -D 0
# VLArbitration tables: DR path slid 65535; dlid 65535; 0 port 0 LowCap
8 HighCap 8
# Low priority VL Arbitration Table:
VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x0 |0x0 |
WEIGHT: |0x8 |0x1 |0x1 |0x4 |0x0 |0x0 |0x0 |0x0 |
# High priority VL Arbitration Table:
VL    : |0x0 |0x1 |0x2 |0x3 |0x4 |0x5 |0x0 |0x0 |
WEIGHT: |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |0x0 |

partitions.conf:
---------------

default=0x7fff,ipoib            : ALL=full;
ip_backbone=0x0001,ipoib        : ALL=full;
ip_admin=0x0002,ipoib            : ALL=full;

qos-policy.conf:
---------------

qos-ulps
    default                : 0 # default SL
    ipoib, pkey 0x7FFF     : 1 # IP with default pkey 0x7FFF
    ipoib, pkey 0x1        : 2 # backbone IP with pkey 0x1
    ipoib, pkey 0x2        : 3 # admin IP with pkey 0x2
end-qos-ulps

Assigned IP addresses (in /etc/hosts):
-------------------------------------

10.12.1.4       pichu16-ic0             # default IPoIB network, pkey 0x7FFF
10.13.1.4       pichu16-backbone        # IPoIB backbone network, pkey 0x1
10.14.1.4       pichu16-admin           # IPoIB admin network, pkey 0x2
10.12.1.10      pichu22-ic0             # default IPoIB network, pkey 0x7FFF
10.13.1.10      pichu22-backbone        # IPoIB backbone network, pkey 0x1
10.14.1.10      pichu22-admin           # IPoIB admin network, pkey 0x2

Note that the netmask is /16, so the -ic0, -backbone and -admin networks
cannot see each other.

IPoIB settings on server side:
------------------------------

[root@pichu16 ~]# tail -n 5 /etc/sysconfig/network-scripts/ifcfg-ib0*
==> /etc/sysconfig/network-scripts/ifcfg-ib0 <==
BOOTPROTO=static
IPADDR=10.12.1.4
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

==> /etc/sysconfig/network-scripts/ifcfg-ib0.8001 <==
BOOTPROTO=static
IPADDR=10.13.1.4
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

==> /etc/sysconfig/network-scripts/ifcfg-ib0.8002 <==
BOOTPROTO=static
IPADDR=10.14.1.4
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

[root@pichu16 ~]# ip addr show ib0
4: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP qlen 256
    link/infiniband
80:00:00:48:fe:80:00:00:00:00:00:00:2c:90:00:10:0d:00:05:6d brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    inet 10.12.1.4/16 brd 10.12.255.255 scope global ib0
    inet 10.13.1.4/16 brd 10.13.255.255 scope global ib0
    inet 10.14.1.4/16 brd 10.14.255.255 scope global ib0
    inet6 fe80::2e90:10:d00:56d/64 scope link
       valid_lft forever preferred_lft forever

IPoIB settings on client side:
------------------------------

[root@pichu22 ~]# tail -n 5 /etc/sysconfig/network-scripts/ifcfg-ib0*
==> /etc/sysconfig/network-scripts/ifcfg-ib0 <==
BOOTPROTO=static
IPADDR=10.12.1.10
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

==> /etc/sysconfig/network-scripts/ifcfg-ib0.8001 <==
BOOTPROTO=static
IPADDR=10.13.1.10
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

==> /etc/sysconfig/network-scripts/ifcfg-ib0.8002 <==
BOOTPROTO=static
IPADDR=10.14.1.10
NETMASK=255.255.0.0
ONBOOT=yes
MTU=2044

[root@pichu22 ~]# ip addr show ib0
48: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP qlen 256
    link/infiniband
80:00:00:48:fe:80:00:00:00:00:00:00:2c:90:00:10:0d:00:06:79 brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    inet 10.12.1.10/16 brd 10.12.255.255 scope global ib0
    inet 10.13.1.10/16 brd 10.13.255.255 scope global ib0
    inet 10.14.1.10/16 brd 10.14.255.255 scope global ib0
    inet6 fe80::2e90:10:d00:679/64 scope link
       valid_lft forever preferred_lft forever

Iperf servers on server side:
-----------------------------

Quoting from iperf help:
  -B, --bind      <host>   bind to <host>, an interface or multicast address
  -s, --server             run in server mode

Each iperf server is bound to a dedicated interface as follows:

[root@pichu16 ~]# iperf -s -B pichu16-backbone
[root@pichu16 ~]# iperf -s -B pichu16-admin
[root@pichu16 ~]# iperf -s -B pichu16-ic0

Iperf clients on client side:
-----------------------------

Quoting from iperf help:
  -c, --client    <host>   run in client mode, connecting to <host>
  -t, --time      #        time in seconds to transmit for (default 10 secs)

And each iperf client talks to the corresponding iperf server:

[root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-ic0 -t
100 2>&1; done | grep Gbits/sec
[  3]  0.0-100.0 sec  64.6 GBytes  5.55 Gbits/sec
[  3]  0.0-100.0 sec  64.5 GBytes  5.54 Gbits/sec
[  3]  0.0-100.0 sec  60.5 GBytes  5.20 Gbits/sec
[root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-backbone
-t 100 2>&1; done | grep Gbits/sec
[  3]  0.0-100.0 sec  64.8 GBytes  5.57 Gbits/sec
[  3]  0.0-100.0 sec  56.7 GBytes  4.87 Gbits/sec
[  3]  0.0-100.0 sec  59.7 GBytes  5.13 Gbits/sec
[root@pichu22 ~]# while test -e keep_going; do iperf -c pichu16-admin -t
100 2>&1; done | grep Gbits/sec
[  3]  0.0-100.0 sec  57.3 GBytes  4.92 Gbits/sec
[  3]  0.0-100.0 sec  61.6 GBytes  5.29 Gbits/sec
[  3]  0.0-100.0 sec  62.7 GBytes  5.38 Gbits/sec

Given the VLarb weights assigned (1 for *-ic0 on VL1, 1 for *-backbone
on VL2 and 4 for *-admin on VL3), we would expect different b/w figures
for the *-admin network.
As we can see, all iperf values are the same, showing that QoS is not
enforced on a per pkey basis.
It seems to me that something is not mapped properly in the ULP layers.
Could anyone tell me if I'm wrong here ? If not, is that a known issue ?

Thanks for your help,

Vincent




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
