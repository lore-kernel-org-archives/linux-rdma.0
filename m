From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_req.c: In req_determine_mkey, fix DR algorithm
Date: Mon, 03 Dec 2012 10:25:12 -0500
Message-ID: <50BCC458.1030305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so that it works regardless of SM port type
Now works on switch port 0 as well as CA and router ports

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_req.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 1f5db3f..b48be48 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -87,16 +87,20 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		goto Remote_Guid;
 	}
 
-	if (p_sm_port)
+	if (p_sm_port) {
+		/* get the node for the SM */
+		p_node = p_sm_port->p_node;
 		p_physp = p_sm_port->p_physp;
+	}
 
-	/* hop_count == 1: outgoing physp is SM physp */
-	for (hop = 2; p_physp && hop <= p_path->hop_count; hop++) {
+	for (hop = 1; p_physp && hop <= p_path->hop_count; hop++) {
+		p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
+		if (!p_physp)
+			break;
 		p_physp = p_physp->p_remote_physp;
 		if (!p_physp)
 			break;
 		p_node = p_physp->p_node;
-		p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
 	}
 
 	/* At this point, p_physp points at the outgoing physp on the
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
