From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/rds: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed CQ
 callbacks
Date: Tue, 30 Mar 2010 15:24:01 -0700
Message-ID: <1269987841.4192.228.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
a callback for the next completion entered since there is a race
between arming the callback and another CQE being added to the queue.
OpenFabrics added a IB_CQ_REPORT_MISSED_EVENTS flag to detect this
race and allow the verbs consumer to call ib_poll_cq() and
ib_req_notify_cq() again to avoid delays in processing the CQE.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

This patch by itself should improve RDS performance over QLogic
HCAs.  I was running "qperf rds_bw" tests and would sometimes
see "unexpected opcode 0xdead" messages from
rds_ib_send_cq_comp_handler(). I have looked very closely at the
code and I didn't see any race conditions which would explain
why delaying the completion callback would cause the message but
with this patch, I don't see the error message.

 net/rds/ib_send.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index a10fab6..609ae66 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -187,10 +187,8 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 
 	rdsdebug("cq %p conn %p\n", cq, conn);
 	rds_ib_stats_inc(s_ib_tx_cq_call);
-	ret = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	if (ret)
-		rdsdebug("ib_req_notify_cq send failed: %d\n", ret);
 
+again:
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		rdsdebug("wc wr_id 0x%llx status %u byte_len %u imm_data %u\n",
 			 (unsigned long long)wc.wr_id, wc.status, wc.byte_len,
@@ -264,6 +262,12 @@ void rds_ib_send_cq_comp_handler(struct ib_cq *cq, void *context)
 				&conn->c_faddr, wc.status);
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
1.6.6.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
