From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_console.c: Support portstatus output for
	unenabled width/speed
Date: Tue, 26 Feb 2013 13:54:40 -0800
Message-ID: <1361915680.28997.11.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On occasion, it has been observed that active link width and/or speed
is set at a level not enabled.  For example, a link may be active at
QDR but SDR & DDR speeds are the only ones enabled.

Under these scenarios, the portstatus option in the console may
incorrectly output port status, which can confuse users.

A new port output status of "unenabled width" or "unenabled speed" is
output when this situation is discovered, helping users find problems
in the fabric.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 600007c..7f9a963 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -703,6 +703,8 @@ typedef struct {
 	uint64_t ports_8X;
 	uint64_t ports_12X;
 	uint64_t ports_unknown_width;
+	uint64_t ports_unenabled_width;
+	port_report_t *unenabled_width_ports;
 	uint64_t ports_reduced_width;
 	port_report_t *reduced_width_ports;
 	uint64_t ports_sdr;
@@ -712,6 +714,8 @@ typedef struct {
 	uint64_t ports_fdr;
 	uint64_t ports_edr;
 	uint64_t ports_unknown_speed;
+	uint64_t ports_unenabled_speed;
+	port_report_t *unenabled_speed_ports;
 	uint64_t ports_reduced_speed;
 	port_report_t *reduced_speed_ports;
 } fabric_stats_t;
@@ -766,14 +770,27 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 		port_state = ib_port_info_get_port_state(pi);
 		port_phys_state = ib_port_info_get_port_phys_state(pi);
 
-		if ((enabled_width ^ active_width) > active_width) {
+		if (!(active_width & enabled_width)) {
+			__tag_port_report(&(fs->unenabled_width_ports),
+					  cl_ntoh64(node->node_info.node_guid),
+					  port, node->print_desc);
+			fs->ports_unenabled_width++;
+		}
+		else if ((enabled_width ^ active_width) > active_width) {
 			__tag_port_report(&(fs->reduced_width_ports),
 					  cl_ntoh64(node->node_info.node_guid),
 					  port, node->print_desc);
 			fs->ports_reduced_width++;
 		}
 
-		if ((enabled_speed ^ active_speed) > active_speed) {
+		/* unenabled speed usually due to problems with force_link_speed */
+		if (!(active_speed & enabled_speed)) {
+			__tag_port_report(&(fs->unenabled_speed_ports),
+					  cl_ntoh64(node->node_info.node_guid),
+					  port, node->print_desc);
+			fs->ports_unenabled_speed++;
+		}
+		else if ((enabled_speed ^ active_speed) > active_speed) {
 			__tag_port_report(&(fs->reduced_speed_ports),
 					  cl_ntoh64(node->node_info.node_guid),
 					  port, node->print_desc);
@@ -814,7 +831,13 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 		    (enabled_speed = pi->link_speed_ext_enabled) != IB_LINK_SPEED_EXT_DISABLE &&
 		    active_speed == IB_LINK_SPEED_ACTIVE_10) {
 			active_speed = ib_port_info_get_link_speed_ext_active(pi);
-			if ((enabled_speed ^ active_speed) > active_speed) {
+			if (!(active_speed & enabled_speed)) {
+				__tag_port_report(&(fs->unenabled_speed_ports),
+						  cl_ntoh64(node->node_info.node_guid),
+						  port, node->print_desc);
+				fs->ports_unenabled_speed++;
+			}
+			else if ((enabled_speed ^ active_speed) > active_speed) {
 				__tag_port_report(&(fs->reduced_speed_ports),
 						  cl_ntoh64(node->node_info.node_guid),
 						  port, node->print_desc);
@@ -933,18 +956,28 @@ static void portstatus_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		fprintf(out, "   %" PRIu64 " at 25.78125 Gbps\n", fs.ports_edr);
 
 	if (fs.ports_disabled + fs.ports_reduced_speed + fs.ports_reduced_width
-	    > 0) {
+	    + fs.ports_unenabled_width + fs.ports_unenabled_speed > 0) {
 		fprintf(out, "\nPossible issues:\n");
 	}
 	if (fs.ports_disabled) {
 		fprintf(out, "   %" PRIu64 " disabled\n", fs.ports_disabled);
 		__print_port_report(out, fs.disabled_ports);
 	}
+	if (fs.ports_unenabled_speed) {
+		fprintf(out, "   %" PRIu64 " with unenabled speed\n",
+			fs.ports_unenabled_speed);
+		__print_port_report(out, fs.unenabled_speed_ports);
+	}
 	if (fs.ports_reduced_speed) {
 		fprintf(out, "   %" PRIu64 " with reduced speed\n",
 			fs.ports_reduced_speed);
 		__print_port_report(out, fs.reduced_speed_ports);
 	}
+	if (fs.ports_unenabled_width) {
+		fprintf(out, "   %" PRIu64 " with unenabled width\n",
+			fs.ports_unenabled_width);
+		__print_port_report(out, fs.unenabled_width_ports);
+	}
 	if (fs.ports_reduced_width) {
 		fprintf(out, "   %" PRIu64 " with reduced width\n",
 			fs.ports_reduced_width);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
