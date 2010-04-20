From: Ken Teague <kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: opensm with multiple IB subnets
Date: Tue, 20 Apr 2010 14:13:21 -0700
Message-ID: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a 17-node cluster and each node has a single IB card that has
2x IB ports (ib0 and ib1).  I have each node plugging in to an IB
switch; one cable between ib0 and the respective A-channel and another
cable between ib1 and the respective B-channel (e.g. c2n2, ib0 leads
to switch port 2A / c2n2, ib1 leads to switch port 2B / c2n3, ib0
leads to switch port 3A / c2n3, ib1 leads to switch port 3B ... etc.).
 Each channel and IB port/cable run are on separate subnets.  opensm
is running as a demon on the master node.

The IB switch in question has a total of 48 ports split between 24
A-channels and 24 B-channels.  Although this is 1 physical switch, the
two channels are separated internally in the circuitry.

After deploying the cluster, my A-channels were lighting up with both
the green and amber lights, but the B-channels were only lighting up
with the green link light.  I read opensm(8) and, if I'm understanding
this correctly, I need to run two instances of opensm; one for each
port.  Is this correct?

If I do need to run an instances of opensm per subnet, what is the
best way to do this automatically during boot?  /etc/ofa/opensm.conf
does allow me to specify a GUID, but will it allow me to specify
multiple GUIDs?  Should I (or is there a benefit to) run opensm on the
same host?  Please let me know if more information is needed.  Thanks
in advance.

Distribution:
OpenSM 3.2.2
openSUSE 10.3 (X86-64)
VERSION = 10.3
LSB_VERSION="core-2.0-noarch:core-3.0-noarch:core-2.0-x86_64:core-3.0-x86_64"

Subnets:
10.1.1.x - eth1
10.0.1.x - ib
10.0.2.x - ib2

HCA:
Microway DDR using Mellanox chipset.  Each card has 2x IB ports and 2x
EIA-422-B ports.

Switch:
Microway FasTree 48-port split between A-channels and B-channels, 24
ports per channel.  Although this is 1 physical switch, the A-channels
and B-channels are separate.

Cluster:
17 nodes including the master

/etc/hosts:
127.0.0.1       localhost.cl.mydomain.local  localhost

10.1.2.1        master.cl.mydomain.local    master
10.1.2.2        c2n2.cl.mydomain.local      c2n2
10.1.2.3        c2n3.cl.mydomain.local      c2n3
10.1.2.4        c2n4.cl.mydomain.local      c2n4
10.1.2.5        c2n5.cl.mydomain.local      c2n5
10.1.2.6        c2n6.cl.mydomain.local      c2n6
10.1.2.7        c2n7.cl.mydomain.local      c2n7
10.1.2.8        c2n8.cl.mydomain.local      c2n8
10.1.2.9        c2n9.cl.mydomain.local      c2n9
10.1.2.10       c2n10.cl.mydomain.local     c2n10
10.1.2.11       c2n11.cl.mydomain.local     c2n11
10.1.2.12       c2n12.cl.mydomain.local     c2n12
10.1.2.13       c2n13.cl.mydomain.local     c2n13
10.1.2.14       c2n14.cl.mydomain.local     c2n14
10.1.2.15       c2n15.cl.mydomain.local     c2n15
10.1.2.16       c2n16.cl.mydomain.local     c2n16
10.1.2.17       c2n17.cl.mydomain.local     c2n17

10.0.1.1        master-ib.cl.mydomain.local master-ib
10.0.1.2        c2n2-ib.cl.mydomain.local   c2n2-ib
10.0.1.3        c2n3-ib.cl.mydomain.local   c2n3-ib c2n3ib
10.0.1.4        c2n4-ib.cl.mydomain.local   c2n4-ib
10.0.1.5        c2n5-ib.cl.mydomain.local   c2n5-ib
10.0.1.6        c2n6-ib.cl.mydomain.local   c2n6-ib
10.0.1.7        c2n7-ib.cl.mydomain.local   c2n7-ib
10.0.1.8        c2n8-ib.cl.mydomain.local   c2n8-ib
10.0.1.9        c2n9-ib.cl.mydomain.local   c2n9-ib
10.0.1.10       c2n10-ib.cl.mydomain.local  c2n10-ib
10.0.1.11       c2n11-ib.cl.mydomain.local  c2n11-ib
10.0.1.12       c2n12-ib.cl.mydomain.local  c2n12-ib
10.0.1.13       c2n13-ib.cl.mydomain.local  c2n13-ib
10.0.1.14       c2n14-ib.cl.mydomain.local  c2n14-ib
10.0.1.15       c2n15-ib.cl.mydomain.local  c2n15-ib
10.0.1.16       c2n16-ib.cl.mydomain.local  c2n16-ib
10.0.1.17       c2n17-ib.cl.mydomain.local  c2n17-ib

10.0.2.1        master-ib2.cl.mydomain.local master-ib2
10.0.2.2        c2n2-ib2.cl.mydomain.local  c2n2-ib2
10.0.2.3        c2n3-ib2.cl.mydomain.local  c2n3-ib2 c2n3ib2
10.0.2.4        c2n4-ib2.cl.mydomain.local  c2n4-ib2
10.0.2.5        c2n5-ib2.cl.mydomain.local  c2n5-ib2
10.0.2.6        c2n6-ib2.cl.mydomain.local  c2n6-ib2
10.0.2.7        c2n7-ib2.cl.mydomain.local  c2n7-ib2
10.0.2.8        c2n8-ib2.cl.mydomain.local  c2n8-ib2
10.0.2.9        c2n9-ib2.cl.mydomain.local  c2n9-ib2
10.0.2.10       c2n10-ib2.cl.mydomain.local c2n10-ib2
10.0.2.11       c2n11-ib2.cl.mydomain.local c2n11-ib2
10.0.2.12       c2n12-ib2.cl.mydomain.local c2n12-ib2
10.0.2.13       c2n13-ib2.cl.mydomain.local c2n13-ib2
10.0.2.14       c2n14-ib2.cl.mydomain.local c2n14-ib2
10.0.2.15       c2n15-ib2.cl.mydomain.local c2n15-ib2
10.0.2.16       c2n16-ib2.cl.mydomain.local c2n16-ib2
10.0.2.17       c2n17-ib2.cl.mydomain.local c2n17-ib2

Routes:
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
239.2.11.71     0.0.0.0         255.255.255.255 UH    0      0        0 eth0
10.0.1.0        0.0.0.0         255.255.255.0   U     0      0        0 ib0
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 ib1
10.1.1.0        0.0.0.0         255.255.255.0   U     0      0        0 eth1
10.1.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U     0      0        0 eth0
127.0.0.0       0.0.0.0         255.0.0.0       U     0      0        0 lo
0.0.0.0         10.1.1.1        0.0.0.0         UG    0      0        0 eth1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
