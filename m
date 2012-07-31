From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/27] opensm/osm_link_mgr.c: Set PortInfo:PortState to LinkDown when remote port isn't accessible
Date: Tue, 31 Jul 2012 19:04:31 +0300
Message-ID: <1343750695-28063-3-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There might be a scenario where port's link physical state is LinkUp,
but port's peer doesn't answer to SMPs. In this case we will move the port
to LinkDown.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 8301643..8733329 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -484,7 +484,7 @@ Exit:
 static int link_mgr_process_node(osm_sm_t * sm, IN osm_node_t * p_node,
 				 IN const uint8_t link_state)
 {
-	osm_physp_t *p_physp;
+	osm_physp_t *p_physp, *p_physp_remote;
 	uint32_t i, num_physp;
 	int ret = 0;
 	uint8_t current_state;
@@ -517,6 +517,19 @@ static int link_mgr_process_node(osm_sm_t * sm, IN osm_node_t * p_node,
 			continue;
 
 		/*
+		    Set PortState to DOWN in case Remote Physical Port is
+		    unreachable. We have to check this for all ports, except
+		    port zero.
+		 */
+		p_physp_remote = osm_physp_get_remote(p_physp);
+		if ((i != 0) && (!p_physp_remote ||
+		    !osm_physp_is_valid(p_physp_remote))) {
+			if (current_state != IB_LINK_INIT)
+				link_mgr_set_physp_pi(sm, p_physp, IB_LINK_DOWN);
+			continue;
+		}
+
+		/*
 		   Normally we only send state update if state is lower
 		   then required state. However, we need to send update if
 		   no state change required.
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
