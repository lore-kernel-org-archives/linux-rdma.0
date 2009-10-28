From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] uDAPL v2: ucm: change some debug message levels, check
 for valid UD REPLY during retries
Date: Wed, 28 Oct 2009 16:19:12 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835F08B518@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 07b8458..b28e911 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -395,12 +395,22 @@ static void ucm_process_recv(ib_hca_transport_t *tp,
 		}
 		dapl_os_unlock(&cm->lock);
 		break;
-	
+	case DCM_RELEASED:
+		/* UD reply retried, ignore */
+		if (ntohs(msg->op) != DCM_REP) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				" ucm_recv: UNKNOWN operation"
+				" <- op %d, %s spsp %d sqpn %d\n", 
+				ntohs(msg->op), dapl_cm_state_str(cm->state),
+				ntohs(msg->sport), ntohl(msg->sqpn));
+		}
+		dapl_os_unlock(&cm->lock);
+		break;
 	default:
 		dapl_log(DAPL_DBG_TYPE_WARN,
 				" ucm_recv: UNKNOWN state"
-				" <- op %d, st %d spsp %d sqpn %d\n", 
-				ntohs(msg->op), cm->state, 
+				" <- op %d, %s spsp %d sqpn %d\n", 
+				ntohs(msg->op), dapl_cm_state_str(cm->state), 
 				ntohs(msg->sport), ntohl(msg->sqpn));
 		dapl_os_unlock(&cm->lock);
 		break;
@@ -479,7 +489,7 @@ retry_listenq:
 	/* not match on listenq for valid request, send reject */
 	if (ntohs(msg->op) == DCM_REQ && !found)
 		ucm_reject(tp, msg);
-#if DAPL_DBG
+
 	if (!found) {
 		dapl_log(DAPL_DBG_TYPE_WARN,
 			" ucm_recv: NO MATCH op %s 0x%x %d i0x%x c0x%x"
@@ -490,7 +500,7 @@ retry_listenq:
 			ntohs(msg->saddr.ib.lid), ntohs(msg->sport), 
 			ntohl(msg->saddr.ib.qpn));
 	}
-#endif
+
 	return found;
 }
 
@@ -813,8 +823,18 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
 		cm->msg.op = htons(DCM_DREQ);
-		if (cm->retries >= cm->hca->ib_trans.retries)
+		if (cm->retries >= cm->hca->ib_trans.retries) {
+			dapl_log(DAPL_DBG_TYPE_ERR, 
+				" CM_DREQ: RETRIES EXHAUSTED:"
+				" 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
+				htons(cm->msg.saddr.ib.lid), 
+				htonl(cm->msg.saddr.ib.qpn), 
+				htons(cm->msg.sport), 
+				htons(cm->msg.daddr.ib.lid), 
+				htonl(cm->msg.dqpn), 
+				htons(cm->msg.dport));
 			finalize = 1;
+		}
 		break;
 	case DCM_DISC_RECV:
 		/* DREQ received, send DREP and schedule event */
@@ -857,7 +877,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 	}
 	
 	if (cm->retries == cm->hca->ib_trans.retries) {
-		dapl_log(DAPL_DBG_TYPE_WARN, 
+		dapl_log(DAPL_DBG_TYPE_ERR, 
 			" CM_REQ: RETRIES EXHAUSTED:"
 			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
 			 htons(cm->msg.saddr.ib.lid), 
@@ -1289,8 +1309,8 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 	}
 
 	if (cm->retries == cm->hca->ib_trans.retries) {
-		dapl_log(DAPL_DBG_TYPE_WARN, 
-			 " CM_REP: RETRIES EXHAUSTED"
+		dapl_log(DAPL_DBG_TYPE_ERR, 
+			 " CM_REPLY: RETRIES EXHAUSTED"
 			 " 0x%x %d 0x%x -> 0x%x %d 0x%x\n",
 			 htons(cm->msg.saddr.ib.lid), 
 			 htons(cm->msg.sport), 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
