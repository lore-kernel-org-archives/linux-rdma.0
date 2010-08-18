From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: opensm/osm_opensm.c: no report when SM is exiting
Date: Wed, 18 Aug 2010 16:38:14 +0300
Message-ID: <4C6BE246.4080102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Don't bother reporting events to plug-ins while SM is exiting.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_opensm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index d3dc02e..50e8763 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -475,7 +475,7 @@ void osm_opensm_report_event(osm_opensm_t *osm, osm_epi_event_id_t event_id,
 	cl_list_item_t *item;

 	for (item = cl_qlist_head(&osm->plugin_list);
-	     item != cl_qlist_end(&osm->plugin_list);
+	     (!osm_exit_flag) && (item != cl_qlist_end(&osm->plugin_list));
 	     item = cl_qlist_next(item)) {
 		osm_epi_plugin_t *p = (osm_epi_plugin_t *)item;
 		if (p->impl->report)
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
