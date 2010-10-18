From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Mon, 18 Oct 2010 09:27:35 -0400
Message-ID: <1287408455.10438.51.camel@lap75545.ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
 <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
 <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
 <1287407410.10438.46.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1287407410.10438.46.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-10-18 at 09:10 -0400, David Dillow wrote:
> On Mon, 2010-10-18 at 06:11 -0400, Bart Van Assche wrote:
> > As far as I can see the above sync call applies to a buffer in the
> > tx_ring[]. Data in that buffer is only modified by the CPU and never
> > by the HCA. So why is the above sync call present ? Is that call
> > necessary ?
> 
> While looking at this, I noticed that we didn't do any syncs in
> srp_send_tsk_mgmt(), so I've pushed this patch for now. We can remove
> the *_sync_for_cpu() calls later if it turns out we really don't need
> them.

If it turns out that we don't need the sync, I'd be receptive to using
something like this to consolidate the handling into __srp_post_send().
If you're feeling adventurous or just want to see if it benchmarks
faster, try it out and let us know how it goes.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cfc1d65..92ced00 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -854,10 +854,13 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 static int __srp_post_send(struct srp_target_port *target,
 			   struct srp_iu *iu, int len)
 {
+	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
 	int ret = 0;
 
+	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
+
 	list.addr   = iu->dma;
 	list.length = len;
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
@@ -985,9 +988,7 @@ static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 		goto out;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
 	memcpy(iu->buf, rsp, len);
-	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
 
 	err = __srp_post_send(target, iu, len);
 	if (err)
@@ -1130,7 +1131,6 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	struct srp_request *req;
 	struct srp_iu *iu;
 	struct srp_cmd *cmd;
-	struct ib_device *dev;
 	int len;
 
 	if (target->state == SRP_TARGET_CONNECTING)
@@ -1147,10 +1147,6 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	if (!iu)
 		goto err;
 
-	dev = target->srp_host->srp_dev->dev;
-	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
-				   DMA_TO_DEVICE);
-
 	req = list_first_entry(&target->free_reqs, struct srp_request, list);
 
 	scmnd->scsi_done     = done;
@@ -1177,9 +1173,6 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		goto err;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
-				      DMA_TO_DEVICE);
-
 	if (__srp_post_send(target, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
@@ -1442,7 +1435,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     struct srp_request *req, u8 func)
 {
-	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
@@ -1460,8 +1452,6 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	if (!iu)
 		goto out;
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
-				   DMA_TO_DEVICE);
 	tsk_mgmt = iu->buf;
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
@@ -1471,8 +1461,6 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
-	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
-				      DMA_TO_DEVICE);
 	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
 		goto out;
 
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
