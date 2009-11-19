From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2 - ucm: inbound DREQ/DREP handshake should
 transition QP.
Date: Wed, 18 Nov 2009 16:22:28 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983619D3FD9@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
during RC QP release, when receiving a disconnect request from remote peer
instead of a disconnect call from the client, the QP didn't get properly
set in ERR state and didn't flush the queue during disconnect processing.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 2b7471e..b51556a 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -711,7 +711,8 @@ static void ucm_ud_free(DAPL_EP *ep)
 void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 {
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " cm_destroy: cm %p ep %p\n", cm, ep);
+		     " cm_destroy: %s cm %p ep %p\n",
+		     cm ? dapl_cm_state_str(cm->state) : "", cm, ep);
 
 	if (!cm && ep) {
 		ucm_ud_free(ep);
@@ -813,6 +814,10 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 	dapl_os_lock(&cm->lock);
 	switch (cm->state) {
 	case DCM_CONNECTED:
+		/* CONSUMER: move to err state to flush, if not UD */
+		if (cm->ep->qp_handle->qp_type != IBV_QPT_UD) 
+			dapls_modify_qp_state(cm->ep->qp_handle, IBV_QPS_ERR,0,0,0);
+
 		/* send DREQ, event after DREP or DREQ timeout */
 		cm->state = DCM_DISC_PENDING;
 		cm->msg.op = htons(DCM_DREQ);
@@ -836,6 +841,10 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		}
 		break;
 	case DCM_DISC_RECV:
+		/* CM_THREAD: move to err state to flush, if not UD */
+		if (cm->ep->qp_handle->qp_type != IBV_QPT_UD) 
+			dapls_modify_qp_state(cm->ep->qp_handle, IBV_QPS_ERR,0,0,0);
+
 		/* DREQ received, send DREP and schedule event */
 		cm->msg.op = htons(DCM_DREP);
 		break;
@@ -1547,10 +1556,6 @@ dapls_ib_disconnect(IN DAPL_EP *ep, IN DAT_CLOSE_FLAGS close_flags)
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
 		     "dapls_ib_disconnect(ep_handle %p ....)\n", ep);
 
-	/* move to err state to flush, if not UD */
-	if (ep->qp_handle->qp_type != IBV_QPT_UD) 
-		dapls_modify_qp_state(ep->qp_handle, IBV_QPS_ERR,0,0,0);
-	
 	if (ep->cm_handle == NULL ||
 	    ep->param.ep_state == DAT_EP_STATE_DISCONNECTED)
 		return DAT_SUCCESS;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
