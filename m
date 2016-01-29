From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 22/22] IB/srpt: Fix wait list processing
Date: Fri, 29 Jan 2016 15:19:01 -0800
Message-ID: <56ABF365.1020708@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5185eca..08a30c6 100644
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
@@ -833,12 +833,14 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -2318,9 +2320,13 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 	if (srpt_set_ch_state(ch, CH_LIVE)) {
 		ret = srpt_ch_qp_rts(ch, ch->qp);
 
-		srpt_process_wait_list(ch);
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
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
