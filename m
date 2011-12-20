From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm/osm_perfmgr.c: Enhance send error log message
Date: Tue, 20 Dec 2011 15:08:27 -0500
Message-ID: <4EF0EB3B.2010600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index ded5a5e..41ef08b 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -212,7 +212,10 @@ static void perfmgr_mad_send_err_callback(void *bind_context,
 	p_mon_node = (monitored_node_t *) p_node;
 
 	OSM_LOG(pm->log, OSM_LOG_ERROR, "ERR 4C02: %s (0x%" PRIx64
-		") port %u\n", p_mon_node->name, p_mon_node->guid, port);
+		") port %u LID %u TID 0x%" PRIx64 "\n",
+		p_mon_node->name, p_mon_node->guid, port,
+		cl_ntoh16(p_madw->mad_addr.dest_lid),
+		cl_ntoh64(p_madw->p_mad->trans_id));
 
 	if (pm->subn->opt.perfmgr_redir && p_madw->status == IB_TIMEOUT) {
 		/* First, find the node in the monitored map */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
