From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_state_mgr.c: do not probe remote side of port
 0
Date: Tue, 10 Nov 2009 11:37:38 +0200
Message-ID: <4AF93462.6070504@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not probe remote side of port 0 of the switch
that SM is running on - spare the timeout error.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_state_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 4303d6e..122a8d4 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -453,7 +453,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 		 * subnet come up.
 		 */
 		num_ports = osm_node_get_num_physp(p_node);
-		for (port_num = 0; port_num < num_ports; port_num++) {
+		for (port_num = 1; port_num < num_ports; port_num++) {
 			/* go through the port only if the port is not DOWN */
 			p_ext_physp = osm_node_get_physp_ptr(p_node, port_num);
 			if (p_ext_physp && ib_port_info_get_port_state
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
