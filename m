From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib/cm: Cancel pending LAP message when exiting
 IB_CM_ESTABLISH state
Date: Thu, 3 Mar 2011 15:31:06 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC8C57C9@orsmsx501.amr.corp.intel.com>
References: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This problem was reported by Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> and
Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:

	When destroying a cm_id from a context of a work queue
	and if the lap_state of this cm_id is IB_CM_LAP_SENT,
	we need to release the reference of this id that
	was taken upon the send of the LAP message.
	Otherwise, if the expected APR message gets lost,
	it is only after a long time that the reference will be
	released, while during that the work handler thread is
	not available to process other things.

It turns out that we need to cancel any pending LAP messages
whenever we transition out of the IB_CM_ESTABLISH state.  This
occurs when disconnecting - either sending or receiving a DREQ.
It can also happen in a corner case where we receive a REJ message
after sending an RTU, followed by a LAP.  Add checks and cancel
any outstanding LAP messages in these three cases.

Canceling the LAP when sending a DREQ fixes the destroy problem
reported by Moni.  When a cm_id is destroyed in the IB_CM_ESTABLISHED
state, it sends a DREQ to the remote side to notify the peer that
the connection is going away.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Moni, I don't have a good way to test that this really fixes your problem,
but it looks like it should.
I considered merging the cm state and lap states together, but I wasn't
convinced that that made things any simpler.

 drivers/infiniband/core/cm.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1d9616b..f804e28 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1988,6 +1988,10 @@ int ib_send_cm_dreq(struct ib_cm_id *cm_id,
 		goto out;
 	}
 
+	if (cm_id->lap_state == IB_CM_LAP_SENT ||
+	    cm_id->lap_state == IB_CM_MRA_LAP_RCVD)
+		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
+
 	ret = cm_alloc_msg(cm_id_priv, &msg);
 	if (ret) {
 		cm_enter_timewait(cm_id_priv);
@@ -2129,6 +2133,10 @@ static int cm_dreq_handler(struct cm_work *work)
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
 		break;
 	case IB_CM_ESTABLISHED:
+		if (cm_id_priv->id.lap_state == IB_CM_LAP_SENT ||
+		    cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
+			ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
+		break;
 	case IB_CM_MRA_REP_RCVD:
 		break;
 	case IB_CM_TIMEWAIT:
@@ -2349,9 +2357,18 @@ static int cm_rej_handler(struct cm_work *work)
 		/* fall through */
 	case IB_CM_REP_RCVD:
 	case IB_CM_MRA_REP_SENT:
-	case IB_CM_ESTABLISHED:
 		cm_enter_timewait(cm_id_priv);
 		break;
+	case IB_CM_ESTABLISHED:
+		if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT ||
+		    cm_id_priv->id.lap_state == IB_CM_LAP_SENT) {
+			if (cm_id_priv->id.lap_state == IB_CM_LAP_SENT)
+				ib_cancel_mad(cm_id_priv->av.port->mad_agent,
+					      cm_id_priv->msg);
+			cm_enter_timewait(cm_id_priv);
+			break;
+		}
+		/* fall through */
 	default:
 		spin_unlock_irq(&cm_id_priv->lock);
 		ret = -EINVAL;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
