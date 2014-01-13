From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: After applying guid_order options,
 add nodes sorted by neighbor switch load
Date: Mon, 13 Jan 2014 13:19:29 -0500
Message-ID: <52D42E31.7010606@dev.mellanox.co.il>
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
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index ab94e34..a1b0eb1 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -799,7 +799,7 @@ static void add_sw_endports_to_order_list(osm_switch_t * sw,
 			port = osm_get_port_by_guid(m->p_subn,
 						    p->p_remote_physp->
 						    port_guid);
-			if (!port)
+			if (!port || port->flag)
 				continue;
 			cl_qlist_insert_tail(&m->port_order_list,
 					     &port->list_item);
@@ -864,8 +864,8 @@ static int ucast_mgr_build_lfts(osm_ucast_mgr_t * p_mgr)
 			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A0D: "
 				"cannot parse guid routing order file \'%s\'\n",
 				p_mgr->p_subn->opt.guid_routing_order_file);
-	} else
-		sort_ports_by_switch_load(p_mgr);
+	}
+	sort_ports_by_switch_load(p_mgr);
 
 	if (p_mgr->p_subn->opt.port_prof_ignore_file) {
 		cl_qmap_apply_func(&p_mgr->p_subn->sw_guid_tbl,
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
