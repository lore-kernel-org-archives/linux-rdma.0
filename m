From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] dapl-2.0 - ucm: incorrectly freeing port on passive
 side after reject
Date: Wed, 16 Jun 2010 10:21:25 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103BF2430@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


cm_release was incorrectly freeing a client port
assuming it was the server listening port. Move
the listening port cleanup to remove_conn_listner
and only cleanup client ports in cm_release.

Error Messages indicating problem:

  CM_REQ retry 1 [lid, port, qpn]: 9 ff9a 340085 -> 9 6fa 34004e Time(ms) 1999 > 1600
  DUPLICATE: op REQ st CM_CONNECTED [lid, port, qpn]: 9 6fa 0x0 <- 0x9 ff9a 0x340085

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 806602f..b874c8b 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -657,10 +657,6 @@ void dapls_cm_release(dp_ib_cm_handle_t cm)
 	if (!cm->sp && cm->msg.sport)
 		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
 
-	/* server, release local conn id port */
-	if (cm->sp && cm->msg.dport)
-		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.dport));
-
 	/* clean up any UD address handles */
 	if (cm->ah) {
 		ibv_destroy_ah(cm->ah);
@@ -1753,6 +1749,7 @@ dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
 
 		sp->cm_srvc_handle = NULL;
 		dapli_dequeue_listen(cm);  
+		ucm_free_port(&cm->hca->ib_trans, ntohs(cm->msg.sport));
 		dapls_cm_release(cm);  /* last ref, dealloc */
 	}
 	return DAT_SUCCESS;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
