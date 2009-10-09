From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr.c: Fix typo in OSM_LOG message
Date: Fri, 9 Oct 2009 10:47:50 -0400
Message-ID: <20091009144750.GB17861@comcast.net>
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
diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 947fe7a..74b5e39 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -1051,7 +1051,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 	    && !p_mgr->p_subn->opt.no_clients_rereg
 	    && (p_old_pi->capability_mask & IB_PORT_CAP_HAS_CLIENT_REREG)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-			"Seting client rereg on %s, port %d\n",
+			"Setting client rereg on %s, port %d\n",
 			p_port->p_node->print_desc, p_port->p_physp->port_num);
 		ib_port_info_set_client_rereg(p_pi, 1);
 		send_set = TRUE;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
