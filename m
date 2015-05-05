From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 11/23] IB/Verbs: Reform route related part in IB-core cma
Date: Tue,  5 May 2015 14:50:28 +0200
Message-ID: <1430830240-32389-12-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use raw management helpers to reform route related part in IB-core cma.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c  | 31 ++++++++-----------------------
 drivers/infiniband/core/ucma.c | 25 ++++++-------------------
 2 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8a07e89..36c5f8a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -923,13 +923,9 @@ static inline int cma_user_data_offset(struct rdma_id_private *id_priv)
 
 static void cma_cancel_route(struct rdma_id_private *id_priv)
 {
-	switch (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)) {
-	case IB_LINK_LAYER_INFINIBAND:
+	if (rdma_protocol_ib(id_priv->id.device, id_priv->id.port_num)) {
 		if (id_priv->query)
 			ib_sa_cancel_query(id_priv->query_id, id_priv->query);
-		break;
-	default:
-		break;
 	}
 }
 
@@ -1957,26 +1953,15 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 		return -EINVAL;
 
 	atomic_inc(&id_priv->refcount);
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
-		switch (rdma_port_get_link_layer(id->device, id->port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
-			ret = cma_resolve_ib_route(id_priv, timeout_ms);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
-			ret = cma_resolve_iboe_route(id_priv);
-			break;
-		default:
-			ret = -ENOSYS;
-		}
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	if (rdma_protocol_ib(id->device, id->port_num))
+		ret = cma_resolve_ib_route(id_priv, timeout_ms);
+	else if (rdma_protocol_iboe(id->device, id->port_num))
+		ret = cma_resolve_iboe_route(id_priv);
+	else if (rdma_protocol_iwarp(id->device, id->port_num))
 		ret = cma_resolve_iw_route(id_priv, timeout_ms);
-		break;
-	default:
+	else
 		ret = -ENOSYS;
-		break;
-	}
+
 	if (ret)
 		goto err;
 
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 45d67e9..dae7620 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -722,26 +722,13 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 
 	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
 	resp.port_num = ctx->cm_id->port_num;
-	switch (rdma_node_get_transport(ctx->cm_id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
-		switch (rdma_port_get_link_layer(ctx->cm_id->device,
-			ctx->cm_id->port_num)) {
-		case IB_LINK_LAYER_INFINIBAND:
-			ucma_copy_ib_route(&resp, &ctx->cm_id->route);
-			break;
-		case IB_LINK_LAYER_ETHERNET:
-			ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
-			break;
-		default:
-			break;
-		}
-		break;
-	case RDMA_TRANSPORT_IWARP:
+
+	if (rdma_protocol_ib(ctx->cm_id->device, ctx->cm_id->port_num))
+		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
+	else if (rdma_protocol_iboe(ctx->cm_id->device, ctx->cm_id->port_num))
+		ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
+	else if (rdma_protocol_iwarp(ctx->cm_id->device, ctx->cm_id->port_num))
 		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
-		break;
-	default:
-		break;
-	}
 
 out:
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
