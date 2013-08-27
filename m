From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2 opensm] Improve m_key lookup
Date: Tue, 27 Aug 2013 08:58:36 -0400
Message-ID: <521CA27C.1020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Lookup for M_Key only when you don't know the M_Key (till you get
GetResp(PortInfo) from the port). In other cases use the M_Key stored in
the PortInfo.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h     |   59 ++++++++++++++++++++++++++++++++++++++++++++
 include/opensm/osm_sm.h    |   29 ++++++++++++++++++++-
 opensm/osm_guid_mgr.c      |    2 +
 opensm/osm_lid_mgr.c       |    1 +
 opensm/osm_link_mgr.c      |   14 +++++++---
 opensm/osm_mcast_mgr.c     |   13 ++++++---
 opensm/osm_node_info_rcv.c |   18 +++++++------
 opensm/osm_perfmgr.c       |    6 ++--
 opensm/osm_pkey_mgr.c      |   18 ++++++++++++-
 opensm/osm_port_info_rcv.c |   27 +++++++++++++++----
 opensm/osm_qos.c           |    9 ++++++
 opensm/osm_req.c           |   37 ++++++++++++++++++---------
 opensm/osm_sm_state_mgr.c  |    5 ++-
 opensm/osm_state_mgr.c     |   30 ++++++++++++++--------
 opensm/osm_sw_info_rcv.c   |   10 +++---
 opensm/osm_trap_rcv.c      |   11 +++++++-
 opensm/osm_ucast_mgr.c     |    7 +++-
 17 files changed, 234 insertions(+), 62 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 5c238ae..24bad76 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -6242,6 +6242,65 @@ ib_port_info_set_phy_and_overrun_err_thd(IN ib_port_info_t * const p_pi,
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_port_info_get_m_key
+* NAME
+*	ib_port_info_get_m_key
+*
+* DESCRIPTION
+*	Gets the M_Key
+*
+* SYNOPSIS
+*/
+static inline ib_net64_t OSM_API
+ib_port_info_get_m_key(IN const ib_port_info_t * const p_pi)
+{
+	return p_pi->m_key;
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	M_Key.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+/****f* IBA Base: Types/ib_port_info_set_m_key
+* NAME
+*	ib_port_info_set_m_key
+*
+* DESCRIPTION
+*	Sets the M_Key value
+*
+* SYNOPSIS
+*/
+static inline void OSM_API
+ib_port_info_set_m_key(IN ib_port_info_t * const p_pi, IN ib_net64_t m_key)
+{
+	p_pi->m_key = m_key;
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*	m_key
+*		[in] M_Key value.
+*
+* RETURN VALUES
+*	None.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+
 /****s* IBA Base: Types/ib_mlnx_ext_port_info_t
 * NAME
 *	ib_mlnx_ext_port_info_t
diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
index 710d206..e48c549 100644
--- a/include/opensm/osm_sm.h
+++ b/include/opensm/osm_sm.h
@@ -402,6 +402,7 @@ ib_api_status_t osm_sm_bind(IN osm_sm_t * p_sm, IN ib_net64_t port_guid);
 */
 ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN boolean_t find_mkey, ib_net64_t m_key,
 			    IN cl_disp_msgid_t err_msg,
 			    IN const osm_madw_context_t * p_context);
 /*
@@ -419,6 +420,13 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 *	attr_mod
 *		[in] Attribute modifier for this request.
 *
+*	find_mkey
+*		[in] Flag to indicate whether the M_Key should be looked up for
+*		     this MAD.
+* 	m_key
+* 		[in] M_Key value to be send with this MAD. Applied, only when
+* 		     find_mkey is FALSE.
+*
 *	err_msg
 *		[in] Message id with which to post this MAD if an error occurs.
 *
@@ -467,7 +475,8 @@ void osm_send_req_mad(IN osm_sm_t * sm, IN osm_madw_t *p_madw);
 osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 				IN const uint8_t * p_payload,
 				IN size_t payload_size, IN ib_net16_t attr_id,
-				IN ib_net32_t attr_mod, IN cl_disp_msgid_t err_msg,
+				IN ib_net32_t attr_mod, IN boolean_t find_mkey,
+				IN ib_net64_t m_key, IN cl_disp_msgid_t err_msg,
 				IN const osm_madw_context_t * p_context);
 /*
 * PARAMETERS
@@ -489,6 +498,13 @@ osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_pat
 *	attr_mod
 *		[in] Attribute modifier for this request.
 *
+*	find_mkey
+*		[in] Flag to indicate whether the M_Key should be looked up for
+*		     this MAD.
+* 	m_key
+* 		[in] M_Key value to be send with this MAD. Applied, only when
+* 		     find_mkey is FALSE.
+*
 *	err_msg
 *		[in] Message id with which to post this MAD if an error occurs.
 *
@@ -513,7 +529,8 @@ osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_pat
 ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 			    IN const uint8_t * p_payload,
 			    IN size_t payload_size, IN ib_net16_t attr_id,
-			    IN ib_net32_t attr_mod, IN cl_disp_msgid_t err_msg,
+			    IN ib_net32_t attr_mod, IN boolean_t find_mkey,
+			    IN ib_net64_t m_key, IN cl_disp_msgid_t err_msg,
 			    IN const osm_madw_context_t * p_context);
 /*
 * PARAMETERS
@@ -535,6 +552,14 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 *	attr_mod
 *		[in] Attribute modifier for this request.
 *
+*	find_mkey
+*		[in] Flag to indicate whether the M_Key should be looked up for
+*		     this MAD.
+*
+* 	m_key
+* 		[in] M_Key value to be send with this MAD. Applied, only when
+* 		     find_mkey is FALSE.
+*
 *	err_msg
 *		[in] Message id with which to post this MAD if an error occurs.
 *
diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
index 5bb2c67..d826366 100644
--- a/opensm/osm_guid_mgr.c
+++ b/opensm/osm_guid_mgr.c
@@ -73,6 +73,8 @@ static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
 
 	status = osm_req_set(sa->sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_GUID_INFO,
+			     FALSE,
+			     ib_port_info_get_m_key(&p_port->p_physp->port_info),
 			     cl_hton32((uint32_t)block_num),
 			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 96ae4d6..ae8d234 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1061,6 +1061,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	status = osm_req_set(p_mgr->sm, osm_physp_get_dr_path_ptr(p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
 			     cl_hton32(osm_physp_get_port_num(p_physp)),
+			     FALSE, ib_port_info_get_m_key(&p_physp->port_info),
 			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		ret = -1;
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 26671bf..95c5537 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -106,6 +106,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	int ret = 0;
 	ib_net32_t attr_mod, cap_mask;
 	boolean_t update_mkey = FALSE;
+	ib_net64_t m_key = 0;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -360,11 +361,15 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			}
 		}
 
-		if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH) {
+		if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH &&
+		    osm_physp_get_port_num(p_physp) != 0) {
 			physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
 			cap_mask = physp0->port_info.capability_mask;
-		} else
+			m_key = ib_port_info_get_m_key(&physp0->port_info);
+		} else {
 			cap_mask = p_pi->capability_mask;
+			m_key = ib_port_info_get_m_key(p_pi);
+		}
 		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
 			issue_ext = 1;
 
@@ -455,7 +460,8 @@ Send:
 		attr_mod |= cl_hton32(1 << 31);	/* AM SMSupportExtendedSpeeds */
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
-			     attr_mod, CL_DISP_MSGID_NONE, &context);
+			     attr_mod, FALSE, m_key,
+			     CL_DISP_MSGID_NONE, &context);
 	if (status)
 		ret = -1;
 
@@ -471,7 +477,7 @@ Send:
 		status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 				     payload2, sizeof(payload2),
 				     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
-				     cl_hton32(port_num),
+				     cl_hton32(port_num), FALSE, m_key,
 				     CL_DISP_MSGID_NONE, &context);
 		if (status)
 			ret = -1;
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index d4f9452..7993150 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -348,6 +348,7 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 				   uint32_t block_num, uint32_t position)
 {
 	osm_node_t *p_node;
+	osm_physp_t *p_physp;
 	osm_dr_path_t *p_path;
 	osm_madw_context_t context;
 	ib_api_status_t status;
@@ -366,7 +367,8 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 	CL_ASSERT(p_node);
 
-	p_path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
+	p_physp = osm_node_get_physp_ptr(p_node, 0);
+	p_path = osm_physp_get_dr_path_ptr(p_physp);
 
 	/*
 	   Send multicast forwarding table blocks to the switch
@@ -390,8 +392,9 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
 
 		status = osm_req_set(sm, p_path, (void *)block, sizeof(block),
 				     IB_MAD_ATTR_MCAST_FWD_TBL,
-				     cl_hton32(block_id_ho), CL_DISP_MSGID_NONE,
-				     &context);
+				     cl_hton32(block_id_ho), FALSE,
+				     ib_port_info_get_m_key(&p_physp->port_info),
+				     CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A02: "
 				"Sending multicast fwd. tbl. block to %s failed (%s)\n",
@@ -1071,7 +1074,9 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
 
 		status = osm_req_set(sm, p_path, (uint8_t *) & si,
 				     sizeof(si), IB_MAD_ATTR_SWITCH_INFO,
-				     0, CL_DISP_MSGID_NONE, &context);
+				     0, FALSE,
+				     ib_port_info_get_m_key(&p_physp->port_info),
+				     CL_DISP_MSGID_NONE, &context);
 
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A1B: "
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 592f2de..786bcde 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -119,7 +119,7 @@ static void requery_dup_node_info(IN osm_sm_t * sm, osm_physp_t * p_physp,
 	context.ni_context.dup_count = count;
 
 	status = osm_req_get(sm, &path, IB_MAD_ATTR_NODE_INFO, 0,
-			     CL_DISP_MSGID_NONE, &context);
+			     TRUE, 0, CL_DISP_MSGID_NONE, &context);
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D02: "
@@ -311,7 +311,7 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	for (; port < num_ports; port++) {
 		status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
 				     IB_MAD_ATTR_PORT_INFO, cl_hton32(port),
-				     CL_DISP_MSGID_NONE, &context);
+				     TRUE, 0, CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR OD02: "
 				"Failure initiating PortInfo request (%s)\n",
@@ -320,7 +320,7 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 			status = osm_req_get(sm,
 					     osm_physp_get_dr_path_ptr(physp),
 					     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
-					     cl_hton32(port),
+					     cl_hton32(port), TRUE, 0,
 					     CL_DISP_MSGID_NONE, &context);
 			if (status != IB_SUCCESS)
 				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0B: "
@@ -344,8 +344,8 @@ void osm_req_get_node_desc(IN osm_sm_t * sm, osm_physp_t * p_physp)
 	    osm_node_get_node_guid(osm_physp_get_node_ptr(p_physp));
 
 	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_physp),
-			     IB_MAD_ATTR_NODE_DESC, 0, CL_DISP_MSGID_NONE,
-			     &context);
+			     IB_MAD_ATTR_NODE_DESC, 0, TRUE, 0,
+			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D03: "
 			"Failure initiating NodeDescription request (%s)\n",
@@ -537,6 +537,7 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 				  IN const osm_madw_t * p_madw)
 {
 	ib_api_status_t status = IB_SUCCESS;
+	osm_physp_t *p_physp;
 	osm_madw_context_t context;
 	osm_dr_path_t *path;
 	ib_smp_t *p_smp;
@@ -545,8 +546,9 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
 
+	p_physp = osm_node_get_physp_ptr(p_node, 0);
 	/* update DR path of already initialized switch port 0 */
-	path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
+	path = osm_physp_get_dr_path_ptr(p_physp);
 	osm_dr_path_init(path, p_smp->hop_count, p_smp->initial_path);
 
 	context.si_context.node_guid = osm_node_get_node_guid(p_node);
@@ -555,8 +557,8 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	context.si_context.lft_top_change = FALSE;
 
 	/* Request a SwitchInfo attribute */
-	status = osm_req_get(sm, path, IB_MAD_ATTR_SWITCH_INFO,
-			     0, CL_DISP_MSGID_NONE, &context);
+	status = osm_req_get(sm, path, IB_MAD_ATTR_SWITCH_INFO, 0, TRUE, 0,
+			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		/* continue despite error */
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D06: "
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 9c1dd62..6f626df 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -822,7 +822,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 		osm_dr_path_init(&hop_1_path, 1, path_array);
 		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
-				     CL_DISP_MSGID_NONE, &context);
+				     TRUE, 0, CL_DISP_MSGID_NONE, &context);
 		CL_PLOCK_RELEASE(sm->p_lock);
 
 		if (status != IB_SUCCESS)
@@ -856,7 +856,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 			osm_dr_path_init(&hop_1_path, 1, path_array);
 			CL_PLOCK_ACQUIRE(sm->p_lock);
 			status = osm_req_get(sm, &hop_1_path,
-					     IB_MAD_ATTR_NODE_INFO, 0,
+					     IB_MAD_ATTR_NODE_INFO, 0, TRUE, 0,
 					     CL_DISP_MSGID_NONE, &context);
 			CL_PLOCK_RELEASE(sm->p_lock);
 
@@ -920,7 +920,7 @@ static int sweep_hop_0(osm_sm_t * sm)
 	osm_dr_path_init(&dr_path, 0, path_array);
 	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
-			     CL_DISP_MSGID_NONE, NULL);
+			     TRUE, 0, CL_DISP_MSGID_NONE, NULL);
 	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 97f76ad..105473f 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -178,18 +178,26 @@ pkey_mgr_update_pkey_entry(IN osm_sm_t * sm,
 {
 	osm_madw_context_t context;
 	osm_node_t *p_node = osm_physp_get_node_ptr(p_physp);
+	osm_physp_t *physp0;
 	uint32_t attr_mod;
+	ib_net64_t m_key;
 
 	context.pkey_context.node_guid = osm_node_get_node_guid(p_node);
 	context.pkey_context.port_guid = osm_physp_get_port_guid(p_physp);
 	context.pkey_context.set_method = TRUE;
 	attr_mod = block_index;
-	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH)
+	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH &&
+	    osm_physp_get_port_num(p_physp) != 0) {
 		attr_mod |= osm_physp_get_port_num(p_physp) << 16;
+		physp0 = osm_node_get_physp_ptr(p_node, 0);
+		m_key = ib_port_info_get_m_key(&physp0->port_info);
+	} else
+		m_key = ib_port_info_get_m_key(&p_physp->port_info);
 	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 			   (uint8_t *) block, sizeof(*block),
 			   IB_MAD_ATTR_P_KEY_TABLE,
-			   cl_hton32(attr_mod), CL_DISP_MSGID_NONE, &context);
+			   cl_hton32(attr_mod), FALSE, m_key,
+			   CL_DISP_MSGID_NONE, &context);
 }
 
 static ib_api_status_t
@@ -200,6 +208,8 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	osm_madw_context_t context;
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	ib_port_info_t *p_pi;
+	ib_net64_t m_key;
+	osm_physp_t *physp0;
 	ib_api_status_t status;
 	uint8_t enforce_bits;
 
@@ -234,6 +244,9 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	p_pi->state_info2 = 0;
 	ib_port_info_set_port_state(p_pi, IB_LINK_NO_CHANGE);
 
+	physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
+	m_key = ib_port_info_get_m_key(&physp0->port_info);
+
 	context.pi_context.node_guid =
 	    osm_node_get_node_guid(osm_physp_get_node_ptr(p_physp));
 	context.pi_context.port_guid = osm_physp_get_port_guid(p_physp);
@@ -245,6 +258,7 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 			     payload, sizeof(payload),
 			     IB_MAD_ATTR_PORT_INFO,
 			     cl_hton32(osm_physp_get_port_num(p_physp)),
+			     FALSE, m_key,
 			     CL_DISP_MSGID_NONE, &context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0511: "
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 961b376..1a7377a 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -171,6 +171,8 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 						     osm_physp_get_dr_path_ptr
 						     (p_physp),
 						     IB_MAD_ATTR_SM_INFO, 0,
+						     FALSE,
+						     ib_port_info_get_m_key(&p_physp->port_info),
 						     CL_DISP_MSGID_NONE,
 						     &context);
 
@@ -289,6 +291,7 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 
 				status = osm_req_get(sm, &path,
 						     IB_MAD_ATTR_NODE_INFO, 0,
+						     TRUE, 0,
 						     CL_DISP_MSGID_NONE,
 						     &context);
 
@@ -387,6 +390,8 @@ static void get_pkey_table(IN osm_log_t * p_log, IN osm_sm_t * sm,
 	osm_madw_context_t context;
 	ib_api_status_t status;
 	osm_dr_path_t path;
+	osm_physp_t *physp0;
+	ib_net64_t m_key;
 	uint8_t port_num;
 	uint16_t block_num, max_blocks;
 	uint32_t attr_mod_ho;
@@ -427,13 +432,18 @@ static void get_pkey_table(IN osm_log_t * p_log, IN osm_sm_t * sm,
 	}
 
 	for (block_num = 0; block_num < max_blocks; block_num++) {
-		if (osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH)
+		if (osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH ||
+		    osm_physp_get_port_num(p_physp) == 0) {
 			attr_mod_ho = block_num;
-		else
+			m_key = ib_port_info_get_m_key(&p_physp->port_info);
+		} else {
 			attr_mod_ho = block_num | (port_num << 16);
+			physp0 = osm_node_get_physp_ptr(p_node, 0);
+			m_key = ib_port_info_get_m_key(&physp0->port_info);
+		}
 		status = osm_req_get(sm, &path, IB_MAD_ATTR_P_KEY_TABLE,
-				     cl_hton32(attr_mod_ho),
-				     CL_DISP_MSGID_NONE, &context);
+				     cl_hton32(attr_mod_ho), FALSE,
+				     m_key, CL_DISP_MSGID_NONE, &context);
 
 		if (status != IB_SUCCESS) {
 			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0F12: "
diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index b443abb..a301803 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -91,8 +91,16 @@ static qos_mad_item_t *osm_qos_mad_create(IN osm_sm_t * sm,
 	osm_madw_context_t context;
 	osm_madw_t *p_madw;
 	osm_node_t *p_node;
+	osm_physp_t *physp0;
+	ib_net64_t m_key;
 
 	p_node = osm_physp_get_node_ptr(p);
+	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH &&
+	    osm_physp_get_port_num(p) != 0) {
+		physp0 = osm_node_get_physp_ptr(p_node, 0);
+		m_key = ib_port_info_get_m_key(&physp0->port_info);
+	} else
+		m_key = ib_port_info_get_m_key(&p->port_info);
 
 	switch (attr_id){
 	case IB_MAD_ATTR_SLVL_TABLE:
@@ -118,6 +126,7 @@ static qos_mad_item_t *osm_qos_mad_create(IN osm_sm_t * sm,
 	p_madw = osm_prepare_req_set(sm, osm_physp_get_dr_path_ptr(p),
 				     p_data, data_size,
 				     attr_id, cl_hton32(attr_mod),
+				     FALSE, m_key,
 				     CL_DISP_MSGID_NONE, &context);
 
 	if (p_madw == NULL) {
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index f0fa406..b2cfefd 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -155,13 +155,14 @@ Remote_Guid:
 **********************************************************************/
 ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN boolean_t find_mkey, ib_net64_t m_key,
 			    IN cl_disp_msgid_t err_msg,
 			    IN const osm_madw_context_t * p_context)
 {
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
+	ib_net64_t m_key_calc;
 	ib_net64_t tid;
-	ib_net64_t m_key;
 
 	CL_ASSERT(sm);
 
@@ -191,18 +192,23 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id)
 							 & (uint64_t)(0xFFFFFFFF));
 
-	m_key = (sm->p_subn->opt.m_key_lookup == TRUE) ?
-		req_determine_mkey(sm, p_path) : sm->p_subn->opt.m_key;
+	if (sm->p_subn->opt.m_key_lookup == TRUE) {
+		if (find_mkey == TRUE)
+			m_key_calc = req_determine_mkey(sm, p_path);
+		else
+			m_key_calc = m_key;
+	} else
+		m_key_calc = sm->p_subn->opt.m_key;
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64
 		", MKey 0x%016" PRIx64 "\n",
 		ib_get_sm_attr_str(attr_id), cl_ntoh16(attr_id),
-		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key));
+		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key_calc));
 
 	ib_smp_init_new(osm_madw_get_smp_ptr(p_madw), IB_MAD_METHOD_GET,
 			tid, attr_id, attr_mod, p_path->hop_count,
-			m_key, p_path->path,
+			m_key_calc, p_path->path,
 			IB_LID_PERMISSIVE, IB_LID_PERMISSIVE);
 
 	p_madw->mad_addr.dest_lid = IB_LID_PERMISSIVE;
@@ -233,12 +239,13 @@ osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_pat
 				IN const uint8_t * p_payload,
 				IN size_t payload_size,
 				IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+				IN boolean_t find_mkey, IN ib_net64_t m_key,
 				IN cl_disp_msgid_t err_msg,
 				IN const osm_madw_context_t * p_context)
 {
 	osm_madw_t *p_madw = NULL;
+	ib_net64_t m_key_calc;
 	ib_net64_t tid;
-	ib_net64_t m_key;
 
 	CL_ASSERT(sm);
 
@@ -268,18 +275,23 @@ osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_pat
 		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id)
 							 & (uint64_t)(0xFFFFFFFF));
 
-	m_key = (sm->p_subn->opt.m_key_lookup == TRUE) ?
-		req_determine_mkey(sm, p_path) : sm->p_subn->opt.m_key;
+	if (sm->p_subn->opt.m_key_lookup == TRUE) {
+		if (find_mkey == TRUE)
+			m_key_calc = req_determine_mkey(sm, p_path);
+		else
+			m_key_calc = m_key;
+	} else
+		m_key_calc = sm->p_subn->opt.m_key;
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64
 		", MKey 0x%016" PRIx64 "\n",
 		ib_get_sm_attr_str(attr_id), cl_ntoh16(attr_id),
-		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key));
+		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key_calc));
 
 	ib_smp_init_new(osm_madw_get_smp_ptr(p_madw), IB_MAD_METHOD_SET,
 			tid, attr_id, attr_mod, p_path->hop_count,
-			m_key, p_path->path,
+			m_key_calc, p_path->path,
 			IB_LID_PERMISSIVE, IB_LID_PERMISSIVE);
 
 	p_madw->mad_addr.dest_lid = IB_LID_PERMISSIVE;
@@ -318,14 +330,15 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
                             IN const uint8_t * p_payload,
                             IN size_t payload_size,
                             IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
+			    IN boolean_t find_mkey, IN ib_net64_t m_key,
                             IN cl_disp_msgid_t err_msg,
                             IN const osm_madw_context_t * p_context)
 {
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
 
-	p_madw = osm_prepare_req_set(sm, p_path, p_payload, payload_size,attr_id,
-				     attr_mod, err_msg, p_context);
+	p_madw = osm_prepare_req_set(sm, p_path, p_payload, payload_size, attr_id,
+				     attr_mod, find_mkey, m_key, err_msg, p_context);
 	if (p_madw == NULL)
 		status = IB_INSUFFICIENT_RESOURCES;
 	else
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 5d4b651..596ad8f 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -119,8 +119,9 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 	memcpy(&dr_path, osm_physp_get_dr_path_ptr(p_port->p_physp), sizeof(osm_dr_path_t));
 
 	status = osm_req_get(sm, &dr_path,
-			     IB_MAD_ATTR_SM_INFO, 0, CL_DISP_MSGID_NONE,
-			     &context);
+			     IB_MAD_ATTR_SM_INFO, 0, FALSE,
+			     ib_port_info_get_m_key(&p_port->p_physp->port_info),
+			     CL_DISP_MSGID_NONE, &context);
 	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 0cc8162..adfea9a 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -121,6 +121,7 @@ static void state_mgr_reset_switch_count(IN cl_map_item_t * p_map_item,
 static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 {
 	osm_node_t *p_node;
+	osm_physp_t *p_physp;
 	osm_dr_path_t *p_dr_path;
 	osm_madw_context_t mad_context;
 	osm_switch_t *const p_sw = (osm_switch_t *) p_object;
@@ -130,8 +131,8 @@ static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 	OSM_LOG_ENTER(sm->p_log);
 
 	p_node = p_sw->p_node;
-	p_dr_path =
-	    osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
+	p_physp = osm_node_get_physp_ptr(p_node, 0);
+	p_dr_path = osm_physp_get_dr_path_ptr(p_physp);
 
 	memset(&mad_context, 0, sizeof(mad_context));
 
@@ -141,6 +142,7 @@ static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 	mad_context.si_context.lft_top_change = FALSE;
 
 	status = osm_req_get(sm, p_dr_path, IB_MAD_ATTR_SWITCH_INFO, 0,
+			     FALSE, ib_port_info_get_m_key(&p_physp->port_info),
 			     OSM_MSG_LIGHT_SWEEP_FAIL, &mad_context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3304: "
@@ -186,7 +188,7 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
 	/* note that with some negative logic - if the query failed it means
 	 * that there is no point in going to heavy sweep */
 	status = osm_req_get(sm, &rem_node_dr_path, IB_MAD_ATTR_PORT_INFO, 0,
-			     CL_DISP_MSGID_NONE, &mad_context);
+			     TRUE, 0, CL_DISP_MSGID_NONE, &mad_context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 332E: "
 			"Request for PortInfo failed (%s)\n",
@@ -246,7 +248,7 @@ static ib_api_status_t state_mgr_sweep_hop_0(IN osm_sm_t * sm)
 		osm_dr_path_init(&dr_path, 0, path_array);
 		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
-				     CL_DISP_MSGID_NONE, NULL);
+				     TRUE, 0, CL_DISP_MSGID_NONE, NULL);
 		CL_PLOCK_RELEASE(sm->p_lock);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3305: "
@@ -441,7 +443,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 		osm_dr_path_init(&hop_1_path, 1, path_array);
 		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
-				     CL_DISP_MSGID_NONE, &context);
+				     TRUE, 0, CL_DISP_MSGID_NONE, &context);
 		CL_PLOCK_RELEASE(sm->p_lock);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3311: "
@@ -473,6 +475,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 				CL_PLOCK_ACQUIRE(sm->p_lock);
 				status = osm_req_get(sm, &hop_1_path,
 						     IB_MAD_ATTR_NODE_INFO, 0,
+						     TRUE, 0,
 						     CL_DISP_MSGID_NONE,
 						     &context);
 				CL_PLOCK_RELEASE(sm->p_lock);
@@ -516,7 +519,9 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
 	context.smi_context.light_sweep = TRUE;
 
 	ret = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
-			  IB_MAD_ATTR_SM_INFO, 0, CL_DISP_MSGID_NONE, &context);
+			  IB_MAD_ATTR_SM_INFO, 0, FALSE,
+			  ib_port_info_get_m_key(&p_port->p_physp->port_info),
+			  CL_DISP_MSGID_NONE, &context);
 	if (ret != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3314: "
 			"Failure requesting SMInfo (%s)\n",
@@ -555,8 +560,9 @@ static void state_mgr_update_node_desc(IN cl_map_item_t * obj, IN void *context)
 	mad_context.nd_context.node_guid = osm_node_get_node_guid(p_node);
 
 	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_physp),
-			     IB_MAD_ATTR_NODE_DESC, 0, CL_DISP_MSGID_NONE,
-			     &mad_context);
+			     IB_MAD_ATTR_NODE_DESC, 0, FALSE,
+			     ib_port_info_get_m_key(&p_physp->port_info),
+			     CL_DISP_MSGID_NONE, &mad_context);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"ERR 331B: Failure initiating NodeDescription request "
@@ -835,8 +841,9 @@ static void state_mgr_send_handover(IN osm_sm_t * sm, IN osm_remote_sm_t * p_sm)
 	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_SM_INFO,
-			     IB_SMINFO_ATTR_MOD_HANDOVER, CL_DISP_MSGID_NONE,
-			     &context);
+			     IB_SMINFO_ATTR_MOD_HANDOVER, FALSE,
+			     ib_port_info_get_m_key(&p_port->p_physp->port_info),
+			     CL_DISP_MSGID_NONE, &context);
 	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 4381cbe..02f6ab2 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -93,7 +93,7 @@ static void si_rcv_get_fwd_tbl(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
 			"Retrieving FT block %u\n", block_id_ho);
 
 		status = osm_req_get(sm, p_dr_path, IB_MAD_ATTR_LIN_FWD_TBL,
-				     cl_hton32(block_id_ho),
+				     cl_hton32(block_id_ho), TRUE, 0,
 				     CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS)
 			/* continue the loop despite the error */
@@ -175,7 +175,7 @@ static void si_rcv_get_mcast_fwd_tbl(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
 			status =
 			    osm_req_get(sm, p_dr_path,
 					IB_MAD_ATTR_MCAST_FWD_TBL,
-					cl_hton32(attr_mod_ho),
+					cl_hton32(attr_mod_ho), TRUE, 0,
 					CL_DISP_MSGID_NONE, &context);
 			if (status != IB_SUCCESS)
 				/* continue the loop despite the error */
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 1e75023..469b00f 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -216,6 +216,8 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
 	ib_port_info_t *pi = (ib_port_info_t *)payload;
+	osm_physp_t *physp0;
+	ib_net64_t m_key;
 	ib_api_status_t status;
 
 	/* select the nearest port to master opensm */
@@ -238,11 +240,18 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	context.pi_context.set_method = TRUE;
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
+	if (osm_node_get_type(p->p_node) == IB_NODE_TYPE_SWITCH &&
+	    osm_physp_get_port_num(p) != 0) {
+		physp0 = osm_node_get_physp_ptr(p->p_node, 0);
+		m_key = ib_port_info_get_m_key(&physp0->port_info);
+	} else
+		m_key = ib_port_info_get_m_key(&p->port_info);
 
 	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
 			   payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
 			   cl_hton32(osm_physp_get_port_num(p)),
+			   FALSE, m_key,
 			   CL_DISP_MSGID_NONE, &context);
 	CL_PLOCK_RELEASE(sm->p_lock);
 	return status;
@@ -428,7 +437,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	p_physp = osm_get_physp_by_mad_addr(sm->p_log, sm->p_subn,
 					    &tmp_madw.mad_addr);
 	if (p_physp)
-		p_smp->m_key = p_physp->port_info.m_key;
+		p_smp->m_key = ib_port_info_get_m_key(&p_physp->port_info);
 	else
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3809: "
 			"Failed to find source physical port for trap\n");
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 77094b7..6384362 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -895,6 +895,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 	osm_ucast_mgr_t *p_mgr = cxt;
 	osm_switch_t * p_sw = (osm_switch_t *) p_map_item;
 	osm_node_t *p_node;
+	osm_physp_t *p_physp;
 	osm_dr_path_t *p_path;
 	osm_madw_context_t context;
 	ib_api_status_t status;
@@ -916,7 +917,11 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 	if (p_mgr->max_lid < p_sw->max_lid_ho)
 		p_mgr->max_lid = p_sw->max_lid_ho;
 
-	p_path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
+	p_physp = osm_node_get_physp_ptr(p_node, 0);
+
+	CL_ASSERT(p_physp);
+
+	p_path = osm_physp_get_dr_path_ptr(p_physp);
 
 	/*
 	   Set the top of the unicast forwarding table.
@@ -953,7 +958,9 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 
 		status = osm_req_set(p_mgr->sm, p_path, (uint8_t *) & si,
 				     sizeof(si), IB_MAD_ATTR_SWITCH_INFO,
-				     0, CL_DISP_MSGID_NONE, &context);
+				     0, FALSE,
+				     ib_port_info_get_m_key(&p_physp->port_info),
+				     CL_DISP_MSGID_NONE, &context);
 
 		if (status != IB_SUCCESS)
 			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A06: "
@@ -969,6 +976,7 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 {
 	osm_madw_context_t context;
 	osm_dr_path_t *p_path;
+	osm_physp_t *p_physp;
 	ib_api_status_t status;
 
 	/*
@@ -983,7 +991,11 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 		return -1;
 	}
 
-	p_path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_sw->p_node, 0));
+	p_physp = osm_node_get_physp_ptr(p_sw->p_node, 0);
+	if (!p_physp)
+		return -1;
+
+	p_path = osm_physp_get_dr_path_ptr(p_physp);
 
 	context.lft_context.node_guid = osm_node_get_node_guid(p_sw->p_node);
 	context.lft_context.set_method = TRUE;
@@ -1001,7 +1013,8 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 	status = osm_req_set(p_mgr->sm, p_path,
 			     p_sw->new_lft + block_id_ho * IB_SMP_DATA_SIZE,
 			     IB_SMP_DATA_SIZE, IB_MAD_ATTR_LIN_FWD_TBL,
-			     cl_hton32(block_id_ho),
+			     cl_hton32(block_id_ho), FALSE,
+			     ib_port_info_get_m_key(&p_physp->port_info),
 			     CL_DISP_MSGID_NONE, &context);
 
 	if (status != IB_SUCCESS) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
