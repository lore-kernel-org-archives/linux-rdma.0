From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: preserve root switch calculation
 functionality
Date: Fri, 5 Feb 2010 00:22:13 +0200
Message-ID: <20100204222213.GL26338@me>
References: <20100204204713.GJ26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100204204713.GJ26338@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


I'm not sure that this is a bug, but anyway. Now for MC group spanning
tree root switch calculation it uses max hops criteria differently -
accumulated hops for all MC members connected to the switch against
previous maximal one.

This patch makes it functionally exactly as it was.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index f33d6a6..322635d 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -253,7 +253,8 @@ static float mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qmap_t * m,
 		sw = cl_item_obj(i, sw, mgrp_item);
 		lid = cl_ntoh16(osm_node_get_base_lid(sw->p_node, 0));
 		hops = osm_switch_get_least_hops(this_sw, lid);
-		hops = (hops + 1) * sw->num_of_mcm + hops * sw->is_mc_member;
+		if (!sw->is_mc_member)
+			hops += 1;
 		if (hops > max_hops)
 			max_hops = hops;
 	}
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
