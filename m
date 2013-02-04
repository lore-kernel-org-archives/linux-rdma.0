From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_torus.c: torus routing should fail with VLCap 1
 on switch external ports
Date: Mon, 4 Feb 2013 11:36:44 +0200
Message-ID: <20130204093644.GB13151@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index e63cb40..757a32a 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7021,11 +7021,13 @@ bool verify_setup(struct torus *t, struct fabric *f)
 			"ERR 4E20: missing required torus size specification!\n");
 		goto out;
 	}
-	if (t->osm->subn.min_sw_data_vls < 2)
-		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
-			"Warning: Too few data VLs to support torus routing "
+	if (t->osm->subn.min_sw_data_vls < 2) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"ERR 4E48: Too few data VLs to support torus routing "
 			"without credit loops (have switchport %d need 2)\n",
 			(int)t->osm->subn.min_sw_data_vls);
+		goto out;
+	}
 	if (t->osm->subn.min_sw_data_vls < 4)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
