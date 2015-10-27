From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/7] IB/srp: Fix a potential queue overflow in an error path
Date: Tue, 27 Oct 2015 15:02:44 -0700
Message-ID: <562FF484.6030400@sandisk.com>
References: <562FF404.7000504@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562FF404.7000504-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wait until memory registration has finished in the srp_queuecommand()
error path before invalidating memory regions to avoid a send queue
overflow.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 41 ++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1aa9a4c..6d17fe2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1044,7 +1044,7 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 	}
 }
 
-static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
+static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey, u32 send_flags)
 {
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr = {
@@ -1052,16 +1052,32 @@ static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 		.wr_id		    = LOCAL_INV_WR_ID,
 		.next		    = NULL,
 		.num_sge	    = 0,
-		.send_flags	    = 0,
+		.send_flags	    = send_flags,
 		.ex.invalidate_rkey = rkey,
 	};
 
 	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
+static bool srp_wait_until_done(struct srp_rdma_ch *ch, int i, long timeout)
+{
+	WARN_ON_ONCE(timeout <= 0);
+
+	for ( ; i > 0; i--) {
+		spin_lock_irq(&ch->lock);
+		srp_send_completion(ch->send_cq, ch);
+		spin_unlock_irq(&ch->lock);
+
+		if (wait_for_completion_timeout(&ch->done, timeout) > 0)
+			return true;
+	}
+	return false;
+}
+
 static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			   struct srp_rdma_ch *ch,
-			   struct srp_request *req)
+			   struct srp_request *req,
+			   bool wait_for_first_unmap)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
@@ -1077,13 +1093,19 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		struct srp_fr_desc **pfr;
 
 		for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++) {
-			res = srp_inv_rkey(ch, (*pfr)->mr->rkey);
+			res = srp_inv_rkey(ch, (*pfr)->mr->rkey,
+					   wait_for_first_unmap ?
+					   IB_SEND_SIGNALED : 0);
 			if (res < 0) {
 				shost_printk(KERN_ERR, target->scsi_host, PFX
 				  "Queueing INV WR for rkey %#x failed (%d)\n",
 				  (*pfr)->mr->rkey, res);
 				queue_work(system_long_wq,
 					   &target->tl_err_work);
+			} else if (wait_for_first_unmap) {
+				wait_for_first_unmap = false;
+				WARN_ON_ONCE(!srp_wait_until_done(ch, 10,
+							msecs_to_jiffies(100)));
 			}
 		}
 		if (req->nmdesc)
@@ -1144,7 +1166,7 @@ static void srp_free_req(struct srp_rdma_ch *ch, struct srp_request *req,
 {
 	unsigned long flags;
 
-	srp_unmap_data(scmnd, ch, req);
+	srp_unmap_data(scmnd, ch, req, false);
 
 	spin_lock_irqsave(&ch->lock, flags);
 	ch->req_lim += req_lim_delta;
@@ -1982,7 +2004,12 @@ static void srp_send_completion(struct ib_cq *cq, void *ch_ptr)
 	struct srp_iu *iu;
 
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (likely(wc.status == IB_WC_SUCCESS)) {
+		if (unlikely(wc.wr_id == LOCAL_INV_WR_ID)) {
+			complete(&ch->done);
+			if (wc.status != IB_WC_SUCCESS)
+				srp_handle_qp_err(wc.wr_id, wc.status, true,
+						  ch);
+		} else if (likely(wc.status == IB_WC_SUCCESS)) {
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &ch->free_tx);
 		} else {
@@ -2084,7 +2111,7 @@ unlock_rport:
 	return ret;
 
 err_unmap:
-	srp_unmap_data(scmnd, ch, req);
+	srp_unmap_data(scmnd, ch, req, true);
 
 err_iu:
 	srp_put_tx_iu(ch, iu, SRP_IU_CMD);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
