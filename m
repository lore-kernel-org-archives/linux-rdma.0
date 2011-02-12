From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3]  DAPL v2.0:  ucm: cm object needs to be on work queue
 before req sent on wire
Date: Sat, 12 Feb 2011 11:33:46 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98301272F405B@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With the delay in cm object queuing there is potential for replies
being dropped coming back with a NO MATCH. Start with INIT
state and queue it up, move to state REP_PENDING when
sending out on the wire to start request timer.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 69f7610..b2db32c 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -951,7 +951,7 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 		 htons(cm->msg.dport));
 
 	dapl_os_lock(&cm->lock);
-	if (cm->state != DCM_REP_PENDING) {
+	if (cm->state != DCM_INIT && cm->state != DCM_REP_PENDING) {
 		dapl_os_unlock(&cm->lock);
 		return DAT_INVALID_STATE;
 	}
@@ -985,8 +985,9 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 				 DAT_INVALID_ADDRESS_UNREACHABLE);
 	}
 
+	cm->state = DCM_REP_PENDING;
 	cm->msg.op = htons(DCM_REQ);
-	dapl_os_get_time(&cm->timer); /* reply expected */
+	dapl_os_get_time(&cm->timer); /* reset reply timer */
 	if (ucm_send(&cm->hca->ib_trans, &cm->msg, 
 		     &cm->msg.p_data, ntohs(cm->msg.p_size))) {
 		dapl_os_unlock(&cm->lock);
@@ -994,10 +995,6 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 	}
 	dapl_os_unlock(&cm->lock);
 
-	/* first time through, link EP and CM, put on work queue */
-	if (!cm->retries) {
-		dapli_queue_conn(cm);
-	}
 	return DAT_SUCCESS;
 
 bail:
@@ -1658,7 +1655,10 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 		dapl_os_memcpy(&cm->msg.p_data, p_data, p_size);
 	}
 	
-	cm->state = DCM_REP_PENDING;
+	cm->state = DCM_INIT;
+
+	/* link EP and CM, put on work queue */
+	dapli_queue_conn(cm);
 
 	/* build connect request, send to remote CM based on r_addr info */
 	return (dapli_cm_connect(ep, cm));
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
