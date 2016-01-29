From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 14/22] IB/srpt: Inline trivial CM callback functions
Date: Fri, 29 Jan 2016 15:16:11 -0800
Message-ID: <56ABF2BB.5060905@sandisk.com>
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

Inline those CM callback functions that are only two lines long.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 652e1ef..5e4fee7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2315,18 +2315,6 @@ static void srpt_cm_rtu_recv(struct ib_cm_id *cm_id)
 	}
 }
 
-static void srpt_cm_timewait_exit(struct ib_cm_id *cm_id)
-{
-	pr_info("Received IB TimeWait exit for cm_id %p.\n", cm_id);
-	srpt_drain_channel(cm_id);
-}
-
-static void srpt_cm_rep_error(struct ib_cm_id *cm_id)
-{
-	pr_info("Received IB REP error for cm_id %p.\n", cm_id);
-	srpt_drain_channel(cm_id);
-}
-
 /**
  * srpt_cm_dreq_recv() - Process reception of a DREQ message.
  */
@@ -2365,15 +2353,6 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 }
 
 /**
- * srpt_cm_drep_recv() - Process reception of a DREP message.
- */
-static void srpt_cm_drep_recv(struct ib_cm_id *cm_id)
-{
-	pr_info("Received InfiniBand DREP message for cm_id %p.\n", cm_id);
-	srpt_drain_channel(cm_id);
-}
-
-/**
  * srpt_cm_handler() - IB connection manager callback function.
  *
  * A non-zero return value will cause the caller destroy the CM ID.
@@ -2404,13 +2383,17 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		srpt_cm_dreq_recv(cm_id);
 		break;
 	case IB_CM_DREP_RECEIVED:
-		srpt_cm_drep_recv(cm_id);
+		pr_info("Received InfiniBand DREP message for cm_id %p.\n",
+			cm_id);
+		srpt_drain_channel(cm_id);
 		break;
 	case IB_CM_TIMEWAIT_EXIT:
-		srpt_cm_timewait_exit(cm_id);
+		pr_info("Received IB TimeWait exit for cm_id %p.\n", cm_id);
+		srpt_drain_channel(cm_id);
 		break;
 	case IB_CM_REP_ERROR:
-		srpt_cm_rep_error(cm_id);
+		pr_info("Received IB REP error for cm_id %p.\n", cm_id);
+		srpt_drain_channel(cm_id);
 		break;
 	case IB_CM_DREQ_ERROR:
 		pr_info("Received IB DREQ ERROR event.\n");
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
