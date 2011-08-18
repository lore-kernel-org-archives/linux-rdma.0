From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Add FDR10 support
Date: Thu, 18 Aug 2011 05:40:50 -0400
Message-ID: <4E4CDE22.5010102@dev.mellanox.co.il>
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
 include/iba/ib_types.h              |   38 ++++++++++
 include/opensm/osm_helper.h         |    8 ++-
 include/opensm/osm_msgdef.h         |    3 +-
 include/opensm/osm_port.h           |    6 +-
 include/opensm/osm_sm.h             |    3 +-
 include/opensm/osm_subnet.h         |    5 +-
 opensm/Makefile.am                  |    2 +-
 opensm/libopensm.map                |    1 +
 opensm/osm_console.c                |   19 ++++-
 opensm/osm_dump.c                   |   12 ++-
 opensm/osm_helper.c                 |   52 ++++++++++---
 opensm/osm_link_mgr.c               |   40 +++++++++-
 opensm/osm_mlnx_ext_port_info_rcv.c |  140 +++++++++++++++++++++++++++++++++++
 opensm/osm_node_info_rcv.c          |   17 ++++-
 opensm/osm_sm.c                     |   10 ++-
 opensm/osm_sm_mad_ctrl.c            |    6 +-
 opensm/osm_subnet.c                 |   29 +++++++-
 17 files changed, 360 insertions(+), 31 deletions(-)
 create mode 100644 opensm/osm_mlnx_ext_port_info_rcv.c

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index 5d92a2c..4a11b89 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -1281,6 +1281,18 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 #define IB_MAD_ATTR_LED_INFO				(CL_HTON16(0x0031))
 /**********/
 
+/****d* IBA Base: Constants/IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO
+* NAME
+*	IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO
+*
+* DESCRIPTION
+*	Vendor specific SM attribute (14.2.5)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO		(CL_HTON16(0xFF90))
+/**********/
+
 /****d* IBA Base: Constants/IB_MAD_ATTR_SERVICE_RECORD
 * NAME
 *	IB_MAD_ATTR_SERVICE_RECORD
@@ -6223,6 +6235,32 @@ ib_port_info_set_phy_and_overrun_err_thd(IN ib_port_info_t * const p_pi,
 * SEE ALSO
 *********/
 
+/****s* IBA Base: Types/ib_mlnx_ext_port_info_t
+* NAME
+*	ib_mlnx_ext_port_info_t
+*
+* DESCRIPTION
+*	Mellanox ExtendedPortInfo (Vendor specific SM class attribute).
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_mlnx_ext_port_info {
+	uint8_t resvd1[3];
+	uint8_t state_change_enable;
+	uint8_t resvd2[3];
+	uint8_t link_speed_supported;
+	uint8_t resvd3[3];
+	uint8_t link_speed_enabled;
+	uint8_t resvd4[3];
+	uint8_t link_speed_active;
+	uint8_t resvd5[48];
+} PACK_SUFFIX ib_mlnx_ext_port_info_t;
+#include <complib/cl_packoff.h>
+/************/
+
+#define FDR10 0x01
+
 typedef uint8_t ib_svc_name_t[64];
 
 #include <complib/cl_packon.h>
diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index 263bbcc..f48af89 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -282,6 +282,11 @@ void osm_dump_guid_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 * SEE ALSO
 *********/
 
+void osm_dump_mlnx_ext_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+				 IN ib_net64_t port_guid, IN uint8_t port_num,
+				 IN const ib_mlnx_ext_port_info_t * p_pi,
+				 IN osm_log_level_t log_level);
+
 void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
 			  IN osm_log_level_t log_level);
 
@@ -534,7 +539,8 @@ const char *osm_get_mtu_str(IN uint8_t mtu);
 
 const char *osm_get_lwa_str(IN uint8_t lwa);
 
-const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state);
+const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state,
+			    IN uint8_t fdr10);
 
 /****f* IBA Base: Types/osm_get_sm_mgr_signal_str
 * NAME
diff --git a/include/opensm/osm_msgdef.h b/include/opensm/osm_msgdef.h
index dbf3e53..4885ac6 100644
--- a/include/opensm/osm_msgdef.h
+++ b/include/opensm/osm_msgdef.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2006 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -160,6 +160,7 @@ enum {
 	OSM_MSG_MAD_MULTIPATH_RECORD,
 #endif
 	OSM_MSG_MAD_PORT_COUNTERS,
+	OSM_MSG_MAD_MLNX_EXT_PORT_INFO,
 	OSM_MSG_MAX
 };
 
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 3433e31..a6ca780 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -104,6 +104,7 @@ struct osm_mgrp;
 */
 typedef struct osm_physp {
 	ib_port_info_t port_info;
+	ib_mlnx_ext_port_info_t ext_port_info;
 	ib_net64_t port_guid;
 	ib_net64_t (*p_guids)[];
 	uint8_t port_num;
@@ -124,6 +125,9 @@ typedef struct osm_physp {
 *	port_info
 *		The IBA defined PortInfo data for this port.
 *
+*	ext_port_info
+*		Mellanox vendor specific ExtendedPortInfo data for this port.
+*
 *	port_guid
 *		Port GUID value of this port.  For switches,
 *		all ports share the same GUID value.
diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
index a3b770f..fb39b48 100644
--- a/include/opensm/osm_sm.h
+++ b/include/opensm/osm_sm.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005,2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -144,6 +144,7 @@ typedef struct osm_sm {
 	cl_disp_reg_handle_t slvl_disp_h;
 	cl_disp_reg_handle_t vla_disp_h;
 	cl_disp_reg_handle_t pkey_disp_h;
+	cl_disp_reg_handle_t mlnx_epi_disp_h;
 } osm_sm_t;
 /*
 * FIELDS
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 57b08a7..8bbce7c 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -159,6 +159,7 @@ typedef struct osm_subn_opt {
 	uint8_t max_op_vls;
 	uint8_t force_link_speed;
 	uint8_t force_link_speed_ext;
+	uint8_t fdr10;
 	boolean_t reassign_lids;
 	boolean_t ignore_other_sm;
 	boolean_t single_thread;
@@ -1129,6 +1130,8 @@ static inline struct osm_mgrp_box *osm_get_mbox_by_mlid(osm_subn_t const *p_subn
 *	The multicast group structure pointer if found. NULL otherwise.
 *********/
 
+int is_mlnx_ext_port_info_supported(ib_net16_t devid);
+
 /****f* OpenSM: Subnet/osm_subn_set_default_opt
 * NAME
 *	osm_subn_set_default_opt
diff --git a/opensm/Makefile.am b/opensm/Makefile.am
index 7d7fb8a..40130e2 100644
--- a/opensm/Makefile.am
+++ b/opensm/Makefile.am
@@ -35,7 +35,7 @@ opensm_SOURCES = main.c osm_console_io.c osm_console.c osm_db_files.c \
 		 osm_mcm_port.c osm_mesh.c osm_mtree.c osm_multicast.c osm_node.c \
 		 osm_node_desc_rcv.c osm_node_info_rcv.c \
 		 osm_opensm.c osm_pkey.c osm_pkey_mgr.c osm_pkey_rcv.c \
-		 osm_port.c osm_port_info_rcv.c \
+		 osm_port.c osm_port_info_rcv.c osm_mlnx_ext_port_info_rcv.c \
 		 osm_remote_sm.c osm_req.c \
 		 osm_resp.c osm_sa.c osm_sa_class_port_info.c \
 		 osm_sa_informinfo.c osm_sa_lft_record.c osm_sa_mft_record.c \
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index ca7d236..f88dd8f 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -60,5 +60,6 @@ OPENSM_1.5 {
 		ib_path_compare_rates;
 		ib_path_rate_get_prev;
 		ib_path_rate_get_next;
+		osm_dump_mlnx_ext_port_info;
 	local: *;
 };
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 925fb72..f1639e2 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -650,6 +650,7 @@ typedef struct {
 	uint64_t ports_sdr;
 	uint64_t ports_ddr;
 	uint64_t ports_qdr;
+	uint64_t ports_fdr10;
 	uint64_t ports_fdr;
 	uint64_t ports_edr;
 	uint64_t ports_unknown_speed;
@@ -685,6 +686,7 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 	for (port = 1; port < num_ports; port++) {
 		osm_physp_t *phys = osm_node_get_physp_ptr(node, port);
 		ib_port_info_t *pi = NULL;
+		ib_mlnx_ext_port_info_t *epi = NULL;
 		uint8_t active_speed = 0;
 		uint8_t enabled_speed = 0;
 		uint8_t active_width = 0;
@@ -696,6 +698,7 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 			continue;
 
 		pi = &phys->port_info;
+		epi = &phys->ext_port_info;
 		if (!pi0)
 			pi0 = pi;
 		active_speed = ib_port_info_get_link_speed_active(pi);
@@ -729,8 +732,20 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 		case IB_LINK_SPEED_ACTIVE_10:
 			if (!(pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) ||
 			    ((pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) &&
-			    !ib_port_info_get_link_speed_ext_active(pi)))
-				fs->ports_qdr++;
+			    !ib_port_info_get_link_speed_ext_active(pi))) {
+				if (epi->link_speed_active & FDR10)
+					fs->ports_fdr10++;
+				else {
+					fs->ports_qdr++;
+					/* check for speed reduced from FDR10 */
+					if (epi->link_speed_enabled & FDR10) {
+						__tag_port_report(&(fs->reduced_speed_ports),
+								  cl_ntoh64(node->node_info.node_guid),
+								  port, node->print_desc);
+						fs->ports_reduced_speed++;
+					}
+				}
+			}
 			break;
 		default:
 			fs->ports_unknown_speed++;
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 685f74c..7e58301 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -463,7 +463,8 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 				link_speed_act_str = "25";
 			else if (link_speed_act != IB_LINK_SPEED_EXT_ACTIVE_NONE)
 				link_speed_act_str = "??";
-		}
+		} else if (p_physp->ext_port_info.link_speed_active & FDR10)
+			link_speed_act_str = "FDR10";
 
 		fprintf(file, "PHY=%s LOG=%s SPD=%s\n",
 			p_physp->port_info.link_width_active == 1 ? "1x" :
@@ -534,9 +535,10 @@ static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 				osm_get_lsa_str
 				(ib_port_info_get_link_speed_active(p_pi),
 				 ib_port_info_get_link_speed_ext_active(p_pi),
-				 ib_port_info_get_port_state(p_pi)));
+				 ib_port_info_get_port_state(p_pi),
+				 p_physp->ext_port_info.link_speed_active & FDR10));
 		else
-			fprintf(file, "      :     :     ");
+			fprintf(file, "      :     :      ");
 
 		if (osm_physp_get_port_guid(p_physp) == osm->subn.sm_port_guid)
 			fprintf(file, "* %016" PRIx64 " *",
@@ -620,7 +622,7 @@ static void print_report(osm_opensm_t * osm, FILE * file)
 	fprintf(file, "\n==================================================="
 		"====================================================\n"
 		"Vendor      : Ty : #  : Sta : LID  : LMC : MTU  : LWA :"
-		" LSA : Port GUID        : Neighbor Port (Port #)\n");
+		" LSA  : Port GUID        : Neighbor Port (Port #)\n");
 	dump_qmap(stdout, &osm->subn.node_guid_tbl, print_node_report, osm);
 }
 
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index e7f0a65..d9bab65 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -502,6 +502,9 @@ const char *ib_get_sm_attr_str(IN ib_net16_t attr)
 {
 	uint16_t host_attr = cl_ntoh16(attr);
 
+	if (attr == IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO)
+		return "MLNXExtendedPortInfo";
+
 	if (host_attr > OSM_SM_ATTR_STR_UNKNOWN_VAL)
 		host_attr = OSM_SM_ATTR_STR_UNKNOWN_VAL;
 
@@ -878,6 +881,27 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 	}
 }
 
+void osm_dump_mlnx_ext_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+				 IN ib_net64_t port_guid, IN uint8_t port_num,
+				 IN const ib_mlnx_ext_port_info_t * p_pi,
+				 IN osm_log_level_t log_level)
+{
+	if (osm_log_is_active(p_log, log_level)) {
+		osm_log(p_log, log_level,
+			"MLNX ExtendedPortInfo dump:\n"
+			"\t\t\t\tport number..............%u\n"
+			"\t\t\t\tnode_guid................0x%016" PRIx64 "\n"
+			"\t\t\t\tport_guid................0x%016" PRIx64 "\n"
+			"\t\t\t\tStateChangeEnable........0x%X\n"
+			"\t\t\t\tLinkSpeedSupported.......0x%X\n"
+			"\t\t\t\tLinkSpeedEnabled.........0x%X\n"
+			"\t\t\t\tLinkSpeedActive..........0x%X\n",
+			port_num, cl_ntoh64(node_guid), cl_ntoh64(port_guid),
+			p_pi->state_change_enable, p_pi->link_speed_supported,
+			p_pi->link_speed_enabled, p_pi->link_speed_active);
+	}
+}
+
 void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			      IN const ib_portinfo_record_t * p_pir,
 			      IN osm_log_level_t log_level)
@@ -2099,6 +2123,7 @@ static const char *disp_msg_str[] = {
 	"OSM_MSG_MAD_MULTIPATH_RECORD",
 #endif
 	"OSM_MSG_MAD_PORT_COUNTERS",
+	"OSM_MSG_MAD_MLNX_EXT_PORT_INFO",
 	"UNKNOWN!!"
 };
 
@@ -2271,25 +2296,30 @@ const char *osm_get_lwa_str(IN uint8_t lwa)
 }
 
 static const char *lsa_str_fixed_width[] = {
-	"Ext",
-	"2.5",
-	"5  ",
-	"???",
-	"10 "
+	"Ext ",
+	"2.5 ",
+	"5   ",
+	"????",
+	"10  "
 };
 
 static const char *lsea_str_fixed_width[] = {
-	"Std",
-	"14 ",
-	"25 "
+	"Std ",
+	"14  ",
+	"25  "
 };
 
-const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state)
+const char *osm_get_lsa_str(IN uint8_t lsa, IN uint8_t lsea, IN uint8_t state,
+			    IN uint8_t fdr10)
 {
 	if (lsa > IB_LINK_SPEED_ACTIVE_10)
 		return lsa_str_fixed_width[3];
-	if (lsea == IB_LINK_SPEED_EXT_ACTIVE_NONE)
-		return lsa_str_fixed_width[lsa];
+	if (lsea == IB_LINK_SPEED_EXT_ACTIVE_NONE) {
+		if (fdr10)
+			return "FDR10";
+		else
+			return lsa_str_fixed_width[lsa];
+	}
 	if (lsea > IB_LINK_SPEED_EXT_ACTIVE_25)
 		return lsa_str_fixed_width[3];
 	return lsea_str_fixed_width[lsea];
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 1495448..aaefa78 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -91,16 +91,18 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 				 IN uint8_t port_state)
 {
-	uint8_t payload[IB_SMP_DATA_SIZE];
+	uint8_t payload[IB_SMP_DATA_SIZE], payload2[IB_SMP_DATA_SIZE];
 	ib_port_info_t *p_pi = (ib_port_info_t *) payload;
+	ib_mlnx_ext_port_info_t *p_epi = (ib_mlnx_ext_port_info_t *) payload2;
 	const ib_port_info_t *p_old_pi;
+	const ib_mlnx_ext_port_info_t *p_old_epi;
 	osm_madw_context_t context;
 	osm_node_t *p_node;
 	ib_api_status_t status;
 	uint8_t port_num, mtu, op_vls, smsl = OSM_DEFAULT_SL;
-	boolean_t esp0 = FALSE, send_set = FALSE;
+	boolean_t esp0 = FALSE, send_set = FALSE, send_set2 = FALSE;
 	osm_physp_t *p_remote_physp, *physp0;
-	int qdr_change = 0;
+	int qdr_change = 0, fdr10_change = 0;
 	int ret = 0;
 	ib_net32_t attr_mod, cap_mask;
 
@@ -346,6 +348,28 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			}
 		}
 
+		if (sm->p_subn->opt.fdr10 &&
+		    p_physp->ext_port_info.link_speed_supported & FDR10) {
+			if (sm->p_subn->opt.fdr10 == 1) { /* enable */
+				if (!(p_physp->ext_port_info.link_speed_enabled & FDR10))
+					fdr10_change = 1;
+			} else {	/* disable */
+				if (p_physp->ext_port_info.link_speed_enabled & FDR10)
+					fdr10_change = 1;
+			}
+			if (fdr10_change) {
+				p_old_epi = &p_physp->ext_port_info;
+				memcpy(payload2, p_old_epi,
+				       sizeof(ib_mlnx_ext_port_info_t));
+				p_epi->state_change_enable = 0x01;
+				if (sm->p_subn->opt.fdr10 == 1)
+					p_epi->link_speed_enabled = FDR10;
+				else
+					p_epi->link_speed_enabled = 0;
+				send_set2 = TRUE;
+			}
+		}
+
 		if (osm_node_get_type(p_physp->p_node) == IB_NODE_TYPE_SWITCH) {
 			physp0 = osm_node_get_physp_ptr(p_physp->p_node, 0);
 			cap_mask = physp0->port_info.capability_mask;
@@ -443,6 +467,16 @@ Send:
 	if (status)
 		ret = -1;
 
+	if (send_set2) {
+		status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
+				     payload2, sizeof(payload2),
+				     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
+				     cl_hton32(port_num),
+				     CL_DISP_MSGID_NONE, &context);
+		if (status)
+			ret = -1;
+	}
+
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
 	return ret;
diff --git a/opensm/osm_mlnx_ext_port_info_rcv.c b/opensm/osm_mlnx_ext_port_info_rcv.c
new file mode 100644
index 0000000..69cf34f
--- /dev/null
+++ b/opensm/osm_mlnx_ext_port_info_rcv.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (c) 2011 Mellanox Technologies LTD. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+/*
+ * Abstract:
+ *    Implementation of osm_mlnx_epi_rcv_t.
+ * This object represents the MLNX ExtendedPortInfo Receiver object.
+ * This object is part of the opensm family of objects.
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <string.h>
+#include <stdlib.h>
+#include <iba/ib_types.h>
+#include <complib/cl_qmap.h>
+#include <complib/cl_passivelock.h>
+#include <complib/cl_debug.h>
+#include <vendor/osm_vendor_api.h>
+#include <opensm/osm_madw.h>
+#include <opensm/osm_log.h>
+#include <opensm/osm_node.h>
+#include <opensm/osm_subnet.h>
+#include <opensm/osm_mad_pool.h>
+#include <opensm/osm_msgdef.h>
+#include <opensm/osm_helper.h>
+#include <opensm/osm_opensm.h>
+
+void osm_mlnx_epi_rcv_process(IN void *context, IN void *data)
+{
+	osm_sm_t *sm = context;
+	osm_madw_t *p_madw = data;
+	ib_mlnx_ext_port_info_t *p_pi;
+	ib_smp_t *p_smp;
+	osm_port_t *p_port;
+	osm_physp_t *p_physp;
+	osm_node_t *p_node;
+	osm_pi_context_t *p_context;
+	ib_net64_t port_guid, node_guid;
+	uint8_t port_num, portnum, start_port = 1;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	CL_ASSERT(sm);
+	CL_ASSERT(p_madw);
+
+	p_smp = osm_madw_get_smp_ptr(p_madw);
+	p_context = osm_madw_get_pi_context_ptr(p_madw);
+	p_pi = ib_smp_get_payload_ptr(p_smp);
+
+	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO);
+
+	port_num = (uint8_t) cl_ntoh32(p_smp->attr_mod);
+
+	port_guid = p_context->port_guid;
+	node_guid = p_context->node_guid;
+
+	osm_dump_mlnx_ext_port_info(sm->p_log, node_guid, port_guid, port_num,
+				    p_pi, OSM_LOG_DEBUG);
+
+	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
+	if (!p_port) {
+		CL_PLOCK_RELEASE(sm->p_lock);
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0F06: "
+			"No port object for port with GUID 0x%" PRIx64
+			"\n\t\t\t\tfor parent node GUID 0x%" PRIx64
+			", TID 0x%" PRIx64 "\n",
+			cl_ntoh64(port_guid),
+			cl_ntoh64(node_guid), cl_ntoh64(p_smp->trans_id));
+		goto Exit;
+	}
+
+	p_node = p_port->p_node;
+	CL_ASSERT(p_node);
+
+	if (!(cl_ntoh16(p_smp->status) & 0x7fff)) {
+		if (port_num != 255) {
+			p_physp = osm_node_get_physp_ptr(p_node, port_num);
+			CL_ASSERT(p_physp);
+			p_physp->ext_port_info = *p_pi;
+		} else {
+			/* Handle all ports on set/set resp */
+			if (p_node->sw &&
+			    ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info))
+				start_port = 0;
+
+			for (portnum = start_port;
+			     portnum < osm_node_get_num_physp(p_node);
+			     portnum++) {
+				p_physp = osm_node_get_physp_ptr(p_node, portnum);
+				CL_ASSERT(p_physp);
+				p_physp->ext_port_info = *p_pi;
+			}
+		}
+	} else
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(p_smp->status) & 0x7fff);
+
+	CL_PLOCK_RELEASE(sm->p_lock);
+
+Exit:
+	/*
+	   Release the lock before jumping here!!
+	 */
+	OSM_LOG_EXIT(sm->p_log);
+}
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index de5f4fb..7d2675f 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -255,6 +255,7 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	ib_node_info_t *ni;
 	unsigned port, num_ports;
 	ib_api_status_t status;
+	int mlnx_epi_supported = 0;
 
 	ni = ib_smp_get_payload_ptr(osm_madw_get_smp_ptr(madw));
 
@@ -266,6 +267,9 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 		num_ports = port + 1;
 	}
 
+	if (sm->p_subn->opt.fdr10)
+		mlnx_epi_supported = is_mlnx_ext_port_info_supported(ni->device_id);
+
 	physp = osm_node_get_physp_ptr(node, port);
 
 	context.pi_context.node_guid = osm_node_get_node_guid(node);
@@ -282,6 +286,17 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR OD02: "
 				"Failure initiating PortInfo request (%s)\n",
 				ib_get_err_str(status));
+		if (mlnx_epi_supported) {
+			status = osm_req_get(sm,
+					     osm_physp_get_dr_path_ptr(physp),
+					     IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO,
+					     cl_hton32(port),
+					     CL_DISP_MSGID_NONE, &context);
+			if (status != IB_SUCCESS)
+				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0B: "
+					"Failure initiating MLNX ExtPortInfo request (%s)\n",
+					ib_get_err_str(status));
+		}
 	}
 }
 
diff --git a/opensm/osm_sm.c b/opensm/osm_sm.c
index b8d7c55..0961bd1 100644
--- a/opensm/osm_sm.c
+++ b/opensm/osm_sm.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -73,6 +73,7 @@ extern void osm_sminfo_rcv_process(IN void *context, IN void *data);
 extern void osm_si_rcv_process(IN void *context, IN void *data);
 extern void osm_trap_rcv_process(IN void *context, IN void *data);
 extern void osm_vla_rcv_process(IN void *context, IN void *data);
+extern void osm_mlnx_epi_rcv_process(IN void *context, IN void *data);
 
 extern void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal);
 extern void osm_sm_state_mgr_polling_callback(IN void *context);
@@ -208,6 +209,7 @@ void osm_sm_shutdown(IN osm_sm_t * p_sm)
 	cl_disp_unregister(p_sm->slvl_disp_h);
 	cl_disp_unregister(p_sm->vla_disp_h);
 	cl_disp_unregister(p_sm->pkey_disp_h);
+	cl_disp_unregister(p_sm->mlnx_epi_disp_h);
 	cl_disp_unregister(p_sm->sweep_fail_disp_h);
 
 	OSM_LOG_EXIT(p_sm->p_log);
@@ -366,6 +368,12 @@ ib_api_status_t osm_sm_init(IN osm_sm_t * p_sm, IN osm_subn_t * p_subn,
 	if (p_sm->pkey_disp_h == CL_DISP_INVALID_HANDLE)
 		goto Exit;
 
+	p_sm->mlnx_epi_disp_h = cl_disp_register(p_disp,
+						 OSM_MSG_MAD_MLNX_EXT_PORT_INFO, 
+						 osm_mlnx_epi_rcv_process, p_sm);
+	if (p_sm->mlnx_epi_disp_h == CL_DISP_INVALID_HANDLE)
+		goto Exit;
+
 	p_subn->sm_state = p_subn->opt.sm_inactive ?
 	    IB_SMINFO_STATE_NOTACTIVE : IB_SMINFO_STATE_DISCOVERING;
 	osm_report_sm_state(p_sm);
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index 086f71c..ee92c66 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
@@ -248,6 +248,9 @@ static void sm_mad_ctrl_process_get_resp(IN osm_sm_mad_ctrl_t * p_ctrl,
 	case IB_MAD_ATTR_P_KEY_TABLE:
 		msg_id = OSM_MSG_MAD_PKEY;
 		break;
+	case IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO:
+		msg_id = OSM_MSG_MAD_MLNX_EXT_PORT_INFO;
+		break;
 	case IB_MAD_ATTR_GUID_INFO:
 	case IB_MAD_ATTR_CLASS_PORT_INFO:
 	case IB_MAD_ATTR_NOTICE:
@@ -726,6 +729,7 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	 */
 	if (p_smp->method == IB_MAD_METHOD_SET &&
 	    (p_smp->attr_id == IB_MAD_ATTR_PORT_INFO ||
+	     p_smp->attr_id == IB_MAD_ATTR_MLNX_EXTENDED_PORT_INFO ||
 	     p_smp->attr_id == IB_MAD_ATTR_MCAST_FWD_TBL ||
 	     p_smp->attr_id == IB_MAD_ATTR_SWITCH_INFO ||
 	     p_smp->attr_id == IB_MAD_ATTR_LIN_FWD_TBL ||
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 1c73bc4..f8623fa 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -311,6 +311,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed_ext", OPT_OFFSET(force_link_speed_ext), opts_parse_uint8, NULL, 1 },
+	{ "fdr10", OPT_OFFSET(fdr10), opts_parse_uint8, NULL, 1 },
 	{ "reassign_lids", OPT_OFFSET(reassign_lids), opts_parse_boolean, NULL, 1 },
 	{ "ignore_other_sm", OPT_OFFSET(ignore_other_sm), opts_parse_boolean, NULL, 1 },
 	{ "single_thread", OPT_OFFSET(single_thread), opts_parse_boolean, NULL, 0 },
@@ -674,6 +675,18 @@ osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_subn_t * subn, IN ib_gid_t * mgid)
 	return NULL;
 }
 
+int is_mlnx_ext_port_info_supported(ib_net16_t devid)
+{
+	uint16_t devid_ho;
+
+	devid_ho = cl_ntoh16(devid);
+	if (devid_ho == 0xc738)
+		return 1;
+	if (devid_ho >= 0x1003 && devid_ho <= 0x1010)
+		return 1;
+	return 0;
+}
+
 static void subn_init_qos_options(osm_qos_options_t *opt, osm_qos_options_t *f)
 {
 	opt->max_vls = 0;
@@ -717,6 +730,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->max_op_vls = OSM_DEFAULT_MAX_OP_VLS;
 	p_opt->force_link_speed = 15;
 	p_opt->force_link_speed_ext = 31;
+	p_opt->fdr10 = 1;
 	p_opt->reassign_lids = FALSE;
 	p_opt->ignore_other_sm = FALSE;
 	p_opt->single_thread = FALSE;
@@ -1110,6 +1124,12 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->force_link_speed_ext = 31;
 	}
 
+	if (2 < p_opts->fdr10) {
+		log_report(" Invalid Cached Option Value:fdr10 = %u:"
+			   "Using Default:%u\n", p_opts->fdr10, 1);
+		p_opts->fdr10 = 1;
+	}
+
 	if (p_opts->max_wire_smps == 0)
 		p_opts->max_wire_smps = 0x7FFFFFFF;
 	else if (p_opts->max_wire_smps > 0x7FFFFFFF) {
@@ -1359,6 +1379,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#    30: Disable extended link speeds\n"
 		"#    Default 31: set to PortInfo:LinkSpeedExtSupported\n"
 		"force_link_speed_ext %u\n\n"
+		"# FDR10 on ports on devices that support FDR10\n"
+		"# Values are:\n"
+		"#    0: don't use fdr10 (no MLNX ExtendedPortInfo MADs)\n"
+		"#    Default 1: enable fdr10 when supported\n"
+		"#    2: disable fdr10 when supported\n"
+		"fdr10 %u\n\n"
 		"# The subnet_timeout code that will be set for all the ports\n"
 		"# The actual timeout is 4.096usec * 2^<subnet_timeout>\n"
 		"subnet_timeout %u\n\n"
@@ -1385,6 +1411,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->max_op_vls,
 		p_opts->force_link_speed,
 		p_opts->force_link_speed_ext,
+		p_opts->fdr10,
 		p_opts->subnet_timeout,
 		p_opts->local_phy_errors_threshold,
 		p_opts->overrun_errors_threshold,
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
