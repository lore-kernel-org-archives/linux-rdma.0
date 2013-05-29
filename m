From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osm_ucast_dfsssp.c: Fix memory leak in dfsssp_do_dijkstra_routing
Date: Wed, 29 May 2013 13:26:54 -0400
Message-ID: <51A63A5E.1070900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jens Domke <domke.j.aa@m.titech.ac.jp>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 5c06cdf5029ca79a8c2e684a23b1b7e89a93c3a6 Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 29 May 2013 15:41:41 +0300
Subject: [PATCH] osm_ucast_dfsssp.c: Fix memory leak in dfsssp_do_dijkstra_routing

Variable "sw_list" going out of scope leaks the storage it points to.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 95e1627..3972656 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2181,6 +2181,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		} else {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 				"ERR AD31: corrupted sw_list array in dfsssp_do_dijkstra_routing\n");
+			free(sw_list);
 			return 1;
 		}
 	}
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
