From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] IB/cm: Fix sleeping in atomic when RoCE is used
Date: Tue, 29 Aug 2017 10:34:43 -0700
Message-ID: <20170829173444.4289-1-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

A couple of places in the CM do

    spin_lock_irq(&cm_id_priv->lock);
    ...
    if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))

However when the underlying transport is RoCE, this leads to a sleeping function
being called with the lock held - the callchain is

    cm_alloc_response_msg() ->
      ib_create_ah_from_wc() ->
        ib_init_ah_from_wc() ->
          rdma_addr_find_l2_eth_by_grh() ->
            rdma_resolve_ip()

and rdma_resolve_ip() starts out by doing

    req = kzalloc(sizeof *req, GFP_KERNEL);

not to mention rdma_addr_find_l2_eth_by_grh() doing

    wait_for_completion(&ctx.comp);

to wait for the task that rdma_resolve_ip() queues up.

Fix this by moving the AH creation out of the lock.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 63 +++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 2b4d613a3474..f814c5035c74 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -373,11 +373,19 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 	return ret;
 }
 
-static int cm_alloc_response_msg(struct cm_port *port,
-				 struct ib_mad_recv_wc *mad_recv_wc,
-				 struct ib_mad_send_buf **msg)
+static struct ib_mad_send_buf *cm_alloc_response_msg_no_ah(struct cm_port *port,
+							   struct ib_mad_recv_wc *mad_recv_wc)
+{
+	return ib_create_send_mad(port->mad_agent, 1, mad_recv_wc->wc->pkey_index,
+				  0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
+				  GFP_ATOMIC,
+				  IB_MGMT_BASE_VERSION);
+}
+
+static int cm_create_response_msg_ah(struct cm_port *port,
+				     struct ib_mad_recv_wc *mad_recv_wc,
+				     struct ib_mad_send_buf *msg)
 {
-	struct ib_mad_send_buf *m;
 	struct ib_ah *ah;
 
 	ah = ib_create_ah_from_wc(port->mad_agent->qp->pd, mad_recv_wc->wc,
@@ -385,27 +393,40 @@ static int cm_alloc_response_msg(struct cm_port *port,
 	if (IS_ERR(ah))
 		return PTR_ERR(ah);
 
-	m = ib_create_send_mad(port->mad_agent, 1, mad_recv_wc->wc->pkey_index,
-			       0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-			       GFP_ATOMIC,
-			       IB_MGMT_BASE_VERSION);
-	if (IS_ERR(m)) {
-		rdma_destroy_ah(ah);
-		return PTR_ERR(m);
-	}
-	m->ah = ah;
-	*msg = m;
+	msg->ah = ah;
 	return 0;
 }
 
 static void cm_free_msg(struct ib_mad_send_buf *msg)
 {
-	rdma_destroy_ah(msg->ah);
+	if (msg->ah)
+		rdma_destroy_ah(msg->ah);
 	if (msg->context[0])
 		cm_deref_id(msg->context[0]);
 	ib_free_send_mad(msg);
 }
 
+static int cm_alloc_response_msg(struct cm_port *port,
+				 struct ib_mad_recv_wc *mad_recv_wc,
+				 struct ib_mad_send_buf **msg)
+{
+	struct ib_mad_send_buf *m;
+	int ret;
+
+	m = cm_alloc_response_msg_no_ah(port, mad_recv_wc);
+	if (IS_ERR(m))
+		return PTR_ERR(m);
+
+	ret = cm_create_response_msg_ah(port, mad_recv_wc, m);
+	if (ret) {
+		cm_free_msg(m);
+		return ret;
+	}
+
+	*msg = m;
+	return 0;
+}
+
 static void * cm_copy_private_data(const void *private_data,
 				   u8 private_data_len)
 {
@@ -2424,7 +2445,8 @@ static int cm_dreq_handler(struct cm_work *work)
 	case IB_CM_TIMEWAIT:
 		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_DREQ_COUNTER]);
-		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
+		msg = cm_alloc_response_msg_no_ah(work->port, work->mad_recv_wc);
+		if (IS_ERR(msg))
 			goto unlock;
 
 		cm_format_drep((struct cm_drep_msg *) msg->mad, cm_id_priv,
@@ -2432,7 +2454,8 @@ static int cm_dreq_handler(struct cm_work *work)
 			       cm_id_priv->private_data_len);
 		spin_unlock_irq(&cm_id_priv->lock);
 
-		if (ib_post_send_mad(msg, NULL))
+		if (cm_create_response_msg_ah(work->port, work->mad_recv_wc, msg) ||
+		    ib_post_send_mad(msg, NULL))
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_DREQ_RCVD:
@@ -2980,7 +3003,8 @@ static int cm_lap_handler(struct cm_work *work)
 	case IB_CM_MRA_LAP_SENT:
 		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_LAP_COUNTER]);
-		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
+		msg = cm_alloc_response_msg_no_ah(work->port, work->mad_recv_wc);
+		if (IS_ERR(msg))
 			goto unlock;
 
 		cm_format_mra((struct cm_mra_msg *) msg->mad, cm_id_priv,
@@ -2990,7 +3014,8 @@ static int cm_lap_handler(struct cm_work *work)
 			      cm_id_priv->private_data_len);
 		spin_unlock_irq(&cm_id_priv->lock);
 
-		if (ib_post_send_mad(msg, NULL))
+		if (cm_create_response_msg_ah(work->port, work->mad_recv_wc, msg) ||
+		    ib_post_send_mad(msg, NULL))
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_LAP_RCVD:
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
