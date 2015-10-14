From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/6] IB/mad: Use a SRQ for receiving GMPs
Date: Wed, 14 Oct 2015 11:29:46 +0300
Message-ID: <1444811388-22486-5-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As a preparation for supporting multiple transmission QPs for each GSI QP,
add a SRQ that will be used for all the receive buffers of these QPs.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 58 ++++++++++++++++++++++++++++++++++----
 drivers/infiniband/core/mad_priv.h |  1 +
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7a1186173179..2d4457239908 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2921,7 +2921,12 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 		post = (++recv_queue->count < recv_queue->max_active);
 		list_add_tail(&mad_priv->header.mad_list.list, &recv_queue->list);
 		spin_unlock_irqrestore(&recv_queue->lock, flags);
-		ret = ib_post_recv(qp_info->qp, &recv_wr, &bad_recv_wr);
+		if (qp_info->srq)
+			ret = ib_post_srq_recv(qp_info->srq, &recv_wr,
+					       &bad_recv_wr);
+		else
+			ret = ib_post_recv(qp_info->qp, &recv_wr, &bad_recv_wr);
+
 		if (ret) {
 			spin_lock_irqsave(&recv_queue->lock, flags);
 			list_del(&mad_priv->header.mad_list.list);
@@ -3074,6 +3079,16 @@ static void qp_event_handler(struct ib_event *event, void *qp_context)
 		event->event, qp_info->qp->qp_num);
 }
 
+static void srq_event_handler(struct ib_event *event, void *srq_context)
+{
+	struct ib_mad_qp_info	*qp_info = srq_context;
+
+	/* We aren't expecting limit reached events, so this must be an error */
+	dev_err(&qp_info->port_priv->device->dev,
+		"Fatal error (%d) on MAD SRQ (QP%d)\n",
+		event->event, qp_info->qp->qp_num);
+}
+
 static void init_mad_queue(struct ib_mad_qp_info *qp_info,
 			   struct ib_mad_queue *mad_queue)
 {
@@ -3099,19 +3114,45 @@ static void init_mad_qp(struct ib_mad_port_private *port_priv,
 static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 			 enum ib_qp_type qp_type)
 {
+	struct ib_device *device = qp_info->port_priv->device;
+	struct ib_srq_init_attr srq_init_attr;
 	struct ib_qp_init_attr	qp_init_attr;
+	struct ib_srq *srq = NULL;
+	const bool multiple_qps = qp_type == IB_QPT_GSI &&
+				  device->gsi_pkey_index_in_qp;
+
 	int ret;
 
 	qp_info->qp_type = qp_type;
 
+	if (multiple_qps) {
+		memset(&srq_init_attr, 0, sizeof(srq_init_attr));
+		srq_init_attr.event_handler = srq_event_handler;
+		srq_init_attr.srq_context = qp_info;
+		srq_init_attr.attr.max_wr = mad_recvq_size;
+		srq_init_attr.attr.max_sge = IB_MAD_RECV_REQ_MAX_SG;
+		srq = ib_create_srq(qp_info->port_priv->pd, &srq_init_attr);
+		if (IS_ERR(srq)) {
+			dev_err(&qp_info->port_priv->device->dev,
+				"Couldn't create ib_mad SRQ for QP%d\n",
+				get_spl_qp_index(qp_type));
+			ret = PTR_ERR(srq);
+			goto error_srq;
+		}
+	}
+	qp_info->srq = srq;
+
 	memset(&qp_init_attr, 0, sizeof qp_init_attr);
 	qp_init_attr.send_cq = qp_info->port_priv->cq;
 	qp_init_attr.recv_cq = qp_info->port_priv->cq;
+	qp_init_attr.srq = srq;
 	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
 	qp_init_attr.cap.max_send_wr = mad_sendq_size;
-	qp_init_attr.cap.max_recv_wr = mad_recvq_size;
 	qp_init_attr.cap.max_send_sge = IB_MAD_SEND_REQ_MAX_SG;
-	qp_init_attr.cap.max_recv_sge = IB_MAD_RECV_REQ_MAX_SG;
+	if (!srq) {
+		qp_init_attr.cap.max_recv_wr = mad_recvq_size;
+		qp_init_attr.cap.max_recv_sge = IB_MAD_RECV_REQ_MAX_SG;
+	}
 	qp_init_attr.qp_type = qp_type;
 	qp_init_attr.port_num = qp_info->port_priv->port_num;
 	qp_init_attr.qp_context = qp_info;
@@ -3122,7 +3163,7 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 			"Couldn't create ib_mad QP%d\n",
 			get_spl_qp_index(qp_type));
 		ret = PTR_ERR(qp_info->qp);
-		goto error;
+		goto error_qp;
 	}
 	/* Use minimum queue sizes unless the CQ is resized */
 	qp_info->send_queue.max_active = mad_sendq_size;
@@ -3130,7 +3171,12 @@ static int create_mad_qp(struct ib_mad_qp_info *qp_info,
 	qp_info->qp_num = qp_info->qp->qp_num;
 	return 0;
 
-error:
+error_qp:
+	if (srq) {
+		WARN_ON(ib_destroy_srq(srq));
+		qp_info->srq = NULL;
+	}
+error_srq:
 	return ret;
 }
 
@@ -3140,6 +3186,8 @@ static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
 		return;
 
 	ib_destroy_qp(qp_info->qp);
+	if (qp_info->srq)
+		WARN_ON(ib_destroy_srq(qp_info->srq));
 	kfree(qp_info->snoop_table);
 }
 
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index ae099f0f9701..0c3b7c576f3a 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -184,6 +184,7 @@ struct ib_mad_queue {
 struct ib_mad_qp_info {
 	struct ib_mad_port_private *port_priv;
 	struct ib_qp *qp;
+	struct ib_srq *srq;
 	struct ib_mad_queue send_queue;
 	struct ib_mad_queue recv_queue;
 	struct list_head overflow_list;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
