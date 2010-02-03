From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_pkey_record.c: optimize port selection logic
Date: Wed, 3 Feb 2010 13:00:54 +0200
Message-ID: <20100203110054.GB26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Optimize port selection logic when port LID is explicitly requested
or wildcarded. Remove unneeded variable.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_pkey_record.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_sa_pkey_record.c
index c4c974e..5b1c794 100644
--- a/opensm/opensm/osm_sa_pkey_record.c
+++ b/opensm/opensm/osm_sa_pkey_record.c
@@ -213,7 +213,6 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	const ib_pkey_table_t *p_pkey;
 	cl_qlist_t rec_list;
 	osm_pkey_search_ctxt_t context;
-	ib_api_status_t status = IB_SUCCESS;
 	ib_net64_t comp_mask;
 	osm_physp_t *p_req_physp;
 
@@ -291,23 +290,15 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	 */
 	if (comp_mask & IB_PKEY_COMPMASK_LID) {
 		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
-		if (!p_port) {
-			status = IB_NOT_FOUND;
+		if (!p_port)
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 460B: "
 				"No port found with LID %u\n",
 				cl_ntoh16(p_rcvd_rec->lid));
-		}
-	}
-
-	if (status == IB_SUCCESS) {
-		/* if we got a unique port - no need for a port search */
-		if (p_port)
-			/* this does the loop on all the port phys ports */
-			sa_pkey_by_comp_mask(sa, p_port, &context);
 		else
-			cl_qmap_apply_func(&sa->p_subn->port_guid_tbl,
-					   sa_pkey_by_comp_mask_cb, &context);
-	}
+			sa_pkey_by_comp_mask(sa, p_port, &context);
+	} else
+		cl_qmap_apply_func(&sa->p_subn->port_guid_tbl,
+				   sa_pkey_by_comp_mask_cb, &context);
 
 	cl_plock_release(sa->p_lock);
 
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
