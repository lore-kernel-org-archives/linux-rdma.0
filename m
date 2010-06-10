From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] return no path when path does not exist
Date: Thu, 10 Jun 2010 18:01:31 +0300
Message-ID: <4C10FE4B.9080106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


return OSM_NO_PATH (instead of port num) when path does not exists.
this will also be reported as error in the log.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_switch.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index 311c4f7..b621852 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -628,6 +628,8 @@ uint8_t osm_switch_recommend_mcast_path(IN osm_switch_t * p_sw,
 	   a black hole that will destroy the Earth in a firey conflagration.
 	 */
 	least_hops = osm_switch_get_least_hops(p_sw, base_lid);
+	if (least_hops == OSM_NO_PATH)
+		return OSM_NO_PATH;
 	for (port_num = 1; port_num < num_ports; port_num++)
 		if (osm_switch_get_hop_count(p_sw, base_lid, port_num) ==
 		    least_hops)
-- 
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
