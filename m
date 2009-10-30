From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Return single PathRecord for SubnAdmGet when SGID and/or DGID
Date: Fri, 30 Oct 2009 13:40:06 +0200
Message-ID: <1256902806-12040-1-git-send-email-elid@voltaire.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   38 ++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index f36eb46..0c6621b 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -890,7 +890,7 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
-static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
+static int pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 				       IN const osm_madw_t * p_madw,
 				       IN const osm_port_t * p_req_port,
 				       IN const osm_port_t * p_src_port,
@@ -908,7 +908,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	uint16_t dest_lid_max_ho;
 	uint16_t src_lid_ho;
 	uint16_t dest_lid_ho;
-	uint32_t path_num;
+	uint32_t path_num = 0;
 	uint8_t preference;
 	uintn_t iterations;
 	uintn_t src_offset;
@@ -1019,7 +1019,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	   Preferred paths come first in OpenSM
 	 */
 	preference = 0;
-	path_num = 0;
+	path_num = cl_qlist_count(p_list);
 
 	/* If SubnAdmGet, assume NumbPaths 1 (1.2 erratum) */
 	if (p_sa_mad->method != IB_MAD_METHOD_GET)
@@ -1111,6 +1111,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
+	return path_num;
 }
 
 /**********************************************************************
@@ -1314,6 +1315,8 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	const cl_qmap_t *p_tbl;
 	const osm_port_t *p_dest_port;
 	const osm_port_t *p_src_port;
+	const ib_sa_mad_t *p_sa_mad;
+	int   num_paths = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1326,14 +1329,17 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	   any check to determine the reversability of the paths.
 	 */
 	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 
 	p_dest_port = (osm_port_t *) cl_qmap_head(p_tbl);
 	while (p_dest_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
 		p_src_port = (osm_port_t *) cl_qmap_head(p_tbl);
 		while (p_src_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
-			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
-						   p_src_port, p_dest_port,
-						   p_dgid, comp_mask, p_list);
+			num_paths += pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
+								p_src_port, p_dest_port,
+								p_dgid, comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && num_paths > 1)
+				return;
 
 			p_src_port =
 			    (osm_port_t *) cl_qmap_next(&p_src_port->map_item);
@@ -1358,6 +1364,8 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 {
 	const cl_qmap_t *p_tbl;
 	const osm_port_t *p_port;
+	const ib_sa_mad_t *p_sa_mad;
+	int   num_paths = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1367,6 +1375,7 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	   need to special case that one.
 	 */
 	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 
 	if (p_src_port) {
 		/*
@@ -1374,9 +1383,11 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 		 */
 		p_port = (osm_port_t *) cl_qmap_head(p_tbl);
 		while (p_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
-			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
-						   p_src_port, p_port, p_dgid,
-						   comp_mask, p_list);
+			num_paths += pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
+								p_src_port, p_port, p_dgid,
+								comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && num_paths > 1)
+				goto Exit;
 			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
 		}
 	} else {
@@ -1385,13 +1396,16 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 		 */
 		p_port = (osm_port_t *) cl_qmap_head(p_tbl);
 		while (p_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
-			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
-						   p_port, p_dest_port, p_dgid,
-						   comp_mask, p_list);
+			num_paths += pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
+								p_port, p_dest_port, p_dgid,
+								comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && num_paths > 1)
+				goto Exit;
 			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
 		}
 	}
 
+Exit:
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
