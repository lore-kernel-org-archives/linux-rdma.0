From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: Eliminate heavy sweep on receipt of
	trap 145
Date: Tue, 3 Nov 2009 10:29:32 -0500
Message-ID: <20091103152932.GA7267@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Trap 145 is sys image GUID changed and can be handled without a 
new heavy sweep. New sys image GUID is present in trap and that
is the only info that needs updating.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 91c3761..dae6e68 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -305,6 +305,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	osm_physp_t *p_physp;
 	cl_ptr_vector_t *p_tbl;
 	osm_port_t *p_port;
+	osm_node_t *p_node;
 	ib_net16_t source_lid = 0;
 	boolean_t is_gsi = TRUE;
 	uint8_t port_num = 0;
@@ -504,8 +505,9 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	}
 
 	/* Check for node description update. IB Spec v1.2.1 pg 823 */
-	if (ib_notice_is_generic(p_ntci) &&
-	    cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 &&
+	if (!ib_notice_is_generic(p_ntci))
+		goto check_sweep;
+	if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 &&
 	    p_ntci->data_details.ntc_144.local_changes & TRAP_144_MASK_OTHER_LOCAL_CHANGES &&
 	    p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) {
 		OSM_LOG(sm->p_log, OSM_LOG_INFO, "Trap 144 Node description update\n");
@@ -518,20 +520,25 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 				"ERR 3812: No physical port found for "
 				"trap 144: \"node description update\"\n");
+		goto check_sweep;
 	}
-
+	if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
+		/* update system image guid (in NodeInfo) */
+		p_node = osm_physp_get_node_ptr(p_physp);
+		p_node->node_info.sys_guid = p_ntci->data_details.ntc_145.new_sys_guid;
+	}
+check_sweep:
 	/* do a sweep if we received a trap */
 	if (sm->p_subn->opt.sweep_on_trap) {
 		/* if this is trap number 128 or run_heavy_sweep is TRUE -
 		   update the force_heavy_sweep flag of the subnet.
-		   Sweep also on traps 144/145 - these traps signal a change of
-		   certain port capabilities/system image guid.
+		   Sweep also on traps 144 - these traps signal a change of
+		   certain port capabilities.
 		   TODO: In the future this can be changed to just getting
 		   PortInfo on this port instead of sweeping the entire subnet. */
 		if (ib_notice_is_generic(p_ntci) &&
 		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
 		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
-		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145 ||
 		     run_heavy_sweep)) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Forcing heavy sweep. Received trap:%u\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
