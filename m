From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_log.h: osm_log_is_active should return true for
	syslog
Date: Tue, 11 May 2010 12:06:01 +0300
Message-ID: <4BE91DF9.4020902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


osm_log() always logs messages that came with OSM_LOG_SYS level,
so osm_log_is_active() should concur with this.
As a by-product of this fix, OSM_LOG_SYS messages can now be
printed with OSM_LOG macro, instead of using osm_log() directly.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_log.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_log.h b/opensm/include/opensm/osm_log.h
index b2f105a..a494bc3 100644
--- a/opensm/include/opensm/osm_log.h
+++ b/opensm/include/opensm/osm_log.h
@@ -355,7 +355,7 @@ static inline void osm_log_set_level(IN osm_log_t * p_log,
 static inline boolean_t osm_log_is_active(IN const osm_log_t * p_log,
 					  IN osm_log_level_t level)
 {
-	return ((p_log->level & level) != 0);
+	return (((OSM_LOG_SYS | p_log->level) & level) != 0);
 }

 /*
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
