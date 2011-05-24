From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/4] opensm/osm_pkey_mgr.c: Detect pkey table overflow in
 pkey_mgr_update_port
Date: Tue, 24 May 2011 13:25:21 -0400
Message-ID: <4DDBEA01.8010701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey_mgr.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 4c92c05..70471b0 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -343,17 +343,16 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 				if (pkey_index >= IB_NUM_PKEY_ELEMENTS_IN_BLOCK) {
 					block_index++;
 					pkey_index -= IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
-					if (block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index >= pkey_mgr_get_physp_max_pkeys(p_physp)) {
-						OSM_LOG(p_log, OSM_LOG_ERROR,
-							"ERR 0512: "
-							"Failed to set PKey 0x%04x since Pkey table is full "
-							"for node 0x%016" PRIx64 " port %u (%s)\n",
-
-							cl_ntoh16(p_pending->pkey),
-							cl_ntoh64(osm_node_get_node_guid(p_node)),
-							osm_physp_get_port_num(p_physp),
-							p_physp->p_node->print_desc);
-					}
+				}
+				if (block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index >= pkey_mgr_get_physp_max_pkeys(p_physp)) {
+					OSM_LOG(p_log, OSM_LOG_ERROR,
+						"ERR 0512: "
+						"Failed to set PKey 0x%04x because Pkey table is full "
+						"for node 0x%016" PRIx64 " port %u (%s)\n",
+						cl_ntoh16(p_pending->pkey),
+						cl_ntoh64(osm_node_get_node_guid(p_node)),
+						osm_physp_get_port_num(p_physp),
+						p_physp->p_node->print_desc);
 				} else
 					found = TRUE;
 			}
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
