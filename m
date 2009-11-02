From: elid <elid-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Return single PathRecord for SubnAdmGet with
 DGID/SGID wild carded
Date: Mon, 02 Nov 2009 17:59:10 +0200
Message-ID: <4AEF01CE.3040809@Voltaire.COM>
References: <1256902806-12040-1-git-send-email-elid@voltaire.com> <20091102150308.GB21323@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091102150308.GB21323@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Return single PathRecord for SubnAdmGet with DGID/SGID wildcarded

Instead of iterating over all ports in the fabric and returning an error (TOO_MANY_RECORDS),
when SGID and/or DGID are wild carded return only single PathRecord.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index c2ef8c5..b3e1072 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1313,6 +1313,7 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	const cl_qmap_t *p_tbl;
 	const osm_port_t *p_dest_port;
 	const osm_port_t *p_src_port;
+	const ib_sa_mad_t *p_sa_mad;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1325,6 +1326,7 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	   any check to determine the reversability of the paths.
 	 */
 	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 
 	p_dest_port = (osm_port_t *) cl_qmap_head(p_tbl);
 	while (p_dest_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
@@ -1333,6 +1335,9 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
 						   p_src_port, p_dest_port,
 						   p_dgid, comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && 
+			    cl_qlist_count(p_list) > 0)
+				goto Exit;
 
 			p_src_port =
 			    (osm_port_t *) cl_qmap_next(&p_src_port->map_item);
@@ -1342,6 +1347,7 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 		    (osm_port_t *) cl_qmap_next(&p_dest_port->map_item);
 	}
 
+Exit:
 	OSM_LOG_EXIT(sa->p_log);
 }
 
@@ -1357,6 +1363,7 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 {
 	const cl_qmap_t *p_tbl;
 	const osm_port_t *p_port;
+	const ib_sa_mad_t *p_sa_mad;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1366,6 +1373,7 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	   need to special case that one.
 	 */
 	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 
 	if (p_src_port) {
 		/*
@@ -1376,6 +1384,9 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
 						   p_src_port, p_port, p_dgid,
 						   comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && 
+			    cl_qlist_count(p_list) > 0)
+				break;
 			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
 		}
 	} else {
@@ -1387,6 +1398,9 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 			pr_rcv_get_port_pair_paths(sa, p_madw, requester_port,
 						   p_port, p_dest_port, p_dgid,
 						   comp_mask, p_list);
+			if (p_sa_mad->method == IB_MAD_METHOD_GET && 
+			    cl_qlist_count(p_list) > 0)
+				break;
 			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
 		}
 	}
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
