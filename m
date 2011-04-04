From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_node_record.c: In nr_rcv_create_nr, only set
 some variables when needed
Date: Mon, 04 Apr 2011 14:46:03 -0400
Message-ID: <4D9A11EB.6020806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, cosmetic formatting change to log message

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index ff08219..f135607 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -131,7 +131,7 @@ static void nr_rcv_create_nr(IN osm_sa_t * sa, IN
osm_node_t * p_node,
 	OSM_LOG_ENTER(sa->p_log);

 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-		"Looking for NodeRecord with LID: %u GUID:0x%016"
+		"Looking for NodeRecord with LID: %u GUID: 0x%016"
 		PRIx64 "\n", cl_ntoh16(match_lid), cl_ntoh64(match_port_guid));

 	/*
@@ -160,12 +160,13 @@ static void nr_rcv_create_nr(IN osm_sa_t * sa, IN
osm_node_t * p_node,
 			continue;

 		base_lid = osm_physp_get_base_lid(p_physp);
-		base_lid_ho = cl_ntoh16(base_lid);
-		lmc = osm_physp_get_lmc(p_physp);
-		max_lid_ho = (uint16_t) (base_lid_ho + (1 << lmc) - 1);
-		match_lid_ho = cl_ntoh16(match_lid);

 		if (comp_mask & IB_NR_COMPMASK_LID) {
+			base_lid_ho = cl_ntoh16(base_lid);
+			lmc = osm_physp_get_lmc(p_physp);
+			max_lid_ho = (uint16_t) (base_lid_ho + (1 << lmc) - 1);
+			match_lid_ho = cl_ntoh16(match_lid);
+
 			/*
 			   We validate that the lid belongs to this node.
 			 */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
