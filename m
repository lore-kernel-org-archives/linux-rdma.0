From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/6] Fix fat-tree routing for CAs with more than 1 connected
 port
Date: Tue, 11 Jun 2013 14:13:25 -0400
Message-ID: <51B768C5.6080301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 269512894d0bbb814707bf0aae56e832228f32f9 Mon Sep 17 00:00:00 2001
From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 29 Apr 2012 12:25:41 +0300
Subject: [PATCH 1/6] Fix fat-tree routing for CAs with more than 1 connected
 port

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 864e161..fecc902 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -886,9 +886,24 @@ static ftree_port_group_t *hca_get_port_group_by_remote_lid(IN ftree_hca_t *
 	return NULL;
 }
 
+static ftree_port_group_t *hca_get_port_group_by_lid(IN ftree_hca_t *
+						     p_hca,
+						     IN uint16_t
+						     base_lid)
+{
+	uint32_t i;
+	for (i = 0; i < p_hca->up_port_groups_num; i++)
+		if (base_lid ==
+		    p_hca->up_port_groups[i]->base_lid)
+			return p_hca->up_port_groups[i];
+
+	return NULL;
+
+}
 /***************************************************/
 
-static void hca_add_port(IN ftree_hca_t * p_hca, IN uint8_t port_num,
+static void hca_add_port(IN ftree_fabric_t * p_ftree,
+			 IN ftree_hca_t * p_hca, IN uint8_t port_num,
 			 IN uint8_t remote_port_num, IN uint16_t base_lid,
 			 IN uint16_t remote_base_lid, IN ib_net64_t port_guid,
 			 IN ib_net64_t remote_port_guid,
@@ -903,7 +918,7 @@ static void hca_add_port(IN ftree_hca_t * p_hca, IN uint8_t port_num,
 	   in hca's that lead to switches */
 	CL_ASSERT(remote_node_type == IB_NODE_TYPE_SWITCH);
 
-	p_group = hca_get_port_group_by_remote_lid(p_hca, remote_base_lid);
+	p_group = hca_get_port_group_by_lid(p_hca, base_lid);
 
 	if (!p_group) {
 		p_group = port_group_create(base_lid, remote_base_lid,
@@ -914,9 +929,11 @@ static void hca_add_port(IN ftree_hca_t * p_hca, IN uint8_t port_num,
 					    p_remote_hca_or_sw, is_cn, is_io);
 		CL_ASSERT(p_group);
 		p_hca->up_port_groups[p_hca->up_port_groups_num++] = p_group;
-	}
-	port_group_add_port(p_group, port_num, remote_port_num);
-
+		port_group_add_port(p_group, port_num, remote_port_num);
+	} else
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_ERROR,
+			"ERR AB32: Duplicated LID for CA GUID: 0x%016" PRIx64 "\n",
+			cl_ntoh64(port_guid));
 }				/* hca_add_port() */
 
 /***************************************************
@@ -3379,7 +3396,8 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 		}
 		p_ftree->ca_ports++;
 
-		hca_add_port(p_hca,	/* local ftree_hca object */
+		hca_add_port(p_ftree,
+			     p_hca,	/* local ftree_hca object */
 			     i,	/* local port number */
 			     remote_port_num,	/* remote port number */
 			     cl_ntoh16(osm_node_get_base_lid(p_node, i)),	/* local lid */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
