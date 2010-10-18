From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Mon, 18 Oct 2010 09:10:10 -0400
Message-ID: <1287407410.10438.46.camel@lap75545.ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
 <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
 <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-10-18 at 06:11 -0400, Bart Van Assche wrote:
> As far as I can see the above sync call applies to a buffer in the
> tx_ring[]. Data in that buffer is only modified by the CPU and never
> by the HCA. So why is the above sync call present ? Is that call
> necessary ?

While looking at this, I noticed that we didn't do any syncs in
srp_send_tsk_mgmt(), so I've pushed this patch for now. We can remove
the *_sync_for_cpu() calls later if it turns out we really don't need
them.

commit 155d75eeb12a09d574688c0ad98c6a24fed5bbcd
Author: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Date:   Mon Oct 18 08:54:49 2010 -0400

    IB/srp: sync buffer before posting send
    
    srp_send_tsk_mgmt() was missing the proper DMA sync calls before posting
    the buffer to the device.
    
    Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 9b4bc5a..cfc1d65 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1442,6 +1442,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
 			     struct srp_request *req, u8 func)
 {
+	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
@@ -1459,6 +1460,8 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	if (!iu)
 		goto out;
 
+	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
+				   DMA_TO_DEVICE);
 	tsk_mgmt = iu->buf;
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
@@ -1468,6 +1471,8 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;
 
+	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
+				      DMA_TO_DEVICE);
 	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
 		goto out;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
