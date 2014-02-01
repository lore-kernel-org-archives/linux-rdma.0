From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_port.c: Improve ERR 4108 log message
Date: Sat, 01 Feb 2014 11:20:05 -0500
Message-ID: <52ED1EB5.9080206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Even though routine name is called osm_physp_set_pkey_tbl, this is
called for GetResp to either Get or Set so change set to update in
log message.

Also, indicate max_blocks in message.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index bcee338..ae74ba6 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -632,9 +632,9 @@ void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 
 	if (block_num >= max_blocks) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 4108: "
-			"Got illegal set for block number:%u "
-			"For GUID: %" PRIx64 " port number:%u\n",
-			block_num,
+			"Got illegal update for block number:%u max:%u "
+			"for GUID: %" PRIx64 " port number:%u\n",
+			block_num, max_blocks,
 			cl_ntoh64(p_physp->p_node->node_info.node_guid),
 			p_physp->port_num);
 		return;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
