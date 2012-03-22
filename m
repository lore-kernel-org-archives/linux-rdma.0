From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv2] opensm: Add support for partition enforcement types
Date: Thu, 22 Mar 2012 12:25:20 +0200
Message-ID: <20120322102520.GF2613@calypso>
References: <4E135D51.3080208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E135D51.3080208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Partition enforcement types are in, out, and both.
Prior to this support, both was being used so that is the default.

--
Changes since v2: 
	Cosmetic changes
	Added comments in man, conf file and help

Signed-off-by: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |   15 +++++++++++++++
 man/opensm.8.in             |   11 +++++++++--
 opensm/main.c               |   31 ++++++++++++++++++++++++++++---
 opensm/osm_pkey_mgr.c       |   41 +++++++++++++++++++++++++----------------
 opensm/osm_subnet.c         |   31 ++++++++++++++++++++++++++++++-
 5 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 4101ab9..d88f9c7 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -68,6 +68,19 @@ BEGIN_C_DECLS
 #define OSM_SUBNET_VECTOR_MIN_SIZE			0
 #define OSM_SUBNET_VECTOR_GROW_SIZE			1
 #define OSM_SUBNET_VECTOR_CAPACITY			256
+
+#define OSM_PARTITION_ENFORCE_BOTH			"both"
+#define OSM_PARTITION_ENFORCE_IN			"in"
+#define OSM_PARTITION_ENFORCE_OUT			"out"
+#define OSM_PARTITION_ENFORCE_OFF			"off"
+
+typedef enum _osm_partition_enforce_type_enum {
+	OSM_PARTITION_ENFORCE_TYPE_BOTH,
+	OSM_PARTITION_ENFORCE_TYPE_IN,
+	OSM_PARTITION_ENFORCE_TYPE_OUT,
+	OSM_PARTITION_ENFORCE_TYPE_OFF
+} osm_partition_enforce_type_enum;
+
 struct osm_opensm;
 struct osm_qos_policy;
 
@@ -184,6 +197,8 @@ typedef struct osm_subn_opt {
 	unsigned long log_max_size;
 	char *partition_config_file;
 	boolean_t no_partition_enforcement;
+	char *part_enforce;
+	osm_partition_enforce_type_enum part_enforce_enum;
 	boolean_t allow_both_pkeys;
 	uint8_t sm_assigned_guid;
 	boolean_t qos;
diff --git a/man/opensm.8.in b/man/opensm.8.in
index ff19f82..1a41f48 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -44,7 +44,8 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-f <log file path> | \-\-log_file <log file path> ]
 [\-L | \-\-log_limit <size in MB>] [\-e(rase_log_file)]
 [\-P(config) <partition config file> ]
-[\-N | \-\-no_part_enforce]
+[\-N | \-\-no_part_enforce] (DEPRECATED)
+[\-Z | \-\-part_enforce [both | in | out | off]]
 [\-W | \-\-allow_both_pkeys]
 [\-Q | \-\-qos [\-Y | \-\-qos_policy_file <file name>]]
 [\-y | \-\-stay_on_fatal]
@@ -367,9 +368,15 @@ name is \fB\%@OPENSM_CONFIG_DIR@/@QOS_POLICY_FILE@\fP. See
 QoS_management_in_OpenSM.txt in opensm doc for more information on
 configuring QoS policy via this file.
 .TP
-\fB\-N\fR, \fB\-\-no_part_enforce\fR
+\fB\-N\fR, \fB\-\-no_part_enforce\fR \fB(DEPRECATED)\fR
+This is a deprecated flag. Please use \fB\-\-part_enforce\fR instead.
 This option disables partition enforcement on switch external ports.
 .TP
+\fB\-Z\fR, \fB\-\-part_enforce\fR [both | in | out | off]
+This option indicates the partition enforcement type (for switches).
+Enforcement type can be inbound only (in), outbound only (out),
+both or disabled (off). Default is both.
+.TP
 \fB\-W\fR, \fB\-\-allow_both_pkeys\fR
 This option indicates whether both full and limited membership on the
 same partition can be configured in the PKeyTable. Default is not
diff --git a/opensm/main.c b/opensm/main.c
index 3351681..8123c16 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -321,8 +321,13 @@ static void show_usage(void)
 	       "          This option defines the optional partition configuration file.\n"
 	       "          The default name is \'"
 	       OSM_DEFAULT_PARTITION_CONFIG_FILE "\'.\n\n");
-	printf("--no_part_enforce, -N\n"
+	printf("--no_part_enforce, -N (DEPRECATED)\n"
+	       "          Use --part_enforce instead.\n"
 	       "          This option disables partition enforcement on switch external ports.\n\n");
+	printf("--part_enforce, -Z [both, in, out, off]\n"
+	       "          This option indicates the partition enforcement type (for switches)\n"
+	       "          Enforcement type can be outbound only (out), inbound only (in), both or\n"
+	       "          disabled (off). Default is both.\n\n");
 	printf("--allow_both_pkeys, -W\n"
 	       "          This option indicates whether both full and limited membership\n"
 	       "          on the same partition can be configured in the PKeyTable.\n"
@@ -573,7 +578,7 @@ int main(int argc, char *argv[])
 	char *conf_template = NULL, *config_file = NULL;
 	uint32_t val;
 	const char *const short_option =
-	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANWBIQvVhoryxp:n:q:k:C:G:H:";
+	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANZ:WBIQvVhoryxp:n:q:k:C:G:H:";
 
 	/*
 	   In the array below, the 2nd parameter specifies the number
@@ -602,6 +607,7 @@ int main(int argc, char *argv[])
 		{"erase_log_file", 0, NULL, 'e'},
 		{"Pconfig", 1, NULL, 'P'},
 		{"no_part_enforce", 0, NULL, 'N'},
+		{"part_enforce", 1, NULL, 'Z'},
 		{"allow_both_pkeys", 0, NULL, 'W'},
 		{"qos", 0, NULL, 'Q'},
 		{"qos_policy_file", 1, NULL, 'Y'},
@@ -879,6 +885,25 @@ int main(int argc, char *argv[])
 			opt.no_partition_enforcement = TRUE;
 			break;
 
+		case 'Z':
+			if (strcmp(optarg, OSM_PARTITION_ENFORCE_BOTH) == 0
+			    || strcmp(optarg, OSM_PARTITION_ENFORCE_IN) == 0
+			    || strcmp(optarg, OSM_PARTITION_ENFORCE_OUT) == 0
+			    || strcmp(optarg, OSM_PARTITION_ENFORCE_OFF) == 0) {
+				SET_STR_OPT(opt.part_enforce, optarg);
+				if (strcmp(optarg, OSM_PARTITION_ENFORCE_BOTH) == 0)
+					opt.part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_BOTH;
+				else if (strcmp(optarg, OSM_PARTITION_ENFORCE_IN) == 0)
+					opt.part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_IN;
+				else if (strcmp(optarg, OSM_PARTITION_ENFORCE_OUT) == 0)
+					opt.part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_OUT;
+				else
+					opt.part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_OFF;
+			} else
+				printf("-part_enforce %s option not understood\n",
+				       optarg);
+			break;
+
 		case 'W':
 			opt.allow_both_pkeys = TRUE;
 			break;
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index f7e6eae..7f25863 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
@@ -192,16 +192,26 @@ pkey_mgr_update_pkey_entry(IN osm_sm_t * sm,
 
 static ib_api_status_t
 pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
-			   IN osm_physp_t * p_physp, IN const boolean_t enforce)
+			   IN osm_physp_t * p_physp,
+			   IN osm_partition_enforce_type_enum enforce_type)
 {
 	osm_madw_context_t context;
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	ib_port_info_t *p_pi;
 	ib_api_status_t status;
+	uint8_t enforce_bits;
 
 	p_pi = &p_physp->port_info;
 
-	if ((p_pi->vl_enforce & 0xc) == (0xc) * (enforce == TRUE)) {
+	if (enforce_type == OSM_PARTITION_ENFORCE_TYPE_BOTH)
+		enforce_bits = 0xc;
+	else if (enforce_type == OSM_PARTITION_ENFORCE_TYPE_IN)
+		enforce_bits = 0x8;
+	else
+		enforce_bits = 0x4;
+
+	if ((p_pi->vl_enforce & 0xc) == enforce_bits *
+	    (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF)) {
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"No need to update PortInfo for "
 			"node 0x%016" PRIx64 " port %u (%s)\n",
@@ -215,10 +225,10 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	memcpy(payload, p_pi, sizeof(ib_port_info_t));
 
 	p_pi = (ib_port_info_t *) payload;
-	if (enforce == TRUE)
-		p_pi->vl_enforce |= 0xc;
-	else
-		p_pi->vl_enforce &= ~0xc;
+	p_pi->vl_enforce &= ~0xc;
+	if (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF)
+		p_pi->vl_enforce |= enforce_bits;
+
 	p_pi->state_info2 = 0;
 	ib_port_info_set_port_state(p_pi, IB_LINK_NO_CHANGE);
 
@@ -572,7 +582,7 @@ static int new_pkey_exists(osm_pkey_tbl_t * p_pkey_tbl, ib_net16_t pkey)
 static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 				     const osm_subn_t * p_subn,
 				     const osm_port_t * const p_port,
-				     boolean_t enforce)
+				     osm_partition_enforce_type_enum enforce_type)
 {
 	osm_physp_t *p_physp, *peer;
 	osm_node_t *p_node;
@@ -597,8 +607,8 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (!p_node->sw || !p_node->sw->switch_info.enforce_cap)
 		return 0;
 
-	if (enforce == FALSE) {
-		pkey_mgr_enforce_partition(p_log, sm, peer, FALSE);
+	if (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF) {
+		pkey_mgr_enforce_partition(p_log, sm, peer, OSM_PARTITION_ENFORCE_TYPE_OFF);
 		return ret;
 	}
 
@@ -669,14 +679,14 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 						cl_ntoh64(osm_node_get_node_guid(p_node)),
 						osm_physp_get_port_num(peer),
 						p_node->print_desc);
-					enforce = FALSE;
+					enforce_type = OSM_PARTITION_ENFORCE_TYPE_OFF;
 					ret = -1;
 				}
 			}
 		}
 	} else {
 		p_peer_pkey_tbl->used_blocks = peer_max_blocks;
-		enforce = FALSE;
+		enforce_type = OSM_PARTITION_ENFORCE_TYPE_OFF;
 	}
 
 	if (!ret)
@@ -686,7 +696,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
 			osm_physp_get_port_num(peer), p_node->print_desc);
 
-	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce))
+	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce_type))
 		ret = -1;
 
 	return ret;
@@ -740,8 +750,7 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
 		if ((osm_node_get_type(p_port->p_node) != IB_NODE_TYPE_SWITCH)
 		    && pkey_mgr_update_peer_port(&p_osm->log, &p_osm->sm,
 						 &p_osm->subn, p_port,
-						 !p_osm->subn.opt.
-						 no_partition_enforcement))
+						 p_osm->subn.opt.part_enforce_enum))
 			ret = -1;
 	}
 
@@ -765,7 +774,7 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
 				continue;
 
 			/* clear partition enforcement */
-			if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, FALSE))
+			if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, OSM_PARTITION_ENFORCE_TYPE_OFF))
 				ret = -1;
 		}
 	}
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 73ac339..ebd8953 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -345,6 +345,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "accum_log_file", OPT_OFFSET(accum_log_file), opts_parse_boolean, opts_setup_accum_log_file, 1 },
 	{ "partition_config_file", OPT_OFFSET(partition_config_file), opts_parse_charp, NULL, 0 },
 	{ "no_partition_enforcement", OPT_OFFSET(no_partition_enforcement), opts_parse_boolean, NULL, 1 },
+	{ "part_enforce", OPT_OFFSET(part_enforce), opts_parse_charp, NULL, 1 },
 	{ "allow_both_pkeys", OPT_OFFSET(allow_both_pkeys), opts_parse_boolean, NULL, 1 },
 	{ "sm_assigned_guid", OPT_OFFSET(sm_assigned_guid), opts_parse_uint8, NULL, 1 },
 	{ "qos", OPT_OFFSET(qos), opts_parse_boolean, NULL, 1 },
@@ -879,6 +880,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->log_max_size = 0;
 	p_opt->partition_config_file = strdup(OSM_DEFAULT_PARTITION_CONFIG_FILE);
 	p_opt->no_partition_enforcement = FALSE;
+	p_opt->part_enforce = OSM_PARTITION_ENFORCE_BOTH;
 	p_opt->allow_both_pkeys = FALSE;
 	p_opt->sm_assigned_guid = 0;
 	p_opt->qos = FALSE;
@@ -1264,6 +1266,27 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->console = strdup(OSM_DEFAULT_CONSOLE);
 	}
 
+	if (p_opts->no_partition_enforcement == TRUE) {
+		strcpy(p_opts->part_enforce, OSM_PARTITION_ENFORCE_OFF);
+		p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_OFF;
+	} else {
+		if (strcmp(p_opts->part_enforce, OSM_PARTITION_ENFORCE_BOTH) == 0)
+			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_BOTH;
+		else if (strcmp(p_opts->part_enforce, OSM_PARTITION_ENFORCE_IN) == 0)
+			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_IN;
+		else if (strcmp(p_opts->part_enforce, OSM_PARTITION_ENFORCE_OUT) == 0)
+			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_OUT;
+		else if (strcmp(p_opts->part_enforce, OSM_PARTITION_ENFORCE_OFF) == 0)
+			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_OFF;
+		else {
+			log_report(" Invalid Cached Option Value:part_enforce = %s"
+	                           ", Using Default:%s\n",
+	                           p_opts->part_enforce = OSM_PARTITION_ENFORCE_BOTH);
+			p_opts->part_enforce = OSM_PARTITION_ENFORCE_BOTH;
+			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_BOTH;
+		}
+	}
+
 	if (p_opts->qos) {
 		subn_verify_qos_set(&p_opts->qos_options, "qos");
 		subn_verify_qos_set(&p_opts->qos_ca_options, "qos_ca");
@@ -1551,8 +1574,13 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"#\n# PARTITIONING OPTIONS\n#\n"
 		"# Partition configuration file to be used\n"
 		"partition_config_file %s\n\n"
-		"# Disable partition enforcement by switches\n"
+		"# Disable partition enforcement by switches (DEPRECATED)\n"
+		"# This option is DEPRECATED. Please use part_enforce instead\n"
 		"no_partition_enforcement %s\n\n"
+		"# Partition enforcement type (for switches)\n"
+		"# Values are both, out, in and off\n"
+		"# Default is both (outbound and inbound enforcement)\n"
+		"part_enforce %s\n\n"
 		"# Allow both full and limited membership on the same partition\n"
 		"allow_both_pkeys %s\n\n"
 		"# SM assigned GUID byte where GUID is formed from OpenFabrics OUI\n"
@@ -1562,6 +1590,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"sm_assigned_guid 0x%02x\n\n",
 		p_opts->partition_config_file,
 		p_opts->no_partition_enforcement ? "TRUE" : "FALSE",
+		p_opts->part_enforce,
 		p_opts->allow_both_pkeys ? "TRUE" : "FALSE",
 		p_opts->sm_assigned_guid);
 
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
