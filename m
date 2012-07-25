From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_inform.c: Make log message format consistent
 for error messages
Date: Wed, 25 Jul 2012 06:39:46 -0400
Message-ID: <500FCCF2.4060008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 2eb646a..f5abbc6 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -314,7 +314,7 @@ static ib_api_status_t send_report(IN osm_infr_t * p_infr_rec,	/* the informinfo
 					 &(p_infr_rec->report_addr));
 
 	if (!p_report_madw) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0203"
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0203: "
 			"osm_mad_pool_get failed\n");
 		status = IB_ERROR;
 		goto Exit;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
