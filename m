From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: Eliminate unneeded trap_rcv_process_response
 routine
Date: Wed, 24 Oct 2012 09:42:11 -0400
Message-ID: <5087F033.6060604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Trap represses (responses) never get to osm_trap_rcv_process.
They are handled in osm_sm_mad_ctrl.c:sm_mad_ctrl_rcv_callback
which invokes sm_mad_ctrl_process_trap_repress.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index c0a287f..6d2a3a6 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -632,18 +632,6 @@ Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static void trap_rcv_process_response(IN osm_sm_t * sm,
-				      IN const osm_madw_t * p_madw)
-{
-
-	OSM_LOG_ENTER(sm->p_log);
-
-	OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3808: "
-		"This function is not supported yet\n");
-
-	OSM_LOG_EXIT(sm->p_log);
-}
-
 void osm_trap_rcv_process(IN void *context, IN void *data)
 {
 	osm_sm_t *sm = context;
@@ -656,15 +644,9 @@ void osm_trap_rcv_process(IN void *context, IN void *data)
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
 
-	/*
-	   Determine if this is a request for our own Trap
-	   or if this is a response to our request for another
-	   SM's Trap.
-	 */
-	if (ib_smp_is_response(p_smp))
-		trap_rcv_process_response(sm, p_madw);
-	else
-		trap_rcv_process_request(sm, p_madw);
+	/* Only Trap requests get here */
+	CL_ASSERT(!ib_smp_is_response(p_smp));
+	trap_rcv_process_request(sm, p_madw);
 
 	OSM_LOG_EXIT(sm->p_log);
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
