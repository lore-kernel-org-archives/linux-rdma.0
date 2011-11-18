From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] ib_srpt: Make compilation with BUG=n proceed
Date: Fri, 18 Nov 2011 18:32:04 +0100
Message-ID: <201111181832.04952.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With CONFIG_BUG=n the __WARN() macro is not defined. Avoid that
building with CONFIG_BUG=n fails by changing pr_err(...);
_WARN() into WARN(true, ...).

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 49ae767..6376e2a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1462,9 +1462,7 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 	} else if (opcode == SRPT_RDMA_ABORT) {
 		ioctx->rdma_aborted = true;
 	} else {
-		__WARN();
-		printk(KERN_ERR "%s[%d]: scmnd == NULL (opcode %d)", __func__,
-				__LINE__, opcode);
+		WARN(true, "unexpected opcode %d\n", opcode);
 	}
 }
 
@@ -2735,7 +2733,7 @@ static void srpt_cm_dreq_recv(struct ib_cm_id *cm_id)
 		break;
 	case CH_DISCONNECTING:
 	case CH_DRAINING:
-		__WARN();
+		WARN(true, "unexpected channel state %d\n", ch->state);
 		break;
 	}
 	spin_unlock_irqrestore(&ch->spinlock, flags);
@@ -2963,8 +2961,7 @@ static int srpt_write_pending(struct se_cmd *se_cmd)
 	ch_state = ch->state;
 	switch (ch_state) {
 	case CH_CONNECTING:
-		/* This code should never be reached. */
-		__WARN();
+		WARN(true, "unexpected channel state %d\n", ch_state);
 		ret = -EINVAL;
 		goto out;
 	case CH_LIVE:
@@ -3028,9 +3025,8 @@ static int srpt_queue_response(struct se_cmd *cmd)
 		ioctx->state = SRPT_STATE_MGMT_RSP_SENT;
 		break;
 	default:
-		printk(KERN_ERR "ch %p; cmd %d: unexpected command state %d\n",
-		       ch, ioctx->ioctx.index, ioctx->state);
-		__WARN();
+		WARN(true, "ch %p; cmd %d: unexpected command state %d\n",
+		     ch, ioctx->ioctx.index, ioctx->state);
 		break;
 	}
 	spin_unlock_irqrestore(&ioctx->spinlock, flags);
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
