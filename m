From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] IB/srp: fix race condition on srp_target_port.req_lim
Date: Sun, 25 Jul 2010 18:12:42 +0200
Message-ID: <201007251812.42757.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the current implementation of ib_srp the req_lim field of
struct srp_target_port can be manipulated in a non-atomic way by
more than one CPU at a time: one CPU can be modifying req_lim in
function srp_process_rsp() while another CPU can concurrently be
decrementing req_lim in function __srp_get_tx_iu(). This is a
race condition which can result in incorrect manipulation of the
req_lim field. The patch below fixes this race condition by
converting all manipulations of req_lim into atomic operations.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed3f9eb..3d334b5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -822,7 +822,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 
 	spin_lock_irqsave(target->scsi_host->host_lock, flags);
 
-	target->req_lim += delta;
+	atomic_add(delta, &target->req_lim);
 
 	req = &target->req_ring[rsp->tag & ~SRP_TAG_TSK_MGMT];
 
@@ -1008,7 +1008,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;
 
-	if (target->req_lim < min) {
+	if (atomic_read(&target->req_lim) < min) {
 		++target->zero_req_lim;
 		return NULL;
 	}
@@ -1042,7 +1042,7 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	if (!ret) {
 		++target->tx_head;
-		--target->req_lim;
+		atomic_dec(&target->req_lim);
 	}
 
 	return ret;
@@ -1266,10 +1266,12 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 			struct srp_login_rsp *rsp = event->private_data;
 
 			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
-			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
+			atomic_set(&target->req_lim,
+				   be32_to_cpu(rsp->req_lim_delta));
 
-			target->scsi_host->can_queue = min(target->req_lim,
-							   target->scsi_host->can_queue);
+			target->scsi_host->can_queue
+				= min(atomic_read(&target->req_lim),
+				      target->scsi_host->can_queue);
 		} else {
 			shost_printk(KERN_WARNING, target->scsi_host,
 				    PFX "Unhandled RSP opcode %#x\n", opcode);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5a80eac..048f213 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -135,7 +135,7 @@ struct srp_target_port {
 	struct ib_qp	       *qp;
 
 	int			max_ti_iu_len;
-	s32			req_lim;
+	atomic_t		req_lim;
 
 	int			zero_req_lim;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
