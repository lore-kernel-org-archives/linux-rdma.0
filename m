From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 25/27] Increase p_port->discovery_count only when received PortInfo for port 0 of the switch
Date: Tue, 31 Jul 2012 19:04:53 +0300
Message-ID: <1343750695-28063-25-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some broken SMA may respond to all MADs except of PortInfo port 0. As a result we want
to drop such switch as it's not healthy.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index ab7418b..692dc2e 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -568,7 +568,6 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 	if (p_context->set_method)
 		pi_rcv_process_set(sm, p_node, port_num, p_madw);
 	else {
-		p_port->discovery_count++;
 
 		/*
 		   This PortInfo arrived because we did a Get() method,
@@ -600,10 +599,13 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		switch (osm_node_get_type(p_node)) {
 		case IB_NODE_TYPE_CA:
 		case IB_NODE_TYPE_ROUTER:
+			p_port->discovery_count++;
 			pi_rcv_process_ca_or_router_port(sm, p_node, p_physp,
 							 p_pi);
 			break;
 		case IB_NODE_TYPE_SWITCH:
+			if (port_num == 0)
+				p_port->discovery_count++;
 			pi_rcv_process_switch_port(sm, p_node, p_physp, p_pi);
 			break;
 		default:
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
