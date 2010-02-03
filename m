From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] libibnetdisc: add ibnd_set_max_smps_on_wire call
Date: Tue, 2 Feb 2010 16:45:39 -0800
Message-ID: <20100202164539.8e597d96.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 2 Feb 2010 14:06:03 -0800
Subject: [PATCH] libibnetdisc: add ibnd_set_max_smps_on_wire call

        In addition update ibnetdiscover, iblinkinfo, and ibqueryerrors to use this function.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    1 +
 .../libibnetdisc/man/ibnd_discover_fabric.3        |    8 ++++++++
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   10 +++++++++-
 infiniband-diags/libibnetdisc/src/libibnetdisc.map |    1 +
 infiniband-diags/src/iblinkinfo.c                  |   10 ++++++++++
 infiniband-diags/src/ibnetdiscover.c               |   10 ++++++++++
 infiniband-diags/src/ibqueryerrors.c               |   10 ++++++++++
 7 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index b6a2899..556014e 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -158,6 +158,7 @@ typedef struct ibnd_fabric {
  */
 MAD_EXPORT void ibnd_debug(int i);
 MAD_EXPORT void ibnd_show_progress(int i);
+MAD_EXPORT int ibnd_set_max_smps_on_wire(int i);
 
 MAD_EXPORT ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 					       ib_portid_t * from, int hops);
diff --git a/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3 b/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
index dfeaf47..10e2729 100644
--- a/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
+++ b/infiniband-diags/libibnetdisc/man/ibnd_discover_fabric.3
@@ -9,6 +9,7 @@ ibnd_discover_fabric, ibnd_destroy_fabric, ibnd_debug ibnd_show_progress \- init
 .BI "void ibnd_destroy_fabric(ibnd_fabric_t *fabric)"
 .BI "void ibnd_debug(int i)"
 .BI "void ibnd_show_progress(int i)"
+.BI "int ibnd_set_max_smps_on_wire(int i)"
 .SH "DESCRIPTION"
 .B ibnd_discover_fabric()
 Discover the fabric connected to the port specified by ibmad_port, using a timeout specified.  The "from" and "hops" parameters are optional and allow one to scan part of a fabric by specifying a node "from" and a number of hops away from that node to scan, "hops".  This gives the user a "sub-fabric" which is "centered" anywhere they chose.
@@ -26,12 +27,19 @@ Set the debug level to be printed as library operations take place.
 Indicate that the library should print debug output which shows it's progress
 through the fabric.
 
+.B ibnd_set_max_smps_on_wire()
+Set the number of SMP\'s which will be issued on the wire simultaneously.
+
 .SH "RETURN VALUE"
 .B ibnd_discover_fabric()
 return NULL on failure, otherwise a valid ibnd_fabric_t object.
 
 .B ibnd_destory_fabric(), ibnd_debug()
 NONE
+
+.B ibnd_set_max_smps_on_wire()
+The previous value is returned
+
 .SH "EXAMPLES"
 
 .B Discover the entire fabric connected to device "mthca0", port 1.
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 7a9adbc..b084373 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -55,6 +55,7 @@
 #include "chassis.h"
 
 static int show_progress = 0;
+static int max_smps_on_wire = DEFAULT_MAX_SMP_ON_WIRE;
 int ibdebug;
 
 /* forward declare */
@@ -456,6 +457,13 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
+int ibnd_set_max_smps_on_wire(int i)
+{
+	int rc = max_smps_on_wire;
+	max_smps_on_wire = i;
+	return rc;
+}
+
 ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 				    ib_portid_t * from, int hops)
 {
@@ -488,7 +496,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 	memset(&(scan.selfportid), 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
 
-	smp_engine_init(&engine, ibmad_port, &scan, DEFAULT_MAX_SMP_ON_WIRE);
+	smp_engine_init(&engine, ibmad_port, &scan, max_smps_on_wire);
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
diff --git a/infiniband-diags/libibnetdisc/src/libibnetdisc.map b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
index 888bdd8..30f7ab9 100644
--- a/infiniband-diags/libibnetdisc/src/libibnetdisc.map
+++ b/infiniband-diags/libibnetdisc/src/libibnetdisc.map
@@ -16,5 +16,6 @@ IBNETDISC_1.0 {
 		ibnd_get_chassis_slot_str;
 		ibnd_iter_nodes;
 		ibnd_iter_nodes_type;
+		ibnd_set_max_smps_on_wire;
 	local: *;
 };
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index d6a0a09..1615492 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -67,6 +67,7 @@ static int down_links_only = 0;
 static int line_mode = 0;
 static int add_sw_settings = 0;
 static int print_port_guids = 0;
+static int outstanding_smps = 0; /* use default from lib */
 
 static unsigned int get_max(unsigned int num)
 {
@@ -261,6 +262,9 @@ static int process_opt(void *context, int ch, char *optarg)
 		break;
 	case 'R':		/* nop */
 		break;
+	case 'o':
+		outstanding_smps = atoi(optarg);
+		break;
 	default:
 		return -1;
 	}
@@ -297,6 +301,9 @@ int main(int argc, char **argv)
 		 "print port guids instead of node guids"},
 		{"load-cache", 2, 1, "<file>",
 		 "filename of ibnetdiscover cache to load"},
+		{"outstanding_smps", 'o', 1, NULL,
+		 "specify the number of outstanding SMP's which should be "
+		 "issued during the scan"},
 		{"GNDN", 'R', 0, NULL,
 		 "(This option is obsolete and does nothing)"},
 		{0}
@@ -324,6 +331,9 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
+	if (outstanding_smps)
+		ibnd_set_max_smps_on_wire(outstanding_smps);
+
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
 		exit(1);
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 651bafd..1ff8ef6 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -67,6 +67,7 @@ static char *cache_file = NULL;
 static char *load_cache_file = NULL;
 
 static int report_max_hops = 0;
+static int outstanding_smps = 0; /* use default from lib */
 
 /**
  * Define our own conversion functions to maintain compatibility with the old
@@ -648,6 +649,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'm':
 		report_max_hops = 1;
 		break;
+	case 'o':
+		outstanding_smps = atoi(optarg);
+		break;
 	default:
 		return -1;
 	}
@@ -677,6 +681,9 @@ int main(int argc, char **argv)
 		{"ports", 'p', 0, NULL, "obtain a ports report"},
 		{"max_hops", 'm', 0, NULL,
 		 "report max hops discovered by the library"},
+		{"outstanding_smps", 'o', 1, NULL,
+		 "specify the number of outstanding SMP's which should be "
+		 "issued during the scan"},
 		{0}
 	};
 	char usage_args[] = "[topology-file]";
@@ -704,6 +711,9 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
+	if (outstanding_smps)
+		ibnd_set_max_smps_on_wire(outstanding_smps);
+
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL)
 			IBERROR("loading cached fabric failed\n");
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 0b320ec..7e7b012 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -70,6 +70,7 @@ enum MAD_FIELDS suppressed_fields[SUP_MAX];
 char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
 unsigned clear_errors = 0, clear_counts = 0, details = 0;
+static int outstanding_smps = 0; /* use default from lib */
 
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
@@ -521,6 +522,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'K':
 		clear_counts = 1;
 		break;
+	case 'o':
+		outstanding_smps = atoi(optarg);
+		break;
 	default:
 		return -1;
 	}
@@ -565,6 +569,9 @@ int main(int argc, char **argv)
 		 "Clear data counters after read"},
 		{"load-cache", 7, 1, "<file>",
 		 "filename of ibnetdiscover cache to load"},
+		{"outstanding_smps", 'o', 1, NULL,
+		 "specify the number of outstanding SMP's which should be "
+		 "issued during the scan"},
 		{0}
 	};
 	char usage_args[] = "";
@@ -591,6 +598,9 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
+	if (outstanding_smps)
+		ibnd_set_max_smps_on_wire(outstanding_smps);
+
 	if (dr_path && load_cache_file) {
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
 		exit(1);
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
