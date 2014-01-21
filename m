From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] [TRIVIAL] opensm: Fix small compile error
Date: Tue, 21 Jan 2014 15:51:46 -0800
Message-ID: <1390348306.6153.356.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 osmeventplugin/src/osmeventplugin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index 1eaf7ea..0feada8 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -195,7 +195,7 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 		fprintf(log->log_file, "Heavy sweep completed\n");
 		break;
 	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
-		fprintf(log->log_file, "Unicast routing completed %d\n", event_data);
+		fprintf(log->log_file, "Unicast routing completed %p\n", event_data);
 		break;
 	case OSM_EVENT_ID_STATE_CHANGE:
 		fprintf(log->log_file, "SM state changed\n");
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
