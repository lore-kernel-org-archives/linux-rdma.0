From: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH] opensm: Add a name to IB subnet and include it in syslog
 messages
Date: Thu, 21 Jan 2010 14:16:21 -0800
Message-ID: <4B58D235.2020409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added a text based name to an IB subnet to help user in identifying
an IB subnet or understanding its function in a multi-fabric IB cluster.
For example, in a dual-fabric (or dual-rail) IB cluster, one subnet
could be named "mpi" and the other subnet could be named "storage".

Summary of changes:
 o Added the option 'subnet_name' to OpenSM command line and config file.
 o Enhanced OpenSM logging facility to include the subnet name in
   syslog messages.

Signed-off-by: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
---
diff -rup a/include/opensm/osm_log.h b/include/opensm/osm_log.h
--- a/include/opensm/osm_log.h	2010-01-18 21:32:12.195328129 -0800
+++ b/include/opensm/osm_log.h	2010-01-18 21:34:46.573932164 -0800
@@ -120,6 +120,7 @@ typedef struct osm_log {
 	boolean_t accum_log_file;
 	boolean_t daemon;
 	char *log_file_name;
+	char *subnet_name;
 } osm_log_t;
 /*********/
 
diff -rup a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
--- a/include/opensm/osm_subnet.h	2010-01-18 21:32:12.195328129 -0800
+++ b/include/opensm/osm_subnet.h	2010-01-18 21:34:55.782087826 -0800
@@ -224,6 +224,7 @@ typedef struct osm_subn_opt {
 	char *event_plugin_name;
 	char *node_name_map_name;
 	char *prefix_routes_file;
+	char *subnet_name;
 	boolean_t consolidate_ipv6_snm_req;
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
diff -rup a/man/opensm.8.in b/man/opensm.8.in
--- a/man/opensm.8.in	2010-01-19 11:29:03.954832199 -0800
+++ b/man/opensm.8.in	2010-01-21 10:56:58.901836423 -0800
@@ -49,6 +49,7 @@ opensm \- InfiniBand subnet manager and 
 [\-\-perfmgr_sweep_time_s <seconds>]
 [\-\-prefix_routes_file <path>]
 [\-\-consolidate_ipv6_snm_req]
+[\-\-subnet_name <subnet name>]
 [\-v(erbose)] [\-V] [\-D <flags>] [\-d(ebug) <number>]
 [\-h(elp)] [\-?]
 
@@ -345,6 +346,9 @@ effect if --enable-perfmgr was specified
 Use shared MLID for IPv6 Solicited Node Multicast groups per MGID scope
 and P_Key.
 .TP
+\fB\-\-subnet_name\fR <subnet name>
+This option specifies the text based name of the subnet.
+.TP
 \fB\-v\fR, \fB\-\-verbose\fR
 This option increases the log verbosity level.
 The -v option may be specified multiple times
diff -rup a/opensm/main.c b/opensm/main.c
--- a/opensm/main.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/main.c	2010-01-19 11:51:45.566967909 -0800
@@ -324,6 +324,8 @@ static void show_usage(void)
 	printf("--consolidate_ipv6_snm_req\n"
 	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
 	       "          per MGID scope and P_Key.\n\n");
+	printf("--subnet_name <subnet name>\n"
+	       "          Text based name of the IB subnet.\n\n");
 	printf("--verbose, -v\n"
 	       "          This option increases the log verbosity level.\n"
 	       "          The -v option may be specified multiple times\n"
@@ -607,6 +609,7 @@ int main(int argc, char *argv[])
 		{"lash_start_vl", 1, NULL, 6},
 		{"sm_sl", 1, NULL, 7},
 		{"retries", 1, NULL, 8},
+		{"subnet_name", 1, NULL, 9},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -985,6 +988,11 @@ int main(int argc, char *argv[])
 			printf(" Transaction retries = %u\n",
 			       opt.transaction_retries);
 			break;
+		case 9:
+			SET_STR_OPT(opt.subnet_name, optarg);
+			printf("IB subnet name = %s\n",
+			       opt.subnet_name);
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff -rup a/opensm/osm_log.c b/opensm/osm_log.c
--- a/opensm/osm_log.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_log.c	2010-01-18 21:33:47.808939648 -0800
@@ -107,6 +107,7 @@ void osm_log(IN osm_log_t * p_log, IN os
 	char buffer[LOG_ENTRY_SIZE_MAX];
 	va_list args;
 	int ret;
+	uint8_t ind = 0;
 #ifdef __WIN__
 	SYSTEMTIME st;
 	uint32_t pid = GetCurrentThreadId();
@@ -123,7 +124,14 @@ void osm_log(IN osm_log_t * p_log, IN os
 		return;
 
 	va_start(args, p_str);
-	vsprintf(buffer, p_str, args);
+	if(p_log->subnet_name) {
+		snprintf(buffer, LOG_ENTRY_SIZE_MAX, "%s: ", p_log->subnet_name);
+		ind = strlen(buffer);
+		vsprintf(&buffer[ind], p_str, args);
+	}
+	else {
+		vsprintf(buffer, p_str, args);
+	}
 	va_end(args);
 
 	/* this is a call to the syslog */
diff -rup a/opensm/osm_opensm.c b/opensm/osm_opensm.c
--- a/opensm/osm_opensm.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_opensm.c	2010-01-18 21:34:00.125147535 -0800
@@ -337,6 +337,7 @@ ib_api_status_t osm_opensm_init(IN osm_o
 				 p_opt->log_max_size, p_opt->accum_log_file);
 	if (status != IB_SUCCESS)
 		return status;
+	p_osm->log.subnet_name = p_opt->subnet_name;
 
 	/* If there is a log level defined - add the OSM_VERSION to it */
 	osm_log(&p_osm->log,
diff -rup a/opensm/osm_subnet.c b/opensm/osm_subnet.c
--- a/opensm/osm_subnet.c	2010-01-18 21:31:43.318842260 -0800
+++ b/opensm/osm_subnet.c	2010-01-18 21:34:10.833328335 -0800
@@ -395,6 +395,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "consolidate_ipv6_snm_req", OPT_OFFSET(consolidate_ipv6_snm_req), opts_parse_boolean, NULL, 1 },
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
+	{ "subnet_name", OPT_OFFSET(subnet_name), opts_parse_charp, NULL, 1 },
 	{0}
 };
 
@@ -1629,6 +1630,11 @@ int osm_subn_output_conf(FILE *out, IN o
 		"consolidate_ipv6_snm_req %s\n\n",
 		p_opts->consolidate_ipv6_snm_req ? "TRUE" : "FALSE");
 
+	fprintf(out,
+		"# Subnet name\n"
+		"subnet_name %s\n\n",
+		p_opts->subnet_name);
+
 	/* optional string attributes ... */
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
