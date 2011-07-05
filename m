From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_switch.c: Fix compile warnings
Date: Tue, 05 Jul 2011 07:33:42 -0400
Message-ID: <4E12F696.1080301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


osm_switch.c: In function 'osm_switch_recommend_path':
osm_switch.c:282: warning: 'found_node_guid' may be used uninitialized in this function
osm_switch.c:281: warning: 'found_sys_guid' may be used uninitialized in this function

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index d921715..8fb84c3 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -278,8 +278,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	unsigned int port_paths_count = 0;
 	uint8_t scatter_possible_ports[IB_NODE_NUM_PORTS_MAX];
 	unsigned int scatter_possible_ports_count = 0;
-	int found_sys_guid;
-	int found_node_guid;
+	int found_sys_guid = 0;
+	int found_node_guid = 0;
 
 	CL_ASSERT(lid_ho > 0);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
