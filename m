From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 11/12] IB/srpt: Inline srpt_get_cmd_state()
Date: Mon,  8 Jan 2018 11:00:50 -0800
Message-ID: <20180108190051.32008-12-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It is not necessary to obtain ioctx->spinlock when reading the ioctx
state. Since after removal of this locking only a single line remains,
inline the srpt_get_cmd_state() function.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e4c1446699a9..d2835b0c15e8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -752,23 +752,6 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
 	kfree(ioctx_ring);
 }
 
-/**
- * srpt_get_cmd_state - get the state of a SCSI command
- * @ioctx: Send I/O context.
- */
-static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
-{
-	enum srpt_command_state state;
-	unsigned long flags;
-
-	BUG_ON(!ioctx);
-
-	spin_lock_irqsave(&ioctx->spinlock, flags);
-	state = ioctx->state;
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
-	return state;
-}
-
 /**
  * srpt_set_cmd_state - set the state of a SCSI command
  * @ioctx: Send I/O context.
@@ -1303,7 +1286,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 		target_execute_cmd(&ioctx->cmd);
 	else
 		pr_err("%s[%d]: wrong state = %d\n", __func__,
-		       __LINE__, srpt_get_cmd_state(ioctx));
+		       __LINE__, ioctx->state);
 }
 
 /**
@@ -2372,7 +2355,7 @@ static int srpt_write_pending_status(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx;
 
 	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
-	return srpt_get_cmd_state(ioctx) == SRPT_STATE_NEED_DATA;
+	return ioctx->state == SRPT_STATE_NEED_DATA;
 }
 
 /*
@@ -2951,7 +2934,7 @@ static int srpt_get_tcm_cmd_state(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx;
 
 	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
-	return srpt_get_cmd_state(ioctx);
+	return ioctx->state;
 }
 
 static int srpt_parse_guid(u64 *guid, const char *name)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
