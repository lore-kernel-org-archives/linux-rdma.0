From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cma: Add debug messages to error flows
Date: Thu,  5 Jan 2017 16:16:35 +0200
Message-ID: <20170105141636.23284-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Print debug messages to the kernel log to add more
information about RDMA_CM events that indicate an error.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c  |  2 ++
 drivers/infiniband/core/cma.c | 25 +++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index cf1edfa..6535f09 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3409,6 +3409,8 @@ static void cm_process_send_error(struct ib_mad_send_buf *msg,
 	if (msg != cm_id_priv->msg || state != cm_id_priv->id.state)
 		goto discard;

+	pr_debug_ratelimited("CM: failed sending MAD in state %d. (%s)\n",
+			     state, ib_wc_status_msg(wc_status));
 	switch (state) {
 	case IB_CM_REQ_SENT:
 	case IB_CM_MRA_REQ_RCVD:
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e7dcfac..847c5ad 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1689,6 +1689,7 @@ static int cma_rep_recv(struct rdma_id_private *id_priv)

 	return 0;
 reject:
+	pr_debug_ratelimited("RDMA CM: CONNECT_ERROR: failed to handle reply. status %d\n", ret);
 	cma_modify_qp_err(id_priv);
 	ib_send_cm_rej(id_priv->cm_id.ib, IB_CM_REJ_CONSUMER_DEFINED,
 		       NULL, 0, NULL, 0);
@@ -1760,6 +1761,8 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		/* ignore event */
 		goto out;
 	case IB_CM_REJ_RECEIVED:
+		pr_debug_ratelimited("RDMA CM: REJECTED: %s\n", rdma_reject_msg(&id_priv->id,
+										ib_event->param.rej_rcvd.reason));
 		cma_modify_qp_err(id_priv);
 		event.status = ib_event->param.rej_rcvd.reason;
 		event.event = RDMA_CM_EVENT_REJECTED;
@@ -2285,6 +2288,8 @@ static void cma_query_handler(int status, struct ib_sa_path_rec *path_rec,
 		work->new_state = RDMA_CM_ADDR_RESOLVED;
 		work->event.event = RDMA_CM_EVENT_ROUTE_ERROR;
 		work->event.status = status;
+		pr_debug_ratelimited("RDMA CM: ROUTE_ERROR: failed to query path. status %d\n",
+				     status);
 	}

 	queue_work(cma_wq, &work->work);
@@ -2720,8 +2725,14 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		goto out;

 	memcpy(cma_src_addr(id_priv), src_addr, rdma_addr_size(src_addr));
-	if (!status && !id_priv->cma_dev)
+	if (!status && !id_priv->cma_dev) {
 		status = cma_acquire_dev(id_priv, NULL);
+		if (status)
+			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
+					     status);
+	} else {
+		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
+	}

 	if (status) {
 		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
@@ -3307,10 +3318,13 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 		if (rep->status != IB_SIDR_SUCCESS) {
 			event.event = RDMA_CM_EVENT_UNREACHABLE;
 			event.status = ib_event->param.sidr_rep_rcvd.status;
+			pr_debug_ratelimited("RDMA CM: UNREACHABLE: bad SIDR reply. status %d\n",
+					     event.status);
 			break;
 		}
 		ret = cma_set_qkey(id_priv, rep->qkey);
 		if (ret) {
+			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to set qkey. status %d\n", ret);
 			event.event = RDMA_CM_EVENT_ADDR_ERROR;
 			event.status = ret;
 			break;
@@ -3759,10 +3773,17 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)

 	if (!status)
 		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
+	else
+		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
+				     status);
 	mutex_lock(&id_priv->qp_mutex);
-	if (!status && id_priv->id.qp)
+	if (!status && id_priv->id.qp) {
 		status = ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
 					 be16_to_cpu(multicast->rec.mlid));
+		if (!status)
+			pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to attach QP. status %d\n",
+					     status);
+	}
 	mutex_unlock(&id_priv->qp_mutex);

 	memset(&event, 0, sizeof event);
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
