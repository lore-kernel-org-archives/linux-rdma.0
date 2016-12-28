From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB/srp: allocate ib_qp_attr on the stack
Date: Wed, 28 Dec 2016 13:00:11 +0200
Message-ID: <1482922813-8392-2-git-send-email-maxg@mellanox.com>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482922813-8392-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No reason to allocate it dynamically.

Tested-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   51 +++++++++++++----------------------
 1 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d980fb4..8a003eb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -263,33 +263,28 @@ static void srp_qp_event(struct ib_event *event, void *context)
 static int srp_init_qp(struct srp_target_port *target,
 		       struct ib_qp *qp)
 {
-	struct ib_qp_attr *attr;
+	struct ib_qp_attr attr;
 	int ret;
 
-	attr = kmalloc(sizeof *attr, GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
 	ret = ib_find_cached_pkey(target->srp_host->srp_dev->dev,
 				  target->srp_host->port,
 				  be16_to_cpu(target->pkey),
-				  &attr->pkey_index);
+				  &attr.pkey_index);
 	if (ret)
 		goto out;
 
-	attr->qp_state        = IB_QPS_INIT;
-	attr->qp_access_flags = (IB_ACCESS_REMOTE_READ |
+	attr.qp_state        = IB_QPS_INIT;
+	attr.qp_access_flags = (IB_ACCESS_REMOTE_READ |
 				    IB_ACCESS_REMOTE_WRITE);
-	attr->port_num        = target->srp_host->port;
+	attr.port_num        = target->srp_host->port;
 
-	ret = ib_modify_qp(qp, attr,
+	ret = ib_modify_qp(qp, &attr,
 			   IB_QP_STATE		|
 			   IB_QP_PKEY_INDEX	|
 			   IB_QP_ACCESS_FLAGS	|
 			   IB_QP_PORT);
 
 out:
-	kfree(attr);
 	return ret;
 }
 
@@ -2280,7 +2275,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			       struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
-	struct ib_qp_attr *qp_attr = NULL;
+	struct ib_qp_attr qp_attr;
 	int attr_mask = 0;
 	int ret;
 	int i;
@@ -2312,44 +2307,36 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			goto error;
 	}
 
-	ret = -ENOMEM;
-	qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
-	if (!qp_attr)
-		goto error;
-
-	qp_attr->qp_state = IB_QPS_RTR;
-	ret = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+	qp_attr.qp_state = IB_QPS_RTR;
+	ret = ib_cm_init_qp_attr(cm_id, &qp_attr, &attr_mask);
 	if (ret)
-		goto error_free;
+		goto error;
 
-	ret = ib_modify_qp(ch->qp, qp_attr, attr_mask);
+	ret = ib_modify_qp(ch->qp, &qp_attr, attr_mask);
 	if (ret)
-		goto error_free;
+		goto error;
 
 	for (i = 0; i < target->queue_size; i++) {
 		struct srp_iu *iu = ch->rx_ring[i];
 
 		ret = srp_post_recv(ch, iu);
 		if (ret)
-			goto error_free;
+			goto error;
 	}
 
-	qp_attr->qp_state = IB_QPS_RTS;
-	ret = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+	qp_attr.qp_state = IB_QPS_RTS;
+	ret = ib_cm_init_qp_attr(cm_id, &qp_attr, &attr_mask);
 	if (ret)
-		goto error_free;
+		goto error;
 
-	target->rq_tmo_jiffies = srp_compute_rq_tmo(qp_attr, attr_mask);
+	target->rq_tmo_jiffies = srp_compute_rq_tmo(&qp_attr, attr_mask);
 
-	ret = ib_modify_qp(ch->qp, qp_attr, attr_mask);
+	ret = ib_modify_qp(ch->qp, &qp_attr, attr_mask);
 	if (ret)
-		goto error_free;
+		goto error;
 
 	ret = ib_send_cm_rtu(cm_id, NULL, 0);
 
-error_free:
-	kfree(qp_attr);
-
 error:
 	ch->status = ret;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
