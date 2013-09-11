From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Use trap number defines rather than actual trap numbers
Date: Wed, 11 Sep 2013 09:29:39 -0400
Message-ID: <52307043.40009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Trap number defines were added in ib_types.h as part of:

commit ae9d7e7f4e2f62eabad4cf9d60cd5b68a8295147
Author: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu May 30 18:16:43 2013 +0000

    Add trap details to notice log message
    
    Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 716a124..c6c180a 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -405,7 +405,8 @@ static int is_access_permitted(osm_infr_t *p_infr_rec,
 	   pkey with MC group.
 	   In all other cases the issuer gid is the trap source.
 	*/
-	if (trap_num >= 64 && trap_num <= 67 )
+	if (trap_num >= SM_GID_IN_SERVICE_TRAP &&
+	    trap_num <= SM_MGID_DESTROYED_TRAP)
 		/* The issuer of these traps is the SM so source_gid
 		   is the gid saved on the data details */
 		source_gid = p_ntc->data_details.ntc_64_67.gid;
@@ -423,8 +424,8 @@ static int is_access_permitted(osm_infr_t *p_infr_rec,
 
 	/* Check if there is a pkey match. o13-17.1.1 */
 	switch (trap_num) {
-		case 66:
-		case 67:
+		case SM_MGID_CREATED_TRAP:
+		case SM_MGID_DESTROYED_TRAP:
 			p_mgrp = osm_get_mgrp_by_mgid(p_subn, &source_gid);
 			if (!p_mgrp) {
 				char gid_str[INET6_ADDRSTRLEN];
@@ -623,10 +624,10 @@ static void log_notice(osm_log_t * log, osm_log_level_t level,
 
 	/* an official Event information log */
 	if (ib_notice_is_generic(ntc)) {
-		if ((ntc->g_or_v.generic.trap_num == CL_HTON16(64)) ||
-		    (ntc->g_or_v.generic.trap_num == CL_HTON16(65)) ||
-		    (ntc->g_or_v.generic.trap_num == CL_HTON16(66)) ||
-		    (ntc->g_or_v.generic.trap_num == CL_HTON16(67)))
+		if ((ntc->g_or_v.generic.trap_num == CL_HTON16(SM_GID_IN_SERVICE_TRAP)) ||
+		    (ntc->g_or_v.generic.trap_num == CL_HTON16(SM_GID_OUT_OF_SERVICE_TRAP)) ||
+		    (ntc->g_or_v.generic.trap_num == CL_HTON16(SM_MGID_CREATED_TRAP)) ||
+		    (ntc->g_or_v.generic.trap_num == CL_HTON16(SM_MGID_DESTROYED_TRAP)))
 			gid = &ntc->data_details.ntc_64_67.gid;
 		else
 			gid = &ntc->issuer_gid;
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 469b00f..ae08012 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -266,9 +266,9 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 	if (ib_notice_is_generic(p_ntci)) {
 		char str[32];
 
-		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(129)) ||
-		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(130)) ||
-		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(131)))
+		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_LINK_INTEGRITY_THRESHOLD_TRAP)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_BUFFER_OVERRUN_THRESHOLD_TRAP)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_WATCHDOG_TIMER_EXPIRED_TRAP)))
 			snprintf(str, sizeof(str), " Port %u",
 				 p_ntci->data_details.ntc_129_131.port_num);
 		else
@@ -284,8 +284,8 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
 			ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
 			cl_hton16(source_lid), str, cl_ntoh64(trans_id));
-		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(257)) ||
-		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(258))) {
+		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_BAD_PKEY_TRAP)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_BAD_QKEY_TRAP))) {
 			OSM_LOG(p_log, OSM_LOG_ERROR,
 				"Bad %s_Key:0x%x on SL:%d from "
 				"LID1:%u QP1:0x%x to "
@@ -459,9 +459,9 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 
 	if (is_gsi == FALSE) {
 		if (ib_notice_is_generic(p_ntci) &&
-		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(129) ||
-		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(130) ||
-		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(131))) {
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_LINK_INTEGRITY_THRESHOLD_TRAP) ||
+		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_BUFFER_OVERRUN_THRESHOLD_TRAP) ||
+		     p_ntci->g_or_v.generic.trap_num == CL_HTON16(SM_WATCHDOG_TIMER_EXPIRED_TRAP))) {
 			/* If this is a trap 129, 130, or 131 - then this is a
 			 * trap signaling a change on a physical port.
 			 * Mark the physp_change_trap flag as TRUE.
@@ -525,7 +525,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	/* Check for node description update. IB Spec v1.2.1 pg 823 */
 	if (!ib_notice_is_generic(p_ntci))
 		goto check_sweep;
-	if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 &&
+	if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_LOCAL_CHANGES_TRAP &&
 	    p_ntci->data_details.ntc_144.local_changes & TRAP_144_MASK_OTHER_LOCAL_CHANGES &&
 	    p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) {
 		OSM_LOG(sm->p_log, OSM_LOG_INFO, "Trap 144 Node description update\n");
@@ -542,7 +542,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 				"ERR 3812: No physical port found for "
 				"trap 144: \"node description update\"\n");
 		goto check_sweep;
-	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
+	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_SYS_IMG_GUID_CHANGED_TRAP) {
 		if (p_physp)
 			/* this assumes that trap 145 content is not broken? */
 			p_physp->p_node->node_info.sys_guid =
@@ -564,8 +564,8 @@ check_sweep:
 		   TODO: In the future this can be changed to just getting
 		   PortInfo on this port instead of sweeping the entire subnet. */
 		if (ib_notice_is_generic(p_ntci) &&
-		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
-		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
+		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_LINK_STATE_CHANGED_TRAP ||
+		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_LOCAL_CHANGES_TRAP ||
 		     run_heavy_sweep)) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Forcing heavy sweep. Received trap:%u\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
