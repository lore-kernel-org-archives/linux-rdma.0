From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: make osm_pr_rcv_get_end_points,
 osm_pr_rcv_process_pair, osm_pr_rcv_process_half public
Date: Mon, 25 Feb 2013 08:30:54 -0800
Message-ID: <20130225083054.86f6e85ec37cb21a81b4eb32@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also change their name to from osm_pr_rcv_* to osm_pr_*

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_sa.h     |   25 +++++++++++++++++++++++++
 opensm/osm_sa_path_record.c |   22 +++++++++++-----------
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index 8393412..f9f334e 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -576,5 +576,30 @@ ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
 				    IN const uint16_t dlid_ho,
 				    OUT osm_path_parms_t * p_parms);
 
+ib_net16_t osm_pr_get_end_points(IN osm_sa_t * sa,
+					IN const ib_sa_mad_t *sa_mad,
+					OUT const osm_alias_guid_t ** pp_src_alias_guid,
+					OUT const osm_alias_guid_t ** pp_dest_alias_guid,
+					OUT const osm_port_t ** pp_src_port,
+					OUT const osm_port_t ** pp_dest_port,
+					OUT const ib_gid_t ** pp_sgid,
+					OUT const ib_gid_t ** pp_dgid);
+
+void osm_pr_process_pair(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
+				IN const osm_port_t * requester_port,
+				IN const osm_alias_guid_t * p_src_alias_guid,
+				IN const osm_alias_guid_t * p_dest_alias_guid,
+				IN const ib_gid_t * p_sgid,
+				IN const ib_gid_t * p_dgid,
+				IN cl_qlist_t * p_list);
+
+void osm_pr_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
+				IN const osm_port_t * requester_port,
+				IN const osm_alias_guid_t * p_src_alias_guid,
+				IN const osm_alias_guid_t * p_dest_alias_guid,
+				IN const ib_gid_t * p_sgid,
+				IN const ib_gid_t * p_dgid,
+				IN cl_qlist_t * p_list);
+
 END_C_DECLS
 #endif				/* _OSM_SA_H_ */
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index c121dba..1bec16d 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1251,7 +1251,7 @@ static ib_net64_t find_router(const osm_sa_t *sa, ib_net64_t prefix)
 	return osm_port_get_guid(osm_router_get_port_ptr(rtr));
 }
 
-static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
+ib_net16_t osm_pr_get_end_points(IN osm_sa_t * sa,
 					IN const ib_sa_mad_t *sa_mad,
 					OUT const osm_alias_guid_t ** pp_src_alias_guid,
 					OUT const osm_alias_guid_t ** pp_dest_alias_guid,
@@ -1430,7 +1430,7 @@ Exit:
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-static void pr_rcv_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
+void osm_pr_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 				IN const osm_port_t * requester_port,
 				IN const osm_alias_guid_t * p_src_alias_guid,
 				IN const osm_alias_guid_t * p_dest_alias_guid,
@@ -1485,7 +1485,7 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-static void pr_rcv_process_pair(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
+void osm_pr_process_pair(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 				IN const osm_port_t * requester_port,
 				IN const osm_alias_guid_t * p_src_alias_guid,
 				IN const osm_alias_guid_t * p_dest_alias_guid,
@@ -1771,7 +1771,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unicast destination requested\n");
 
-	if (pr_rcv_get_end_points(sa, p_sa_mad,
+	if (osm_pr_get_end_points(sa, p_sa_mad,
 				  &p_src_alias_guid, &p_dest_alias_guid,
 				  &p_src_port, &p_dest_port,
 				  &p_sgid, &p_dgid) != IB_SA_MAD_STATUS_SUCCESS)
@@ -1782,11 +1782,11 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	 */
 	if (p_src_alias_guid) {
 		if (p_dest_alias_guid)
-			pr_rcv_process_pair(sa, p_sa_mad, requester_port,
+			osm_pr_process_pair(sa, p_sa_mad, requester_port,
 					    p_src_alias_guid, p_dest_alias_guid,
 					    p_sgid, p_dgid, &pr_list);
 		else if (!p_dest_port)
-			pr_rcv_process_half(sa, p_sa_mad, requester_port,
+			osm_pr_process_half(sa, p_sa_mad, requester_port,
 					    p_src_alias_guid, NULL, p_sgid,
 					    p_dgid, &pr_list);
 		else {
@@ -1796,7 +1796,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 			       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
 				if (osm_get_port_by_alias_guid(sa->p_subn, p_dest_alias_guid->alias_guid) ==
 				    p_dest_port)
-					pr_rcv_process_pair(sa, p_sa_mad,
+					osm_pr_process_pair(sa, p_sa_mad,
 							    requester_port,
 							    p_src_alias_guid,
 							    p_dest_alias_guid,
@@ -1811,7 +1811,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 		}
 	} else {
 		if (p_dest_alias_guid)
-			pr_rcv_process_half(sa, p_sa_mad, requester_port,
+			osm_pr_process_half(sa, p_sa_mad, requester_port,
 					    NULL, p_dest_alias_guid, p_sgid,
 					    p_dgid, &pr_list);
 		else if (!p_src_port && !p_dest_port)
@@ -1828,7 +1828,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 				if (osm_get_port_by_alias_guid(sa->p_subn,
 							       p_src_alias_guid->alias_guid) ==
 				    p_src_port)
-					pr_rcv_process_half(sa, p_sa_mad,
+					osm_pr_process_half(sa, p_sa_mad,
 							    requester_port,
 							    p_src_alias_guid,
 							    NULL, p_sgid,
@@ -1843,7 +1843,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 				if (osm_get_port_by_alias_guid(sa->p_subn,
 							       p_dest_alias_guid->alias_guid) ==
 				    p_dest_port)
-					pr_rcv_process_half(sa, p_sa_mad,
+					osm_pr_process_half(sa, p_sa_mad,
 							    requester_port,
 							    NULL,
 							    p_dest_alias_guid,
@@ -1866,7 +1866,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 						if (osm_get_port_by_alias_guid(sa->p_subn,
 									       p_dest_alias_guid->alias_guid) ==
 						    p_dest_port)
-						pr_rcv_process_pair(sa,
+						osm_pr_process_pair(sa,
 								    p_sa_mad,
 								    requester_port,
 								    p_src_alias_guid,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
