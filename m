From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: Check that retry count values are in range
Date: Wed, 3 Oct 2012 23:42:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98EFE@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The retry_count and rnr_retry_count connection parameters
are both 3-bit values.  Validate that the values are in
range or reduce accordingly.

This fixes a problem reported by Doug Ledford
<dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> that resulted in the userspace
rping test (part of the librdmacm samples) failing to
run over Intel IB HCAs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7172559..18271e1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2648,8 +2648,8 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.responder_resources = conn_param->responder_resources;
 	req.initiator_depth = conn_param->initiator_depth;
 	req.flow_control = conn_param->flow_control;
-	req.retry_count = conn_param->retry_count;
-	req.rnr_retry_count = conn_param->rnr_retry_count;
+	req.retry_count = min(7, conn_param->retry_count);
+	req.rnr_retry_count = min(7, conn_param->rnr_retry_count);
 	req.remote_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
 	req.local_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
@@ -2770,7 +2770,7 @@ static int cma_accept_ib(struct rdma_id_private *id_priv,
 	rep.initiator_depth = conn_param->initiator_depth;
 	rep.failover_accepted = 0;
 	rep.flow_control = conn_param->flow_control;
-	rep.rnr_retry_count = conn_param->rnr_retry_count;
+	rep.rnr_retry_count = min(conn_param->rnr_retry_count, 7);
 	rep.srq = id_priv->srq ? 1 : 0;
 
 	ret = ib_send_cm_rep(id_priv->cm_id.ib, &rep);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
