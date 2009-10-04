From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: separate router guid
 resolution code
Date: Sun, 4 Oct 2009 02:19:42 +0200
Message-ID: <20091004001942.GM17846@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Move off subnet destination (router address) resolution code to separate
function to improve readability.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |  122 +++++++++++++++--------------------
 1 files changed, 52 insertions(+), 70 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index b9c6055..c91c7a2 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1115,6 +1115,39 @@ Exit:
 
 /**********************************************************************
  **********************************************************************/
+/* Find the router port that is configured to handle this prefix, if any */
+static ib_net64_t find_router(osm_sa_t *sa, ib_net64_t prefix)
+{
+	osm_prefix_route_t *route = NULL;
+	osm_router_t *rtr;
+	cl_qlist_t *l = &sa->p_subn->prefix_routes_list;
+	cl_list_item_t *i;
+
+	OSM_LOG(sa->p_log, OSM_LOG_VERBOSE, "Non local DGID subnet prefix "
+		"0x%016" PRIx64 "\n", cl_ntoh64(prefix));
+
+	for (i = cl_qlist_head(l); i != cl_qlist_end(l); i = cl_qlist_next(i)) {
+		osm_prefix_route_t *r = (osm_prefix_route_t *)i;
+		if (!r->prefix || r->prefix == prefix) {
+			route = r;
+			break;
+		}
+	}
+	if (!route)
+		return 0;
+
+	if (route->guid == 0) /* first router */
+		rtr = (osm_router_t *) cl_qmap_head(&sa->p_subn->rtr_guid_tbl);
+	else
+		rtr = (osm_router_t *) cl_qmap_get(&sa->p_subn->rtr_guid_tbl,
+						   route->guid);
+
+	if (rtr == (osm_router_t *) cl_qmap_end(&sa->p_subn->rtr_guid_tbl))
+		return 0;
+
+	return osm_port_get_guid(osm_router_get_port_ptr(rtr));
+}
+
 static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 					IN const osm_madw_t * p_madw,
 					OUT const osm_port_t ** pp_src_port,
@@ -1127,8 +1160,6 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 	ib_net64_t dest_guid;
 	ib_api_status_t status;
 	ib_net16_t sa_status = IB_SA_MAD_STATUS_SUCCESS;
-	osm_router_t *p_rtr;
-	osm_port_t *p_rtr_port;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1209,75 +1240,23 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 		memset(p_dgid, 0, sizeof(*p_dgid));
 
 	if (comp_mask & IB_PR_COMPMASK_DGID) {
-		dest_guid = p_pr->dgid.unicast.interface_id;
-		if (!ib_gid_is_link_local(&p_pr->dgid)) {
-			if (!ib_gid_is_multicast(&p_pr->dgid) &&
-			    ib_gid_get_subnet_prefix(&p_pr->dgid) !=
-			    sa->p_subn->opt.subnet_prefix) {
-				/* Find the router port that is configured to
-				   handle this prefix, if any */
-				osm_prefix_route_t *route = NULL;
-				osm_prefix_route_t *r = (osm_prefix_route_t *)
-				    cl_qlist_head(&sa->p_subn->
-						  prefix_routes_list);
-
-				OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
-					"Non local DGID subnet prefix 0x%016"
-					PRIx64 "\n",
-					cl_ntoh64(p_pr->dgid.unicast.prefix));
-
-				while (r != (osm_prefix_route_t *)
-				       cl_qlist_end(&sa->p_subn->
-						    prefix_routes_list)) {
-					if (r->prefix ==
-					    p_pr->dgid.unicast.prefix
-					    || r->prefix == 0) {
-						route = r;
-						break;
-					}
-					r = (osm_prefix_route_t *)
-					    cl_qlist_next(&r->list_item);
-				}
-
-				if (!route) {
-					/*
-					   This 'error' is the client's fault (bad gid) so
-					   don't enter it as an error in our own log.
-					   Return an error response to the client.
-					 */
-					sa_status =
-					    IB_SA_MAD_STATUS_INVALID_GID;
-					goto Exit;
-				} else if (route->guid == 0) {
-					/* first router */
-					p_rtr = (osm_router_t *)
-					    cl_qmap_head(&sa->
-							 p_subn->rtr_guid_tbl);
-				} else {
-					p_rtr = (osm_router_t *)
-					    cl_qmap_get(&sa->p_subn->
-							rtr_guid_tbl,
-							route->guid);
-				}
-
-				if (p_rtr ==
-				    (osm_router_t *) cl_qmap_end(&sa->p_subn->
-								 rtr_guid_tbl))
-				{
-					OSM_LOG(sa->p_log, OSM_LOG_ERROR,
-						"ERR 1F22: "
-						"Off subnet DGID but router not found\n");
-					sa_status =
-					    IB_SA_MAD_STATUS_INVALID_GID;
-					goto Exit;
-				}
-
-				p_rtr_port = osm_router_get_port_ptr(p_rtr);
-				dest_guid = osm_port_get_guid(p_rtr_port);
-				if (p_dgid)
-					*p_dgid = p_pr->dgid;
+		if (!ib_gid_is_link_local(&p_pr->dgid) &&
+		    !ib_gid_is_multicast(&p_pr->dgid) &&
+		    ib_gid_get_subnet_prefix(&p_pr->dgid) !=
+		    sa->p_subn->opt.subnet_prefix) {
+			dest_guid = find_router(sa, p_pr->dgid.unicast.prefix);
+			if (!dest_guid) {
+				char gid_str[INET6_ADDRSTRLEN];
+				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F22: "
+					"Off subnet DGID %s, but router not "
+					"found\n",
+					inet_ntop(AF_INET6, p_pr->dgid.raw,
+						  gid_str, sizeof(gid_str)));
+				sa_status = IB_SA_MAD_STATUS_INVALID_GID;
+				goto Exit;
 			}
-		}
+		} else
+			dest_guid = p_pr->dgid.unicast.interface_id;
 
 		*pp_dest_port = osm_get_port_by_guid(sa->p_subn, dest_guid);
 		if (!*pp_dest_port) {
@@ -1293,6 +1272,9 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 			goto Exit;
 		}
+
+		if (p_dgid)
+			*p_dgid = p_pr->dgid;
 	} else {
 		*pp_dest_port = 0;
 		if (comp_mask & IB_PR_COMPMASK_DLID) {
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
