From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 10/13] opensm/osm_sa.c: Change log level of message
Date: Fri, 29 Apr 2011 09:27:54 -0400
Message-ID: <4DBABCDA.8030408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 62b4e09b5461ea7a02c07c220dffd2516cb708e0 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 29 Apr 2011 03:19:55 +0300
Subject: [PATCH] opensm/osm_sa.c: Change log level of message

for "Dump guidinfo" message

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 6b033fd..54b94a6 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -721,7 +721,7 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
 
 	dump_context.p_osm = p_osm;
 	dump_context.file = file;
-	OSM_LOG(&p_osm->log, OSM_LOG_ERROR /* DEBUG */, "Dump guidinfo\n");
+	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump guidinfo\n");
 	cl_plock_acquire(&p_osm->lock);
 	cl_qmap_apply_func(&p_osm->subn.port_guid_tbl,
 			   sa_dump_one_port_guidinfo, &dump_context);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
