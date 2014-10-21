From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] send client reregistration in case of SM LID change
Date: Tue, 21 Oct 2014 10:26:02 +0200
Message-ID: <1413879962-15383-1-git-send-email-vladimirk@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

if for some reason SM LID recorded in PortInfo of the node is different
from our SM LID, it is safer to send client reregister notification to this node
to trigger reregistration of the node in Master SM.

This scenario may occur when Standby SM loses connectivity to the Master SM and becomes
Master SM for some time period. If the connectivity is re-established but Handover sent by
Standby SM is lost. the only indication about SM handovers in the fabric is SM LID mis-configuration
in some nodes.

It is important to note that this is a workaround.
Some applications/ULPs only look at client reregistration and not at SM LID change.
Most IB device drivers are not currently issuing SM LID change local event.

The fix forces opensm to set client reregister bit in PortInfo(Set) in the scenario above.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_lid_mgr.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index f52c770..9f4858d 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -806,6 +806,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	uint8_t op_vls;
 	uint8_t port_num;
 	boolean_t send_set = FALSE;
+	boolean_t send_client_rereg = FALSE;
 	boolean_t update_mkey = FALSE;
 	int ret = 0;
 
@@ -892,11 +893,17 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 		p_mgr->dirty = TRUE;
 	}
 
-	/* we are updating the ports with our local sm_base_lid */
+	/*
+	   We are updating the ports with our local sm_base_lid
+	   if for some reason currently received SM LID is different from our SM LID,
+	   need to send client reregister to this port
+	*/
 	p_pi->master_sm_base_lid = p_mgr->p_subn->sm_base_lid;
 	if (memcmp(&p_pi->master_sm_base_lid, &p_old_pi->master_sm_base_lid,
-		   sizeof(p_pi->master_sm_base_lid)))
+		   sizeof(p_pi->master_sm_base_lid))) {
+		send_client_rereg = TRUE;
 		send_set = TRUE;
+	}
 
 	p_pi->m_key_lease_period = p_mgr->p_subn->opt.m_key_lease_period;
 	if (memcmp(&p_pi->m_key_lease_period, &p_old_pi->m_key_lease_period,
@@ -1029,13 +1036,16 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	context.pi_context.active_transition = FALSE;
 
 	/*
-	   We need to set the cli_rereg bit when we are in first_time_master_sweep
-	   for ports supporting the ClientReregistration Vol1 (v1.2) p811 14.4.11
-	   Also, if this port was just now discovered, then we should also set
-	   the cli_rereg bit. We know that the port was just discovered if its
-	   is_new field is set.
-	 */
-	if ((p_mgr->p_subn->first_time_master_sweep == TRUE || p_port->is_new)
+	  For ports supporting the ClientReregistration Vol1 (v1.2) p811 14.4.11:
+	  need to set the cli_rereg bit when current SM LID at the Host
+	  is different from our SM LID,
+	  also if we are in first_time_master_sweep,
+	  also if this port was just now discovered, then we should also set
+	  the cli_rereg bit (we know that the port was just discovered
+	  if its is_new field is set).
+	*/
+	if  ((send_client_rereg ||
+	    p_mgr->p_subn->first_time_master_sweep == TRUE || p_port->is_new)
 	    && !p_mgr->p_subn->opt.no_clients_rereg
 	    && (p_old_pi->capability_mask & IB_PORT_CAP_HAS_CLIENT_REREG)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
