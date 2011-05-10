From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] RDMA/iwcm: Get rid of enum iw_cm_event_status
Date: Mon,  9 May 2011 22:26:39 -0700
Message-ID: <1305005199-4943-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

The IW_CM_EVENT_STATUS_xxx values were used in only a couple of places;
cma.c uses -Exxx values instead, and so do the amso1100, cxgb3 and cxgb4
drivers -- only nes was using the enum values (with the mild consequence
that all nes connection failures were treated as generic errors rather
than reported as timeouts or rejections).

We can fix this confusion by getting rid of enum iw_cm_event_status and
using a plain int for struct iw_cm_event.status, and converting nes to
use -Exxx as the other iWARP drivers do.

This also gets rid of the warning

    drivers/infiniband/core/cma.c: In function 'cma_iw_handler':
    drivers/infiniband/core/cma.c:1333:3: warning: case value '4294967185' not in enumerated type 'enum iw_cm_event_status'
    drivers/infiniband/core/cma.c:1336:3: warning: case value '4294967186' not in enumerated type 'enum iw_cm_event_status'
    drivers/infiniband/core/cma.c:1332:3: warning: case value '4294967192' not in enumerated type 'enum iw_cm_event_status'

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
This looks pretty safe and reasonable to me -- would love to hear
any differing opinions though.

 drivers/infiniband/core/iwcm.c        |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c    |   16 ++++++++--------
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 include/rdma/iw_cm.h                  |   11 +----------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 2a1e9ae..a9c0423 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -725,7 +725,7 @@ static int cm_conn_rep_handler(struct iwcm_id_private *cm_id_priv,
 	 */
 	clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
 	BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_SENT);
-	if (iw_event->status == IW_CM_EVENT_STATUS_ACCEPTED) {
+	if (iw_event->status == 0) {
 		cm_id_priv->id.local_addr = iw_event->local_addr;
 		cm_id_priv->id.remote_addr = iw_event->remote_addr;
 		cm_id_priv->state = IW_CM_STATE_ESTABLISHED;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 33c7eed..e74cdf9 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2563,7 +2563,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 	u16 last_ae;
 	u8 original_hw_tcp_state;
 	u8 original_ibqp_state;
-	enum iw_cm_event_status disconn_status = IW_CM_EVENT_STATUS_OK;
+	int disconn_status = 0;
 	int issue_disconn = 0;
 	int issue_close = 0;
 	int issue_flush = 0;
@@ -2605,7 +2605,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 			(last_ae == NES_AEQE_AEID_LLP_CONNECTION_RESET))) {
 		issue_disconn = 1;
 		if (last_ae == NES_AEQE_AEID_LLP_CONNECTION_RESET)
-			disconn_status = IW_CM_EVENT_STATUS_RESET;
+			disconn_status = -ECONNRESET;
 	}
 
 	if (((original_hw_tcp_state == NES_AEQE_TCP_STATE_CLOSED) ||
@@ -2666,7 +2666,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 			cm_id->provider_data = nesqp;
 			/* Send up the close complete event */
 			cm_event.event = IW_CM_EVENT_CLOSE;
-			cm_event.status = IW_CM_EVENT_STATUS_OK;
+			cm_event.status = 0;
 			cm_event.provider_data = cm_id->provider_data;
 			cm_event.local_addr = cm_id->local_addr;
 			cm_event.remote_addr = cm_id->remote_addr;
@@ -2966,7 +2966,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nes_add_ref(&nesqp->ibqp);
 
 	cm_event.event = IW_CM_EVENT_ESTABLISHED;
-	cm_event.status = IW_CM_EVENT_STATUS_ACCEPTED;
+	cm_event.status = 0;
 	cm_event.provider_data = (void *)nesqp;
 	cm_event.local_addr = cm_id->local_addr;
 	cm_event.remote_addr = cm_id->remote_addr;
@@ -3377,7 +3377,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	/* notify OF layer we successfully created the requested connection */
 	cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
-	cm_event.status = IW_CM_EVENT_STATUS_ACCEPTED;
+	cm_event.status = 0;
 	cm_event.provider_data = cm_id->provider_data;
 	cm_event.local_addr.sin_family = AF_INET;
 	cm_event.local_addr.sin_port = cm_id->local_addr.sin_port;
@@ -3484,7 +3484,7 @@ static void cm_event_reset(struct nes_cm_event *event)
 	nesqp->cm_id = NULL;
 	/* cm_id->provider_data = NULL; */
 	cm_event.event = IW_CM_EVENT_DISCONNECT;
-	cm_event.status = IW_CM_EVENT_STATUS_RESET;
+	cm_event.status = -ECONNRESET;
 	cm_event.provider_data = cm_id->provider_data;
 	cm_event.local_addr = cm_id->local_addr;
 	cm_event.remote_addr = cm_id->remote_addr;
@@ -3495,7 +3495,7 @@ static void cm_event_reset(struct nes_cm_event *event)
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	atomic_inc(&cm_closes);
 	cm_event.event = IW_CM_EVENT_CLOSE;
-	cm_event.status = IW_CM_EVENT_STATUS_OK;
+	cm_event.status = 0;
 	cm_event.provider_data = cm_id->provider_data;
 	cm_event.local_addr = cm_id->local_addr;
 	cm_event.remote_addr = cm_id->remote_addr;
@@ -3534,7 +3534,7 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 			cm_node, cm_id, jiffies);
 
 	cm_event.event = IW_CM_EVENT_CONNECT_REQUEST;
-	cm_event.status = IW_CM_EVENT_STATUS_OK;
+	cm_event.status = 0;
 	cm_event.provider_data = (void *)cm_node;
 
 	cm_event.local_addr.sin_family = AF_INET;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 26d8018..95ca93c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1484,7 +1484,7 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 			(nesqp->ibqp_state == IB_QPS_RTR)) && (nesqp->cm_id)) {
 		cm_id = nesqp->cm_id;
 		cm_event.event = IW_CM_EVENT_CONNECT_REPLY;
-		cm_event.status = IW_CM_EVENT_STATUS_TIMEOUT;
+		cm_event.status = -ETIMEDOUT;
 		cm_event.local_addr = cm_id->local_addr;
 		cm_event.remote_addr = cm_id->remote_addr;
 		cm_event.private_data = NULL;
diff --git a/include/rdma/iw_cm.h b/include/rdma/iw_cm.h
index cbb822e..2d0191c 100644
--- a/include/rdma/iw_cm.h
+++ b/include/rdma/iw_cm.h
@@ -46,18 +46,9 @@ enum iw_cm_event_type {
 	IW_CM_EVENT_CLOSE		 /* close complete */
 };
 
-enum iw_cm_event_status {
-	IW_CM_EVENT_STATUS_OK = 0,	 /* request successful */
-	IW_CM_EVENT_STATUS_ACCEPTED = 0, /* connect request accepted */
-	IW_CM_EVENT_STATUS_REJECTED,	 /* connect request rejected */
-	IW_CM_EVENT_STATUS_TIMEOUT,	 /* the operation timed out */
-	IW_CM_EVENT_STATUS_RESET,	 /* reset from remote peer */
-	IW_CM_EVENT_STATUS_EINVAL,	 /* asynchronous failure for bad parm */
-};
-
 struct iw_cm_event {
 	enum iw_cm_event_type event;
-	enum iw_cm_event_status status;
+	int			 status;
 	struct sockaddr_in local_addr;
 	struct sockaddr_in remote_addr;
 	void *private_data;
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
