From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for partition enforcement types
Date: Wed, 13 Jul 2011 17:09:42 +0300
Message-ID: <20110713140942.GC17818@localhost.localdomain>
References: <4E135D51.3080208@dev.mellanox.co.il>
 <20110710112626.GC8520@localhost.localdomain>
 <4E1AE7D6.9060209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E1AE7D6.9060209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 08:08 Mon 11 Jul     , Hal Rosenstock wrote:
> Hi Alex,
> 
> On 7/10/2011 7:26 AM, Alex Netes wrote:
> > Hi Hal,
> > 
> > On 14:52 Tue 05 Jul     , Hal Rosenstock wrote:
> >>
> >> Partition enforcement types are in, out, and both.
> >> Prior to this support, both was being used so that is the default.
> >>
> >> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> > 
> > Now we end up with two parameters for same functionality:
> > no_part_enforce - you define whether the enforcement is disabled or enabled.
> > part_enforcement_type - you define enforcement type: in/out/both.
> > 
> > When no_part_enforce is disabled, part_enforcement_type has no meaning.
> 
> Yes.
> 
> > Don't you find it simpler if we had only one option for partition enforcement
> > with 4 options: disabled/in/out/both(default)?
> 
> I didn't want to break backward compatibility with existing command line
> or option file.
> 
> If we were starting from scratch, it would be one option.

I think that besides backward compatibility, the usage should be kept simple.
Someone who is not familiar with opensm, may find this confusing.
Maybe we can replace no_part_enforce, with the new option for future versions
while marking it as deprecated meanwhile?
Bellow is mine suggestion.

---
 include/opensm/osm_subnet.h |   15 +++++++++++++++
 man/opensm.8.in             |   13 ++++++++++---
 opensm/main.c               |   31 ++++++++++++++++++++++++++++---
 opensm/osm_pkey_mgr.c       |   40 ++++++++++++++++++++++++----------------
 opensm/osm_subnet.c         |   32 ++++++++++++++++++++++++++++++--
 5 files changed, 107 insertions(+), 24 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 6d17c31..99f7f5e 100644
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
 
@@ -182,6 +195,8 @@ typedef struct osm_subn_opt {
 	unsigned long log_max_size;
 	char *partition_config_file;
 	boolean_t no_partition_enforcement;
+	char *part_enforce;
+	osm_partition_enforce_type_enum part_enforce_enum;
 	boolean_t qos;
 	char *qos_policy_file;
 	boolean_t accum_log_file;
diff --git a/man/opensm.8.in b/man/opensm.8.in
index f360739..94b3882 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -1,4 +1,4 @@
-.TH OPENSM 8 "November 3, 2010" "OpenIB" "OpenIB Management"
+.TH OPENSM 8 "July 5, 2011" "OpenIB" "OpenIB Management"
 
 .SH NAME
 opensm \- InfiniBand subnet manager and administration (SM/SA)
@@ -44,7 +44,8 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-f <log file path> | \-\-log_file <log file path> ]
 [\-L | \-\-log_limit <size in MB>] [\-e(rase_log_file)]
 [\-P(config) <partition config file> ]
-[\-N | \-\-no_part_enforce]
+[\-N | \-\-no_part_enforce] (DEPRECATED)
+[\-Z | \-\-part_enforce [both | in | out | off]]
 [\-Q | \-\-qos [\-Y | \-\-qos_policy_file <file name>]]
 [\-y | \-\-stay_on_fatal]
 [\-B | \-\-daemon]
@@ -363,9 +364,15 @@ name is \fB\%@OPENSM_CONFIG_DIR@/@QOS_POLICY_FILE@\fP. See
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
 \fB\-y\fR, \fB\-\-stay_on_fatal\fR
 This option will cause SM not to exit on fatal initialization
 issues: if SM discovers duplicated guids or a 12x link with
diff --git a/opensm/main.c b/opensm/main.c
index 798cb20..779cf4a 100644
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
@@ -318,8 +318,13 @@ static void show_usage(void)
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
 	printf("--qos, -Q\n" "          This option enables QoS setup.\n\n");
 	printf("--qos_policy_file, -Y <QoS-policy-file>\n"
 	       "          This option defines the optional QoS policy file.\n"
@@ -566,7 +571,7 @@ int main(int argc, char *argv[])
 	char *conf_template = NULL, *config_file = NULL;
 	uint32_t val;
 	const char *const short_option =
-	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:k:C:G:H:";
+	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:k:C:G:H:Z:";
 
 	/*
 	   In the array below, the 2nd parameter specifies the number
@@ -595,6 +600,7 @@ int main(int argc, char *argv[])
 		{"erase_log_file", 0, NULL, 'e'},
 		{"Pconfig", 1, NULL, 'P'},
 		{"no_part_enforce", 0, NULL, 'N'},
+		{"part_enforce", 1, NULL, 'Z'},
 		{"qos", 0, NULL, 'Q'},
 		{"qos_policy_file", 1, NULL, 'Y'},
 		{"maxsmps", 1, NULL, 'n'},
@@ -870,6 +876,25 @@ int main(int argc, char *argv[])
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
 		case 'Q':
 			opt.qos = TRUE;
 			break;
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index e6bf0d1..a98cca9 100644
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
@@ -182,16 +182,26 @@ pkey_mgr_update_pkey_entry(IN osm_sm_t * sm,
 
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
@@ -207,10 +217,9 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	       IB_SMP_DATA_SIZE - sizeof(ib_port_info_t));
 
 	p_pi = (ib_port_info_t *) payload;
-	if (enforce == TRUE)
-		p_pi->vl_enforce |= 0xc;
-	else
-		p_pi->vl_enforce &= ~0xc;
+	p_pi->vl_enforce &= ~0xc;
+	if (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF)
+		p_pi->vl_enforce |= enforce_bits;
 	p_pi->state_info2 = 0;
 	ib_port_info_set_port_state(p_pi, IB_LINK_NO_CHANGE);
 
@@ -436,7 +445,7 @@ static int update_peer_block(osm_log_t * p_log, osm_sm_t * sm,
 static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 				     const osm_subn_t * p_subn,
 				     const osm_port_t * const p_port,
-				     boolean_t enforce)
+				     osm_partition_enforce_type_enum enforce_type)
 {
 	osm_physp_t *p_physp, *peer;
 	osm_node_t *p_node;
@@ -461,8 +470,8 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (!p_node->sw || !p_node->sw->switch_info.enforce_cap)
 		return 0;
 
-	if (enforce == FALSE) {
-		pkey_mgr_enforce_partition(p_log, sm, peer, FALSE);
+	if (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF) {
+		pkey_mgr_enforce_partition(p_log, sm, peer, OSM_PARTITION_ENFORCE_TYPE_OFF);
 		return ret;
 	}
 
@@ -528,14 +537,14 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
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
@@ -545,7 +554,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 			cl_ntoh64(osm_node_get_node_guid(p_node)),
 			osm_physp_get_port_num(peer), p_node->print_desc);
 
-	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce))
+	if (pkey_mgr_enforce_partition(p_log, sm, peer, enforce_type))
 		ret = -1;
 
 	return ret;
@@ -599,8 +608,7 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
 		if ((osm_node_get_type(p_port->p_node) != IB_NODE_TYPE_SWITCH)
 		    && pkey_mgr_update_peer_port(&p_osm->log, &p_osm->sm,
 						 &p_osm->subn, p_port,
-						 !p_osm->subn.opt.
-						 no_partition_enforcement))
+						 p_osm->subn.opt.part_enforce_enum))
 			ret = -1;
 	}
 
@@ -624,7 +632,7 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
 				continue;
 
 			/* clear partition enforcement */
-			if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, FALSE))
+			if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, OSM_PARTITION_ENFORCE_TYPE_OFF))
 				ret = -1;
 		}
 	}
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 0b79d3a..907209a 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -342,6 +342,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "accum_log_file", OPT_OFFSET(accum_log_file), opts_parse_boolean, opts_setup_accum_log_file, 1 },
 	{ "partition_config_file", OPT_OFFSET(partition_config_file), opts_parse_charp, NULL, 0 },
 	{ "no_partition_enforcement", OPT_OFFSET(no_partition_enforcement), opts_parse_boolean, NULL, 1 },
+	{ "part_enforce", OPT_OFFSET(part_enforce), opts_parse_charp, NULL, 1 },
 	{ "qos", OPT_OFFSET(qos), opts_parse_boolean, NULL, 1 },
 	{ "qos_policy_file", OPT_OFFSET(qos_policy_file), opts_parse_charp, NULL, 0 },
 	{ "dump_files_dir", OPT_OFFSET(dump_files_dir), opts_parse_charp, NULL, 0 },
@@ -761,6 +762,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->log_max_size = 0;
 	p_opt->partition_config_file = strdup(OSM_DEFAULT_PARTITION_CONFIG_FILE);
 	p_opt->no_partition_enforcement = FALSE;
+	p_opt->part_enforce = OSM_PARTITION_ENFORCE_BOTH;
 	p_opt->qos = FALSE;
 	p_opt->qos_policy_file = strdup(OSM_DEFAULT_QOS_POLICY_FILE);
 	p_opt->accum_log_file = TRUE;
@@ -1129,6 +1131,27 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->console = OSM_DEFAULT_CONSOLE;
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
@@ -1372,9 +1395,14 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Partition configuration file to be used\n"
 		"partition_config_file %s\n\n"
 		"# Disable partition enforcement by switches\n"
-		"no_partition_enforcement %s\n\n",
+		"no_partition_enforcement %s\n\n"
+		"# Partition enforcement type (for switches)\n"
+		"# Values are both, out, and in\n"
+		"# Default is both (outbound and inbound enforcement)\n"
+		"part_enforce %s\n\n",
 		p_opts->partition_config_file,
-		p_opts->no_partition_enforcement ? "TRUE" : "FALSE");
+		p_opts->no_partition_enforcement ? "TRUE" : "FALSE",
+		p_opts->part_enforce);
 
 	fprintf(out,
 		"#\n# SWEEP OPTIONS\n#\n"
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
