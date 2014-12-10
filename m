From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_perfmgr.c: Reset physp_discovered before discovery
Date: Wed, 10 Dec 2014 12:29:17 -0500
Message-ID: <548882ED.5000400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>, Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Bug description:
When PerfMgr starts discovery, it resets the discovery_count of ports and
node, but it doesn't reset the physp_discoved buffers.
As a result, the drop manager frees osm_port_t and osm_physp_t objects
of nodes without removing the nodes themselves.
On the next discovery process, when OpenSM receives responses for
NodeInfo from a switch, it treats it as a NodeInfo from an existing
node and assumes that osm_physp_t objects of the switch exists and tries
to access them.

This change adds code that clears the physp_discoverd buffers of all nodes
at the beginning of the discovery process in PerfMgr.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_perfmgr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 4ab654b..993fdb7 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -985,6 +985,9 @@ static void reset_node_count(cl_map_item_t * p_map_item, void *cxt)
 {
 	osm_node_t *p_node = (osm_node_t *) p_map_item;
 	p_node->discovery_count = 0;
+
+	memset(p_node->physp_discovered, 0,
+	       sizeof(uint8_t) * p_node->physp_tbl_size);
 }
 
 static void reset_port_count(cl_map_item_t * p_map_item, void *cxt)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
