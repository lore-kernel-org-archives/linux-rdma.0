From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when changing the MTU in UD over the max range
Date: Wed, 28 Dec 2016 14:47:20 +0200
Message-ID: <20161228124728.26619-2-leon@kernel.org>
References: <20161228124728.26619-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228124728.26619-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In datagram mode, the IB UD (Unreliable Datagram) transport is used
so the MTU of the interface is equal to the IB L2 MTU minus the
IPoIB encapsulation header. Any request to change the MTU value
above the maximum range will change the MTU to the max allowed, but
will not show any warning message. An ipoib_warn is issued in such
cases, letting the user know that even though the value is legal,
it can't be currently applied.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765..a550cc6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -229,6 +229,10 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 
 	priv->admin_mtu = new_mtu;
 
+	if (priv->mcast_mtu < priv->admin_mtu)
+		ipoib_warn(priv, "MTU must be smaller than mcast_mtu (%u)\n",
+			   priv->mcast_mtu);
+
 	dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
 
 	return 0;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
