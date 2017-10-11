From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 05/45] RDMA/isert: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 10:48:47 -0700
Message-ID: <20171011174927.25113-6-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ceabdb85df8b..720dfb3a1ac2 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -788,10 +788,11 @@ isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		 * the rdma cm id
 		 */
 		return 1;
-	case RDMA_CM_EVENT_REJECTED:       /* FALLTHRU */
+	case RDMA_CM_EVENT_REJECTED:
 		isert_info("Connection rejected: %s\n",
 			   rdma_reject_msg(cma_id, event->status));
-	case RDMA_CM_EVENT_UNREACHABLE:    /* FALLTHRU */
+		/* fall through */
+	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 		ret = isert_connect_error(cma_id);
 		break;
@@ -1569,9 +1570,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
 			transport_generic_free_cmd(&cmd->se_cmd, 0);
 			break;
 		}
-		/*
-		 * Fall-through
-		 */
+		/* fall through */
 	default:
 		iscsit_release_cmd(cmd);
 		break;
@@ -1749,8 +1748,9 @@ isert_do_control_comp(struct work_struct *work)
 	switch (cmd->i_state) {
 	case ISTATE_SEND_TASKMGTRSP:
 		iscsit_tmr_post_handler(cmd, cmd->conn);
-	case ISTATE_SEND_REJECT:   /* FALLTHRU */
-	case ISTATE_SEND_TEXTRSP:  /* FALLTHRU */
+		/* fall through */
+	case ISTATE_SEND_REJECT:
+	case ISTATE_SEND_TEXTRSP:
 		cmd->i_state = ISTATE_SENT_STATUS;
 		isert_completion_put(&isert_cmd->tx_desc, isert_cmd,
 				     ib_dev, false);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
