From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibqueryerrors add query failure count
Date: Thu, 22 Sep 2011 16:27:00 -0700
Message-ID: <20110922162700.f4f3fbb9.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Report query failure count as part of summary

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/ibqueryerrors.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 8e0b336..fa116a9 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -83,6 +83,7 @@ struct {
 	int bad_nodes;
 	int ports_checked;
 	int bad_ports;
+	int pma_query_failures;
 } summary = { 0 };
 
 #define DEF_THRES_FILE IBDIAG_CONFIG_PATH"/error_thresholds"
@@ -291,6 +292,8 @@ static int print_summary(void)
 	printf("##          %d ports checked, %d ports have errors beyond threshold\n",
 		summary.ports_checked, summary.bad_ports);
 	printf("## %s\n", threshold_str);
+	if (summary.pma_query_failures)
+		printf("##          %d PMA query failures\n", summary.pma_query_failures);
 	report_suppressed();
 	return (summary.bad_ports);
 }
@@ -310,6 +313,7 @@ static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 			   ibmad_port)) {
 		IBWARN("%s query failed on %s, %s port %d", attr_name,
 		       node_name, portid2str(portid), portnum);
+		summary.pma_query_failures++;
 		return 0;
 	}
 
@@ -447,6 +451,7 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 			   ibmad_port)) {
 		IBWARN("classportinfo query failed on %s, %s port %d",
 		       node_name, portid2str(portid), portnum);
+		summary.pma_query_failures++;
 		return -1;
 	}
 
@@ -473,6 +478,7 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 				   IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
 			IBWARN("IB_GSI_PORT_COUNTERS_EXT query failed on %s, %s port %d",
 			       node_name, portid2str(portid), portnum);
+			summary.pma_query_failures++;
 			return (1);
 		}
 		start_field = IB_PC_EXT_XMT_BYTES_F;
@@ -485,6 +491,7 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 				   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 			IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
 			       node_name, portid2str(portid), portnum);
+			summary.pma_query_failures++;
 			return (1);
 		}
 		start_field = IB_PC_XMT_BYTES_F;
@@ -539,6 +546,7 @@ static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
 		       node_name, portid2str(portid), portnum);
+		summary.pma_query_failures++;
 		return (0);
 	}
 
@@ -547,6 +555,7 @@ static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
 		    IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
 			IBWARN("IB_GSI_PORT_COUNTERS_EXT query failed on %s, %s port %d",
 			       node_name, portid2str(portid), portnum);
+			summary.pma_query_failures++;
 			return (0);
 		}
 		pc_ext = pce;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
