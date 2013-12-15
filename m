From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_path_record.c: Improve ERR 1F1D to show the
 pkey specified in PathQuery
Date: Sun, 15 Dec 2013 12:22:13 -0500
Message-ID: <52ADE545.5030509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_path_record.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 8384ece..1709062 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -680,18 +680,18 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (p_qos_level && p_qos_level->pkey_range_len &&
 		    !osm_qos_level_has_pkey(p_qos_level, pkey)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1D: "
-				"Ports 0x%016" PRIx64 " (%s port %d) and "
-				"0x%016"PRIx64" (%s port %d) "
-				"do not share PKeys defined by QoS level "
-				"\"%s\"\n",
+				"QoS level \"%s\" doesn't define specified PKey 0x%04x "
+				"for ports 0x%016" PRIx64 " (%s port %d) and "
+				"0x%016"PRIx64" (%s port %d)\n",
+				p_qos_level->name,
+				cl_ntoh16(pkey),
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
 				p_src_physp->p_node->print_desc,
 				p_src_alias_guid->p_base_port->p_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
 					  (p_dest_physp)),
 				p_dest_physp->p_node->print_desc,
-				p_dest_alias_guid->p_base_port->p_physp->port_num,
-				p_qos_level->name);
+				p_dest_alias_guid->p_base_port->p_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
