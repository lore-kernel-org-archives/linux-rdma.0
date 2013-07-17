From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST FIXES for-3.11 0/4] Pkey fixes for IB core and IPoIB
Date: Wed, 17 Jul 2013 17:22:38 +0300
Message-ID: <1374070962-328-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- Did quick reposting as of one hunk in the last patch that went by mistake 
  from ipoib_ib.c to ipoib_multicast.c, sorry for the spam

Hi Roland,

This set of fixes is critical for Virtualization environments when the VM 
para-virtualized PKEY table isn't fully configured at the time the 
VF is probed, or when the management pkey is provisioned to non-zero index
in the VF pkey table.

The first three patches are pretty much few liners (two of them with somehow 
long change log...). The forth one a bit larger. Would be happy to see them 
all going to -stable, either by you adding a Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org when 
you push them or I can send them to Greg after they spend some time upstream.



Or.


Erez Shitrit (1):
  IB/ipoib: Fix pkey-change flow for Virtualization environments

Jack Morgenstein (2):
  IB/core: Create QP1 using the pkey index which contains the default pkey
  IB/mlx4: Use default pkey when creating tunnel QPs

Or Gerlitz (1):
  IB/ipoib: Make sure child devices use valid/proper pkeys

 drivers/infiniband/core/mad.c                |    8 +++-
 drivers/infiniband/hw/mlx4/mad.c             |   10 +++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |   76 +++++++++++++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    9 +++
 5 files changed, 88 insertions(+), 17 deletions(-)


 drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |    3 +
 6 files changed, 85 insertions(+), 18 deletions(-)

This is the sequence of events when the IPoIB patch is applied at the guest:

<-- the VM pkey table contains 0x0000 in index 0, and hence the mgid has 0x8000 as the pkey

[root@xena017-3 infiniband]# cat /sys/class/infiniband/mlx4_0/ports/1/pkeys/0

0x0000

[root@xena017-3 ~]# ip addr show ib0
22: ib0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc pfifo_fast state DOWN qlen 256
    link/infiniband 80:00:05:8b:fe:80:00:00:00:00:00:00:00:14:05:00:00:00:04:f9 brd 00:ff:ff:ff:ff:12:40:1b:80:00:00:00:00:00:00:00:ff:ff:ff:ff
    inet 192.168.20.199/24 brd 192.168.20.255 scope global ib0

<--  the hypervisor changed pkey value in index 0  of the VM pkey table to contain 0x8001

[root@xena017-3 infiniband]# cat /sys/class/infiniband/mlx4_0/ports/1/pkeys/0

0x8001

[root@xena017-3 ~]# dmesg
ib0: bringing up interface
IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
[...]
ib0: Event 12 on device mlx4_0 port 1
ib0: pkey changed from 0x8000 to 0x8001
ib0: downing ib_dev
ib0: All sends and receives done.
ib0: Created ah ffff88011a11f4e0
IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
ib0: Created ah ffff88011a11f660
ib0: Created ah ffff88011a11f780

<--- mgid changed to use 0x8001

[root@xena017-3 ~]# ip addr show ib0
22: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast state UP qlen 256
    link/infiniband 80:00:05:8b:fe:80:00:00:00:00:00:00:00:14:05:00:00:00:04:f9 brd 00:ff:ff:ff:ff:12:40:1b:80:01:00:00:00:00:00:00:ff:ff:ff:ff
    inet 192.168.20.199/24 brd 192.168.20.255 scope global ib0


ping works etc

--> when the mlx4 patch isn't applied on the host we see these errors

<mlx4_ib> create_pv_sqp: Couldn't change tunnel qp state to INIT (-22)
<mlx4_ib> create_pv_resources: Couldn't create tunnel for QP1 (-22)

--> this is the sequence of events when the IPoIB patch is not applied at the guest:

<-- the VM pkey table contains 0x0000 in index 0, and hence the mgid has 0x8000 as the pkey

[root@xena017-3 infiniband]# cat /sys/class/infiniband/mlx4_0/ports/1/pkeys/0

0x0000

[root@xena017-3 infiniband]# modprobe ib_ipoib debug_level=1

[root@xena017-3 infiniband]# ip a s ib0

30: ib0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc pfifo_fast state DOWN qlen 256
    link/infiniband 80:00:05:93:fe:80:00:00:00:00:00:00:00:14:05:00:00:00:04:f9 brd 00:ff:ff:ff:ff:12:40:1b:80:00:00:00:00:00:00:00:ff:ff:ff:ff

[root@xena017-3 infiniband]# cat /sys/class/infiniband/mlx4_0/ports/1/pkeys/0

0x8001

<-- ipoib got the event, but nothing changed

[root@xena017-3 infiniband]# ip a s ib0

30: ib0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc pfifo_fast state DOWN qlen 256
    link/infiniband 80:00:05:93:fe:80:00:00:00:00:00:00:00:14:05:00:00:00:04:f9 brd 00:ff:ff:ff:ff:12:40:1b:80:00:00:00:00:00:00:00:ff:ff:ff:ff
    inet 192.168.20.199/24 brd 192.168.20.255 scope global ib0

[root@xena017-3 infiniband]# dmesg
ib%d: max_srq_sge=31
ib%d: max_cm_mtu = 0xfff0, num_frags=16
ib%d: max_srq_sge=31
ib%d: max_cm_mtu = 0xfff0, num_frags=16
ib0: bringing up interface
IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, status -22
ib0: Event 12 on device mlx4_0 port 1
ib0: downing ib_dev
ib0: All sends and receives done.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
