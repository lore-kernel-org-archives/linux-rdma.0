From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_link_mgr.c: Fix IBA reference for PortInfo
	attribute
Date: Fri, 6 Nov 2009 15:42:19 -0500
Message-ID: <20091106204219.GA13988@comcast.net>
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
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index bcfc269..62c365e 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -115,7 +115,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 		/*
 		   CAs don't have a port 0, and for switch port 0,
 		   we need to check if this is enhanced or base port 0.
-		   For base port 0 the following parameters are not valid (p822, table 145).
+		   For base port 0 the following parameters are not valid
+		   (IBA 1.2.1 p.830 table 146).
 		 */
 		if (!p_node->sw) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4201: "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
