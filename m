From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/4] common: dapl_ep_free must serialize CM object destroy
Date: Mon, 15 Dec 2014 11:58:54 -0800
Message-ID: <1418673535-1464-4-git-send-email-arlin.r.davis@intel.com>
References: <1418673535-1464-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418673535-1464-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

CM object could be destroyed from time_wait state from
provider in separate thread. Destruction must be serialized
with EP lock.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_free.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index 62d7eff..652b61d 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -66,7 +66,7 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 	DAPL_EP *ep_ptr;
 	DAPL_IA *ia_ptr;
 	DAT_EP_PARAM *param;
-	dp_ib_cm_handle_t cm_ptr, next_cm_ptr;
+	dp_ib_cm_handle_t cm_ptr;
 	ib_qp_state_t save_qp_state;
 	DAT_RETURN dat_status = DAT_SUCCESS;
 
@@ -110,25 +110,26 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 	 */
 	(void)dapl_ep_disconnect(ep_ptr, DAT_CLOSE_ABRUPT_FLAG);
 
+	/*
+	 * Do verification of parameters and the state change atomically.
+	 */
+	dapl_os_lock(&ep_ptr->header.lock);
+
 	/* Free all CM objects */
 	cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
 		  ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
+
 	while (cm_ptr != NULL) {
                 dapl_log(DAPL_DBG_TYPE_EP,
 			 "dapl_ep_free: Free CM: EP=%p CM=%p\n",
 			 ep_ptr, cm_ptr);
-
-		next_cm_ptr = dapl_llist_next_entry(&ep_ptr->cm_list_head,
-						    &cm_ptr->list_entry);
+		dapl_os_unlock(&ep_ptr->header.lock);
 		dapls_cm_free(cm_ptr); /* blocking call */
-		cm_ptr = next_cm_ptr;
+		dapl_os_lock(&ep_ptr->header.lock);
+		cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+			  ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
 	}
 
-	/*
-	 * Do verification of parameters and the state change atomically.
-	 */
-	dapl_os_lock(&ep_ptr->header.lock);
-
 #ifdef DAPL_DBG
 	/* check if event pending and warn, don't assert, state is valid */
 	if (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECT_PENDING) {
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
