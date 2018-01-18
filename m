From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 1/4] RDMA/cma: Introduce API to read GIDs for multiple transports
Date: Thu, 18 Jan 2018 10:11:16 +0200
Message-ID: <20180118081119.30024-2-leon@kernel.org>
References: <20180118081119.30024-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118081119.30024-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduces an API that allows legacy applications to query
GIDs for a rdma_cm_id which is used during connection establishment.

GIDs are stored and created differently for iWarp, IB and RoCE transports.
Therefore rdma_read_gids() returns GID for all the transports hiding
such internal details to caller.
It is usable for client side and server side connections.

rdma_read_gids() should not be used by any new ULPs.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 27 +++++++++++++++++++++++++++
 include/rdma/rdma_cm.h        | 19 +++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3810716ea65e..a4c010e7b82b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2037,6 +2037,33 @@ __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(rdma_get_service_id);
 
+void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
+		    union ib_gid *dgid)
+{
+	struct rdma_addr *addr = &cm_id->route.addr;
+
+	if (!cm_id->device) {
+		if (sgid)
+			memset(sgid, 0, sizeof(*sgid));
+		if (dgid)
+			memset(dgid, 0, sizeof(*dgid));
+		return;
+	}
+
+	if (rdma_protocol_roce(cm_id->device, cm_id->port_num)) {
+		if (sgid)
+			rdma_ip2gid((struct sockaddr *)&addr->src_addr, sgid);
+		if (dgid)
+			rdma_ip2gid((struct sockaddr *)&addr->dst_addr, dgid);
+	} else {
+		if (sgid)
+			rdma_addr_get_sgid(&addr->dev_addr, sgid);
+		if (dgid)
+			rdma_addr_get_dgid(&addr->dev_addr, dgid);
+	}
+}
+EXPORT_SYMBOL(rdma_read_gids);
+
 static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 {
 	struct rdma_id_private *id_priv = iw_id->context;
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
