From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/osm_console.c: Support portstatus output for
	incorrect link speeds
Date: Thu, 21 Feb 2013 15:39:23 -0800
Message-ID: <1361489963.24405.68.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Usually coinciding with use of the force_link_speed configuration option,
some link speeds can be observed to be incorrect.  For example, a link
may be active at QDR even if SDR & DDR speeds are the only ones enabled.

Under these scenarios, the portstatus may incorrectly output port status,
confusing users.

A new port output status of "incorrect speed" differentiates ports in this
state from other states, so as to not confuse users.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 600007c..06c9360 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -712,6 +712,8 @@ typedef struct {
 	uint64_t ports_fdr;
 	uint64_t ports_edr;
 	uint64_t ports_unknown_speed;
+	uint64_t ports_incorrect_speed;
+	port_report_t *incorrect_speed_ports;
 	uint64_t ports_reduced_speed;
 	port_report_t *reduced_speed_ports;
 } fabric_stats_t;
@@ -773,7 +775,14 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 			fs->ports_reduced_width++;
 		}
 
-		if ((enabled_speed ^ active_speed) > active_speed) {
+		/* incorrect speed usually due to problems with force_link_speed */
+		if (!(active_speed & enabled_speed)) {
+			__tag_port_report(&(fs->incorrect_speed_ports),
+					  cl_ntoh64(node->node_info.node_guid),
+					  port, node->print_desc);
+			fs->ports_incorrect_speed++;
+		}
+		else if ((enabled_speed ^ active_speed) > active_speed) {
 			__tag_port_report(&(fs->reduced_speed_ports),
 					  cl_ntoh64(node->node_info.node_guid),
 					  port, node->print_desc);
@@ -933,13 +942,18 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		fprintf(out, "   %" PRIu64 " at 25.78125 Gbps\n", fs.ports_edr);
 
 	if (fs.ports_disabled + fs.ports_reduced_speed + fs.ports_reduced_width
-	    > 0) {
+	    + fs.ports_incorrect_speed > 0) {
 		fprintf(out, "\nPossible issues:\n");
 	}
 	if (fs.ports_disabled) {
 		fprintf(out, "   %" PRIu64 " disabled\n", fs.ports_disabled);
 		__print_port_report(out, fs.disabled_ports);
 	}
+	if (fs.ports_incorrect_speed) {
+		fprintf(out, "   %" PRIu64 " with incorrect speed\n",
+			fs.ports_incorrect_speed);
+		__print_port_report(out, fs.incorrect_speed_ports);
+	}
 	if (fs.ports_reduced_speed) {
 		fprintf(out, "   %" PRIu64 " with reduced speed\n",
 			fs.ports_reduced_speed);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
