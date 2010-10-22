From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: scm, ucm: MPI spawn test on oversubcribed server
 taking excessive time to complete
Date: Fri, 22 Oct 2010 13:59:07 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA20A98@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simultaneous DREQ processing from user and CM thread caused some improper
state change on UCM. State change can incorrectly change from FREE back
to DISC in certain corner cases. Add checking on internal disconnect call
to prevent double callback events and improper state change.

For SCM, a remote DREQ will shutdown socket which will cause POLLERR
on the disconnected FD. This will in turn cause the cm_thread to
wakeup continuously unnecessarily. Fix thread thrashing by moving
CM object to FREE state and removing object FD from pollfd array.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   10 +++++++---
 dapl/openib_ucm/cm.c |    9 +++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 56d4c73..f82d0ff 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -463,10 +463,8 @@ DAT_RETURN dapli_socket_disconnect(dp_ib_cm_handle_t cm_ptr)
 		return DAT_SUCCESS;
 	}
 	cm_ptr->state = DCM_DISCONNECTED;
-	dapl_os_unlock(&cm_ptr->lock);
-	
-	/* send disc date, close socket, schedule destroy */
 	send(cm_ptr->socket, (char *)&disc_data, sizeof(disc_data), 0);
+	dapl_os_unlock(&cm_ptr->lock);
 
 	/* disconnect events for RC's only */
 	if (cm_ptr->ep->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
@@ -1812,7 +1810,13 @@ void cr_thread(void *arg)
 						dapl_os_unlock(&cr->lock);
 						dapli_socket_disconnect(cr);
 						break;
+					case DCM_DISCONNECTED:
+						cr->state = DCM_FREE;
+						dapl_os_unlock(&cr->lock);
+						break;
 					default:
+						if (ret == DAPL_FD_ERROR)
+							cr->state = DCM_FREE;
 						dapl_os_unlock(&cr->lock);
 						break;
 					}
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 3a518c3..0fe5e2e 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -544,8 +544,9 @@ retry:
 		msg = (ib_cm_msg_t*) (uintptr_t) wc[i].wr_id;
 
 		dapl_dbg_log(DAPL_DBG_TYPE_CM, 
-			     " ucm_recv: wc status=%d, ln=%d id=%p sqp=%x\n", 
-			     wc[i].status, wc[i].byte_len, 
+			     " ucm_recv: stat=%d op=%s ln=%d id=%p sqp=%x\n",
+			     wc[i].status, dapl_cm_op_str(ntohs(msg->op)),
+			     wc[i].byte_len,
 			     (void*)wc[i].wr_id, wc[i].src_qp);
 
 		/* validate CM message, version */
@@ -609,7 +610,7 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
         sge.addr = (uintptr_t)smsg;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, 
-		" ucm_send: op %s ln %d lid %x c_qpn %x rport %s\n", 
+		" ucm_send: op %s ln %d lid %x c_qpn %x rport %x\n",
 		dapl_cm_op_str(ntohs(smsg->op)), 
 		sge.length, htons(smsg->daddr.ib.lid), 
 		htonl(smsg->dqpn), htons(smsg->dport));
@@ -818,7 +819,7 @@ static void ucm_disconnect_final(dp_ib_cm_handle_t cm)
 		return;
 
 	dapl_os_lock(&cm->lock);
-	if (cm->state == DCM_DISCONNECTED) {
+	if ((cm->state == DCM_DISCONNECTED) || (cm->state == DCM_FREE)) {
 		dapl_os_unlock(&cm->lock);
 		return;
 	}
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
