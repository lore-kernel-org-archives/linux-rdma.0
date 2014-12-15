From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/4] ucm: RTU not retransmitted in TIMEWAIT state
Date: Mon, 15 Dec 2014 11:58:52 -0800
Message-ID: <1418673535-1464-2-git-send-email-arlin.r.davis@intel.com>
References: <1418673535-1464-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418673535-1464-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index e462632..141086d 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -231,7 +231,7 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		*timer = cm->hca->ib_trans.cm_timer;
 		if ((time - cm->timer)/1000 >
 		     (cm->hca->ib_trans.rtu_time << cm->retries)) {
-			dapl_log(DAPL_DBG_TYPE_CM_WARN,
+			dapl_log(DAPL_DBG_TYPE_CM,
 				 " CM_TIMEWAIT %d %p [lid, port, cqp, iqp]:"
 				 " %x %x %x %x -> %x %x %x %x r_pid %x"
 				 " Time(ms) %d > %d\n",
@@ -247,8 +247,17 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 		}
 		if (cm->retries > 2) {
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
-				" CM_TIMEWAIT expired (%d ms) for CM %p\n",
-				 cm, (time - cm->timer)/1000);
+				 " CM_TIMEWAIT EXPIRED %d %p [lid, port, cqp, iqp]:"
+				 " %x %x %x %x -> %x %x %x %x r_pid %x"
+				 " Time(ms) %d > %d\n",
+				 cm->retries+1, cm,
+				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
+				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
+				 ntohs(cm->msg.daddr.ib.lid), ntohs(cm->msg.dport),
+				 ntohl(cm->msg.dqpn), ntohl(cm->msg.daddr.ib.qpn),
+				 ntohl(cm->msg.d_id),
+				 (time - cm->timer)/1000,
+				 cm->hca->ib_trans.rtu_time << cm->retries);
 			cm->ah = NULL;  /* consumer will free AH */
 			cm->state = DCM_FREE;
 			dapl_os_unlock(&cm->lock);
@@ -382,8 +391,10 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 		ucm_connect_rtu(cm, msg);
 		break;
 	case DCM_CONNECTED: /* active and passive */
+	case DCM_TIMEWAIT:  /* passive */
 		/* DREQ, change state and process */
-		cm->retries = 2; 
+		if (cm->state == DCM_CONNECTED)
+			cm->retries = 2;
 		if (ntohs(msg->op) == DCM_DREQ) {
 			cm->state = DCM_DISC_RECV;
 			dapl_os_unlock(&cm->lock);
@@ -395,7 +406,7 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 			dapl_log(DAPL_DBG_TYPE_CM_WARN,
 				 " RESEND RTU: op %s st %s [lid, port, cqp, iqp]:"
 				 " %x %x %x %x -> %x %x %x %x r_pid %x\n",
-				  dapl_cm_op_str(ntohs(cm->msg.op)),
+				  dapl_cm_op_str(ntohs(msg->op)),
 				  dapl_cm_state_str(cm->state),
 				 ntohs(cm->msg.saddr.ib.lid), ntohs(cm->msg.sport),
 				 ntohl(cm->msg.sqpn), ntohl(cm->msg.saddr.ib.qpn),
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
