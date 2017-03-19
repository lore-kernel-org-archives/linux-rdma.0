From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/ipoib: Update broadcast object if PKey value was changed in index 0
Date: Sun, 19 Mar 2017 11:18:54 +0200
Message-ID: <20170319091855.8419-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update the broadcast address in the priv->broadcast object when the
Pkey value changes in index 0, otherwise the multicast GID value will
keep the previous value of the PKey, and will not be updated.
This leads to interface state down because the interface will keep the
old PKey value.

For example, in SR-IOV environment, if the PF changes the value of PKey
index 0 for one of the VFs, then the VF receives PKey change event that
triggers heavy flush. This flush calls update_parent_pkey that update the
broadcast object and its relevant members. If in this case the multicast
GID will not be updated, the interface state will be down.

Fixes: c2904141696e ("IPoIB: Fix pkey change flow for virtualization environments")
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 12c4f84a6639..4c80681922c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -967,6 +967,19 @@ static inline int update_parent_pkey(struct ipoib_dev_priv *priv)
 		 */
 		priv->dev->broadcast[8] = priv->pkey >> 8;
 		priv->dev->broadcast[9] = priv->pkey & 0xff;
+
+		/*
+		 * Update the broadcast address in the priv->broadcast object,
+		 * in case it already exists, otherwise no one will do that.
+		 */
+		if (priv->broadcast) {
+			spin_lock_irq(&priv->lock);
+			memcpy(priv->broadcast->mcmember.mgid.raw,
+			       priv->dev->broadcast + 4,
+			sizeof(union ib_gid));
+			spin_unlock_irq(&priv->lock);
+		}
+
 		return 0;
 	}
 
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
