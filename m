From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp receive buffer handling robustness improvement
Date: Fri, 30 Jul 2010 12:59:05 +0200
Message-ID: <201007301259.05796.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current strategy in ib_srp for posting receive buffers is as follows:
* Post one buffer after channel establishment.
* Post one buffer before sending an SRP_CMD or SRP_TSK_MGMT to the target.
As a result, only the first non-SRP_RSP information unit from the target will
be processed. If that first information unit is an SRP_T_LOGOUT, it will be
processed. On the other hand, if the initiator receives an SRP_CRED_REQ or
SRP_AER_REQ before it receives a SRP_T_LOGOUT, the SRP_T_LOGOUT won't be
processed. This patch fixes this inconsistency by changing the strategy for
posting receive buffers as follows:
* Post all receive buffers after channel establishment.
* After a receive buffer has been consumed and processed, post it again.
A side effect is that the ib_post_recv() call is moved out of the SCSI command
processing path.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed3f9eb..b9a38c2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -82,6 +82,7 @@ static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
+static int srp_post_recv(struct srp_target_port *target);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
 
 static struct scsi_transport_template *ib_srp_transport_template;
@@ -868,6 +869,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev;
 	struct srp_iu *iu;
+	int res;
 	u8 opcode;
 
 	iu = target->rx_ring[wc->wr_id];
@@ -915,6 +917,11 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_ti_iu_len,
 				      DMA_FROM_DEVICE);
+
+	res = srp_post_recv(target);
+	if (res != 0)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "Recv failed with error code %d\n", res);
 }
 
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
@@ -1102,11 +1109,6 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		goto err;
 	}
 
-	if (__srp_post_recv(target)) {
-		shost_printk(KERN_ERR, target->scsi_host, PFX "Recv failed\n");
-		goto err_unmap;
-	}
-
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
@@ -1249,6 +1251,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	int i;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1298,7 +1301,11 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (target->status)
 			break;
 
-		target->status = srp_post_recv(target);
+		for (i = 0; i < SRP_RQ_SIZE; i++) {
+			target->status = srp_post_recv(target);
+			if (target->status)
+				break;
+		}
 		if (target->status)
 			break;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
