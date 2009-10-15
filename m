From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_ucast_updn.c: Further reduction in cas_per_sw
	allocation
Date: Thu, 15 Oct 2009 16:00:29 -0400
Message-ID: <20091015200028.GA14851@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Use cl_ptr_vector_get_size for max lid

diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index ced076a..e81a299 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -432,13 +432,14 @@ static void updn_find_root_nodes_by_min_hop(OUT updn_t * p_updn)
 		"Current number of ports in the subnet is %d\n",
 		cl_qmap_count(&p_osm->subn.port_guid_tbl));
 
-	cas_per_sw = malloc(p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
+	lid_ho = (uint16_t) cl_ptr_vector_get_size(&p_updn->p_osm->subn.port_lid_tbl) + 1;
+	cas_per_sw = malloc(lid_ho * sizeof(*cas_per_sw));
 	if (!cas_per_sw) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR AA14: "
 			"cannot alloc mem for CAs per switch counter array\n");
 		goto _exit;
 	}
-	memset(cas_per_sw, 0, p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
+	memset(cas_per_sw, 0, lid_ho * sizeof(*cas_per_sw));
 
 	/* Find the Maximum number of CAs (and routers) for histogram normalization */
 	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
