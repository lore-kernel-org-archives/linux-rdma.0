From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_path_record.c: path_sl may return SL different
 from requested SL
Date: Wed, 11 Dec 2013 13:36:20 -0500
Message-ID: <52A8B0A4.9040402@dev.mellanox.co.il>
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
 opensm/osm_sa_path_record.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index d2ff93b..8384ece 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -839,10 +839,28 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 * send the currently computed SL value as a hint and let the routing
 	 * engine override it.
 	 */
-	if (p_re && p_re->path_sl)
+	if (p_re && p_re->path_sl) {
+		uint8_t pr_sl;
+		pr_sl = sl;
+
 		sl = p_re->path_sl(p_re->context, sl,
 				   cl_hton16(src_lid_ho), cl_hton16(dest_lid_ho));
 
+		if ((comp_mask & IB_PR_COMPMASK_SL) && (sl != pr_sl)) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F2A: "
+				"Requested SL (%u) doesn't match SL calculated"
+				"by routing engine (%u) "
+				"[%s port %d <-> %s port %d]\n",
+				pr_sl,
+				sl,
+				p_src_alias_guid->p_base_port->p_node->print_desc,
+				p_src_alias_guid->p_base_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_node->print_desc,
+				p_dest_alias_guid->p_base_port->p_physp->port_num);
+			status = IB_NOT_FOUND;
+			goto Exit;
+		}
+	}
 	/* reset pkey when raw traffic */
 	if (comp_mask & IB_PR_COMPMASK_RAWTRAFFIC &&
 	    cl_ntoh32(p_pr->hop_flow_raw) & (1 << 31))
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
