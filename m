From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: fix bug in MC root switch
 calculation
Date: Thu, 4 Feb 2010 22:47:13 +0200
Message-ID: <20100204204713.GJ26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In newly introduced MC group root switch calculation method as it is
now, sw->num_of_mcm field (number of MC group members connected to this
switch) is updated only once when switch is first visited (for some
reason it is under such 'if' block), as result it will always '1' or
'0', which is obviously not correct and breaks the following hops
calculations algorithm. Fix this - update sw->num_of_mcm field
unconditionally.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index abd54a0..ef288b8 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -190,18 +190,17 @@ static void mcast_mgr_build_switch_map(osm_sm_t * sm,
 		remote_sw = remote_node->sw;
 		port_guid = osm_node_get_node_guid(remote_node);
 		if (cl_qmap_get(p_mcast_member_sw_tbl, port_guid) ==
-		    cl_qmap_end(p_mcast_member_sw_tbl)) {
+		    cl_qmap_end(p_mcast_member_sw_tbl))
 			/* insert switch to table */
 			cl_qmap_insert(p_mcast_member_sw_tbl, port_guid,
 				       &remote_sw->mgrp_item);
-			/* New element in the table */
-			if (p_port->p_node->sw)
-				/* the switch is MC member */
-				remote_sw->is_mc_member = 1;
-			else
-				/* for others - update MC count */
-				remote_sw->num_of_mcm++;
-		}
+
+		if (p_port->p_node->sw)
+			/* the switch is MC member */
+			remote_sw->is_mc_member = 1;
+		else
+			/* for others - update MC count */
+			remote_sw->num_of_mcm++;
 	}
 	OSM_LOG_EXIT(sm->p_log);
 }
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
