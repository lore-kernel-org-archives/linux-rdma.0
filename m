From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osmeventplugin.c: Modify osm_event_plugin_t initialization
Date: Tue, 27 Jan 2015 18:40:02 +0200
Message-ID: <1422376802-32161-1-git-send-email-ilyan@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, sashakot-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

SM event plugin structure initialization was modified
to be alligned with C89 standard.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmeventplugin/src/osmeventplugin.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index d7975a3..cba69ea 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -227,8 +227,8 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 #endif
 
 osm_event_plugin_t osm_event_plugin = {
-      osm_version:OSM_VERSION,
-      create:construct,
-      delete:destroy,
-      report:report
+      OSM_VERSION,
+      construct,
+      destroy,
+      report
 };
-- 
1.8.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
