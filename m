From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2 - common: seg fault in dapl_evd_wait with
 multi-thread application using CNO's
Date: Wed, 18 Nov 2009 16:22:31 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983619D3FDA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


if dealing with event streams besides a CQ event stream,
be conservative and set producer side locking.  Otherwise, no.
Check for CNO is missing, CNO is not considered CQ event stream.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_evd_util.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 02909e9..cc0aa17 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -159,9 +159,11 @@ dapls_evd_internal_create(DAPL_IA * ia_ptr,
 	/*
 	 * If we are dealing with event streams besides a CQ event stream,
 	 * be conservative and set producer side locking.  Otherwise, no.
+	 * Note: CNO is not considered CQ event stream.
 	 */
 	evd_ptr->evd_producer_locking_needed =
-	    !(evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG));
+	    (!(evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG)) ||
+	     evd_ptr->cno_ptr);
 
 	/* Before we setup any callbacks, transition state to OPEN.  */
 	evd_ptr->evd_state = DAPL_EVD_STATE_OPEN;
@@ -646,8 +648,9 @@ dapli_evd_post_event(IN DAPL_EVD * evd_ptr, IN const DAT_EVENT * event_ptr)
 	DAT_RETURN dat_status;
 	DAPL_CNO *cno_to_trigger = NULL;
 
-	dapl_dbg_log(DAPL_DBG_TYPE_EVD, "%s: Called with event %s\n",
-		     __FUNCTION__, dapl_event_str(event_ptr->event_number));
+	dapl_dbg_log(DAPL_DBG_TYPE_EVD, "%s: %s evd %p state %d\n",
+		     __FUNCTION__, dapl_event_str(event_ptr->event_number), 
+		     evd_ptr, evd_ptr->evd_state);
 
 	dat_status = dapls_rbuf_add(&evd_ptr->pending_event_queue,
 				    (void *)event_ptr);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
