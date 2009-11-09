From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/6]  SRP handles send/recv errors and connection
 closed event
Date: Mon, 09 Nov 2009 13:35:33 -0800
Message-ID: <4AF88B25.8010106@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010602060505000903040306"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010602060505000903040306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Setting up timer for SRP_CONN_ERR_TIMEOUT seconds to propagate I/O errors
and clean up connection resources. When we receive cqe with error status
or connection closed callback, the target already left the fabric for
awhile (30 seconds < n < ...); therefore, we just set a default value
for SRP_CONN_ERR_TIMEOUT at 1 second.

The best solution is registering for trap when target joining/leaving the
the fabric and setting up timer at target->device_loss_timeout seconds to
propagate I/O errors and clean up connection resources; however,
this solution requires a lot of changes in srp_daemon to register for
traps and pass these trap events down to srp driver, and srp driver
need to create sys entry points to receive them.

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------010602060505000903040306
Content-Type: text/plain;
 name="srp_6_handling_send_recv_conn_errors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_6_handling_send_recv_conn_errors.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |   18 +++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f62ef8f..04f4ece 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -950,11 +950,19 @@ static void srp_completion(struct ib_cq *cq, void *target_ptr)
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (wc.status) {
+			unsigned long flags;
+
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "failed %s status %d\n",
 				     wc.wr_id & SRP_OP_RECV ? "receive" : "send",
 				     wc.status);
-			target->qp_in_error = 1;
+			spin_lock_irqsave(target->scsi_host->host_lock, flags);
+			if (!target->qp_in_error &&
+			    target->state == SRP_TARGET_LIVE) {
+				target->qp_in_error = 1;
+				srp_qp_err_add_timer(target, SRP_CONN_ERR_TIMEOUT);
+			}
+			spin_unlock_irqrestore(target->scsi_host->host_lock, flags);		
 			break;
 		}
 
@@ -1258,6 +1266,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	unsigned long flags;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1344,6 +1353,13 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_TIMEWAIT_EXIT:
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
+		spin_lock_irqsave(target->scsi_host->host_lock, flags);
+		if (!target->qp_in_error &&
+		    target->state == SRP_TARGET_LIVE) {
+			target->qp_in_error = 1;
+			srp_qp_err_add_timer(target, SRP_CONN_ERR_TIMEOUT);
+		}
+		spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 		target->status = 0;
 		break;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 74d1f09..131f7a8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -49,6 +49,7 @@
 enum {
 	SRP_PATH_REC_TIMEOUT_MS	= 1000,
 	SRP_ABORT_TIMEOUT_MS	= 5000,
+	SRP_CONN_ERR_TIMEOUT	= 1,
 
 	SRP_PORT_REDIRECT	= 1,
 	SRP_DLID_REDIRECT	= 2,

--------------010602060505000903040306--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
