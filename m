From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Fix some issues found by Coverity
Date: Tue, 31 May 2011 07:30:07 -0400
Message-ID: <4DE4D13F.6050702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 51e252a..e7e7b8e 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3281,7 +3281,7 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 		p_remote_node =
 		    osm_node_get_remote_node(p_node, i, &remote_port_num);
 
-		if (!p_remote_osm_port)
+		if (!p_remote_osm_port || !p_remote_node)
 			continue;
 
 		remote_node_type = osm_node_get_type(p_remote_node);
@@ -3420,6 +3420,8 @@ static int fabric_construct_sw_ports(IN ftree_fabric_t * p_ftree,
 
 		p_remote_node =
 		    osm_node_get_remote_node(p_node, i, &remote_port_num);
+		if (!p_remote_node)
+			continue;
 
 		/* ignore any loopback connection on switch */
 		if (p_node == p_remote_node) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
