From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST FIXES for-3.11 3/4] IB/ipoib: Make sure child devices use valid/proper pkeys
Date: Wed, 17 Jul 2013 17:22:41 +0300
Message-ID: <1374070962-328-4-git-send-email-ogerlitz@mellanox.com>
References: <1374070962-328-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374070962-328-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make sure that the IB invalid pkey (0x0000 or 0x8000) isn't used for child devices.

Also, make sure to always set the full membership bit for the pkey of devices
created by rtnl link ops.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b6e049a..c6f71a8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1461,7 +1461,7 @@ static ssize_t create_child(struct device *dev,
 	if (sscanf(buf, "%i", &pkey) != 1)
 		return -EINVAL;
 
-	if (pkey < 0 || pkey > 0xffff)
+	if (pkey <= 0 || pkey > 0xffff || pkey == 0x8000)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index 7468593..f81abe1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -119,6 +119,15 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	} else
 		child_pkey  = nla_get_u16(data[IFLA_IPOIB_PKEY]);
 
+	if (child_pkey == 0 || child_pkey == 0x8000)
+		return -EINVAL;
+
+	/*
+	 * Set the full membership bit, so that we join the right
+	 * broadcast group, etc.
+	 */
+	child_pkey |= 0x8000;
+
 	err = __ipoib_vlan_add(ppriv, netdev_priv(dev), child_pkey, IPOIB_RTNL_CHILD);
 
 	if (!err && data)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
