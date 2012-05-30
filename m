From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/include/opensm/osm_log.h: Fix commentary
 cut 'n paste error
Date: Wed, 30 May 2012 10:42:55 -0400
Message-ID: <4FC631EF.4080209@dev.mellanox.co.il>
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
diff --git a/include/opensm/osm_log.h b/include/opensm/osm_log.h
index b2f105a..4214cd4 100644
--- a/include/opensm/osm_log.h
+++ b/include/opensm/osm_log.h
@@ -102,7 +102,7 @@ typedef uint8_t osm_log_level_t;
 */
 #define OSM_LOG_DEFAULT_LEVEL		OSM_LOG_ERROR | OSM_LOG_INFO
 
-/****s* OpenSM: MAD Wrapper/osm_log_t
+/****s* OpenSM: Log/osm_log_t
 * NAME
 *	osm_log_t
 *
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
