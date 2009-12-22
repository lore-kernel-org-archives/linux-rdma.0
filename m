From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osm_sa_path_record.c: use PR DGID by reference
Date: Tue, 22 Dec 2009 13:57:20 +0200
Message-ID: <20091222115720.GE26940@me>
References: <20091215170317.GV5262@me>
 <20091215171532.GA8288@obsidianresearch.com>
 <20091215091819.c217cf36.weiny2@llnl.gov>
 <f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
 <20091215185511.3ae458cc.weiny2@llnl.gov>
 <f0e08f230912160529h64424ba7id5c57dffb770380c@mail.gmail.com>
 <20091217181800.a1ee6b9b.weiny2@llnl.gov>
 <20091220195710.GA18524@me>
 <20091222113701.GC26940@me>
 <20091222113842.GD26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091222113842.GD26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When passing an original value of DGID requested (currently only for
inter-subnet PR requests) use it by reference instead of copied value.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index b78225e..4614b6d 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -754,16 +754,12 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 {
 	const osm_physp_t *p_src_physp;
 	const osm_physp_t *p_dest_physp;
-	boolean_t is_nonzero_gid = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
 
 	p_src_physp = p_src_port->p_physp;
 
 	if (p_dgid)
-		is_nonzero_gid = ib_gid_is_notzero(p_dgid);
-
-	if (is_nonzero_gid)
 		p_pr->dgid = *p_dgid;
 	else {
 		p_dest_physp = p_dest_port->p_physp;
@@ -783,7 +779,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 	p_pr->hop_flow_raw &= cl_hton32(1 << 31);
 
 	/* Only set HopLimit if going through a router */
-	if (is_nonzero_gid)
+	if (p_dgid)
 		p_pr->hop_flow_raw |= cl_hton32(IB_HOPLIMIT_MAX);
 
 	p_pr->pkey = p_parms->pkey;
@@ -1133,7 +1129,7 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 					IN const osm_madw_t * p_madw,
 					OUT const osm_port_t ** pp_src_port,
 					OUT const osm_port_t ** pp_dest_port,
-					OUT ib_gid_t * p_dgid)
+					OUT const ib_gid_t ** pp_dgid)
 {
 	const ib_path_rec_t *p_pr;
 	const ib_sa_mad_t *p_sa_mad;
@@ -1217,9 +1213,6 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 		}
 	}
 
-	if (p_dgid)
-		memset(p_dgid, 0, sizeof(*p_dgid));
-
 	if (comp_mask & IB_PR_COMPMASK_DGID) {
 		if (!ib_gid_is_link_local(&p_pr->dgid) &&
 		    !ib_gid_is_multicast(&p_pr->dgid) &&
@@ -1236,8 +1229,8 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 				sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 				goto Exit;
 			}
-			if (p_dgid)
-				*p_dgid = p_pr->dgid;
+			if (pp_dgid)
+				*pp_dgid = &p_pr->dgid;
 		} else
 			dest_guid = p_pr->dgid.unicast.interface_id;
 
@@ -1560,7 +1553,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	const osm_port_t *p_src_port;
 	const osm_port_t *p_dest_port;
 	cl_qlist_t pr_list;
-	ib_gid_t dgid;
+	const ib_gid_t *p_dgid = NULL;
 	ib_net16_t sa_status;
 	osm_port_t *requester_port;
 
@@ -1614,7 +1607,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unicast destination requested\n");
 
 	sa_status = pr_rcv_get_end_points(sa, p_madw, &p_src_port, &p_dest_port,
-					  &dgid);
+					  &p_dgid);
 	if (sa_status == IB_SA_MAD_STATUS_SUCCESS) {
 		/*
 		   What happens next depends on the type of endpoint information
@@ -1624,17 +1617,17 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 			if (p_dest_port)
 				pr_rcv_process_pair(sa, p_madw, requester_port,
 						    p_src_port, p_dest_port,
-						    &dgid, p_sa_mad->comp_mask,
+						    p_dgid, p_sa_mad->comp_mask,
 						    &pr_list);
 			else
 				pr_rcv_process_half(sa, p_madw, requester_port,
-						    p_src_port, NULL, &dgid,
+						    p_src_port, NULL, p_dgid,
 						    p_sa_mad->comp_mask,
 						    &pr_list);
 		} else {
 			if (p_dest_port)
 				pr_rcv_process_half(sa, p_madw, requester_port,
-						    NULL, p_dest_port, &dgid,
+						    NULL, p_dest_port, p_dgid,
 						    p_sa_mad->comp_mask,
 						    &pr_list);
 			else
@@ -1642,7 +1635,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 				   Katie, bar the door!
 				 */
 				pr_rcv_process_world(sa, p_madw, requester_port,
-						     &dgid, p_sa_mad->comp_mask,
+						     p_dgid, p_sa_mad->comp_mask,
 						     &pr_list);
 		}
 	}
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
