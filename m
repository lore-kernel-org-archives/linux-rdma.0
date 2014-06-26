From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_drop_mgr.c: Add missing CR at end of log message
 in drop_mgr_check_node
Date: Thu, 26 Jun 2014 08:16:38 -0400
Message-ID: <53AC0F26.9090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_drop_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 7eb174c..66c85b9 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -525,7 +525,7 @@ static void drop_mgr_check_node(osm_sm_t * sm, IN osm_node_t * p_node)
 					"Unlinking local node 0x%" PRIx64
 					", port %u"
 					"\n\t\t\t\tand remote node 0x%" PRIx64
-					", port %u\n due to missing PortInfo",
+					", port %u due to missing PortInfo\n",
 					cl_ntoh64(osm_node_get_node_guid
 						  (p_node)), port_num,
 					cl_ntoh64(osm_node_get_node_guid
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
