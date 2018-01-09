From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/6] RDMA/cma: Refactor to access multiple fields of rdma_dev_addr
Date: Tue,  9 Jan 2018 15:58:55 +0200
Message-ID: <20180109135859.7676-3-leon@kernel.org>
References: <20180109135859.7676-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109135859.7676-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Pass the rdma_cm_id so that multiple fields of the rdma_dev_addr
structure can be accessed, instead of passing each individual fields.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 683428cffd54..78b1ce5789e6 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -612,11 +612,14 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 
 static inline int cma_validate_port(struct ib_device *device, u8 port,
 				    enum ib_gid_type gid_type,
-				      union ib_gid *gid, int dev_type,
-				      int bound_if_index)
+				    union ib_gid *gid,
+				    struct rdma_id_private *id_priv)
 {
-	int ret = -ENODEV;
+	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
+	int bound_if_index = dev_addr->bound_dev_if;
+	int dev_type = dev_addr->dev_type;
 	struct net_device *ndev = NULL;
+	int ret = -ENODEV;
 
 	if ((dev_type == ARPHRD_INFINIBAND) && !rdma_protocol_ib(device, port))
 		return ret;
@@ -671,8 +674,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 					rdma_protocol_ib(cma_dev->device, port) ?
 					IB_GID_TYPE_IB :
 					listen_id_priv->gid_type, gidp,
-					dev_addr->dev_type,
-					dev_addr->bound_dev_if);
+					id_priv);
 		if (!ret) {
 			id_priv->id.port_num = port;
 			goto out;
@@ -693,8 +695,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 						rdma_protocol_ib(cma_dev->device, port) ?
 						IB_GID_TYPE_IB :
 						cma_dev->default_gid_type[port - 1],
-						gidp, dev_addr->dev_type,
-						dev_addr->bound_dev_if);
+						gidp, id_priv);
 			if (!ret) {
 				id_priv->id.port_num = port;
 				goto out;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
