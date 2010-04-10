From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2] libibnetdisc: config struct for ibnd_discover_fabric()
Date: Sat, 10 Apr 2010 04:41:22 +0300
Message-ID: <20100410014122.GQ4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
 <20100410005752.GL4808@me>
 <20100410005819.GM4808@me>
 <20100410005857.GN4808@me>
 <20100410010050.GO4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410010050.GO4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Instead of using static configuration parameters/flags and to have API
functions to set up each one (and so add new API when any new flag is
added) use just single configuration structure which is reenterently
passed by to ibnd_fabric_discover() function.

In order to not change API a lot we will keep some "padding" space in
this configuration structure, so it will be extendable for future
parameters/flags.

Remove old config related functions.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
v2 - proper scan.cfg initialization (in ibnd_discover_fabric())

 .../libibnetdisc/include/infiniband/ibnetdisc.h    |   14 ++++--
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   48 +++++---------------
 infiniband-diags/libibnetdisc/src/internal.h       |    2 +-
 infiniband-diags/libibnetdisc/src/libibnetdisc.map |    3 -
 infiniband-diags/libibnetdisc/test/testleaks.c     |   23 ++++-----
 infiniband-diags/src/iblinkinfo.c                  |   22 +++------
 infiniband-diags/src/ibnetdiscover.c               |   17 +++-----
 infiniband-diags/src/ibqueryerrors.c               |   17 +++-----
 8 files changed, 52 insertions(+), 94 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 8c38c94..136282c 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -129,6 +129,14 @@ typedef struct ibnd_chassis {
 
 #define HTSZ 137
 
+typedef struct ibnd_config {
+	unsigned max_smps;
+	unsigned show_progress;
+	unsigned max_hops;
+	unsigned debug;
+	uint8_t pad[64];
+} ibnd_config_t;
+
 /** =========================================================================
  * Fabric
  * Main fabric object which is returned and represents the data discovered
@@ -157,12 +165,10 @@ typedef struct ibnd_fabric {
 /** =========================================================================
  * Initialization (fabric operations)
  */
-MAD_EXPORT void ibnd_debug(int i);
-MAD_EXPORT void ibnd_show_progress(int i);
-MAD_EXPORT int ibnd_set_max_smps_on_wire(int i);
 
 MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
-					       ib_portid_t * from, int hops);
+					       ib_portid_t * from,
+					       struct ibnd_config *config);
 	/**
 	 * open: (required) ibmad_port object from libibmad
 	 * from: (optional) specify the node to start scanning from.
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 03b678e..0762867 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -54,10 +54,6 @@
 #include "internal.h"
 #include "chassis.h"
 
-static int show_progress = 0;
-static int max_smps_on_wire = DEFAULT_MAX_SMP_ON_WIRE;
-int ibdebug;
-
 /* forward declare */
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
 			   ibnd_node_t * node);
@@ -96,7 +92,8 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 	ibnd_scan_t *scan = engine->user_data;
 	ibnd_fabric_t *fabric = scan->fabric;
 
-	if (scan->max_hops && fabric->maxhops_discovered >= scan->max_hops)
+	if (scan->cfg->max_hops &&
+	    fabric->maxhops_discovered >= scan->cfg->max_hops)
 		return 0;
 
 	if (portid->lid) {
@@ -289,7 +286,8 @@ static void dump_endnode(ib_portid_t * path, char *prompt,
 static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	ibnd_scan_t *scan = engine->user_data;
+	ibnd_fabric_t *fabric = scan->fabric;
 	int i = 0;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
 	ibnd_node_t *rem_node = cb_data;
@@ -319,7 +317,7 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	}
 	port->guid = port_guid;
 
-	if (show_progress)
+	if (scan->cfg->show_progress)
 		dump_endnode(&smp->path, node_is_new ? "new" : "known",
 			     node, port);
 
@@ -463,16 +461,10 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-int ibnd_set_max_smps_on_wire(int i)
-{
-	int rc = max_smps_on_wire;
-	max_smps_on_wire = i;
-	return rc;
-}
-
-ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
-				    ib_portid_t * from, int hops)
+ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
+				    ib_portid_t * from, struct ibnd_config *cfg)
 {
+	struct ibnd_config default_config = { 0 };
 	ibnd_fabric_t *fabric = NULL;
 	ib_portid_t my_portid = { 0 };
 	smp_engine_t engine;
@@ -495,10 +487,10 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
-	if (hops >= 0)
-		scan.max_hops = hops;
+	scan.cfg = cfg ? cfg : &default_config;
 
-	smp_engine_init(&engine, ibmad_port, &scan, max_smps_on_wire);
+	smp_engine_init(&engine, ibmad_port, &scan, cfg->max_smps ?
+			cfg->max_smps : DEFAULT_MAX_SMP_ON_WIRE);
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
@@ -555,24 +547,6 @@ void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
 	free(fabric);
 }
 
-void ibnd_debug(int i)
-{
-	if (i) {
-		ibdebug++;
-		madrpc_show_errors(1);
-		umad_debug(i);
-	} else {
-		ibdebug = 0;
-		madrpc_show_errors(0);
-		umad_debug(0);
-	}
-}
-
-void ibnd_show_progress(int i)
-{
-	show_progress = i;
-}
-
 void ibnd_iter_nodes(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
 		     void *user_data)
 {
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index d2d4826..57034f9 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -58,7 +58,7 @@
 typedef struct ibnd_scan {
 	ib_portid_t selfportid;
 	ibnd_fabric_t *fabric;
-	unsigned max_hops;
+	struct ibnd_config *cfg;
 } ibnd_scan_t;
 
 typedef struct ibnd_smp ibnd_smp_t;
diff --git a/infiniband-diags/libibnetdisc/src/libibnetdisc.map b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
index 30f7ab9..8a56fbb 100644
--- a/infiniband-diags/libibnetdisc/src/libibnetdisc.map
+++ b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
@@ -1,7 +1,5 @@
 IBNETDISC_1.0 {
 	global:
-		ibnd_debug;
-		ibnd_show_progress;
 		ibnd_discover_fabric;
 		ibnd_destroy_fabric;
 		ibnd_load_fabric;
@@ -16,6 +14,5 @@ IBNETDISC_1.0 {
 		ibnd_get_chassis_slot_str;
 		ibnd_iter_nodes;
 		ibnd_iter_nodes_type;
-		ibnd_set_max_smps_on_wire;
 	local: *;
 };
diff --git a/infiniband-diags/libibnetdisc/test/testleaks.c b/infiniband-diags/libibnetdisc/test/testleaks.c
index cb5651e..da2fc0a 100644
--- a/infiniband-diags/libibnetdisc/test/testleaks.c
+++ b/infiniband-diags/libibnetdisc/test/testleaks.c
@@ -77,6 +77,7 @@ void usage(void)
 
 int main(int argc, char **argv)
 {
+	struct ibnd_config config = { 0 };
 	int rc = 0;
 	char *ca = 0;
 	int ca_port = 0;
@@ -84,7 +85,6 @@ int main(int argc, char **argv)
 	uint64_t guid = 0;
 	char *dr_path = NULL;
 	char *from = NULL;
-	int hops = 0;
 	ib_portid_t port_id;
 	int iters = -1;
 
@@ -118,7 +118,7 @@ int main(int argc, char **argv)
 			break;
 		switch (ch) {
 		case 2:
-			ibnd_debug(1);
+			config.debug++;
 			break;
 		case 'f':
 			from = strdup(optarg);
@@ -133,7 +133,7 @@ int main(int argc, char **argv)
 			dr_path = strdup(optarg);
 			break;
 		case 'n':
-			hops = (int)strtol(optarg, NULL, 0);
+			config.max_hops = strtoul(optarg, NULL, 0);
 			break;
 		case 'i':
 			iters = (int)strtol(optarg, NULL, 0);
@@ -161,21 +161,18 @@ int main(int argc, char **argv)
 			/* only scan part of the fabric */
 			str2drpath(&(port_id.drpath), from, 0, 0);
 			if ((fabric = ibnd_discover_fabric(ibmad_port,
-							   &port_id,
-							   hops)) == NULL) {
+							   &port_id, &config))
+			    == NULL) {
 				fprintf(stderr, "discover failed\n");
 				rc = 1;
 				goto close_port;
 			}
 			guid = 0;
-		} else {
-			if ((fabric =
-			     ibnd_discover_fabric(ibmad_port, NULL,
-						  -1)) == NULL) {
-				fprintf(stderr, "discover failed\n");
-				rc = 1;
-				goto close_port;
-			}
+		} else if ((fabric = ibnd_discover_fabric(ibmad_port, NULL,
+							  &config)) == NULL) {
+			fprintf(stderr, "discover failed\n");
+			rc = 1;
+			goto close_port;
 		}
 
 		ibnd_destroy_fabric(fabric);
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index 5627dc9..029573f 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -61,13 +61,11 @@ static uint64_t guid = 0;
 static char *guid_str = NULL;
 static char *dr_path = NULL;
 static int all = 0;
-static int hops = 0;
 
 static int down_links_only = 0;
 static int line_mode = 0;
 static int add_sw_settings = 0;
 static int print_port_guids = 0;
-static int outstanding_smps = 0; /* use default from lib */
 
 static unsigned int get_max(unsigned int num)
 {
@@ -242,6 +240,7 @@ void print_switch(ibnd_node_t * node, void *user_data)
 
 static int process_opt(void *context, int ch, char *optarg)
 {
+	struct ibnd_config *cfg = context;
 	switch (ch) {
 	case 1:
 		node_name_map_file = strdup(optarg);
@@ -260,7 +259,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		all = 1;
 		break;
 	case 'n':
-		hops = (int)strtol(optarg, NULL, 0);
+		cfg->max_hops = strtoul(optarg, NULL, 0);
 		break;
 	case 'd':
 		down_links_only = 1;
@@ -277,7 +276,7 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'R':		/* nop */
 		break;
 	case 'o':
-		outstanding_smps = atoi(optarg);
+		cfg->max_smps = strtoul(optarg, NULL, 0);
 		break;
 	default:
 		return -1;
@@ -288,6 +287,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
+	struct ibnd_config config = { 0 };
 	int rc = 0;
 	int resolved = -1;
 	ibnd_fabric_t *fabric = NULL;
@@ -324,15 +324,12 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "";
 
-	ibdiag_process_opts(argc, argv, NULL, "SDandlpgRGL", opts, process_opt,
-			    usage_args, NULL);
+	ibdiag_process_opts(argc, argv, &config, "SDandlpgRGL", opts,
+			    process_opt, usage_args, NULL);
 
 	argc -= optind;
 	argv += optind;
 
-	if (ibverbose)
-		ibnd_debug(1);
-
 	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 3);
 	if (!ibmad_port) {
 		fprintf(stderr, "Failed to open %s port %d", ibd_ca,
@@ -345,9 +342,6 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
-	if (outstanding_smps)
-		ibnd_set_max_smps_on_wire(outstanding_smps);
-
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
 		exit(1);
@@ -377,12 +371,12 @@ int main(int argc, char **argv)
 	} else {
 		if (resolved >= 0 &&
 		    !(fabric =
-		      ibnd_discover_fabric(ibmad_port, &port_id, hops)))
+		      ibnd_discover_fabric(ibmad_port, &port_id, &config)))
 			IBWARN("Single node discover failed;"
 			       " attempting full scan\n");
 
 		if (!fabric &&
-		    !(fabric = ibnd_discover_fabric(ibmad_port, NULL, -1))) {
+		    !(fabric = ibnd_discover_fabric(ibmad_port, NULL, &config))) {
 			fprintf(stderr, "discover failed\n");
 			rc = 1;
 			goto close_port;
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 32776ad..f40d0f9 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -67,7 +67,6 @@ static char *cache_file = NULL;
 static char *load_cache_file = NULL;
 
 static int report_max_hops = 0;
-static int outstanding_smps = 0; /* use default from lib */
 
 /**
  * Define our own conversion functions to maintain compatibility with the old
@@ -616,6 +615,7 @@ static int list, group, ports_report;
 
 static int process_opt(void *context, int ch, char *optarg)
 {
+	struct ibnd_config *cfg = context;
 	switch (ch) {
 	case 1:
 		node_name_map_file = strdup(optarg);
@@ -627,7 +627,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		load_cache_file = strdup(optarg);
 		break;
 	case 's':
-		ibnd_show_progress(1);
+		cfg->show_progress = 1;
 		break;
 	case 'l':
 		list = LIST_CA_NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
@@ -651,7 +651,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		report_max_hops = 1;
 		break;
 	case 'o':
-		outstanding_smps = atoi(optarg);
+		cfg->max_smps = strtoul(optarg, NULL, 0);
 		break;
 	default:
 		return -1;
@@ -662,6 +662,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
+	struct ibnd_config config = { 0 };
 	ibnd_fabric_t *fabric = NULL;
 
 	struct ibmad_port *ibmad_port;
@@ -689,7 +690,7 @@ int main(int argc, char **argv)
 	};
 	char usage_args[] = "[topology-file]";
 
-	ibdiag_process_opts(argc, argv, NULL, "sGDL", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &config, "sGDL", opts, process_opt,
 			    usage_args, NULL);
 
 	f = stdout;
@@ -697,9 +698,6 @@ int main(int argc, char **argv)
 	argc -= optind;
 	argv += optind;
 
-	if (ibverbose)
-		ibnd_debug(1);
-
 	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 2);
 	if (!ibmad_port)
 		IBERROR("Failed to open %s port %d", ibd_ca, ibd_ca_port);
@@ -712,15 +710,12 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
-	if (outstanding_smps)
-		ibnd_set_max_smps_on_wire(outstanding_smps);
-
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL)
 			IBERROR("loading cached fabric failed\n");
 	} else {
 		if ((fabric =
-		     ibnd_discover_fabric(ibmad_port, NULL, -1)) == NULL)
+		     ibnd_discover_fabric(ibmad_port, NULL, &config)) == NULL)
 			IBERROR("discover failed\n");
 	}
 
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 725e098..e896254 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -70,7 +70,6 @@ enum MAD_FIELDS suppressed_fields[SUP_MAX];
 char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
 unsigned clear_errors = 0, clear_counts = 0, details = 0;
-static int outstanding_smps = 0; /* use default from lib */
 
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
@@ -483,6 +482,7 @@ static void calculate_suppressed_fields(char *str)
 
 static int process_opt(void *context, int ch, char *optarg)
 {
+	struct ibnd_config *cfg = context;
 	switch (ch) {
 	case 's':
 		calculate_suppressed_fields(optarg);
@@ -532,7 +532,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		clear_counts = 1;
 		break;
 	case 'o':
-		outstanding_smps = atoi(optarg);
+		cfg->max_smps = strtoul(optarg, NULL, 0);
 		break;
 	default:
 		return -1;
@@ -543,6 +543,7 @@ static int process_opt(void *context, int ch, char *optarg)
 
 int main(int argc, char **argv)
 {
+	struct ibnd_config config = { 0 };
 	int resolved = -1;
 	ib_portid_t portid = { 0 };
 	int rc = 0;
@@ -586,7 +587,7 @@ int main(int argc, char **argv)
 	char usage_args[] = "";
 
 	memset(suppressed_fields, 0, sizeof suppressed_fields);
-	ibdiag_process_opts(argc, argv, NULL, "scnSrRDGL", opts, process_opt,
+	ibdiag_process_opts(argc, argv, &config, "scnSrRDGL", opts, process_opt,
 			    usage_args, NULL);
 
 	argc -= optind;
@@ -595,9 +596,6 @@ int main(int argc, char **argv)
 	if (!node_type_to_print)
 		node_type_to_print = PRINT_ALL;
 
-	if (ibverbose)
-		ibnd_debug(1);
-
 	ibmad_port = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
 	if (!ibmad_port)
 		IBERROR("Failed to open port; %s:%d\n", ibd_ca, ibd_ca_port);
@@ -607,9 +605,6 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
-	if (outstanding_smps)
-		ibnd_set_max_smps_on_wire(outstanding_smps);
-
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
 		exit(1);
@@ -642,8 +637,8 @@ int main(int argc, char **argv)
 			IBWARN("Single node discover failed;"
 			       " attempting full scan");
 
-		if (!fabric &&
-		    !(fabric = ibnd_discover_fabric(ibmad_port, NULL, -1))) {
+		if (!fabric && !(fabric = ibnd_discover_fabric(ibmad_port, NULL,
+							       &config))) {
 			fprintf(stderr, "discover failed\n");
 			rc = 1;
 			goto close_port;
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
