From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_prtn.c: Fix typo in log message
Date: Tue, 27 Dec 2011 19:11:26 -0500
Message-ID: <4EFA5EAE.5010903@dev.mellanox.co.il>
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
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 6c324cf..a5a97df 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -371,7 +371,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 	    p_subn->opt.partition_config_file : OSM_DEFAULT_PARTITION_CONFIG_FILE;
 	if (stat(file_name, &statbuf)) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "Partition configuration "
-			"%s is not accesible (%s)\n", file_name,
+			"%s is not accessible (%s)\n", file_name,
 			strerror(errno));
 		is_config = FALSE;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
