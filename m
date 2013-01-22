From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 05/10] OpenSM: dfsssp ignores differences in the lmc value
Date: Wed, 23 Jan 2013 01:40:29 +0900
Message-ID: <1358872829-16969-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

dfsssp used one port representative to obtain the lmc value for all ports;
but lmc can vary, e.g. SW base port 0 vs. CA port

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index f88382b..3e9bc31 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1145,7 +1145,7 @@ static int dfsssp_build_graph(void *context)
 				continue;
 			/* if there is a Hca connected -> count and cycle */
 			if (!remote_node->sw) {
-				lmc = osm_port_get_lmc(p_port);
+				lmc = osm_node_get_lmc(remote_node, (uint32_t)remote_port);
 				adj_list[i].num_hca += (1 << lmc);
 				continue;
 			}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
