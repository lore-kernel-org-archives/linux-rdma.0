From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_log.c: add OSM_LOG_SYS to default flags
Date: Mon, 17 May 2010 10:22:04 +0300
Message-ID: <4BF0EE9C.7030607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As suggested by Sasha, instead of checking OSM_LOG_SYS in
osm_log_is_active(), just adding OSM_LOG_SYS to default flags.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_log.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_log.c b/opensm/opensm/osm_log.c
index 54c2f36..bd4a200 100644
--- a/opensm/opensm/osm_log.c
+++ b/opensm/opensm/osm_log.c
@@ -119,7 +119,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 #endif				/* __WIN__ */

 	/* If this is a call to syslog - always print it */
-	if (!(verbosity & (OSM_LOG_SYS | p_log->level)))
+	if (!(verbosity & p_log->level))
 		return;

 	va_start(args, p_str);
@@ -306,7 +306,7 @@ ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
 				IN unsigned long max_size,
 				IN boolean_t accum_log_file)
 {
-	p_log->level = log_flags;
+	p_log->level = log_flags | OSM_LOG_SYS;
 	p_log->flush = flush;
 	p_log->count = 0;
 	p_log->max_size = max_size << 20; /* convert size in MB to bytes */
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
