From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/12] dapl-2.0: common: EP links to EVD, PZ incorrectly
 released before provider CM objects freed.
Date: Wed, 19 May 2010 11:11:51 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013091@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


unlink/clear references after ALL CM objects linked to EP are freed.
Otherwise, event processing via CM objects could reference the handles
still linked to EP. After CM objects are freed (blocking) these handles
linked to EP are guaranteed not to refereence from underlying provider.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_free.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/dapl/common/dapl_ep_free.c b/dapl/common/dapl_ep_free.c
index 8708e6f..3bfc541 100644
--- a/dapl/common/dapl_ep_free.c
+++ b/dapl/common/dapl_ep_free.c
@@ -110,6 +110,20 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 	 */
 	(void)dapl_ep_disconnect(ep_ptr, DAT_CLOSE_ABRUPT_FLAG);
 
+	/* Free all CM objects */
+	cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
+		  ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
+	while (cm_ptr != NULL) {
+                dapl_log(DAPL_DBG_TYPE_EP,
+			 "dapl_ep_free: Free CM: EP=%p CM=%p\n",
+			 ep_ptr, cm_ptr);
+
+		next_cm_ptr = dapl_llist_next_entry(&ep_ptr->cm_list_head,
+						    &cm_ptr->list_entry);
+		dapls_cm_free(cm_ptr); /* blocking call */
+		cm_ptr = next_cm_ptr;
+	}
+
 	/*
 	 * Do verification of parameters and the state change atomically.
 	 */
@@ -188,20 +202,6 @@ DAT_RETURN DAT_API dapl_ep_free(IN DAT_EP_HANDLE ep_handle)
 		}
 	}
 
-	/* Free all CM objects */
-	cm_ptr = (dapl_llist_is_empty(&ep_ptr->cm_list_head)
-		  ? NULL : dapl_llist_peek_head(&ep_ptr->cm_list_head));
-	while (cm_ptr != NULL) {
-                dapl_log(DAPL_DBG_TYPE_EP,
-			 "dapl_ep_free: Free CM: EP=%p CM=%p\n",
-			 ep_ptr, cm_ptr);
-
-		next_cm_ptr = dapl_llist_next_entry(&ep_ptr->cm_list_head,
-						    &cm_ptr->list_entry);
-		dapls_cm_free(cm_ptr); /* blocking call */
-		cm_ptr = next_cm_ptr;
-	}
-
 	/* Free the resource */
 	dapl_ep_dealloc(ep_ptr);
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
