From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Delete port only after GID OUT trap was sent
Date: Thu, 04 Feb 2010 20:12:20 +0200
Message-ID: <4B6B0E04.808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Send GID OUT trap first and only then remove the port.
This is done to allow SM check that subscriber and trap source
are permitted to access each other.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_drop_mgr.c |   56 ++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/opensm/opensm/osm_drop_mgr.c b/opensm/opensm/osm_drop_mgr.c
index 879e21f..111582e 100644
--- a/opensm/opensm/osm_drop_mgr.c
+++ b/opensm/opensm/osm_drop_mgr.c
@@ -180,6 +180,33 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		goto Exit;
 	}
 
+	/* issue a notice - trap 65 */
+	/* details of the notice */
+	notice.generic_type = 0x83;	/* is generic subn mgt type */
+	ib_notice_set_prod_type_ho(&notice, 4);	/* A class manager generator */
+	/* endport ceases to be reachable */
+	notice.g_or_v.generic.trap_num = CL_HTON16(65);
+	/* The sm_base_lid is saved in network order already. */
+	notice.issuer_lid = sm->p_subn->sm_base_lid;
+	/* following C14-72.1.2 and table 119 p725 */
+	/* we need to provide the GID */
+	port_gid.unicast.prefix = sm->p_subn->opt.subnet_prefix;
+	port_gid.unicast.interface_id = port_guid;
+	memcpy(&(notice.data_details.ntc_64_67.gid),
+	       &(port_gid), sizeof(ib_gid_t));
+
+	/* According to page 653 - the issuer gid in this case of trap
+	   is the SM gid, since the SM is the initiator of this trap. */
+	notice.issuer_gid.unicast.prefix = sm->p_subn->opt.subnet_prefix;
+	notice.issuer_gid.unicast.interface_id = sm->p_subn->sm_port_guid;
+
+	status = osm_report_notice(sm->p_log, sm->p_subn, &notice);
+	if (status != IB_SUCCESS) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0103: "
+			"Error sending trap reports (%s)\n",
+			ib_get_err_str(status));
+	}
+
 	p_sm_guid_tbl = &sm->p_subn->sm_guid_tbl;
 	p_sm = (osm_remote_sm_t *) cl_qmap_remove(p_sm_guid_tbl, port_guid);
 	if (p_sm != (osm_remote_sm_t *) cl_qmap_end(p_sm_guid_tbl)) {
@@ -217,35 +244,6 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 
 	osm_port_delete(&p_port);
 
-	/* issue a notice - trap 65 */
-
-	/* details of the notice */
-	notice.generic_type = 0x83;	/* is generic subn mgt type */
-	ib_notice_set_prod_type_ho(&notice, 4);	/* A class manager generator */
-	/* endport ceases to be reachable */
-	notice.g_or_v.generic.trap_num = CL_HTON16(65);
-	/* The sm_base_lid is saved in network order already. */
-	notice.issuer_lid = sm->p_subn->sm_base_lid;
-	/* following C14-72.1.2 and table 119 p725 */
-	/* we need to provide the GID */
-	port_gid.unicast.prefix = sm->p_subn->opt.subnet_prefix;
-	port_gid.unicast.interface_id = port_guid;
-	memcpy(&(notice.data_details.ntc_64_67.gid),
-	       &(port_gid), sizeof(ib_gid_t));
-
-	/* According to page 653 - the issuer gid in this case of trap
-	   is the SM gid, since the SM is the initiator of this trap. */
-	notice.issuer_gid.unicast.prefix = sm->p_subn->opt.subnet_prefix;
-	notice.issuer_gid.unicast.interface_id = sm->p_subn->sm_port_guid;
-
-	status = osm_report_notice(sm->p_log, sm->p_subn, &notice);
-	if (status != IB_SUCCESS) {
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0103: "
-			"Error sending trap reports (%s)\n",
-			ib_get_err_str(status));
-		goto Exit;
-	}
-
 	OSM_LOG(sm->p_log, OSM_LOG_INFO,
 		"Removed port with GUID:0x%016" PRIx64
 		" LID range [%u, %u] of node:%s\n",
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
