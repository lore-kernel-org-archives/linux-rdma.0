From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_node_info_rcv.c: In ni_rcv_process_existing_ca_or_router,
 handle error
Date: Thu, 12 Jul 2012 12:23:06 -0400
Message-ID: <4FFEF9EA.4060006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add handling for case where osm_node_get_physp_ptr returns NULL pointer

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 58c92b9..293f0c8 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -479,6 +479,16 @@ alias_done:
 
 	} else {
 		osm_physp_t *p_physp = osm_node_get_physp_ptr(p_node, port_num);
+
+		if (p_physp == NULL) {
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D1C: "
+				"No physical port found for node GUID 0x%"
+				PRIx64 " port %u. Might be duplicate port GUID\n",
+				cl_ntoh64(p_node->node_info.node_guid),
+				port_num);
+			goto Exit;
+		}
+
 		/*
 		   Update the DR Path to the port,
 		   in case the old one is no longer available.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
