From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs for multiple transports
Date: Tue,  9 Jan 2018 13:10:57 +0200
Message-ID: <20180109111058.29534-3-leon@kernel.org>
References: <20180109111058.29534-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109111058.29534-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduces an API that allows legacy applications to query
GIDs for a rdma_cm_id which is used during connection establishment.

GIDs are stored and created differently for IB, RoCE and iWARP transports.
Therefore rdma_read_gids() returns GID for all the transports hiding
such internal details to caller. It is usable for client side and server
side connections.

The rdma_read_gids() should not be used by any new ULPs.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 18 ++++++++++++++++++
 include/rdma/ib_addr.h        | 16 ++++++++++++++--
 include/rdma/rdma_cm.h        | 19 +++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f4c6c2cbc585..169d3a3bbf71 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2037,6 +2037,24 @@ __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(rdma_get_service_id);
 
+void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
+		    union ib_gid *dgid)
+{
+	struct rdma_addr *addr = &cm_id->route.addr;
+
+	if (!cm_id->device)
+		return;
+
+	if (rdma_protocol_roce(cm_id->device, cm_id->port_num)) {
+		rdma_ip2gid((struct sockaddr *)&addr->src_addr, sgid);
+		rdma_ip2gid((struct sockaddr *)&addr->dst_addr, dgid);
+	} else {
+		rdma_addr_get_sgid(&addr->dev_addr, sgid);
+		rdma_addr_get_dgid(&addr->dev_addr, dgid);
+	}
+}
+EXPORT_SYMBOL(rdma_read_gids);
+
 static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 {
 	struct rdma_id_private *id_priv = iw_id->context;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index fa809a7b48e7..edb1cdf2a892 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -165,6 +165,9 @@ static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
 
 static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
 {
+	if (!gid)
+		return 0;
+
 	switch (addr->sa_family) {
 	case AF_INET:
 		ipv6_addr_set_v4mapped(((struct sockaddr_in *)
@@ -205,6 +208,9 @@ static inline void rdma_gid2ip(struct sockaddr *out, const union ib_gid *gid)
 static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 				      union ib_gid *gid)
 {
+	if (!gid)
+		return;
+
 	memcpy(gid,
 	       dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr),
 	       sizeof(*gid));
@@ -215,9 +221,15 @@ static inline void rdma_addr_set_sgid(struct rdma_dev_addr *dev_addr, union ib_g
 	memcpy(dev_addr->src_dev_addr + rdma_addr_gid_offset(dev_addr), gid, sizeof *gid);
 }
 
-static inline void rdma_addr_get_dgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
+static inline void rdma_addr_get_dgid(struct rdma_dev_addr *dev_addr,
+				      union ib_gid *gid)
 {
-	memcpy(gid, dev_addr->dst_dev_addr + rdma_addr_gid_offset(dev_addr), sizeof *gid);
+	if (!gid)
+		return;
+
+	memcpy(gid,
+	       dev_addr->dst_dev_addr + rdma_addr_gid_offset(dev_addr),
+	       sizeof(*gid));
 }
 
 static inline void rdma_addr_set_dgid(struct rdma_dev_addr *dev_addr, union ib_gid *gid)
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 3d2eed3c4e75..6538a5cc27b6 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -413,4 +413,23 @@ bool rdma_is_consumer_reject(struct rdma_cm_id *id, int reason);
 const void *rdma_consumer_reject_data(struct rdma_cm_id *id,
 				      struct rdma_cm_event *ev, u8 *data_len);
 
+/**
+ * rdma_read_gids - Return the SGID and DGID used for establishing
+ *                  connection. This can be used after rdma_resolve_addr()
+ *                  on client side. This can be use on new connection
+ *                  on server side. This is applicable to IB, RoCE, iWarp.
+ *                  If cm_id is not bound yet to the RDMA device, it doesn't
+ *                  copy and SGID or DGID to the given pointers.
+ * @id: Communication identifier whose GIDs are queried.
+ * @sgid: Pointer to SGID where SGID will be returned. It is optional.
+ * @dgid: Pointer to DGID where DGID will be returned. It is optional.
+ * Note: This API should not be used by any new ULPs or new code.
+ * Instead, users interested in querying GIDs should refer to path record
+ * of the rdma_cm_id to query the GIDs.
+ * This API is provided for compatibility for existing users.
+ */
+
+void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
+		    union ib_gid *dgid);
+
 #endif /* RDMA_CM_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
