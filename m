From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_mad_ctrl.c: Make some minor simplifications
Date: Tue, 1 Dec 2009 11:15:48 -0500
Message-ID: <20091201161548.GA14828@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Rather than check msg_id for CL_DISP_MSGID_NONE, move into default case
of switch statement in sm_mad_ctrl_process_get/set/trap
Eliminate dead code in sm_mad_ctrl_process_get_resp

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index 74beb1c..0ccc327 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -260,9 +260,6 @@ static void sm_mad_ctrl_process_get_resp(IN osm_sm_mad_ctrl_t * p_ctrl,
 		goto Exit;
 	}
 
-	if (msg_id == CL_DISP_MSGID_NONE)
-		goto Exit;
-
 	/*
 	   Post this MAD to the dispatcher for asynchronous
 	   processing by the appropriate controller.
@@ -319,14 +316,6 @@ static void sm_mad_ctrl_process_get(IN osm_sm_mad_ctrl_t * p_ctrl,
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_VERBOSE,
 			"Ignoring SubnGet MAD - unsupported attribute 0x%X\n",
 			cl_ntoh16(p_smp->attr_id));
-		break;
-	}
-
-	if (msg_id == CL_DISP_MSGID_NONE) {
-		/*
-		   There is an unknown MAD attribute type for which there is
-		   no recipient.  Simply retire the MAD here.
-		 */
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
 	}
@@ -397,14 +386,6 @@ static void sm_mad_ctrl_process_set(IN osm_sm_mad_ctrl_t * p_ctrl,
 			"Unsupported attribute 0x%X\n",
 			cl_ntoh16(p_smp->attr_id));
 		osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
-		break;
-	}
-
-	if (msg_id == CL_DISP_MSGID_NONE) {
-		/*
-		   There is an unknown MAD attribute type for which there is
-		   no recipient.  Simply retire the MAD here.
-		 */
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
 	}
@@ -484,14 +465,6 @@ static void sm_mad_ctrl_process_trap(IN osm_sm_mad_ctrl_t * p_ctrl,
 			"Unsupported attribute 0x%X\n",
 			cl_ntoh16(p_smp->attr_id));
 		osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
-		break;
-	}
-
-	if (msg_id == CL_DISP_MSGID_NONE) {
-		/*
-		   There is an unknown MAD attribute type for which there is
-		   no recipient.  Simply retire the MAD here.
-		 */
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
