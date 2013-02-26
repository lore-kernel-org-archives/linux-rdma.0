From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_console.c: Do not perform portstatus checks
	on down ports
Date: Tue, 26 Feb 2013 13:54:42 -0800
Message-ID: <1361915682.28997.12.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Portstatus checks were performed on ports regardless of them being
down or active.  This could lead to confusing output from the console
portstatus command.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_console.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 7f9a963..e3f27a2 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -770,6 +770,22 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 		port_state = ib_port_info_get_port_state(pi);
 		port_phys_state = ib_port_info_get_port_phys_state(pi);
 
+		if (port_state == IB_LINK_DOWN)
+			fs->ports_down++;
+		else if (port_state == IB_LINK_ACTIVE)
+			fs->ports_active++;
+		if (port_phys_state == IB_PORT_PHYS_STATE_DISABLED) {
+			__tag_port_report(&(fs->disabled_ports),
+					  cl_ntoh64(node->node_info.node_guid),
+					  port, node->print_desc);
+			fs->ports_disabled++;
+		}
+
+		fs->total_ports++;
+
+		if (port_state == IB_LINK_DOWN)
+			continue;
+
 		if (!(active_width & enabled_width)) {
 			__tag_port_report(&(fs->unenabled_width_ports),
 					  cl_ntoh64(node->node_info.node_guid),
@@ -872,18 +888,6 @@ static void __get_stats(cl_map_item_t * const p_map_item, void *context)
 			fs->ports_unknown_width++;
 			break;
 		}
-		if (port_state == IB_LINK_DOWN)
-			fs->ports_down++;
-		else if (port_state == IB_LINK_ACTIVE)
-			fs->ports_active++;
-		if (port_phys_state == IB_PORT_PHYS_STATE_DISABLED) {
-			__tag_port_report(&(fs->disabled_ports),
-					  cl_ntoh64(node->node_info.node_guid),
-					  port, node->print_desc);
-			fs->ports_disabled++;
-		}
-
-		fs->total_ports++;
 	}
 }
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
