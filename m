From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_drop_mgr.c: GID out trap fix
Date: Tue, 15 Nov 2011 10:42:41 +0200
Message-ID: <20111115084241.GA2501@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Because removed port GUID was deleted from port_guid_tbl,
osm_report_notice() failed when trying to locate source port GUID

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_drop_mgr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 10b51e2..31f8970 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -173,8 +173,7 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		"Unreachable port 0x%016" PRIx64 "\n", cl_ntoh64(port_guid));
 
 	p_port_check =
-	    (osm_port_t *) cl_qmap_remove(&sm->p_subn->port_guid_tbl,
-					  port_guid);
+	    (osm_port_t *) cl_qmap_get(&sm->p_subn->port_guid_tbl, port_guid);
 	if (p_port_check != p_port) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0101: "
 			"Port 0x%016" PRIx64 " not in guid table\n",
@@ -224,6 +223,8 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		}
 	}
 
+	cl_qmap_remove(&sm->p_subn->port_guid_tbl, port_guid);
+
 	p_sm_guid_tbl = &sm->p_subn->sm_guid_tbl;
 	p_sm = (osm_remote_sm_t *) cl_qmap_remove(p_sm_guid_tbl, port_guid);
 	if (p_sm != (osm_remote_sm_t *) cl_qmap_end(p_sm_guid_tbl)) {
-- 
1.7.7.1

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
