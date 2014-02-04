From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 1/1] OpenSM: osm_ucast_dfsssp.c - prevent double free error
Date: Tue,  4 Feb 2014 21:18:46 +0900
Message-ID: <1391516326-11399-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

an error in the routing execution can cause a second
free() call on sw_list, which results in a 'double free' error

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 5eaff3d..ec69df0 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2382,6 +2382,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 
 	/* the intermediate array lived long enough */
 	free(sw_list);
+	sw_list = NULL;
 	/* same is true for the compute node and I/O guid map */
 	destroy_guid_map(&cn_tbl);
 	cn_nodes_provided = FALSE;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
