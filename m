From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_torus.c: Add error code to error log
 message
Date: Tue, 18 Sep 2012 14:53:10 -0400
Message-ID: <5058C316.1070409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Also, cosmetic formatting change

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index addda89..49abef8 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -8583,7 +8583,7 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 	mtn = osm_mtree_node_new(osm_sw);
 	if (!mtn) {
 		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
-			"Insufficient memory to build multicast tree\n");
+			"ERR 4E46: Insufficient memory to build multicast tree\n");
 		goto out;
 	}
 	mcast_tbl = osm_switch_get_mcast_tbl_ptr(osm_sw);
@@ -9186,7 +9186,7 @@ void check_qos_config(osm_qos_options_t *opt, bool tgt_is_default,
 	if (opt->vlarb_high) {
 		is_default = false;
 		vlarb_str = opt->vlarb_high;
-	} else{
+	} else {
 		is_default = true;
 		vlarb_str = OSM_DEFAULT_QOS_VLARB_HIGH;
 	}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
