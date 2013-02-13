From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr: mark/report time of last counter update
Date: Wed, 13 Feb 2013 13:51:23 -0800
Message-ID: <20130213135123.5ab8e737df71f2b465939984@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr_db.c |   43 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 238081b..ab6c978 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -413,6 +413,9 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 
 	p_port->err_previous = *reading;
 
+	/* mark the time this total was updated */
+	p_port->err_total.time = reading->time;
+
 	osm_opensm_report_event(db->perfmgr->osm, OSM_EVENT_ID_PORT_ERRORS,
 				&epi_pe_data);
 
@@ -540,6 +543,9 @@ perfmgr_db_add_dc_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 
 	p_port->dc_previous = *reading;
 
+	/* mark the time this total was updated */
+	p_port->dc_total.time = reading->time;
+
 	osm_opensm_report_event(db->perfmgr->osm,
 				OSM_EVENT_ID_PORT_DATA_COUNTERS, &epi_dc_data);
 
@@ -647,6 +653,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 	int i = 0;
 
 	fprintf(fp, "\nName\tGUID\tActive\tPort\tLast Reset\t"
+		"Last Error Update\tLast Data Update\t"
 		"%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
@@ -672,15 +679,22 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 		"multicast_xmit_pkts",
 		"multicast_rcv_pkts");
 	for (i = (node->esp0) ? 0 : 1; i < node->num_ports; i++) {
-		char *since = ctime(&node->ports[i].last_reset);
+		char lr[128];
+		char *last_reset = ctime_r(&node->ports[i].last_reset, lr);
+		char leu[128];
+		char *last_err_update = ctime_r(&node->ports[i].err_total.time, leu);
+		char ldu[128];
+		char *last_data_update = ctime_r(&node->ports[i].dc_total.time, ldu);
 
 		if (!node->ports[i].valid)
 			continue;
 
-		since[strlen(since) - 1] = '\0';	/* remove \n */
+		last_reset[strlen(last_reset) - 1] = '\0';	/* remove \n */
+		last_err_update[strlen(last_err_update) - 1] = '\0';	/* remove \n */
+		last_data_update[strlen(last_data_update) - 1] = '\0';	/* remove \n */
 
 		fprintf(fp,
-			"%s\t0x%" PRIx64 "\t%s\t%d\t%s\t%" PRIu64 "\t%" PRIu64 "\t"
+			"%s\t0x%" PRIx64 "\t%s\t%d\t%s\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\t"
 			"%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t"
 			"%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64 "\t%" PRIu64
@@ -688,7 +702,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 			"\t%" PRIu64 "\t%" PRIu64 "\n", node->node_name,
 			node->node_guid,
 			node->active ? "TRUE" : "FALSE",
-			i, since,
+			i, last_reset, last_err_update, last_data_update,
 			node->ports[i].err_total.symbol_err_cnt,
 			node->ports[i].err_total.link_err_recover,
 			node->ports[i].err_total.link_downed,
@@ -780,12 +794,20 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 		}
 	}
 	for (/* set above */; i < num_ports; i++) {
-		char *since = ctime(&node->ports[i].last_reset);
+		char lr[128];
+		char *last_reset = ctime_r(&node->ports[i].last_reset, lr);
+		char leu[128];
+		char *last_err_update = ctime_r(&node->ports[i].err_total.time, leu);
+		char ldu[128];
+		char *last_data_update = ctime_r(&node->ports[i].dc_total.time, ldu);
 
 		if (!node->ports[i].valid)
 			continue;
 
-		since[strlen(since) - 1] = '\0';	/* remove \n */
+		last_reset[strlen(last_reset) - 1] = '\0';	/* remove \n */
+		last_err_update[strlen(last_err_update) - 1] = '\0';	/* remove \n */
+		last_data_update[strlen(last_data_update) - 1] = '\0';	/* remove \n */
+
 		perfmgr_db_err_reading_t *err = &node->ports[i].err_total;
 
 		if (err_only
@@ -803,9 +825,12 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 		    && err->vl15_dropped == 0)
 			continue;
 
-		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d (Since %s)\n",
+		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d\n"
+				    "     Last Reset           : %s\n"
+				    "     Last Error Update    : %s\n",
 			node->node_name, node->node_guid,
-			node->active ? "TRUE":"FALSE", i, since);
+			node->active ? "TRUE":"FALSE", i, last_reset,
+			last_err_update);
 
 		if (!err_only || err->symbol_err_cnt != 0)
 			fprintf(fp, "     symbol_err_cnt       : %" PRIu64 "\n",
@@ -844,6 +869,8 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 			fprintf(fp, "     vl15_dropped         : %" PRIu64 "\n",
 				err->vl15_dropped);
 
+		fprintf(fp, "     Last Data Update     : %s\n",
+			last_data_update);
 		fprintf(fp, "     xmit_data            : %" PRIu64,
 			node->ports[i].dc_total.xmit_data);
 		dump_hr_dc(fp, node->ports[i].dc_total.xmit_data, 1);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
