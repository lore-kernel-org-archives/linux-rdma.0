From: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH V2] opensm: Add option to specify prefix to syslog messages
Date: Mon, 08 Feb 2010 21:26:50 -0800
Message-ID: <4B70F21A.2090101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added the option 'log_prefix' that allows users to specify a prefix to
syslog messages from OpenSM.
For example, in a dual-fabric (or dual-rail) IB cluster, the prefix for
the first fabric could be "mpi" and the other fabric could be "storage".
This helps users to identify the subnet in the syslog messages when
two or more instances of OpenSM run in a single node to manage multiple
fabrics.

Summary of changes:
 o Added the option 'log_prefix' to OpenSM command line and config file.
 o Enhanced OpenSM logging facility to include the specified prefix in
   syslog messages.

Signed-off-by: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
---
diff -rup a/include/opensm/osm_log.h b/include/opensm/osm_log.h
--- a/include/opensm/osm_log.h	2010-01-18 21:32:12.195328129 -0800
+++ b/include/opensm/osm_log.h	2010-01-28 07:21:39.617882774 -0800
@@ -120,6 +120,7 @@ typedef struct osm_log {
 	boolean_t accum_log_file;
 	boolean_t daemon;
 	char *log_file_name;
+	char *log_prefix;
 } osm_log_t;
 /*********/
 
diff -rup a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
--- a/include/opensm/osm_subnet.h	2010-01-18 21:32:12.195328129 -0800
+++ b/include/opensm/osm_subnet.h	2010-01-28 07:21:53.702143886 -0800
@@ -224,6 +224,7 @@ typedef struct osm_subn_opt {
 	char *event_plugin_name;
 	char *node_name_map_name;
 	char *prefix_routes_file;
+	char *log_prefix;
 	boolean_t consolidate_ipv6_snm_req;
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
diff -rup a/man/opensm.8.in b/man/opensm.8.in
--- a/man/opensm.8.in	2010-01-19 11:29:03.954832199 -0800
+++ b/man/opensm.8.in	2010-02-08 16:06:52.816907526 -0800
@@ -49,6 +49,7 @@ opensm \- InfiniBand subnet manager and 
 [\-\-perfmgr_sweep_time_s <seconds>]
 [\-\-prefix_routes_file <path>]
 [\-\-consolidate_ipv6_snm_req]
+[\-\-log_prefix <prefix text>]
 [\-v(erbose)] [\-V] [\-D <flags>] [\-d(ebug) <number>]
 [\-h(elp)] [\-?]
 
@@ -345,6 +346,13 @@ effect if --enable-perfmgr was specified
 Use shared MLID for IPv6 Solicited Node Multicast groups per MGID scope
 and P_Key.
 .TP
+\fB\-\-log_prefix\fR <prefix text>
+This option specifies the prefix to the syslog messages from OpenSM.
+A suitable prefix can be used to identify the IB subnet in syslog messages
+when two or more instances of OpenSM run in a single node to manage multiple
+fabrics. For example, in a dual-fabric (or dual-rail) IB cluster, the prefix
+for the first fabric could be "mpi" and the other fabric could be "storage".
+.TP
 \fB\-v\fR, \fB\-\-verbose\fR
 This option increases the log verbosity level.
 The -v option may be specified multiple times
diff -rup a/opensm/main.c b/opensm/main.c
--- a/opensm/main.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/main.c	2010-02-05 19:23:01.736046042 -0800
@@ -324,6 +324,8 @@ static void show_usage(void)
 	printf("--consolidate_ipv6_snm_req\n"
 	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
 	       "          per MGID scope and P_Key.\n\n");
+	printf("--log_prefix <prefix text>\n"
+	       "          Prefix to syslog messages from OpenSM.\n\n");
 	printf("--verbose, -v\n"
 	       "          This option increases the log verbosity level.\n"
 	       "          The -v option may be specified multiple times\n"
@@ -607,6 +609,7 @@ int main(int argc, char *argv[])
 		{"lash_start_vl", 1, NULL, 6},
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
+		{"log_prefix", 1, NULL, 9},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -985,6 +988,11 @@ int main(int argc, char *argv[])
 			printf(" Transaction retries = %u\n",
 			       opt.transaction_retries);
 			break;
+		case 9:
+			SET_STR_OPT(opt.log_prefix, optarg);
+			printf("Log prefix = %s\n",
+			       opt.log_prefix);
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff -rup a/opensm/osm_log.c b/opensm/osm_log.c
--- a/opensm/osm_log.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_log.c	2010-02-08 19:31:22.249010867 -0800
@@ -123,7 +123,13 @@ void osm_log(IN osm_log_t * p_log, IN os
 		return;
 
 	va_start(args, p_str);
-	vsprintf(buffer, p_str, args);
+	if (p_log->log_prefix == NULL) {
+		vsprintf(buffer, p_str, args);
+	}
+	else {
+		int n = snprintf(buffer, sizeof(buffer), "%s: ", p_log->log_prefix);
+		vsprintf(buffer + n, p_str, args);
+	}
 	va_end(args);
 
 	/* this is a call to the syslog */
diff -rup a/opensm/osm_opensm.c b/opensm/osm_opensm.c
--- a/opensm/osm_opensm.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_opensm.c	2010-01-28 07:20:40.204781351 -0800
@@ -337,6 +337,7 @@ ib_api_status_t osm_opensm_init(IN osm_o
 				 p_opt->log_max_size, p_opt->accum_log_file);
 	if (status != IB_SUCCESS)
 		return status;
+	p_osm->log.log_prefix = p_opt->log_prefix;
 
 	/* If there is a log level defined - add the OSM_VERSION to it */
 	osm_log(&p_osm->log,
diff -rup a/opensm/osm_subnet.c b/opensm/osm_subnet.c
--- a/opensm/osm_subnet.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_subnet.c	2010-02-08 19:36:04.090346291 -0800
@@ -395,6 +395,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
+	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
 	{0}
 };
 
@@ -762,6 +763,7 @@ void osm_subn_set_default_opt(IN osm_sub
 	p_opt->consolidate_ipv6_snm_req = FALSE;
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
+	p_opt->log_prefix = NULL;
 	subn_init_qos_options(&p_opt->qos_options, NULL);
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
 	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
@@ -1629,6 +1631,11 @@ int osm_subn_output_conf(FILE *out, IN o
 		"consolidate_ipv6_snm_req %s\n\n",
 		p_opts->consolidate_ipv6_snm_req ? "TRUE" : "FALSE");
 
+	fprintf(out,
+		"# Log prefix\n"
+		"log_prefix %s\n\n",
+		p_opts->log_prefix);
+
 	/* optional string attributes ... */
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
