From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IPoIB: report operstate consistently when brought up without a link
Date: Fri, 17 Jan 2014 19:47:25 +0100
Message-ID: <1389984445-29360-1-git-send-email-mschmidt@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After booting without a working link, "ip link" shows:

 5: mlx4_ib1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc pfifo_fast
 state DOWN qlen 256
    ...
 7: mlx4_ib1.8003@mlx4_ib1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc
 pfifo_fast state DOWN qlen 256
    ...

Then after connecting and disconnecting the link, which should result
in exactly the same state as before, it shows:

 5: mlx4_ib1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc pfifo_fast
 state DOWN qlen 256
    ...
 7: mlx4_ib1.8003@mlx4_ib1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 2044 qdisc
 pfifo_fast state LOWERLAYERDOWN qlen 256
    ...

Notice the (now correct) LOWERLAYERDOWN operstate shown for the mlx4_ib1.8003
interface. Ideally the identical state would be shown right after boot.

The problem is related to the calling of netif_carrier_off() in network drivers.
For a long time it was known that doing netif_carrier_off() before registering
the netdevice would result in the interface's operstate being shown as UNKNOWN
if the device was brought up without a working link. This problem was fixed in
commit 8f4cccbbd92 ('net: Set device operstate at registration time'), but
still there remains the minor inconsistency demonstrated above.

This patch fixes it by moving ipoib's call to netif_carrier_off() into the
.ndo_open method, which is where network drivers ordinarily do it.
With the patch when doing the same test as above, the operstate of
mlx4_ib1.8003 is shown as LOWERLAYERDOWN right after boot.

Signed-off-by: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index d64ed05..5786a78 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -104,6 +104,8 @@ int ipoib_open(struct net_device *dev)
 
 	ipoib_dbg(priv, "bringing up interface\n");
 
+	netif_carrier_off(dev);
+
 	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
 	if (ipoib_pkey_dev_delay_open(dev))
@@ -1366,8 +1368,6 @@ void ipoib_setup(struct net_device *dev)
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
 
-	netif_carrier_off(dev);
-
 	priv->dev = dev;
 
 	spin_lock_init(&priv->lock);
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
