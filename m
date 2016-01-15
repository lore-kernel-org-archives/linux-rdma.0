From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a race condition related to SRP login
Date: Fri, 15 Jan 2016 14:14:35 -0800
Message-ID: <56996F4B.1030707@sandisk.com>
References: <5684ED4B.2010303@sandisk.com> <5684EE16.8070701@sandisk.com>
 <20160103105127.GA10025@lst.de> <56890507.9080404@dev.mellanox.co.il>
 <56891BB8.6040502@sandisk.com> <56891DA5.5060506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56891DA5.5060506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/03/2016 05:09 AM, Sagi Grimberg wrote:
>>>> But now the first I/O(s) could be lost if no other I/O comes in,
>>>> right?  I suspect that we need to keep this loop to protect against
>>>> such corner cases.
>>>
>>> It can happen theoretically, but why do we even bother? Why not just
>>> post the recv buffer after we moved in to CH_LIVE? This why we let the
>>> RC transport handle the "Recv-Not-Ready" NAK by retrying?
>>
>> Making wait list processing in the RTU handler safe would require to
>> introduce additional locking. Posting receive buffers after the RTU
>> event has been received would introduce another race condition because
>> then it can happen that an initiator starts sending data before the
>> receive buffers have been posted.
> 
> And what is the problem with that? The peer HCA will get a RNR_NAK
> and retry a pre-configured number of retries (7). The initiator stack
> won't feel it at all...
> 
> I'd say it's a clean way to go.
> 
>> A possible solution would be to  trigger the receive handler after
>> the RTU event has been received in
>> such a way that all invocations of the receive handler are still
>> serialized.
> 
> We can also do that, it's less trivial though.

Hello Sagi,

I have started to test the patch below. I will repost this series
after the merge window has closed and after Doug has had the chance
to process his e-mail backlog.

From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/srpt: Fix wait list processing

Since the wait list is not protected against concurrent access
it must be processed from the context of the completion handler.
Replace the wait list processing code in the IB CM RTU callback
handler by code that triggers a completion handler. This patch
fixes the following rare crash:

WARNING: CPU: 2 PID: 78656 at lib/list_debug.c:53 __list_del_entry+0x67/0xd0()
list_del corruption, ffff88041ae404b8->next is LIST_POISON1 (dead000000000100)
Call Trace:
 [<ffffffff81251c6b>] dump_stack+0x4f/0x74
 [<ffffffff810574ab>] warn_slowpath_common+0x8b/0xd0
 [<ffffffff81057591>] warn_slowpath_fmt+0x41/0x70
 [<ffffffff8126f007>] __list_del_entry+0x67/0xd0
 [<ffffffff8126f081>] list_del+0x11/0x40
 [<ffffffffa0265242>] srpt_cm_handler+0x172/0x1a4 [ib_srpt]
 [<ffffffffa0370370>] cm_process_work+0x20/0xf0 [ib_cm]
 [<ffffffffa0370dae>] cm_establish_handler+0xbe/0x110 [ib_cm]
 [<ffffffffa03733e7>] cm_work_handler+0x67/0xd0 [ib_cm]
 [<ffffffff8107184d>] process_one_work+0x1bd/0x460
 [<ffffffff81073148>] worker_thread+0x118/0x420
 [<ffffffff81078444>] kthread+0xe4/0x100
 [<ffffffff8151caff>] ret_from_fork+0x3f/0x70

---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 64 +++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2cc9813..8991d3f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -96,7 +96,7 @@ static void srpt_free_ch(struct kref *kref);
 static int srpt_queue_status(struct se_cmd *cmd);
 static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
-static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc);
+static void srpt_process_wait_list(struct srpt_rdma_ch *ch);
 
 /*
  * The only allowed channel state changes are those that change the channel
@@ -832,12 +832,14 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_rdma_ch *ch = cq->cq_context;
 
-	WARN(wc->status == IB_WC_SUCCESS, "%s-%d: QP not in error state\n",
-	     ch->sess_name, ch->qp->qp_num);
-	if (srpt_set_ch_state(ch, CH_DISCONNECTED))
-		schedule_work(&ch->release_work);
-	else
-		WARN_ONCE("%s-%d\n", ch->sess_name, ch->qp->qp_num);
+	if (wc->status == IB_WC_SUCCESS) {
+		srpt_process_wait_list(ch);
+	} else {
+		if (srpt_set_ch_state(ch, CH_DISCONNECTED))
+			schedule_work(&ch->release_work);
+		else
+			WARN_ONCE("%s-%d\n", ch->sess_name, ch->qp->qp_num);
+	}
 }
 
 /**
@@ -1734,6 +1736,28 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	}
 }
 
+/*
+ * This function must be called from the context of the IB completion handler
+ * because it accesses the wait list without protection against access from
+ * other threads.
+ */
+static void srpt_process_wait_list(struct srpt_rdma_ch *ch)
+{
+	struct srpt_send_ioctx *ioctx;
+
+	while (!list_empty(&ch->cmd_wait_list) &&
+	       ch->state >= CH_LIVE &&
+	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
+		struct srpt_recv_ioctx *recv_ioctx;
+
+		recv_ioctx = list_first_entry(&ch->cmd_wait_list,
+					      struct srpt_recv_ioctx,
+					      wait_list);
+		list_del(&recv_ioctx->wait_list);
+		srpt_handle_new_iu(ch, recv_ioctx, ioctx);
+	}
+}
+
 /**
  * Note: Although this has not yet been observed during tests, at least in
  * theory it is possible that the srpt_get_send_ioctx() call invoked by
@@ -1773,17 +1797,7 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 		       " wr_id = %u.\n", ioctx->ioctx.index);
 	}
 
-	while (!list_empty(&ch->cmd_wait_list) &&
-	       ch->state == CH_LIVE &&
-	       (ioctx = srpt_get_send_ioctx(ch)) != NULL) {
-		struct srpt_recv_ioctx *recv_ioctx;
-
-		recv_ioctx = list_first_entry(&ch->cmd_wait_list,
-					      struct srpt_recv_ioctx,
-					      wait_list);
-		list_del(&recv_ioctx->wait_list);
-		srpt_handle_new_iu(ch, recv_ioctx, ioctx);
-	}
+	srpt_process_wait_list(ch);
 }
 
 /**
@@ -2328,17 +2342,15 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 	int ret;
 
 	if (srpt_set_ch_state(ch, CH_LIVE)) {
-		struct srpt_recv_ioctx *ioctx, *ioctx_tmp;
-
 		ret = srpt_ch_qp_rts(ch, ch->qp);
 
-		list_for_each_entry_safe(ioctx, ioctx_tmp, &ch->cmd_wait_list,
-					 wait_list) {
-			list_del(&ioctx->wait_list);
-			srpt_handle_new_iu(ch, ioctx, NULL);
-		}
-		if (ret)
+		if (ret == 0) {
+			/* Trigger wait list processing. */
+			ret = srpt_zerolength_write(ch);
+			WARN_ONCE(ret < 0, "%d\n", ret);
+		} else {
 			srpt_close_ch(ch);
+		}
 	}
 }
 
-- 
2.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
