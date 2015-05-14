From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] ib/cm: Change reject message type when destroying cm_id
Date: Thu, 14 May 2015 12:49:01 -0700
Message-ID: <1431632941-3430-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Problem reported by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:

We have a case where a Linux system and a non-Linux system are
trying to interoperate.  The Linux host is the active side and
starts the connection establishment, but later decides to not go
through with the connection setup and does rdma_destroy_id().

The rdma_destroy_id() eventually works its way down to cm_destroy_id()
in core/cm.c, where a REJ is sent. The non-Linux system
has some trouble recognizing the REJ because of:

A. CM states which can't receive the REJ
B. Some issues about REJ formatting (missing comm ID)

ISSUE A: That part of the spec says, a Consumer Reject REJ can be
sent for a connection abort, but it goes further
and says: can send a REJ message with a "Consumer Reject"
Reason code if they are in a CM state (i.e. REP
Rcvd, MRA(REP) Sent, REQ Rcvd, MRA Sent) that allows
a REJ to be sent (lines 35-38).

Of the states listed there in that sentence, it would
seem to limit the active side to using the Consumer Reject
(for the abort case) in just the REP-Rcvd and MRA-REP-Sent
states. That is basically only after the active side
sees a REP (or alternatively goes down the state transitions
to timeout in which case a Timeout REJ is sent).

As a fix, in cm-destroy-id() move the IB-CM-MRA-REQ-RCVD case
to the same as REQ-SENT.  Essentially, make a REJ sent after
getting an MRA on active side a timeout rather than Consumer-
Reject, which is arguably more correct with the CM state
diagrams previous to getting a REP.

Signed-off-by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e28a494..346243e 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -862,6 +862,7 @@ retest:
 		cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
 		break;
 	case IB_CM_REQ_SENT:
+	case IB_CM_MRA_REQ_RCVD:
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
 		spin_unlock_irq(&cm_id_priv->lock);
 		ib_send_cm_rej(cm_id, IB_CM_REJ_TIMEOUT,
@@ -880,7 +881,6 @@ retest:
 				       NULL, 0, NULL, 0);
 		}
 		break;
-	case IB_CM_MRA_REQ_RCVD:
 	case IB_CM_REP_SENT:
 	case IB_CM_MRA_REP_RCVD:
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
