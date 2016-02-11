From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 20/21] IB/srpt: Introduce srpt_process_wait_list()
Date: Thu, 11 Feb 2016 11:09:50 -0800
Message-ID: <56BCDC7E.6070202@sandisk.com>
References: <56BCDAAD.7030906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BCDAAD.7030906-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 42 ++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c11e617..9d365ea 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1730,6 +1730,28 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	}
 }
 
+/*
+ * This function must be called from the context in which RDMA completions are
+ * processed because it accesses the wait list without protection against
+ * access from other threads.
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
@@ -1769,17 +1791,7 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -2309,15 +2321,9 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
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
+		srpt_process_wait_list(ch);
 		if (ret)
 			srpt_close_ch(ch);
 	}
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
