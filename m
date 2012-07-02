From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_node_info_rec.c: Also handle non compliant SMA
 in ni_rcv_process_existing
Date: Mon, 02 Jul 2012 08:54:36 -0400
Message-ID: <4FF19A0C.9010201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in case of NodeInfo.LocalPortNum > NodeInfo.NumPorts

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 9375e36..12e7693 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -782,6 +782,17 @@ static void ni_rcv_process_existing(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		cl_ntoh64(p_ni->node_guid),
 		cl_ntoh64(p_smp->trans_id), p_node->discovery_count);
 
+	if (port_num > p_ni->num_ports) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0C: "
+			"Existing %s node GUID 0x%" PRIx64 "is non-compliant "
+			"and is being ignored since the "
+			"local port num %u > num ports %u\n",
+			ib_get_node_type_str(p_ni->node_type),
+			cl_ntoh64(p_ni->node_guid), port_num,
+			p_ni->num_ports);
+		goto Exit;
+	}
+
 	/*
 	   If we haven't already encountered this existing node
 	   on this particular sweep, then process further.
@@ -807,6 +818,7 @@ static void ni_rcv_process_existing(IN osm_sm_t * sm, IN osm_node_t * p_node,
 
 	ni_rcv_set_links(sm, p_node, port_num, p_ni_context);
 
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
