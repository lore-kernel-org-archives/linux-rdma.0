From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 09/10] opensm/console: Add human readable output for perfmgr
 data counters
Date: Tue, 3 Jul 2012 16:54:00 -0700
Message-ID: <20120703165400.8fc331e9.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr_db.c |   93 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 6f9c1ab..ea6fe19 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -699,6 +699,55 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 	}
 }
 
+static void dump_hr_dc(FILE *fp, uint64_t val64, int data)
+{
+	char *unit = "";
+	uint64_t tmp = val64;
+	float val = 0.0;
+	int ui = 0;
+	int div = 1;
+
+	tmp /= 1024;
+	while (tmp) {
+		ui++;
+		tmp /= 1024;
+		div *= 1024;
+	}
+
+	val = (float)(val64);
+	if (data) {
+		val *= 4;
+		if (val/div > 1024) {
+			ui++;
+			div *= 1024;
+		}
+	}
+	val /= div;
+
+	switch (ui) {
+		case 1:
+			unit = "K";
+			break;
+		case 2:
+			unit = "M";
+			break;
+		case 3:
+			unit = "G";
+			break;
+		case 4:
+			unit = "T";
+			break;
+		case 5:
+			unit = "P";
+			break;
+		case 6:
+			unit = "E";
+			break;
+	}
+
+	fprintf(fp, " (%5.3f%s%s)\n", val, unit, data ? "B" : "");
+}
+
 /**********************************************************************
  * Output a human readable output of the port counters
  **********************************************************************/
@@ -738,15 +787,7 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
 			"     rcv_constraint_err   : %" PRIu64 "\n"
 			"     link_integrity_err   : %" PRIu64 "\n"
 			"     buf_overrun_err      : %" PRIu64 "\n"
-			"     vl15_dropped         : %" PRIu64 "\n"
-			"     xmit_data            : %" PRIu64 "\n"
-			"     rcv_data             : %" PRIu64 "\n"
-			"     xmit_pkts            : %" PRIu64 "\n"
-			"     rcv_pkts             : %" PRIu64 "\n"
-			"     unicast_xmit_pkts    : %" PRIu64 "\n"
-			"     unicast_rcv_pkts     : %" PRIu64 "\n"
-			"     multicast_xmit_pkts  : %" PRIu64 "\n"
-			"     multicast_rcv_pkts   : %" PRIu64 "\n",
+			"     vl15_dropped         : %" PRIu64 "\n",
 			node->node_name,
 			node->node_guid,
 			node->active ? "TRUE":"FALSE",
@@ -763,15 +804,33 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
 			node->ports[i].err_total.rcv_constraint_err,
 			node->ports[i].err_total.link_integrity,
 			node->ports[i].err_total.buffer_overrun,
-			node->ports[i].err_total.vl15_dropped,
-			node->ports[i].dc_total.xmit_data,
-			node->ports[i].dc_total.rcv_data,
-			node->ports[i].dc_total.xmit_pkts,
-			node->ports[i].dc_total.rcv_pkts,
-			node->ports[i].dc_total.unicast_xmit_pkts,
-			node->ports[i].dc_total.unicast_rcv_pkts,
-			node->ports[i].dc_total.multicast_xmit_pkts,
+			node->ports[i].err_total.vl15_dropped);
+
+		fprintf(fp, "     xmit_data            : %" PRIu64,
+			node->ports[i].dc_total.xmit_data);
+		dump_hr_dc(fp, node->ports[i].dc_total.xmit_data, 1);
+		fprintf(fp, "     rcv_data             : %" PRIu64,
+			node->ports[i].dc_total.rcv_data);
+		dump_hr_dc(fp, node->ports[i].dc_total.rcv_data, 1);
+		fprintf(fp, "     xmit_pkts            : %" PRIu64,
+			node->ports[i].dc_total.xmit_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.xmit_pkts, 0);
+		fprintf(fp, "     rcv_pkts             : %" PRIu64,
+			node->ports[i].dc_total.rcv_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.rcv_pkts, 0);
+		fprintf(fp, "     unicast_xmit_pkts    : %" PRIu64,
+			node->ports[i].dc_total.unicast_xmit_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.unicast_xmit_pkts, 0);
+		fprintf(fp, "     unicast_rcv_pkts     : %" PRIu64,
+			node->ports[i].dc_total.unicast_rcv_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.unicast_rcv_pkts, 0);
+		fprintf(fp, "     multicast_xmit_pkts  : %" PRIu64,
+			node->ports[i].dc_total.multicast_xmit_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.multicast_xmit_pkts, 0);
+		fprintf(fp, "     multicast_rcv_pkts   : %" PRIu64,
 			node->ports[i].dc_total.multicast_rcv_pkts);
+		dump_hr_dc(fp, node->ports[i].dc_total.multicast_rcv_pkts, 0);
+
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
