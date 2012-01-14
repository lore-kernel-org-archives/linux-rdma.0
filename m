From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 04/18] ib_srp: Micro-optimize completion handlers
Date: Sat, 14 Jan 2012 12:42:41 +0000
Message-ID: <8420403.E35AZndOFd@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reduce completion queue lock contention by polling for multiple
work completions at once. Help the CPU branch predictor by making
it clear that IB_WC_SUCCESS is the most likely case. Move the
error handling code into the new function srp_handle_qp_err().

Also, convert srp_target_port.qp_in_error from int to bool and
move the initialization of that variable into srp_connect_target().

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   57 +++++++++++++++++++++--------------
 drivers/infiniband/ulp/srp/ib_srp.h |    4 ++-
 2 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b1327c6..afbddd8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -515,6 +515,8 @@ static int srp_connect_target(struct srp_target_port *target)
 	int retries = 3;
 	int ret;
 
+	target->qp_in_error = false;
+
 	ret = srp_lookup_path(target);
 	if (ret)
 		return ret;
@@ -648,7 +650,6 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret)
 		goto err;
@@ -1215,42 +1216,53 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+static void srp_handle_qp_err(enum ib_wc_status wc_status,
+			      enum ib_wc_opcode wc_opcode,
+			      struct srp_target_port *target)
+{
+	shost_printk(KERN_ERR, target->scsi_host, PFX "failed %s status %d\n",
+		     wc_opcode & IB_WC_RECV ? "receive" : "send", wc_status);
+	target->qp_in_error = true;
+}
+
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
-	struct ib_wc wc;
+	struct ib_wc *const wc = target->recv_wc;
+	int i, n;
 
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status) {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed receive status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
-			break;
+	while ((n = ib_poll_cq(cq, ARRAY_SIZE(target->recv_wc), wc)) > 0) {
+		for (i = 0; i < n; ++i) {
+			if (likely(wc[i].status == IB_WC_SUCCESS)) {
+				srp_handle_recv(target, &wc[i]);
+			} else {
+				srp_handle_qp_err(wc[i].status, wc[i].opcode,
+						  target);
+				return;
+			}
 		}
-
-		srp_handle_recv(target, &wc);
 	}
 }
 
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
-	struct ib_wc wc;
+	struct ib_wc *const wc = target->send_wc;
+	int i, n;
 	struct srp_iu *iu;
 
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status) {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed send status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
-			break;
+	while ((n = ib_poll_cq(cq, ARRAY_SIZE(target->send_wc), wc)) > 0) {
+		for (i = 0; i < n; ++i) {
+			if (likely(wc[i].status == IB_WC_SUCCESS)) {
+				iu = (struct srp_iu *) (uintptr_t) wc[i].wr_id;
+				list_add(&iu->list, &target->free_tx);
+			} else {
+				srp_handle_qp_err(wc[i].status, wc[i].opcode,
+						  target);
+				return;
+			}
 		}
-
-		iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
-		list_add(&iu->list, &target->free_tx);
 	}
 }
 
@@ -2238,7 +2250,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e3a6304..91f92aa 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -135,6 +135,8 @@ struct srp_target_port {
 	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
+	struct ib_wc		recv_wc[16];
+	struct ib_wc		send_wc[16];
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
@@ -180,7 +182,7 @@ struct srp_target_port {
 	struct list_head	list;
 	struct completion	done;
 	int			status;
-	int			qp_in_error;
+	bool			qp_in_error;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
