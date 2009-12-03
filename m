From: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Subject: [patch 2/6] RDMA/ehca - ib_post_send fixes, v2
Date: Wed, 02 Dec 2009 20:35:57 -0600
Message-ID: <4B17240D.8060906@zago.net>
References: <20091203023350.646158428@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203023350.646158428-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_send()'s bad_wr when an error occurred.
Do not report success if an error occurred.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

Index: linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-12-02
19:20:53.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-12-02
19:23:19.000000000 -0600
@@ -400,7 +400,6 @@

 static inline int post_one_send(struct ehca_qp *my_qp,
 			 struct ib_send_wr *cur_send_wr,
-			 struct ib_send_wr **bad_send_wr,
 			 int hidden)
 {
 	struct ehca_wqe *wqe_p;
@@ -412,8 +411,6 @@
 	wqe_p = ipz_qeit_get_inc(&my_qp->ipz_squeue);
 	if (unlikely(!wqe_p)) {
 		/* too many posted work requests: queue overflow */
-		if (bad_send_wr)
-			*bad_send_wr = cur_send_wr;
 		ehca_err(my_qp->ib_qp.device, "Too many posted WQEs "
 			 "qp_num=%x", my_qp->ib_qp.qp_num);
 		return -ENOMEM;
@@ -433,8 +430,6 @@
 	 */
 	if (unlikely(ret)) {
 		my_qp->ipz_squeue.current_q_offset = start_offset;
-		if (bad_send_wr)
-			*bad_send_wr = cur_send_wr;
 		ehca_err(my_qp->ib_qp.device, "Could not write WQE "
 			 "qp_num=%x", my_qp->ib_qp.qp_num);
 		return -EINVAL;
@@ -448,7 +443,6 @@
 		   struct ib_send_wr **bad_send_wr)
 {
 	struct ehca_qp *my_qp = container_of(qp, struct ehca_qp, ib_qp);
-	struct ib_send_wr *cur_send_wr;
 	int wqe_cnt = 0;
 	int ret = 0;
 	unsigned long flags;
@@ -457,7 +451,8 @@
 	if (unlikely(my_qp->state < IB_QPS_RTS)) {
 		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
 			 my_qp->state, qp->qp_num);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}

 	/* LOCK the QUEUE */
@@ -476,24 +471,21 @@
 		struct ib_send_wr circ_wr;
 		memset(&circ_wr, 0, sizeof(circ_wr));
 		circ_wr.opcode = IB_WR_RDMA_READ;
-		post_one_send(my_qp, &circ_wr, NULL, 1); /* ignore retcode */
+		post_one_send(my_qp, &circ_wr, 1); /* ignore retcode */
 		wqe_cnt++;
 		ehca_dbg(qp->device, "posted circ wr  qp_num=%x", qp->qp_num);
 		my_qp->message_count = my_qp->packet_count = 0;
 	}

 	/* loop processes list of send reqs */
-	for (cur_send_wr = send_wr; cur_send_wr != NULL;
-	     cur_send_wr = cur_send_wr->next) {
-		ret = post_one_send(my_qp, cur_send_wr, bad_send_wr, 0);
+	while(send_wr) {
+		ret = post_one_send(my_qp, send_wr, 0);
 		if (unlikely(ret)) {
-			/* if one or more WQEs were successful, don't fail */
-			if (wqe_cnt)
-				ret = 0;
 			goto post_send_exit0;
 		}
 		wqe_cnt++;
-	} /* eof for cur_send_wr */
+		send_wr = send_wr->next;
+	}

 post_send_exit0:
 	iosync(); /* serialize GAL register access */
@@ -503,6 +495,10 @@
 			 my_qp, qp->qp_num, wqe_cnt, ret);
 	my_qp->message_count += wqe_cnt;
 	spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
+
+out:
+	if (ret)
+		*bad_send_wr = send_wr;
 	return ret;
 }


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
