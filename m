From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_sa_path_record.c: Add missing end-of-line
 in the log message
Date: Wed, 25 Jul 2012 06:40:33 -0400
Message-ID: <500FCD21.9020807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 70e7b61..d37d35c 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -306,7 +306,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F05: "
 				"Can't find remote phys port of %s (GUID: "
 				"0x%016"PRIx64") port %d "
-				"while routing to LID %u",
+				"while routing to LID %u\n",
 				p_node->print_desc,
 				cl_ntoh64(osm_node_get_node_guid(p_node)),
 				tmp_pnum,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
