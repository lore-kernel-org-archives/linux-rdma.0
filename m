From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_multipath_record.c: livelock in
	mpr_rcv_get_path_parms
Date: Mon, 24 May 2010 15:43:53 -0400
Message-ID: <20100524194353.GB26919@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Similar to commit 1010c9c5014d5a6af2db33e27ae7156f239e7254 for
opensm/osm_sa_path_record.c:pr_rcv_get_path_parms

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 opensm/opensm/osm_sa_multipath_record.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_sa_multipath_record.c b/opensm/opensm/osm_sa_multipath_record.c
index cb27e9d..18a0122 100644
--- a/opensm/opensm/osm_sa_multipath_record.c
+++ b/opensm/opensm/osm_sa_multipath_record.c
@@ -62,6 +62,7 @@
 #include <opensm/osm_sa.h>
 
 #define OSM_SA_MPR_MAX_NUM_PATH        127
+#define MAX_HOPS 64
 
 typedef struct osm_mpr_item {
 	cl_list_item_t list_item;
@@ -295,7 +296,23 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 			goto Exit;
 		}
 
+		/* update number of hops traversed */
 		hops++;
+		if (hops > MAX_HOPS) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4520: "
+				"Path from GUID 0x%016" PRIx64 " (%s) to"
+				" lid %u GUID 0x%016" PRIx64 " (%s) needs"
+				" more than %d hops, max %d hops allowed\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc, dest_lid_ho,
+				cl_ntoh64(osm_physp_get_port_guid
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc, hops,
+				MAX_HOPS);
+			status = IB_NOT_FOUND;
+			goto Exit;
+		}
+
 		in_port_num = osm_physp_get_port_num(p_physp);
 
 		/*
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
