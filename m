From: Michael Heinz <mheinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ofed_kernel/net/rds/ib_send.c
Date: Fri, 11 Feb 2011 16:42:55 -0500
Message-ID: <20110211214255.27586.4904.stgit@kop-sds-dev-02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This corrects a CQ overflow and timing issue which can be observed in RDS

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 net/rds/ib_send.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 71f373c..61a317e 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -286,10 +286,8 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 
 	rdsdebug("cq %p conn %p\n", cq, conn);
 	rds_ib_stats_inc(s_ib_tx_cq_call);
-	ret = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	if (ret)
-		rdsdebug("ib_req_notify_cq send failed: %d\n", ret);
 
+again:
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		rdsdebug("wc wr_id 0x%llx status %u (%s) byte_len %u imm_data %u\n",
 			 (unsigned long long)wc.wr_id, wc.status,
@@ -347,6 +345,12 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 					  rds_ib_wc_status_str(wc.status));
 		}
 	}
+	ret = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
+				   IB_CQ_REPORT_MISSED_EVENTS);
+	if (ret > 0)
+		goto again;
+	if (ret < 0)
+		rdsdebug("ib_req_notify_cq send failed: %d\n", ret);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
