From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/7] ib_srpt: Introduce srpt_ch_qp_err()
Date: Sun, 9 Jan 2011 17:27:00 +0100
Message-ID: <201101091727.00530.bvanassche@acm.org>
References: <201101091723.41399.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101091723.41399.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the code for setting the state of a queue pair into the error state
to a separate function.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index a308ce1..08f1de0 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -1045,6 +1045,17 @@ out:
 }
 
 /**
+ * srpt_ch_qp_err() - Set the channel queue pair state to 'error'.
+ */
+static int srpt_ch_qp_err(struct srpt_rdma_ch *ch)
+{
+	struct ib_qp_attr qp_attr;
+
+	qp_attr.qp_state = IB_QPS_ERR;
+	return ib_modify_qp(ch->qp, &qp_attr, IB_QP_STATE);
+}
+
+/**
  * srpt_get_send_ioctx() - Obtain an I/O context for sending to the initiator.
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
@@ -1973,7 +1984,6 @@ static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 	__releases(&ch->sport->sdev->spinlock)
 {
 	struct srpt_device *sdev;
-	struct ib_qp_attr qp_attr;
 	int ret;
 
 	sdev = ch->sport->sdev;
@@ -1981,8 +1991,7 @@ static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 	atomic_set(&ch->state, CH_DISCONNECTING);
 	spin_unlock_irq(&sdev->spinlock);
 
-	qp_attr.qp_state = IB_QPS_ERR;
-	ret = ib_modify_qp(ch->qp, &qp_attr, IB_QP_STATE);
+	ret = srpt_ch_qp_err(ch);
 	if (ret < 0)
 		PRINT_ERROR("Setting queue pair in error state failed: %d",
 			    ret);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
