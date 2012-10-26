From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 03/19] ib_srp: Introduce srp_handle_qp_err()
Date: Fri, 26 Oct 2012 14:46:56 +0200
Message-ID: <508A8640.8040506@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce the function srp_handle_qp_err(), change the type of
qp_in_error from int into bool and move the initialization of that
variable from srp_reconnect_target() to srp_connect_target().

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   37 +++++++++++++++++++----------------
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +-
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed89370..87f0bfd 100644
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
@@ -689,7 +691,6 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret)
 		goto err;
@@ -1268,6 +1269,15 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
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
@@ -1275,15 +1285,12 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status) {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed receive status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
+		if (likely(wc.status == IB_WC_SUCCESS)) {
+			srp_handle_recv(target, &wc);
+		} else {
+			srp_handle_qp_err(wc.status, wc.opcode, target);
 			break;
 		}
-
-		srp_handle_recv(target, &wc);
 	}
 }
 
@@ -1294,16 +1301,13 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	struct srp_iu *iu;
 
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status) {
-			shost_printk(KERN_ERR, target->scsi_host,
-				     PFX "failed send status %d\n",
-				     wc.status);
-			target->qp_in_error = 1;
+		if (likely(wc.status == IB_WC_SUCCESS)) {
+			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
+			list_add(&iu->list, &target->free_tx);
+		} else {
+			srp_handle_qp_err(wc.status, wc.opcode, target);
 			break;
 		}
-
-		iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
-		list_add(&iu->list, &target->free_tx);
 	}
 }
 
@@ -2279,7 +2283,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 8b436ce..02dc3ac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -179,7 +179,7 @@ struct srp_target_port {
 	struct list_head	list;
 	struct completion	done;
 	int			status;
-	int			qp_in_error;
+	bool			qp_in_error;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
