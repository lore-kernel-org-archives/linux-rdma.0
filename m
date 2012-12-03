From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_req.c: In req_determine_mkey, use osm_physp
 APIs
Date: Mon, 03 Dec 2012 10:25:21 -0500
Message-ID: <50BCC461.5060604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather tha direct accesses to physp struct

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_req.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index b48be48..caf94fb 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -97,10 +97,10 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
 		if (!p_physp)
 			break;
-		p_physp = p_physp->p_remote_physp;
+		p_physp = osm_physp_get_remote(p_physp);
 		if (!p_physp)
 			break;
-		p_node = p_physp->p_node;
+		p_node = osm_physp_get_node_ptr(p_physp);
 	}
 
 	/* At this point, p_physp points at the outgoing physp on the
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
