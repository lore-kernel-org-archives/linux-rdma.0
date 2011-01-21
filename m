From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/ucma: Copy iWARP route information on queries.
Date: Thu, 20 Jan 2011 21:40:46 -0600
Message-ID: <20110121034045.17376.43085.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For iWARP rdma_cm ids, the "route" information is the L2 src and
next hop addresses.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ca12acf..ec1e9da 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -636,6 +636,16 @@ static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
 	}
 }
 
+static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
+			       struct rdma_route *route)
+{
+	struct rdma_dev_addr *dev_addr;
+
+	dev_addr = &route->addr.dev_addr;
+	rdma_addr_get_dgid(dev_addr, (union ib_gid *) &resp->ib_route[0].dgid);
+	rdma_addr_get_sgid(dev_addr, (union ib_gid *) &resp->ib_route[0].sgid);
+}
+
 static ssize_t ucma_query_route(struct ucma_file *file,
 				const char __user *inbuf,
 				int in_len, int out_len)
@@ -670,8 +680,10 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 
 	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
 	resp.port_num = ctx->cm_id->port_num;
-	if (rdma_node_get_transport(ctx->cm_id->device->node_type) == RDMA_TRANSPORT_IB) {
-		switch (rdma_port_get_link_layer(ctx->cm_id->device, ctx->cm_id->port_num)) {
+	switch (rdma_node_get_transport(ctx->cm_id->device->node_type)) {
+	case RDMA_TRANSPORT_IB:
+		switch (rdma_port_get_link_layer(ctx->cm_id->device,
+			ctx->cm_id->port_num)) {
 		case IB_LINK_LAYER_INFINIBAND:
 			ucma_copy_ib_route(&resp, &ctx->cm_id->route);
 			break;
@@ -681,6 +693,12 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 		default:
 			break;
 		}
+		break;
+	case RDMA_TRANSPORT_IWARP:
+		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
+		break;
+	default:
+		break;
 	}
 
 out:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
