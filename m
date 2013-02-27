From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv3] infiniband-diags/ibqueryerrors.c: obtain destination sl
 before perf query
Date: Wed, 27 Feb 2013 16:10:32 +0200
Message-ID: <20130227141032.GA9919@r-ufm5-17.mtr.labs.mlnx>
References: <20130220115807.GC20018@r-ufm5-17.lab.mtl.com>
 <20130224082140.GA11648@r-ufm5-17.lab.mtl.com>
 <20130226170744.53adb74b6af9a54d9481dd4c@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130226170744.53adb74b6af9a54d9481dd4c-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

1) if use -G or -D option : we obtain sl before doing perf query.
2) if no destination is given : we obtain sl for every pair source-destination.
3) if no destination is given and use --skip-sl option : we don't obtain
sl to all nodes in the fabric,in this case sl=0 for all node pairs.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v2:
	1.Skip-sl option will apply to 1 and 2.
	2.Update documentation doc/rst/ibqueryerrors.8.in.rst
	3.Pop the resolve_self call to be before the check for dr_path. 
	4.Add new variable self_portid for the usage of resolve_self only.
	5.Change "goto close_port" into "goto destroy_fabric" if fabric object
	  is created.

 doc/rst/ibqueryerrors.8.in.rst |    2 +
 src/ibqueryerrors.c            |   81 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/doc/rst/ibqueryerrors.8.in.rst b/doc/rst/ibqueryerrors.8.in.rst
index 9a05e7b..b910368 100644
--- a/doc/rst/ibqueryerrors.8.in.rst
+++ b/doc/rst/ibqueryerrors.8.in.rst
@@ -52,6 +52,8 @@ Specify an alternate threshold file.  The default is @IBDIAG_CONFIG_PATH@/error_
 
 **--ca**  print data for CA's only
 
+**--skip-sl**  Use the default sl for queries
+
 **--router**  print data for routers only
 
 **--clear-errors -k** Clear error counters after read.
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 6320972..6d17497 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -55,11 +55,14 @@
 #include <infiniband/mad.h>
 
 #include "ibdiag_common.h"
+#include "ibdiag_sa.h"
 
 struct ibmad_port *ibmad_port;
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
 static char *load_cache_file = NULL;
+static uint16_t lid2sl_table[sizeof(uint8_t) * 1024 * 48] = { 0 };
+static int obtain_sl = 1;
 
 int data_counters = 0;
 int data_counters_only = 0;
@@ -78,6 +81,8 @@ unsigned clear_errors = 0, clear_counts = 0, details = 0;
 #define PRINT_ROUTER 0x4
 #define PRINT_ALL 0xFF		/* all nodes default flag */
 
+#define DEFAULT_HALF_WORLD_PR_TIMEOUT (3000)
+
 struct {
 	int nodes_checked;
 	int bad_nodes;
@@ -298,6 +303,51 @@ static int print_summary(void)
 	return (summary.bad_ports);
 }
 
+static void insert_lid2sl_table(struct sa_query_result *r)
+{
+	unsigned int i;
+	for (i = 0; i < r->result_cnt; i++) {
+		ib_path_rec_t *p_pr = (ib_path_rec_t *)sa_get_query_rec(r->p_result_madw, i);
+		lid2sl_table[cl_ntoh16(p_pr->dlid)] = ib_path_rec_sl(p_pr);
+	}
+}
+
+static int path_record_query(int src_lid,int dest_lid)
+{
+	ib_path_rec_t pr;
+	ib_net64_t comp_mask = 0;
+	uint8_t reversible = 0;
+	struct sa_handle * h;
+
+	h = sa_get_handle();
+	ibd_timeout = DEFAULT_HALF_WORLD_PR_TIMEOUT;
+	memset(&pr, 0, sizeof(pr));
+
+	CHECK_AND_SET_VAL(src_lid, 16, 0, pr.slid, PR, SLID);
+	CHECK_AND_SET_VAL(dest_lid, 16, 0, pr.dlid, PR, DLID);/*if dlid is 0 then we do half world query*/
+	CHECK_AND_SET_VAL(1, 8, -1, pr.num_path, PR, NUMBPATH);/*to get only one PathRecord for each source and destination pair*/
+	CHECK_AND_SET_VAL(1, 8, -1, reversible, PR, REVERSIBLE);/*for a reversible path*/
+	pr.num_path |= reversible << 7;
+	struct sa_query_result result;
+	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE,
+			   (uint16_t)IB_SA_ATTR_PATHRECORD,0,cl_ntoh64(comp_mask),ibd_sakey,
+			   &pr, sizeof(pr), &result);
+	if (ret) {
+		fprintf(stderr, "Query SA failed: %s; sa call path_query failed\n", strerror(ret));
+		return ret;
+	}
+	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
+		sa_report_err(result.status);
+		ret = EIO;
+		goto Exit;
+	}
+
+	insert_lid2sl_table(&result);
+Exit:
+	sa_free_result_mad(&result);
+	return ret;
+}
+
 static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 			  ibnd_node_t * node, char *node_name, int portnum,
 			  const char *attr_name, uint16_t attr_id,
@@ -447,6 +497,8 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 	uint8_t pc[1024] = { 0 };
 	uint16_t rc_cap_mask;
 
+	portid->sl = lid2sl_table[portid->lid];
+
 	/* PerfMgt ClassPortInfo is a required attribute */
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout, CLASS_PORT_INFO,
 			   ibmad_port)) {
@@ -474,6 +526,8 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 
 	memset(pc, 0, 1024);
 
+	portid->sl = lid2sl_table[portid->lid];
+
 	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
 		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
 				   IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
@@ -543,6 +597,8 @@ static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
 	memset(pc, 0, 1024);
 	memset(pce, 0, 1024);
 
+	portid->sl = lid2sl_table[portid->lid];
+
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
@@ -822,6 +878,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 9:
 		data_counters_only = 1;
 		break;
+	case 10:
+		obtain_sl = 0;
+		break;
 	case 'G':
 	case 'S':
 		port_guid_str = optarg;
@@ -856,8 +915,11 @@ int main(int argc, char **argv)
 	struct ibnd_config config = { 0 };
 	int resolved = -1;
 	ib_portid_t portid = { 0 };
+	ib_portid_t self_portid = { 0 };
 	int rc = 0;
 	ibnd_fabric_t *fabric = NULL;
+	int self_lid = 0;
+	int port = 0;
 
 	int mgmt_classes[4] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS,
 		IB_PERFORMANCE_CLASS
@@ -875,6 +937,7 @@ int main(int argc, char **argv)
 		 "Same as \"-G\" for backward compatibility"},
 		{"Direct", 'D', 1, "<dr_path>",
 		 "report the node containing the port specified by <dr_path>"},
+		{"skip-sl", 10, 0, NULL,"don't obtain SL to all destinations"},
 		{"report-port", 'r', 0, NULL,
 		 "report port link information"},
 		{"threshold-file", 8, 1, NULL,
@@ -931,6 +994,12 @@ int main(int argc, char **argv)
 		exit(-1);
 	}
 
+	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, 0) < 0) {
+		IBERROR("can't resolve self port %s", argv[0]);
+		goto close_port;
+	}
+	self_lid = self_portid.lid;
+
 	/* limit the scan the fabric around the target */
 	if (dr_path) {
 		if ((resolved =
@@ -947,6 +1016,8 @@ int main(int argc, char **argv)
 			IBWARN("Failed to resolve %s;",port_guid_str);
 			goto close_port;
 		}
+		if(obtain_sl)
+			lid2sl_table[portid.lid] = portid.sl;
 	}
 
 	if (load_cache_file) {
@@ -996,12 +1067,18 @@ int main(int argc, char **argv)
 
 		port = ibnd_find_port_guid(fabric, port_guid);
 		if (port) {
+			if(obtain_sl)
+				if(path_record_query(self_lid,port->base_lid))
+					goto destroy_fabric;
 			print_node(port->node, NULL);
 		} else
 			fprintf(stderr, "Failed to find node: %s\n", dr_path);
-	} else
+	} else {
+		if(obtain_sl)
+			if(path_record_query(self_lid,0))
+				goto destroy_fabric;
 		ibnd_iter_nodes(fabric, print_node, NULL);
-
+	}
 	rc = print_summary();
 	if (rc)
 		rc = 1;
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
