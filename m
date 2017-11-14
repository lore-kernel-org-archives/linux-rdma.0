From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 25/31] IB/{core, ipoib}: Simplify ib_find_gid to search only for IB link layer
Date: Tue, 14 Nov 2017 14:52:12 +0200
Message-ID: <20171114125218.20477-26-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently there are no users of ib_find_gid for RoCE transport. It is
only used by IPoIB.
Therefore its simplified to ignore RoCE ports and GID type check which
was previously done for every port.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/device.c        | 16 +++-------------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |  3 +--
 include/rdma/ib_verbs.h                 |  3 +--
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 84fc32a2c8b3..bb2686d56d3c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1017,32 +1017,22 @@ EXPORT_SYMBOL(ib_modify_port);
 
 /**
  * ib_find_gid - Returns the port number and GID table index where
- *   a specified GID value occurs.
+ *   a specified GID value occurs. Its searches only for IB link layer.
  * @device: The device to query.
  * @gid: The GID value to search for.
- * @gid_type: Type of GID.
  * @ndev: The ndev related to the GID to search for.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the GID table where the GID was found.  This
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		enum ib_gid_type gid_type, struct net_device *ndev,
-		u8 *port_num, u16 *index)
+		struct net_device *ndev, u8 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
 	int ret, port, i;
 
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
-		if (rdma_cap_roce_gid_table(device, port)) {
-			if (!ib_find_cached_gid_by_port(device, gid, gid_type, port,
-							ndev, index)) {
-				*port_num = port;
-				return 0;
-			}
-		}
-
-		if (gid_type != IB_GID_TYPE_IB)
+		if (rdma_cap_roce_gid_table(device, port))
 			continue;
 
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 3b96cdaf9a83..b9fa21790da9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1085,8 +1085,7 @@ static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
 
 	netif_addr_unlock_bh(priv->dev);
 
-	err = ib_find_gid(priv->ca, &search_gid, IB_GID_TYPE_IB,
-			  priv->dev, &port, &index);
+	err = ib_find_gid(priv->ca, &search_gid, priv->dev, &port, &index);
 
 	netif_addr_lock_bh(priv->dev);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd84cda5ed7c..cfd837049a32 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2836,8 +2836,7 @@ int ib_modify_port(struct ib_device *device,
 		   struct ib_port_modify *port_modify);
 
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		enum ib_gid_type gid_type, struct net_device *ndev,
-		u8 *port_num, u16 *index);
+		struct net_device *ndev, u8 *port_num, u16 *index);
 
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
