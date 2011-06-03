From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Handle [sw hca]_create failures
Date: Thu, 02 Jun 2011 20:40:27 -0400
Message-ID: <4DE82D7B.1090408@dev.mellanox.co.il>
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
index 51e252a..477f883 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2009 Simula Research Laboratory. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -1050,10 +1050,14 @@ static uint8_t fabric_get_rank(ftree_fabric_t * p_ftree)
 
 static void fabric_add_hca(ftree_fabric_t * p_ftree, osm_node_t * p_osm_node)
 {
-	ftree_hca_t *p_hca = hca_create(p_osm_node);
+	ftree_hca_t *p_hca;
 
 	CL_ASSERT(osm_node_get_type(p_osm_node) == IB_NODE_TYPE_CA);
 
+	p_hca = hca_create(p_osm_node);
+	if (!p_hca)
+		return;
+
 	cl_qmap_insert(&p_ftree->hca_tbl, p_osm_node->node_info.node_guid,
 		       &p_hca->map_item);
 }
@@ -1062,10 +1066,14 @@ static void fabric_add_hca(ftree_fabric_t * p_ftree, osm_node_t * p_osm_node)
 
 static void fabric_add_sw(ftree_fabric_t * p_ftree, osm_switch_t * p_osm_sw)
 {
-	ftree_sw_t *p_sw = sw_create(p_ftree, p_osm_sw);
+	ftree_sw_t *p_sw;
 
 	CL_ASSERT(osm_node_get_type(p_osm_sw->p_node) == IB_NODE_TYPE_SWITCH);
 
+	p_sw = sw_create(p_ftree, p_osm_sw);
+	if (!p_sw)
+		return;
+
 	cl_qmap_insert(&p_ftree->sw_tbl, p_osm_sw->p_node->node_info.node_guid,
 		       &p_sw->map_item);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
