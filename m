From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/5] opensm: change discovery order of switch data
Date: Mon,  3 Feb 2014 13:05:13 +0200
Message-ID: <1391425516-14462-2-git-send-email-alexne@mellanox.com>
References: <1391425516-14462-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391425516-14462-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously upon receiving GetResp(NodeInfo) of a switch, SM sent
Get(SwitchInfo) and Get(PortInfo) to all its' ports in parallel. Upon receiving
GetResp(PortInfo) SM sends Get(PkeyTable). The problem is that we need
SwitchInfo.PartEnforceCap value to calculate max Pkeys block, so in case
one of the GetResp(PortInfo) arrives prior to GetResp(SwitchInfo) this
value won't be set.
The fix to change the discover order. Upon receiving GetResP(NodeInfo),
SM sends Get(SwitchInfo). Upon receiving GetResp(SwitchInfo), SM sends
Get(PortInfo port0). If we don't get GetResp(PortInfo port=0), SM will
drop the switch, otherwise SM sends Get(PortInfo ExtPorts).
Moreover, now SM queries for ExtPortInfo and Pkeys only for non-Down
ports.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |   43 ++++-------
 opensm/osm_port_info_rcv.c |  165 +++++++++++++++++++++++++++++++++-----------
 opensm/osm_sw_info_rcv.c   |   43 ++++++++++++
 3 files changed, 183 insertions(+), 68 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 4242924..b4e00f3 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -283,19 +283,13 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	osm_madw_context_t context;
 	osm_physp_t *physp;
 	ib_node_info_t *ni;
-	unsigned port, num_ports;
+	unsigned port;
 	ib_api_status_t status;
 	int mlnx_epi_supported = 0;
 
 	ni = ib_smp_get_payload_ptr(osm_madw_get_smp_ptr(madw));
 
-	if (ni->node_type == IB_NODE_TYPE_SWITCH) {
-		port = 0;
-		num_ports = osm_node_get_num_physp(node);
-	} else {
-		port = ib_node_info_get_local_port_num(ni);
-		num_ports = port + 1;
-	}
+	port = ib_node_info_get_local_port_num(ni);
 
 	if (sm->p_subn->opt.fdr10)
 		mlnx_epi_supported = is_mlnx_ext_port_info_supported(ni->device_id);
@@ -309,25 +303,23 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	context.pi_context.active_transition = FALSE;
 	context.pi_context.client_rereg = FALSE;
 
-	for (; port < num_ports; port++) {
-		status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
-				     IB_MAD_ATTR_PORT_INFO, cl_hton32(port),
+	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
+			     IB_MAD_ATTR_PORT_INFO, cl_hton32(port),
+			     TRUE, 0, CL_DISP_MSGID_NONE, &context);
+	if (status != IB_SUCCESS)
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR OD02: "
+			"Failure initiating PortInfo request (%s)\n",
+			ib_get_err_str(status));
+	if (mlnx_epi_supported) {
+		status = osm_req_get(sm,
+				     osm_physp_get_dr_path_ptr(physp),
+				     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
+				     cl_hton32(port),
 				     TRUE, 0, CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS)
-			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR OD02: "
-				"Failure initiating PortInfo request (%s)\n",
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0B: "
+				"Failure initiating MLNX ExtPortInfo request (%s)\n",
 				ib_get_err_str(status));
-		if (mlnx_epi_supported) {
-			status = osm_req_get(sm,
-					     osm_physp_get_dr_path_ptr(physp),
-					     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
-					     cl_hton32(port), TRUE, 0,
-					     CL_DISP_MSGID_NONE, &context);
-			if (status != IB_SUCCESS)
-				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0B: "
-					"Failure initiating MLNX ExtPortInfo request (%s)\n",
-					ib_get_err_str(status));
-		}
 	}
 }
 
@@ -566,9 +558,6 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			"Failure initiating SwitchInfo request (%s)\n",
 			ib_get_err_str(status));
 
-	if (p_node->discovery_count == 1)
-		ni_rcv_get_port_info(sm, p_node, p_madw);
-
 	OSM_LOG_EXIT(sm->p_log);
 }
 
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 5c12989..b3d4bd3 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -199,18 +199,75 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 /**********************************************************************
  The plock must be held before calling this function.
 **********************************************************************/
-static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
-				       IN osm_physp_t * p_physp,
-				       IN ib_port_info_t * p_pi)
+static void pi_rcv_process_switch_port0(IN osm_sm_t * sm,
+					IN osm_node_t * p_node,
+					IN osm_physp_t * p_physp,
+					IN ib_port_info_t * p_pi)
+{
+	ib_api_status_t status;
+	osm_madw_context_t context;
+	uint8_t port, num_ports;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	num_ports = osm_node_get_num_physp(p_node);
+
+	context.pi_context.node_guid = osm_node_get_node_guid(p_node);
+	context.pi_context.port_guid = osm_physp_get_port_guid(p_physp);
+	context.pi_context.set_method = FALSE;
+	context.pi_context.light_sweep = FALSE;
+	context.pi_context.active_transition = FALSE;
+	context.pi_context.client_rereg = FALSE;
+
+	for (port = 1; port < num_ports; port++) {
+		status = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_physp),
+				     IB_MAD_ATTR_PORT_INFO, cl_hton32(port),
+				     FALSE,
+				     ib_port_info_get_m_key(&p_physp->port_info),
+				     CL_DISP_MSGID_NONE, &context);
+		if (status != IB_SUCCESS)
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F16: "
+				"Failure initiating PortInfo request (%s)\n",
+				ib_get_err_str(status));
+	}
+
+	if (p_physp->need_update)
+		sm->p_subn->ignore_existing_lfts = TRUE;
+
+	pi_rcv_check_and_fix_lid(sm->p_log, p_pi, p_physp);
+
+	/*
+	   Update the PortInfo attribute.
+	 */
+	osm_physp_set_port_info(p_physp, p_pi, sm);
+
+	/* Determine if base switch port 0 */
+	if (p_node->sw &&
+	    !ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info))
+		/* PortState is not used on BSP0 but just in case it is DOWN */
+		p_physp->port_info = *p_pi;
+	pi_rcv_process_endport(sm, p_physp, p_pi);
+	OSM_LOG_EXIT(sm->p_log);
+}
+
+/**********************************************************************
+ The plock must be held before calling this function.
+**********************************************************************/
+static void pi_rcv_process_switch_ext_port(IN osm_sm_t * sm,
+					   IN osm_node_t * p_node,
+					   IN osm_physp_t * p_physp,
+					   IN ib_port_info_t * p_pi)
 {
 	ib_api_status_t status = IB_SUCCESS;
 	osm_madw_context_t context;
-	osm_physp_t *p_remote_physp;
+	osm_physp_t *p_remote_physp, *physp0;
 	osm_node_t *p_remote_node;
+	ib_net64_t m_key;
 	unsigned data_vls;
 	uint8_t port_num;
 	uint8_t remote_port_num;
 	osm_dr_path_t path;
+	int mlnx_epi_supported = 0;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -220,10 +277,14 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	   then ask for NodeInfo.  Ignore the switch management port.
 	 */
 	port_num = osm_physp_get_port_num(p_physp);
+
+	if (sm->p_subn->opt.fdr10)
+		mlnx_epi_supported = is_mlnx_ext_port_info_supported(p_node->node_info.device_id);
+
 	/* if in_sweep_hop_0 is TRUE, then this means the SM is on the switch,
 	   and we got switchInfo of our local switch. Do not continue
 	   probing through the switch. */
-	if (port_num != 0 && sm->p_subn->in_sweep_hop_0 == FALSE) {
+	if (sm->p_subn->in_sweep_hop_0 == FALSE) {
 		switch (ib_port_info_get_port_state(p_pi)) {
 		case IB_LINK_DOWN:
 			p_remote_physp = osm_physp_get_remote(p_physp);
@@ -259,6 +320,26 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		case IB_LINK_INIT:
 		case IB_LINK_ARMED:
 		case IB_LINK_ACTIVE:
+			physp0 = osm_node_get_physp_ptr(p_node, 0);
+			if (mlnx_epi_supported) {
+				m_key = ib_port_info_get_m_key(&physp0->port_info);
+
+				context.pi_context.node_guid = osm_node_get_node_guid(p_node);
+				context.pi_context.port_guid = osm_physp_get_port_guid(p_physp);
+				context.pi_context.set_method = FALSE;
+				context.pi_context.light_sweep = FALSE;
+				context.pi_context.active_transition = FALSE;
+				context.pi_context.client_rereg = FALSE;
+				status = osm_req_get(sm,
+						     osm_physp_get_dr_path_ptr(p_physp),
+						     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
+						     cl_hton32(port_num), FALSE, m_key,
+						     CL_DISP_MSGID_NONE, &context);
+				if (status != IB_SUCCESS)
+					OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F11: "
+						"Failure initiating MLNX ExtPortInfo request (%s)\n",
+						ib_get_err_str(status));
+		        }
 			/*
 			   To avoid looping forever, only probe the port if it
 			   is NOT the port that responded to the SMP.
@@ -316,46 +397,35 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	}
 
 	if (ib_port_info_get_port_state(p_pi) > IB_LINK_INIT && p_node->sw &&
-	    p_node->sw->need_update == 1 && port_num != 0)
+	    p_node->sw->need_update == 1)
 		p_node->sw->need_update = 0;
 
 	if (p_physp->need_update)
 		sm->p_subn->ignore_existing_lfts = TRUE;
 
-	if (port_num == 0)
-		pi_rcv_check_and_fix_lid(sm->p_log, p_pi, p_physp);
-
 	/*
 	   Update the PortInfo attribute.
 	 */
 	osm_physp_set_port_info(p_physp, p_pi, sm);
 
-	if (port_num == 0) {
-		/* Determine if base switch port 0 */
-		if (p_node->sw &&
-		    !ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info))
-			/* PortState is not used on BSP0 but just in case it is DOWN */
-			p_physp->port_info = *p_pi;
-		pi_rcv_process_endport(sm, p_physp, p_pi);
-	} else {
-		if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
-			goto Exit;
+	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
+		goto Exit;
 
-		p_remote_physp = osm_physp_get_remote(p_physp);
-		if (p_remote_physp) {
-			p_remote_node = osm_physp_get_node_ptr(p_remote_physp);
-			if (p_remote_node->sw) {
-				data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
-				if (data_vls >= IB_MAX_NUM_VLS)
-					data_vls = IB_MAX_NUM_VLS - 1;
-				if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
-					OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-						"Setting switch port minimal data VLs to:%u defined by node:0x%"
-						PRIx64 ", port:%u\n", data_vls,
-						cl_ntoh64(osm_node_get_node_guid(p_node)),
-						port_num);
-					sm->p_subn->min_sw_data_vls = data_vls;
-				}
+	p_remote_physp = osm_physp_get_remote(p_physp);
+	if (p_remote_physp) {
+		p_remote_node = osm_physp_get_node_ptr(p_remote_physp);
+		if (p_remote_node->sw) {
+			data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+			if (data_vls >= IB_MAX_NUM_VLS)
+				data_vls = IB_MAX_NUM_VLS - 1;
+			if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
+				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+					"Setting switch port minimal data VLs "
+					"to:%u defined by node:0x%"
+					PRIx64 ", port:%u\n", data_vls,
+					cl_ntoh64(osm_node_get_node_guid(p_node)),
+					port_num);
+				sm->p_subn->min_sw_data_vls = data_vls;
 			}
 		}
 	}
@@ -469,6 +539,18 @@ static void pi_rcv_get_pkey_slvl_vla_tables(IN osm_sm_t * sm,
 	OSM_LOG_EXIT(sm->p_log);
 }
 
+static int osm_pi_rcv_update_self(IN osm_sm_t *sm, IN osm_physp_t *p_physp,
+				  IN ib_port_info_t *p_pi)
+{
+	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN)
+		return 0;
+
+	if (sm->p_subn->need_update || p_physp->need_update > 1)
+		return 1;
+
+	return 0;
+}
+
 static void pi_rcv_process_set(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			       IN uint8_t port_num, IN osm_madw_t * p_madw)
 {
@@ -654,11 +736,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		osm_dr_path_init(p_dr_path, p_smp->hop_count,
 				 p_smp->initial_path);
 
-		/* if port just inited or reached INIT state (external reset)
-		   request update for port related tables */
-		p_physp->need_update =
-		    (ib_port_info_get_port_state(p_pi) == IB_LINK_INIT ||
-		     p_physp->need_update > 1) ? 1 : 0;
+		p_physp->need_update = osm_pi_rcv_update_self(sm, p_physp, p_pi);
 
 		switch (osm_node_get_type(p_node)) {
 		case IB_NODE_TYPE_CA:
@@ -675,7 +753,12 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 				p_port->discovery_count++;
 				p_node->physp_discovered[port_num] = 1;
 			}
-			pi_rcv_process_switch_port(sm, p_node, p_physp, p_pi);
+			if (port_num == 0)
+				pi_rcv_process_switch_port0(sm, p_node,
+							    p_physp, p_pi);
+			else
+				pi_rcv_process_switch_ext_port(sm, p_node,
+							       p_physp, p_pi);
 			break;
 		default:
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F07: "
@@ -688,7 +771,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		/*
 		   Get the tables on the physp.
 		 */
-		if (p_physp->need_update || sm->p_subn->need_update)
+		if (p_physp->need_update)
 			pi_rcv_get_pkey_slvl_vla_tables(sm, p_node, p_physp);
 
 	}
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 02f6ab2..98f7b81 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -333,6 +333,48 @@ static boolean_t si_rcv_process_existing(IN osm_sm_t * sm,
 	return is_change_detected;
 }
 
+static void si_rcv_get_sp0_info(IN osm_sm_t * sm, IN osm_node_t * node)
+{
+	osm_madw_context_t context;
+	osm_physp_t *physp;
+	ib_api_status_t status;
+	int mlnx_epi_supported = 0;
+
+	physp = osm_node_get_physp_ptr(node, 0);
+
+	context.pi_context.node_guid = osm_node_get_node_guid(node);
+	context.pi_context.port_guid = osm_physp_get_port_guid(physp);
+	context.pi_context.set_method = FALSE;
+	context.pi_context.light_sweep = FALSE;
+	context.pi_context.active_transition = FALSE;
+	context.pi_context.client_rereg = FALSE;
+
+	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
+			     IB_MAD_ATTR_PORT_INFO, 0, TRUE, 0,
+			     CL_DISP_MSGID_NONE, &context);
+	if (status != IB_SUCCESS)
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3611: "
+			"Failure initiating PortInfo request (%s)\n",
+			ib_get_err_str(status));
+
+	if (ib_switch_info_is_enhanced_port0(&node->sw->switch_info) &&
+	    sm->p_subn->opt.fdr10) {
+		mlnx_epi_supported = is_mlnx_ext_port_info_supported(node->node_info.device_id);
+		if (mlnx_epi_supported) {
+			status = osm_req_get(sm,
+					     osm_physp_get_dr_path_ptr(physp),
+					     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
+					     0, TRUE, 0,
+					     CL_DISP_MSGID_NONE, &context);
+			if (status != IB_SUCCESS)
+				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3616: "
+					"Failure initiating MLNX ExtPortInfo request (%s)\n",
+					ib_get_err_str(status));
+		}
+	}
+
+}
+
 void osm_si_rcv_process(IN void *context, IN void *data)
 {
 	osm_sm_t *sm = context;
@@ -390,6 +432,7 @@ void osm_si_rcv_process(IN void *context, IN void *data)
 		/* we might get back a request for signaling change was detected */
 		sm->p_subn->force_heavy_sweep = TRUE;
 
+	si_rcv_get_sp0_info(sm, p_node);
 	CL_PLOCK_RELEASE(sm->p_lock);
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
