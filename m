From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2] opensm: Add extended link speeds support
Date: Tue, 09 Aug 2011 10:30:45 -0400
Message-ID: <4E414495.70004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

    
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Used defines rather than hard coded constants in a number of places
In osm_link_mgr.c, renamed portnum to be attr_mod for better clarity
Fixed copyright year change in osm_base.h
In osm_helper.c:ib_get_lsa_str, removed DOWN check (separate patch later)
In osm_link_mgr.c:link_mgr_set_physp_pi, use [rem_]cap_mask rather
than [r]pi0
In osm_sa_portinfo_record.c: Change p_pi_mask to cap_mask and really use it

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 3dc8a7c..c6a09e2 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -2720,6 +2720,11 @@ typedef struct _ib_path_rec {
 #define IB_PIR_COMPMASK_MAXCREDHINT	 (CL_HTON64(((uint64_t)1)<<50))
 #define IB_PIR_COMPMASK_RESV5		 (CL_HTON64(((uint64_t)1)<<51))
 #define IB_PIR_COMPMASK_LINKRTLAT	 (CL_HTON64(((uint64_t)1)<<52))
+#define IB_PIR_COMPMASK_RESV6		 (CL_HTON64(((uint64_t)1)<<53))
+#define IB_PIR_COMPMASK_LINKSPDEXTACT	 (CL_HTON64(((uint64_t)1)<<54))
+#define IB_PIR_COMPMASK_LINKSPDEXTSUPP	 (CL_HTON64(((uint64_t)1)<<55))
+#define IB_PIR_COMPMASK_RESV7		 (CL_HTON64(((uint64_t)1)<<56))
+#define IB_PIR_COMPMASK_LINKSPDEXTENAB	 (CL_HTON64(((uint64_t)1)<<57))
 
 /* Multicast Member Record Component Masks */
 #define IB_MCR_COMPMASK_GID         (CL_HTON64(((uint64_t)1)<<0))
@@ -5073,6 +5078,8 @@ ib_port_info_get_link_speed_active(IN const ib_port_info_t * const p_pi)
 #define IB_LINK_SPEED_EXT_ACTIVE_NONE		0
 #define IB_LINK_SPEED_EXT_ACTIVE_14		1
 #define IB_LINK_SPEED_EXT_ACTIVE_25		2
+#define IB_LINK_SPEED_EXT_DISABLE		30
+#define IB_LINK_SPEED_EXT_SET_LSES		31
 
 /* following v1 ver1.2 p901 */
 #define IB_PATH_RECORD_RATE_2_5_GBS		2
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index 9a20890..e558c55 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -843,6 +843,18 @@ typedef enum _osm_thread_state {
 #define OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED (1 << 6)
 /***********/
 
+/****d* OpenSM: Base/OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED
+* Name
+*	OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED
+*
+* DESCRIPTION
+*	Extended Link Speeds supported
+*
+* SYNOPSIS
+*/
+#define OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED (1 << 7)
+/***********/
+
 /****d* OpenSM: Base/osm_signal_t
 * NAME
 *	osm_signal_t
diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index a2c1dea..263bbcc 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -534,7 +534,7 @@ const char *osm_get_mtu_str(IN uint8_t mtu);
 
 const char *osm_get_lwa_str(IN uint8_t lwa);
 
-const char *osm_get_lsa_str(IN uint8_t lsa);
+const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state);
 
 /****f* IBA Base: Types/osm_get_sm_mgr_signal_str
 * NAME
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 6d17c31..57b08a7 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -158,6 +158,7 @@ typedef struct osm_subn_opt {
 	boolean_t lmc_esp0;
 	uint8_t max_op_vls;
 	uint8_t force_link_speed;
+	uint8_t force_link_speed_ext;
 	boolean_t reassign_lids;
 	boolean_t ignore_other_sm;
 	boolean_t single_thread;
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 82a9b48..925fb72 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
- * Copyright (c) 2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2010,2011 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -650,6 +650,8 @@ typedef struct {
 	uint64_t ports_sdr;
 	uint64_t ports_ddr;
 	uint64_t ports_qdr;
+	uint64_t ports_fdr;
+	uint64_t ports_edr;
 	uint64_t ports_unknown_speed;
 	uint64_t ports_reduced_speed;
 	port_report_t *reduced_speed_ports;
@@ -662,6 +664,8 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 {
 	fabric_stats_t *fs = (fabric_stats_t *) context;
 	osm_node_t *node = (osm_node_t *) p_map_item;
+	osm_physp_t *physp0;
+	ib_port_info_t *pi0;
 	uint8_t num_ports = osm_node_get_num_physp(node);
 	uint8_t port = 0;
 
@@ -672,6 +676,12 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 
 	fs->total_nodes++;
 
+	if (osm_node_get_type(node) == IB_NODE_TYPE_SWITCH) {
+		physp0 = osm_node_get_physp_ptr(node, 0);
+		pi0 = &physp0->port_info;
+	} else
+		pi0 = NULL;
+
 	for (port = 1; port < num_ports; port++) {
 		osm_physp_t *phys = osm_node_get_physp_ptr(node, port);
 		ib_port_info_t *pi = NULL;
@@ -685,7 +695,9 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 		if (!phys)
 			continue;
 
-		pi = &(phys->port_info);
+		pi = &phys->port_info;
+		if (!pi0)
+			pi0 = pi;
 		active_speed = ib_port_info_get_link_speed_active(pi);
 		enabled_speed = ib_port_info_get_link_speed_enabled(pi);
 		active_width = pi->link_width_active;
@@ -715,12 +727,38 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 			fs->ports_ddr++;
 			break;
 		case IB_LINK_SPEED_ACTIVE_10:
-			fs->ports_qdr++;
+			if (!(pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) ||
+			    ((pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) &&
+			    !ib_port_info_get_link_speed_ext_active(pi)))
+				fs->ports_qdr++;
 			break;
 		default:
 			fs->ports_unknown_speed++;
 			break;
 		}
+		if (pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
+		    ib_port_info_get_link_speed_ext_sup(pi) &&
+		    (enabled_speed = pi->link_speed_ext_enabled) != IB_LINK_SPEED_EXT_DISABLE &&
+		    active_speed == IB_LINK_SPEED_ACTIVE_10) {
+			active_speed = ib_port_info_get_link_speed_ext_active(pi);
+			if ((enabled_speed ^ active_speed) > active_speed) {
+				__tag_port_report(&(fs->reduced_speed_ports),
+						  cl_ntoh64(node->node_info.node_guid),
+						  port, node->print_desc);
+				fs->ports_reduced_speed++;
+			}
+			switch (active_speed) {
+			case IB_LINK_SPEED_EXT_ACTIVE_14:
+				fs->ports_fdr++;
+				break;
+			case IB_LINK_SPEED_EXT_ACTIVE_25:
+				fs->ports_edr++;
+				break;
+			default:
+				fs->ports_unknown_speed++;
+				break;
+			}
+		}
 		switch (active_width) {
 		case IB_LINK_WIDTH_ACTIVE_1X:
 			fs->ports_1X++;
@@ -814,6 +852,10 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		fprintf(out, "   %" PRIu64 " at 5.0 Gbps\n", fs.ports_ddr);
 	if (fs.ports_qdr)
 		fprintf(out, "   %" PRIu64 " at 10.0 Gbps\n", fs.ports_qdr);
+	if (fs.ports_fdr)
+		fprintf(out, "   %" PRIu64 " at 14.0625 Gbps\n", fs.ports_fdr);
+	if (fs.ports_edr)
+		fprintf(out, "   %" PRIu64 " at 25.78125 Gbps\n", fs.ports_edr);
 
 	if (fs.ports_disabled + fs.ports_reduced_speed + fs.ports_reduced_width
 	    > 0) {
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index adcab2f..685f74c 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -368,6 +368,7 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 	osm_node_t *p_nbnode;
 	osm_physp_t *p_physp, *p_default_physp, *p_rphysp;
 	uint8_t link_speed_act;
+	char *link_speed_act_str;
 
 	if (!p_node->node_info.num_ports)
 		return;
@@ -444,6 +445,25 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 		port_state = ib_port_info_get_port_state(&p_physp->port_info);
 		link_speed_act =
 		    ib_port_info_get_link_speed_active(&p_physp->port_info);
+		if (link_speed_act == IB_LINK_SPEED_ACTIVE_2_5)
+			link_speed_act_str = "2.5";
+		else if (link_speed_act == IB_LINK_SPEED_ACTIVE_5)
+			link_speed_act_str = "5";
+		else if (link_speed_act == IB_LINK_SPEED_ACTIVE_10)
+			link_speed_act_str = "10";
+		else
+			link_speed_act_str = "??";
+
+		if (p_default_physp->port_info.capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) {
+			link_speed_act =
+			    ib_port_info_get_link_speed_ext_active(&p_physp->port_info);
+			if (link_speed_act == IB_LINK_SPEED_EXT_ACTIVE_14)
+				link_speed_act_str = "14";
+			else if (link_speed_act == IB_LINK_SPEED_EXT_ACTIVE_25)
+				link_speed_act_str = "25";
+			else if (link_speed_act != IB_LINK_SPEED_EXT_ACTIVE_NONE)
+				link_speed_act_str = "??";
+		}
 
 		fprintf(file, "PHY=%s LOG=%s SPD=%s\n",
 			p_physp->port_info.link_width_active == 1 ? "1x" :
@@ -453,9 +473,7 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 			port_state == IB_LINK_ACTIVE ? "ACT" :
 			port_state == IB_LINK_ARMED ? "ARM" :
 			port_state == IB_LINK_INIT ? "INI" : "DWN",
-			link_speed_act == 1 ? "2.5" :
-			link_speed_act == 2 ? "5" :
-			link_speed_act == 4 ? "10" : "??");
+			link_speed_act_str);
 	}
 }
 
@@ -514,7 +532,9 @@ static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 				(ib_port_info_get_neighbor_mtu(p_pi)),
 				osm_get_lwa_str(p_pi->link_width_active),
 				osm_get_lsa_str
-				(ib_port_info_get_link_speed_active(p_pi)));
+				(ib_port_info_get_link_speed_active(p_pi),
+				 ib_port_info_get_link_speed_ext_active(p_pi),
+				 ib_port_info_get_port_state(p_pi)));
 		else
 			fprintf(file, "      :     :     ");
 
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index e8e54e1..c754ca0 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -795,45 +795,45 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 
 		osm_log(p_log, log_level,
 			"PortInfo dump:\n"
-			"\t\t\t\tport number.............%u\n"
-			"\t\t\t\tnode_guid...............0x%016" PRIx64 "\n"
-			"\t\t\t\tport_guid...............0x%016" PRIx64 "\n"
-			"\t\t\t\tm_key...................0x%016" PRIx64 "\n"
-			"\t\t\t\tsubnet_prefix...........0x%016" PRIx64 "\n"
-			"\t\t\t\tbase_lid................%u\n"
-			"\t\t\t\tmaster_sm_base_lid......%u\n"
-			"\t\t\t\tcapability_mask.........0x%X\n"
-			"\t\t\t\tdiag_code...............0x%X\n"
-			"\t\t\t\tm_key_lease_period......0x%X\n"
-			"\t\t\t\tlocal_port_num..........%u\n"
-			"\t\t\t\tlink_width_enabled......0x%X\n"
-			"\t\t\t\tlink_width_supported....0x%X\n"
-			"\t\t\t\tlink_width_active.......0x%X\n"
-			"\t\t\t\tlink_speed_supported....0x%X\n"
-			"\t\t\t\tport_state..............%s\n"
-			"\t\t\t\tstate_info2.............0x%X\n"
-			"\t\t\t\tm_key_protect_bits......0x%X\n"
-			"\t\t\t\tlmc.....................0x%X\n"
-			"\t\t\t\tlink_speed..............0x%X\n"
-			"\t\t\t\tmtu_smsl................0x%X\n"
-			"\t\t\t\tvl_cap_init_type........0x%X\n"
-			"\t\t\t\tvl_high_limit...........0x%X\n"
-			"\t\t\t\tvl_arb_high_cap.........0x%X\n"
-			"\t\t\t\tvl_arb_low_cap..........0x%X\n"
-			"\t\t\t\tinit_rep_mtu_cap........0x%X\n"
-			"\t\t\t\tvl_stall_life...........0x%X\n"
-			"\t\t\t\tvl_enforce..............0x%X\n"
-			"\t\t\t\tm_key_violations........0x%X\n"
-			"\t\t\t\tp_key_violations........0x%X\n"
-			"\t\t\t\tq_key_violations........0x%X\n"
-			"\t\t\t\tguid_cap................0x%X\n"
-			"\t\t\t\tclient_reregister.......0x%X\n"
-			"\t\t\t\tmcast_pkey_trap_suppr...0x%X\n"
-			"\t\t\t\tsubnet_timeout..........0x%X\n"
-			"\t\t\t\tresp_time_value.........0x%X\n"
-			"\t\t\t\terror_threshold.........0x%X\n"
-			"\t\t\t\tmax_credit_hint.........0x%X\n"
-			"\t\t\t\tlink_round_trip_latency.0x%X\n"
+			"\t\t\t\tport number..............%u\n"
+			"\t\t\t\tnode_guid................0x%016" PRIx64 "\n"
+			"\t\t\t\tport_guid................0x%016" PRIx64 "\n"
+			"\t\t\t\tm_key....................0x%016" PRIx64 "\n"
+			"\t\t\t\tsubnet_prefix............0x%016" PRIx64 "\n"
+			"\t\t\t\tbase_lid.................%u\n"
+			"\t\t\t\tmaster_sm_base_lid.......%u\n"
+			"\t\t\t\tcapability_mask..........0x%X\n"
+			"\t\t\t\tdiag_code................0x%X\n"
+			"\t\t\t\tm_key_lease_period.......0x%X\n"
+			"\t\t\t\tlocal_port_num...........%u\n"
+			"\t\t\t\tlink_width_enabled.......0x%X\n"
+			"\t\t\t\tlink_width_supported.....0x%X\n"
+			"\t\t\t\tlink_width_active........0x%X\n"
+			"\t\t\t\tlink_speed_supported.....0x%X\n"
+			"\t\t\t\tport_state...............%s\n"
+			"\t\t\t\tstate_info2..............0x%X\n"
+			"\t\t\t\tm_key_protect_bits.......0x%X\n"
+			"\t\t\t\tlmc......................0x%X\n"
+			"\t\t\t\tlink_speed...............0x%X\n"
+			"\t\t\t\tmtu_smsl.................0x%X\n"
+			"\t\t\t\tvl_cap_init_type.........0x%X\n"
+			"\t\t\t\tvl_high_limit............0x%X\n"
+			"\t\t\t\tvl_arb_high_cap..........0x%X\n"
+			"\t\t\t\tvl_arb_low_cap...........0x%X\n"
+			"\t\t\t\tinit_rep_mtu_cap.........0x%X\n"
+			"\t\t\t\tvl_stall_life............0x%X\n"
+			"\t\t\t\tvl_enforce...............0x%X\n"
+			"\t\t\t\tm_key_violations.........0x%X\n"
+			"\t\t\t\tp_key_violations.........0x%X\n"
+			"\t\t\t\tq_key_violations.........0x%X\n"
+			"\t\t\t\tguid_cap.................0x%X\n"
+			"\t\t\t\tclient_reregister........0x%X\n"
+			"\t\t\t\tmcast_pkey_trap_suppr....0x%X\n"
+			"\t\t\t\tsubnet_timeout...........0x%X\n"
+			"\t\t\t\tresp_time_value..........0x%X\n"
+			"\t\t\t\terror_threshold..........0x%X\n"
+			"\t\t\t\tmax_credit_hint..........0x%X\n"
+			"\t\t\t\tlink_round_trip_latency..0x%X\n"
 			"\t\t\t\tlink_speed_ext_active....0x%X\n"
 			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
 			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
@@ -859,7 +859,8 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			cl_ntoh16(p_pi->q_key_violations), p_pi->guid_cap,
 			ib_port_info_get_client_rereg(p_pi),
 			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
-			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
+			ib_port_info_get_timeout(p_pi),
+			ib_port_info_get_resp_time_value(p_pi),
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
 			cl_ntoh32(p_pi->link_rt_latency),
 			ib_port_info_get_link_speed_ext_active(p_pi),
@@ -886,46 +887,46 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 		osm_log(p_log, log_level,
 			"PortInfo Record dump:\n"
 			"\t\t\t\tRID\n"
-			"\t\t\t\tEndPortLid..............%u\n"
-			"\t\t\t\tPortNum.................%u\n"
-			"\t\t\t\tOptions.................0x%X\n"
+			"\t\t\t\tEndPortLid...............%u\n"
+			"\t\t\t\tPortNum..................%u\n"
+			"\t\t\t\tOptions..................0x%X\n"
 			"\t\t\t\tPortInfo dump:\n"
-			"\t\t\t\tm_key...................0x%016" PRIx64 "\n"
-			"\t\t\t\tsubnet_prefix...........0x%016" PRIx64 "\n"
-			"\t\t\t\tbase_lid................%u\n"
-			"\t\t\t\tmaster_sm_base_lid......%u\n"
-			"\t\t\t\tcapability_mask.........0x%X\n"
-			"\t\t\t\tdiag_code...............0x%X\n"
-			"\t\t\t\tm_key_lease_period......0x%X\n"
-			"\t\t\t\tlocal_port_num..........%u\n"
-			"\t\t\t\tlink_width_enabled......0x%X\n"
-			"\t\t\t\tlink_width_supported....0x%X\n"
-			"\t\t\t\tlink_width_active.......0x%X\n"
-			"\t\t\t\tlink_speed_supported....0x%X\n"
-			"\t\t\t\tport_state..............%s\n"
-			"\t\t\t\tstate_info2.............0x%X\n"
-			"\t\t\t\tm_key_protect_bits......0x%X\n"
-			"\t\t\t\tlmc.....................0x%X\n"
-			"\t\t\t\tlink_speed..............0x%X\n"
-			"\t\t\t\tmtu_smsl................0x%X\n"
-			"\t\t\t\tvl_cap_init_type........0x%X\n"
-			"\t\t\t\tvl_high_limit...........0x%X\n"
-			"\t\t\t\tvl_arb_high_cap.........0x%X\n"
-			"\t\t\t\tvl_arb_low_cap..........0x%X\n"
-			"\t\t\t\tinit_rep_mtu_cap........0x%X\n"
-			"\t\t\t\tvl_stall_life...........0x%X\n"
-			"\t\t\t\tvl_enforce..............0x%X\n"
-			"\t\t\t\tm_key_violations........0x%X\n"
-			"\t\t\t\tp_key_violations........0x%X\n"
-			"\t\t\t\tq_key_violations........0x%X\n"
-			"\t\t\t\tguid_cap................0x%X\n"
-			"\t\t\t\tclient_reregister.......0x%X\n"
-			"\t\t\t\tmcast_pkey_trap_suppr...0x%X\n"
-			"\t\t\t\tsubnet_timeout..........0x%X\n"
-			"\t\t\t\tresp_time_value.........0x%X\n"
-			"\t\t\t\terror_threshold.........0x%X\n"
-			"\t\t\t\tmax_credit_hint.........0x%X\n"
-			"\t\t\t\tlink_round_trip_latency.0x%X\n"
+			"\t\t\t\tm_key....................0x%016" PRIx64 "\n"
+			"\t\t\t\tsubnet_prefix............0x%016" PRIx64 "\n"
+			"\t\t\t\tbase_lid.................%u\n"
+			"\t\t\t\tmaster_sm_base_lid.......%u\n"
+			"\t\t\t\tcapability_mask..........0x%X\n"
+			"\t\t\t\tdiag_code................0x%X\n"
+			"\t\t\t\tm_key_lease_period.......0x%X\n"
+			"\t\t\t\tlocal_port_num...........%u\n"
+			"\t\t\t\tlink_width_enabled.......0x%X\n"
+			"\t\t\t\tlink_width_supported.....0x%X\n"
+			"\t\t\t\tlink_width_active........0x%X\n"
+			"\t\t\t\tlink_speed_supported.....0x%X\n"
+			"\t\t\t\tport_state...............%s\n"
+			"\t\t\t\tstate_info2..............0x%X\n"
+			"\t\t\t\tm_key_protect_bits.......0x%X\n"
+			"\t\t\t\tlmc......................0x%X\n"
+			"\t\t\t\tlink_speed...............0x%X\n"
+			"\t\t\t\tmtu_smsl.................0x%X\n"
+			"\t\t\t\tvl_cap_init_type.........0x%X\n"
+			"\t\t\t\tvl_high_limit............0x%X\n"
+			"\t\t\t\tvl_arb_high_cap..........0x%X\n"
+			"\t\t\t\tvl_arb_low_cap...........0x%X\n"
+			"\t\t\t\tinit_rep_mtu_cap.........0x%X\n"
+			"\t\t\t\tvl_stall_life............0x%X\n"
+			"\t\t\t\tvl_enforce...............0x%X\n"
+			"\t\t\t\tm_key_violations.........0x%X\n"
+			"\t\t\t\tp_key_violations.........0x%X\n"
+			"\t\t\t\tq_key_violations.........0x%X\n"
+			"\t\t\t\tguid_cap.................0x%X\n"
+			"\t\t\t\tclient_reregister........0x%X\n"
+			"\t\t\t\tmcast_pkey_trap_suppr....0x%X\n"
+			"\t\t\t\tsubnet_timeout...........0x%X\n"
+			"\t\t\t\tresp_time_value..........0x%X\n"
+			"\t\t\t\terror_threshold..........0x%X\n"
+			"\t\t\t\tmax_credit_hint..........0x%X\n"
+			"\t\t\t\tlink_round_trip_latency..0x%X\n"
 			"\t\t\t\tlink_speed_ext_active....0x%X\n"
 			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
 			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
@@ -951,7 +952,8 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			cl_ntoh16(p_pi->q_key_violations), p_pi->guid_cap,
 			ib_port_info_get_client_rereg(p_pi),
 			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
-			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
+			ib_port_info_get_timeout(p_pi),
+			ib_port_info_get_resp_time_value(p_pi),
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
 			cl_ntoh32(p_pi->link_rt_latency),
 			ib_port_info_get_link_speed_ext_active(p_pi),
@@ -975,9 +977,9 @@ void osm_dump_guid_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 	if (osm_log_is_active(p_log, log_level)) {
 		osm_log(p_log, log_level,
 			"GUIDInfo dump:\n"
-                        "\t\t\t\tblock number............%u\n"
-                        "\t\t\t\tnode_guid...............0x%016" PRIx64 "\n"
-                        "\t\t\t\tport_guid...............0x%016" PRIx64 "\n"
+			"\t\t\t\tblock number............%u\n"
+			"\t\t\t\tnode_guid...............0x%016" PRIx64 "\n"
+			"\t\t\t\tport_guid...............0x%016" PRIx64 "\n"
 			"\t\t\t\tGUID 0..................0x%016" PRIx64 "\n"
 			"\t\t\t\tGUID 1..................0x%016" PRIx64 "\n"
 			"\t\t\t\tGUID 2..................0x%016" PRIx64 "\n"
@@ -2265,19 +2267,28 @@ const char *osm_get_lwa_str(IN uint8_t lwa)
 }
 
 static const char *lsa_str_fixed_width[] = {
-	"???",
+	"Ext",
 	"2.5",
 	"5  ",
 	"???",
 	"10 "
 };
 
-const char *osm_get_lsa_str(IN uint8_t lsa)
+static const char *lsea_str_fixed_width[] = {
+	"Std",
+	"14 ",
+	"25 "
+};
+
+const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state)
 {
-	if (lsa > 4)
-		return lsa_str_fixed_width[0];
-	else
+	if (lsa > IB_LINK_SPEED_ACTIVE_10)
+		return lsa_str_fixed_width[3];
+	if (lsea == IB_LINK_SPEED_EXT_ACTIVE_NONE)
 		return lsa_str_fixed_width[lsa];
+	if (lsea > IB_LINK_SPEED_EXT_ACTIVE_25)
+		return lsa_str_fixed_width[3];
+	return lsea_str_fixed_width[lsea];
 }
 
 static const char *sm_mgr_signal_str[] = {
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index dd37eee..1495448 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
@@ -99,8 +99,10 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	ib_api_status_t status;
 	uint8_t port_num, mtu, op_vls, smsl = OSM_DEFAULT_SL;
 	boolean_t esp0 = FALSE, send_set = FALSE;
-	osm_physp_t *p_remote_physp;
+	osm_physp_t *p_remote_physp, *physp0;
+	int qdr_change = 0;
 	int ret = 0;
+	ib_net32_t attr_mod, cap_mask;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -329,8 +331,54 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 							    sm->p_subn->opt.
 							    force_link_speed);
 			if (memcmp(&p_pi->link_speed, &p_old_pi->link_speed,
-				   sizeof(p_pi->link_speed)))
+				   sizeof(p_pi->link_speed))) {
 				send_set = TRUE;
+				/* Determine whether QDR in LSE is being changed */
+				if ((ib_port_info_get_link_speed_enabled(p_pi) &
+				     IB_LINK_SPEED_ACTIVE_10 &&
+				     !(ib_port_info_get_link_speed_enabled(p_old_pi) &
+				      IB_LINK_SPEED_ACTIVE_10)) ||
+				    ((!(ib_port_info_get_link_speed_enabled(p_pi) &
+				       IB_LINK_SPEED_ACTIVE_10) &&
+				      ib_port_info_get_link_speed_enabled(p_old_pi) &
+				      IB_LINK_SPEED_ACTIVE_10)))
+				qdr_change = 1;
+			}
+		}
+
+		if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH) {
+			physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
+			cap_mask = physp0->port_info.capability_mask;
+		} else
+			cap_mask = p_pi->capability_mask;
+		if (!(cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS))
+			qdr_change = 0;
+
+		/* Do peer ports support extended link speeds ? */
+		if (port_num != 0 && p_remote_physp) {
+			osm_physp_t *rphysp0;
+			ib_net32_t rem_cap_mask;
+
+			if (osm_node_get_type(p_remote_physp->p_node) ==
+			    IB_NODE_TYPE_SWITCH) {
+				rphysp0 = osm_node_get_physp_ptr(p_remote_physp->p_node, 0);
+				rem_cap_mask = rphysp0->port_info.capability_mask;
+			} else
+				rem_cap_mask = p_remote_physp->port_info.capability_mask;
+
+			if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS &&
+			    rem_cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) {
+				if (sm->p_subn->opt.force_link_speed_ext &&
+				    (sm->p_subn->opt.force_link_speed_ext != IB_LINK_SPEED_EXT_SET_LSES ||
+				     p_pi->link_speed_ext_enabled !=
+				     ib_port_info_get_link_speed_sup(p_pi))) {
+					p_pi->link_speed_ext_enabled = sm->p_subn->opt.force_link_speed_ext;
+					if (memcmp(&p_pi->link_speed_ext_enabled,
+						   &p_old_pi->link_speed_ext_enabled,
+						   sizeof(p_pi->link_speed_ext_enabled)))
+						send_set = TRUE;
+				}
+			}
 		}
 
 		/* calc new op_vls and mtu */
@@ -386,9 +434,12 @@ Send:
 	if (!send_set)
 		goto Exit;
 
+	attr_mod = cl_hton32(port_num);
+	if (qdr_change)
+		attr_mod |= cl_hton32(1 << 31);	/* AM SMSupportExtendedSpeeds */
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
-			     cl_hton32(port_num), CL_DISP_MSGID_NONE, &context);
+			     attr_mod, CL_DISP_MSGID_NONE, &context);
 	if (status)
 		ret = -1;
 
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index b4f64d5..a4f81a8 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -102,7 +102,8 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 			sm->p_subn->min_ca_mtu = mtu;
 		}
 
-		rate = ib_port_info_compute_rate(p_pi, 0);
+		rate = ib_port_info_compute_rate(p_pi,
+						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 		if (rate < sm->p_subn->min_ca_rate) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Setting endport minimal rate to:%u defined by port:0x%"
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index a5d17a8..64e3f33 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -158,7 +158,8 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 	    OSM_CAP_IS_PORT_INFO_CAPMASK_MATCH_SUPPORTED;
 #endif
 	cap_mask2 = OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
-		    OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED;
+		    OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED |
+		    OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED;
 	if (sa->p_subn->opt.qos)
 		cap_mask2 |= OSM_CAP2_IS_QOS_SUPPORTED;
 	ib_class_set_cap_mask2(p_resp_cpi, cap_mask2);
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 0b6b973..81d752a 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -327,6 +327,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 				    const osm_mgrp_t * p_mgrp,
 				    const osm_physp_t * p_physp)
 {
+	const ib_port_info_t *p_pi;
 	uint8_t mtu_required;
 	uint8_t mtu_mgrp;
 	uint8_t rate_required;
@@ -341,7 +342,9 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 		return FALSE;
 	}
 
-	rate_required = ib_port_info_compute_rate(&p_physp->port_info, 0);
+	p_pi = &p_physp->port_info;
+	rate_required = ib_port_info_compute_rate(p_pi,
+						  p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 	rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
 	if (ib_path_compare_rates(rate_required, rate_mgrp) < 0) {
 		OSM_LOG(p_log, OSM_LOG_VERBOSE,
@@ -635,6 +638,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	uint8_t mtu_required, mtu, port_mtu;
 	uint8_t rate_sel = 2;	/* exactly */
 	uint8_t rate_required, rate, port_rate;
+	const ib_port_info_t *p_pi;
 	osm_log_t *p_log = sa->p_log;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -652,7 +656,8 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	 * masked in.
 	 */
 
-	port_mtu = p_physp ? ib_port_info_get_mtu_cap(&p_physp->port_info) : 0;
+	p_pi = &p_physp->port_info;
+	port_mtu = p_physp ? ib_port_info_get_mtu_cap(p_pi) : 0;
 	if (!(comp_mask & IB_MCR_COMPMASK_MTU) ||
 	    !(comp_mask & IB_MCR_COMPMASK_MTU_SEL) ||
 	    (mtu_sel = (p_mcm_rec->mtu >> 6)) == 3)
@@ -699,7 +704,8 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	p_mcm_rec->mtu = (mtu_sel << 6) | mtu;
 
 	port_rate =
-	    p_physp ? ib_port_info_compute_rate(&p_physp->port_info, 0) : 0;
+	    p_physp ? ib_port_info_compute_rate(p_pi,
+						p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) : 0;
 	if (!(comp_mask & IB_MCR_COMPMASK_RATE)
 	    || !(comp_mask & IB_MCR_COMPMASK_RATE_SEL)
 	    || (rate_sel = (p_mcm_rec->rate >> 6)) == 3)
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index cec12ed..33cf130 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -157,11 +157,11 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 					      OUT osm_path_parms_t * p_parms)
 {
 	const osm_node_t *p_node;
-	const osm_physp_t *p_physp;
+	const osm_physp_t *p_physp, *p_physp0;
 	const osm_physp_t *p_src_physp;
 	const osm_physp_t *p_dest_physp;
 	const osm_prtn_t *p_prtn = NULL;
-	const ib_port_info_t *p_pi;
+	const ib_port_info_t *p_pi, *p_pi0;
 	ib_slvl_table_t *p_slvl_tbl;
 	ib_api_status_t status = IB_SUCCESS;
 	uint8_t mtu;
@@ -189,7 +189,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_pi = &p_physp->port_info;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi, 0);
+	rate = ib_port_info_compute_rate(p_pi,
+					 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -361,9 +362,13 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
+		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
+		p_pi0 = &p_physp0->port_info;
 		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi, 0)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, 0);
+					  ib_port_info_compute_rate(p_pi,
+								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+			rate = ib_port_info_compute_rate(p_pi,
+							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -385,9 +390,13 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
+		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
+		p_pi0 = &p_physp0->port_info;
 		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi, 0)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, 0);
+					  ib_port_info_compute_rate(p_pi,
+								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+			rate = ib_port_info_compute_rate(p_pi,
+							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -420,8 +429,10 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
 	if (ib_path_compare_rates(rate,
-				  ib_port_info_compute_rate(p_pi, 0)) > 0)
-		rate = ib_port_info_compute_rate(p_pi, 0);
+				  ib_port_info_compute_rate(p_pi,
+							    p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+		rate = ib_port_info_compute_rate(p_pi,
+						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index f3b25f6..266c5c5 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
@@ -159,13 +159,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 					     OUT osm_path_parms_t * p_parms)
 {
 	const osm_node_t *p_node;
-	const osm_physp_t *p_physp;
+	const osm_physp_t *p_physp, *p_physp0;
 	const osm_physp_t *p_src_physp;
 	const osm_physp_t *p_dest_physp;
 	const osm_prtn_t *p_prtn = NULL;
 	osm_opensm_t *p_osm;
 	struct osm_routing_engine *p_re;
-	const ib_port_info_t *p_pi;
+	const ib_port_info_t *p_pi, *p_pi0;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_net16_t pkey;
 	uint8_t mtu;
@@ -195,7 +195,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_re = p_osm->routing_engine_used;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi, 0);
+	rate = ib_port_info_compute_rate(p_pi,
+					 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -349,9 +350,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
+		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
+		p_pi0 = &p_physp0->port_info;
 		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi, 0)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, 0);
+					  ib_port_info_compute_rate(p_pi,
+								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+			rate = ib_port_info_compute_rate(p_pi,
+							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -373,9 +378,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
+		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
+		p_pi0 = &p_physp0->port_info;
 		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi, 0)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, 0);
+					  ib_port_info_compute_rate(p_pi,
+								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+			rate = ib_port_info_compute_rate(p_pi,
+							 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -428,8 +437,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
 	if (ib_path_compare_rates(rate,
-				  ib_port_info_compute_rate(p_pi, 0)) > 0)
-		rate = ib_port_info_compute_rate(p_pi, 0);
+				  ib_port_info_compute_rate(p_pi,
+							    p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
+		rate = ib_port_info_compute_rate(p_pi,
+						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 0836c3c..e8631a1 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -74,10 +74,12 @@ typedef struct osm_pir_search_ctxt {
 
 static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 				       IN const osm_physp_t * p_physp,
-				       IN cl_qlist_t * p_list,
+				       IN osm_pir_search_ctxt_t * p_ctxt,
 				       IN ib_net16_t const lid)
 {
 	osm_pir_item_t *p_rec_item;
+	ib_port_info_t *p_pi;
+	osm_physp_t *p_physp0;
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -100,9 +102,35 @@ static ib_api_status_t pir_rcv_new_pir(IN osm_sa_t * sa,
 
 	p_rec_item->rec.lid = lid;
 	p_rec_item->rec.port_info = p_physp->port_info;
+	if (p_ctxt->comp_mask & IB_PIR_COMPMASK_OPTIONS)
+		p_rec_item->rec.options = p_ctxt->p_rcvd_rec->options;
+	if ((p_ctxt->comp_mask & IB_PIR_COMPMASK_OPTIONS) == 0 ||
+	    (p_ctxt->p_rcvd_rec->options & 0x80) == 0) {
+		/* Does requested port have an extended link speed active ? */
+		if (osm_node_get_type(p_physp->p_node) ==
+		    IB_NODE_TYPE_SWITCH) {
+			p_physp0 = osm_node_get_physp_ptr(p_ctxt->p_req_physp->p_node, 0);
+			p_pi = &p_physp0->port_info;
+		} else
+			p_pi = (ib_port_info_t *) &p_physp->port_info;
+		if ((p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) > 0) {
+			if (ib_port_info_get_link_speed_ext_active(&p_physp->port_info)) {
+				/* Add QDR bits to original link speed components */
+				p_pi = &p_rec_item->rec.port_info;
+				ib_port_info_set_link_speed_enabled(p_pi,
+								    ib_port_info_get_link_speed_enabled(p_pi) | IB_LINK_SPEED_ACTIVE_10);
+				p_pi->state_info1 =
+				    (uint8_t) ((p_pi->state_info1 & IB_PORT_STATE_MASK) |
+					       (ib_port_info_get_link_speed_sup(p_pi) | IB_LINK_SPEED_ACTIVE_10) << IB_PORT_LINK_SPEED_SHIFT);
+				p_pi->link_speed =
+				    (uint8_t) ((p_pi->link_speed & IB_PORT_LINK_SPEED_ENABLED_MASK) |
+					       (ib_port_info_get_link_speed_active(p_pi) | IB_LINK_SPEED_ACTIVE_10) << IB_PORT_LINK_SPEED_SHIFT);
+			}
+		}
+	}
 	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
 
-	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
+	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -147,7 +175,7 @@ static void sa_pir_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 			goto Exit;
 	}
 
-	pir_rcv_new_pir(sa, p_physp, p_ctxt->p_list, cl_hton16(base_lid_ho));
+	pir_rcv_new_pir(sa, p_physp, p_ctxt, cl_hton16(base_lid_ho));
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -160,6 +188,8 @@ static void sa_pir_check_physp(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 	ib_net64_t comp_mask;
 	const ib_port_info_t *p_comp_pi;
 	const ib_port_info_t *p_pi;
+	const osm_physp_t * p_physp0;
+	ib_net32_t cap_mask;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -372,7 +402,29 @@ static void sa_pir_check_physp(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 		    ib_port_info_get_overrun_err_thd(p_pi))
 			goto Exit;
 	}
-
+	if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH) {
+		p_physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
+		cap_mask = p_physp0->port_info.capability_mask;
+	} else
+		cap_mask = p_pi->capability_mask;
+	if (comp_mask & IB_PIR_COMPMASK_LINKSPDEXTACT) {
+		if (((cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) > 0) &&
+		    (ib_port_info_get_link_speed_ext_active(p_comp_pi) !=
+		     ib_port_info_get_link_speed_ext_active(p_pi)))
+			goto Exit;
+	}
+	if (comp_mask & IB_PIR_COMPMASK_LINKSPDEXTSUPP) {
+		if (((cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) > 0) &&
+		    (ib_port_info_get_link_speed_ext_sup(p_comp_pi) !=
+		     ib_port_info_get_link_speed_ext_sup(p_pi)))
+			goto Exit;
+	}
+	if (comp_mask & IB_PIR_COMPMASK_LINKSPDEXTENAB) {
+		if (((cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) > 0) &&
+		    (ib_port_info_get_link_speed_ext_enabled(p_comp_pi) !=
+		     ib_port_info_get_link_speed_ext_enabled(p_pi)))
+			goto Exit;
+	}
 	sa_pir_create(sa, p_physp, p_ctxt);
 
 Exit:
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 3ba1f81..1c73bc4 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -310,6 +310,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_parse_boolean, NULL, 1 },
 	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_parse_uint8, NULL, 1 },
+	{ "force_link_speed_ext", OPT_OFFSET(force_link_speed_ext), opts_parse_uint8, NULL, 1 },
 	{ "reassign_lids", OPT_OFFSET(reassign_lids), opts_parse_boolean, NULL, 1 },
 	{ "ignore_other_sm", OPT_OFFSET(ignore_other_sm), opts_parse_boolean, NULL, 1 },
 	{ "single_thread", OPT_OFFSET(single_thread), opts_parse_boolean, NULL, 0 },
@@ -715,6 +716,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lmc_esp0 = FALSE;
 	p_opt->max_op_vls = OSM_DEFAULT_MAX_OP_VLS;
 	p_opt->force_link_speed = 15;
+	p_opt->force_link_speed_ext = 31;
 	p_opt->reassign_lids = FALSE;
 	p_opt->ignore_other_sm = FALSE;
 	p_opt->single_thread = FALSE;
@@ -1100,6 +1102,14 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->force_link_speed = IB_PORT_LINK_SPEED_ENABLED_MASK;
 	}
 
+	if ((31 < p_opts->force_link_speed_ext) ||
+	    (p_opts->force_link_speed_ext > 3 && p_opts->force_link_speed_ext < 30)) {
+		log_report(" Invalid Cached Option Value:force_link_speed_ext = %u:"
+			   "Using Default:%u\n", p_opts->force_link_speed_ext,
+			   31);
+		p_opts->force_link_speed_ext = 31;
+	}
+
 	if (p_opts->max_wire_smps == 0)
 		p_opts->max_wire_smps = 0x7FFFFFFF;
 	else if (p_opts->max_wire_smps > 0x7FFFFFFF) {
@@ -1339,6 +1349,16 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#    2,4,6,8-14 Reserved\n"
 		"#    Default 15: set to PortInfo:LinkSpeedSupported\n"
 		"force_link_speed %u\n\n"
+		"# Force PortInfo:LinkSpeedExtEnabled on ports\n"
+		"# If 0, don't modify PortInfo:LinkSpeedExtEnabled on port\n"
+		"# Otherwise, use value for PortInfo:LinkSpeedExtEnabled on port\n"
+		"# Values are (MgtWG RefID #4722)\n"
+		"#    1: 14.0625 Gbps\n"
+		"#    2: 25.78125 Gbps\n"
+		"#    3: 14.0625 Gbps or 25.78125 Gbps\n"
+		"#    30: Disable extended link speeds\n"
+		"#    Default 31: set to PortInfo:LinkSpeedExtSupported\n"
+		"force_link_speed_ext %u\n\n"
 		"# The subnet_timeout code that will be set for all the ports\n"
 		"# The actual timeout is 4.096usec * 2^<subnet_timeout>\n"
 		"subnet_timeout %u\n\n"
@@ -1364,6 +1384,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->leaf_head_of_queue_lifetime,
 		p_opts->max_op_vls,
 		p_opts->force_link_speed,
+		p_opts->force_link_speed_ext,
 		p_opts->subnet_timeout,
 		p_opts->local_phy_errors_threshold,
 		p_opts->overrun_errors_threshold,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
