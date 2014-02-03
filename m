From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/5] opensm: Better handle topology changes in the fabric
Date: Mon,  3 Feb 2014 13:05:14 +0200
Message-ID: <1391425516-14462-3-git-send-email-alexne@mellanox.com>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch tries to solve the following problem:
When newly discovered switch is rebooted during the configuration cycle,
SM end-up setting all Initialized ports to Active, but the configuration
on the switch such as Pkey tables, QoS, etc' might be incorrect.

The fix is solves this in two steps. First, turn need_update flag when
switch's StateChange bit is detected ON or CA's neighbor switch has
StateChange bit ON. Second, clear StateChange bit on the switches, before
any configuration is done. This assures that we don't miss changes in
the fabric. If a switch was rebooted during a sweep, we will detect it
in a sequential sweep and configure all its' neighbors from scratch.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h     |   60 ++++++++++++++++++++++++++++++++++++++++
 opensm/osm_port_info_rcv.c |   27 +++++++++++++++++-
 opensm/osm_state_mgr.c     |   66 ++++++++++++++++++++++++++++++++++++++++++++
 opensm/osm_ucast_mgr.c     |   15 ++-------
 4 files changed, 156 insertions(+), 12 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index a5136d4..249ee16 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -6507,6 +6507,34 @@ ib_switch_info_clear_state_change(IN ib_switch_info_t * const p_si)
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_switch_info_set_state_change
+* NAME
+*	ib_switch_info_set_state_change
+*
+* DESCRIPTION
+*	Clears the switch's state change bit.
+*
+* SYNOPSIS
+*/
+static inline void OSM_API
+ib_switch_info_set_state_change(IN ib_switch_info_t * const p_si)
+{
+	p_si->life_state = (uint8_t) ((p_si->life_state & ~IB_SWITCH_PSC) | IB_SWITCH_PSC);
+}
+
+/*
+* PARAMETERS
+*	p_si
+*		[in] Pointer to a SwitchInfo attribute.
+*
+* RETURN VALUES
+*	None
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_switch_info_get_opt_sl2vlmapping
 * NAME
 *	ib_switch_info_get_state_opt_sl2vlmapping
@@ -6535,6 +6563,38 @@ ib_switch_info_get_opt_sl2vlmapping(IN const ib_switch_info_t * const p_si)
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_switch_info_set_life_time
+* NAME
+*	ib_switch_info_set_life_time
+*
+* DESCRIPTION
+*	Sets the value of LifeTimeValue.
+*
+* SYNOPSIS
+*/
+static inline void OSM_API
+ib_switch_info_set_life_time(IN ib_switch_info_t * const p_si,
+			     IN const uint8_t life_time_val)
+{
+	p_si->life_state = (p_si->life_state & 0x1f) |
+			   (life_time_val << 3);
+}
+
+/*
+* PARAMETERS
+*	p_si
+*		[in] Pointer to a SwitchInfo attribute.
+*	life_time_val
+*		[in] LiveTimeValue.
+*
+* RETURN VALUES
+*	None.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_switch_info_is_enhanced_port0
 * NAME
 *	ib_switch_info_is_enhanced_port0
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index b3d4bd3..d813f1a 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -397,6 +397,7 @@ static void pi_rcv_process_switch_ext_port(IN osm_sm_t * sm,
 	}
 
 	if (ib_port_info_get_port_state(p_pi) > IB_LINK_INIT && p_node->sw &&
+	    !ib_switch_info_get_state_change(&p_node->sw->switch_info) &&
 	    p_node->sw->need_update == 1)
 		p_node->sw->need_update = 0;
 
@@ -545,7 +546,8 @@ static int osm_pi_rcv_update_self(IN osm_sm_t *sm, IN osm_physp_t *p_physp,
 	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
 		return 0;
 
-	if (sm->p_subn->need_update || p_physp->need_update > 1)
+	if (sm->p_subn->need_update || p_physp->need_update > 1 ||
+	    ib_port_info_get_port_state(p_pi) == IB_LINK_INIT)
 		return 1;
 
 	return 0;
@@ -608,6 +610,28 @@ static void pi_rcv_process_set(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	OSM_LOG_EXIT(sm->p_log);
 }
 
+static int osm_pi_rcv_update_neighbor(IN osm_physp_t *p_physp)
+{
+	osm_physp_t *p_rem_physp = p_physp->p_remote_physp;
+	osm_node_t *p_node;
+
+	/*
+	 * Our own port - this is the only case where CA port
+	 * is discovered before its' neighbor port
+	 */
+	if (!p_rem_physp)
+		return p_physp->need_update;
+
+	p_node = osm_physp_get_node_ptr(p_rem_physp);
+	CL_ASSERT(p_node);
+
+	/* CA/RTR to CA/RTR connection */
+	if (!p_node->sw)
+		return p_physp->need_update;
+
+	return (ib_switch_info_get_state_change(&p_node->sw->switch_info) ? 1 : p_physp->need_update);
+}
+
 void osm_pi_rcv_process(IN void *context, IN void *data)
 {
 	osm_sm_t *sm = context;
@@ -745,6 +769,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 				p_port->discovery_count++;
 				p_node->physp_discovered[port_num] = 1;
 			}
+			p_physp->need_update = osm_pi_rcv_update_neighbor(p_physp);
 			pi_rcv_process_ca_or_router_port(sm, p_node, p_physp,
 							 p_pi);
 			break;
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index c86627d..5080b22 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -531,6 +531,60 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
 			ib_get_err_str(ret));
 }
 
+static void state_mgr_reset_state_change_bit(IN cl_map_item_t * obj,
+					     IN void *context)
+{
+	osm_madw_context_t mad_context;
+	osm_switch_t *p_sw = (osm_switch_t *) obj;
+	osm_sm_t *sm = context;
+	osm_node_t *p_node;
+	osm_physp_t *p_physp;
+	osm_dr_path_t *p_path;
+	ib_api_status_t status;
+	ib_switch_info_t si;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	CL_ASSERT(p_sw);
+
+	p_node = p_sw->p_node;
+
+	CL_ASSERT(p_node);
+
+	p_physp = osm_node_get_physp_ptr(p_node, 0);
+	p_path = osm_physp_get_dr_path_ptr(p_physp);
+
+	if (!ib_switch_info_get_state_change(&p_sw->switch_info))
+		goto exit;
+
+	si = p_sw->switch_info;
+
+	ib_switch_info_set_state_change(&si);
+
+	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+		"Resetting PortStateChange on switch GUID 0x%016" PRIx64 "\n",
+		cl_ntoh64(osm_node_get_node_guid(p_node)));
+
+	mad_context.si_context.light_sweep = FALSE;
+	mad_context.si_context.node_guid = osm_node_get_node_guid(p_node);
+	mad_context.si_context.set_method = TRUE;
+	mad_context.si_context.lft_top_change = FALSE;
+
+	status = osm_req_set(sm, p_path, (uint8_t *) &si,
+			     sizeof(si), IB_MAD_ATTR_SWITCH_INFO,
+			     0, FALSE,
+			     ib_port_info_get_m_key(&p_physp->port_info),
+			     CL_DISP_MSGID_NONE, &mad_context);
+
+	if (status != IB_SUCCESS)
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 332A: "
+			"Sending SwitchInfo attribute failed (%s)\n",
+			ib_get_err_str(status));
+
+exit:
+	OSM_LOG_EXIT(sm->p_log);
+}
+
 static void state_mgr_update_node_desc(IN cl_map_item_t * obj, IN void *context)
 {
 	osm_madw_context_t mad_context;
@@ -576,6 +630,14 @@ exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
+void osm_reset_switch_state_change_bit(IN osm_opensm_t *osm)
+{
+	CL_PLOCK_ACQUIRE(&osm->lock);
+	cl_qmap_apply_func(&osm->subn.sw_guid_tbl, state_mgr_reset_state_change_bit,
+			   &osm->sm);
+	CL_PLOCK_RELEASE(&osm->lock);
+}
+
 void osm_update_node_desc(IN osm_opensm_t *osm)
 {
 	CL_PLOCK_ACQUIRE(&osm->lock);
@@ -1340,6 +1402,10 @@ repeat_discovery:
 	if (sm->p_subn->sm_state == IB_SMINFO_STATE_DISCOVERING)
 		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVERY_COMPLETED);
 
+	osm_reset_switch_state_change_bit(sm->p_subn->p_osm);
+	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
+		return;
+
 	osm_pkey_mgr_process(sm->p_subn->p_osm);
 
 	/* try to restore SA DB (this should be before lid_mgr
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index f53e288..8194307 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -938,18 +938,11 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 	} else
 		context.si_context.lft_top_change = FALSE;
 
-	/* check to see if the change state bit is on. If it is - then we
-	   need to clear it. */
-	if (ib_switch_info_get_state_change(&si))
-		life_state = ((p_mgr->p_subn->opt.packet_life_time << 3)
-			      | (si.life_state & IB_SWITCH_PSC)) & 0xfc;
-	else
-		life_state = (p_mgr->p_subn->opt.packet_life_time << 3) & 0xf8;
-
-	if (life_state != si.life_state || ib_switch_info_get_state_change(&si)) {
+	life_state = si.life_state;
+	ib_switch_info_set_life_time(&si, p_mgr->p_subn->opt.packet_life_time);
+
+	if (life_state != si.life_state)
 		set_swinfo_require = TRUE;
-		si.life_state = life_state;
-	}
 
 	if (set_swinfo_require) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
