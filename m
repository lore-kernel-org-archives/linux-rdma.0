From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_mgr.c: Fix some issues found by Coverity
Date: Tue, 31 May 2011 07:30:13 -0400
Message-ID: <4DE4D145.8060104@dev.mellanox.co.il>
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
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 211d6e0..600bb10 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -529,6 +529,7 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 	if (!ports) {
 		OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR,
 			"ERR 3A08: cannot allocate memory for ports\n");
+		free(dimn_ports);
 		return -1;
 	}
 	memset(ports, 0, words*sizeof(*ports));
@@ -794,6 +795,8 @@ static void add_sw_endports_to_order_list(osm_switch_t * sw,
 			port = osm_get_port_by_guid(m->p_subn,
 						    p->p_remote_physp->
 						    port_guid);
+			if (!port)
+				continue;
 			cl_qlist_insert_tail(&m->port_order_list,
 					     &port->list_item);
 			port->flag = 1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
