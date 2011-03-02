From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH] IB/rdma_cm: cancel pending lap message when destroying an
 ID
Date: Wed, 2 Mar 2011 17:45:10 +0200
Message-ID: <4D6E6606.5010900@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When destroying a cm_id from a context of a work queue and if the lap_state of
this cm_id is IB_CM_LAP_SENT, we need to release the reference of this id that
was taken upon the send of the lap message.  Otherwise, if the expected apr
message gets lost, it is only after a long time that the reference will be
released, while during that the work handler thread is not available to process
other things.
Also, a sigle variable 'msg' was used to hold the last snet mad. However, this
variable serves 2 state machines (CM and LAP) which can cause to memory leaks or
to unexpected behavior. This patch adds another variable to hold the lap mad.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
 drivers/infiniband/core/cm.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 64e0903..3c00646 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -210,6 +210,7 @@ struct cm_id_private {
 	atomic_t refcount;
 
 	struct ib_mad_send_buf *msg;
+	struct ib_mad_send_buf *lap_msg;
 	struct cm_timewait_info *timewait_info;
 	/* todo: use alternate port on send failure */
 	struct cm_av av;
@@ -839,6 +840,24 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 retest:
 	spin_lock_irq(&cm_id_priv->lock);
+
+	/* handle lap states first */
+	switch (cm_id->lap_state) {
+	case IB_CM_LAP_UNINIT:
+	case IB_CM_LAP_IDLE:
+		break;
+	case IB_CM_LAP_SENT:
+		cm_id_priv->id.lap_state = IB_CM_LAP_IDLE;
+		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->lap_msg);
+		cm_id_priv->lap_msg = NULL;
+		break;
+	case IB_CM_LAP_RCVD:
+	case IB_CM_MRA_LAP_SENT:
+	case IB_CM_MRA_LAP_RCVD:
+	default:
+		break;
+	}
+
 	switch (cm_id->state) {
 	case IB_CM_LISTEN:
 		cm_id->state = IB_CM_IDLE;
@@ -2615,7 +2634,7 @@ int ib_send_cm_lap(struct ib_cm_id *cm_id,
 	}
 
 	cm_id->lap_state = IB_CM_LAP_SENT;
-	cm_id_priv->msg = msg;
+	cm_id_priv->lap_msg = msg;
 
 out:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return ret;
@@ -2811,8 +2830,8 @@ static int cm_apr_handler(struct cm_work *work)
 		goto out;
 	}
 	cm_id_priv->id.lap_state = IB_CM_LAP_IDLE;
-	ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
-	cm_id_priv->msg = NULL;
+	ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->lap_msg);
+	cm_id_priv->lap_msg = NULL;
 
 	ret = atomic_inc_and_test(&cm_id_priv->work_count);
 	if (!ret)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
