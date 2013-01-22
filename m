From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 02/10] opensm/osm_ucast_dfsssp.c : Fix resource leak
Date: Wed, 23 Jan 2013 01:39:13 +0900
Message-ID: <1358872753-16885-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Variable "head" going out of scope leaks the storage it points to.

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index ff525ea..013bad4 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1161,6 +1161,11 @@ static int dfsssp_build_graph(void *context)
 				OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 					"ERR AD08: cannot allocate memory for a link\n");
 				dfsssp_context_destroy(context);
+				while (head) {
+					link = head;
+					head = head->next;
+					free(link);
+                                }
 				return 1;
 			}
 			link = link->next;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
