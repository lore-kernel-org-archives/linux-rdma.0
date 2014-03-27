From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_torus.c: Fix torus crash when actual topology
 is not torus
Date: Thu, 27 Mar 2014 16:05:46 -0400
Message-ID: <5334849A.2000201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 27 Mar 2014 18:52:49 +0200

Torus crashes when it is configured in a way but actual topology has
nothing to do with torus or the configuration, changed it to fail
without crash

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 71753cf..330f55d 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7262,7 +7262,7 @@ out:
 }
 
 static
-void build_torus(struct fabric *f, struct torus *t)
+bool build_torus(struct fabric *f, struct torus *t)
 {
 	int i, j, k;
 	int im1, jm1, km1;
@@ -7383,9 +7383,12 @@ again:
 	for (k = 0; k < (int)t->z_sz; k++)
 		for (j = 0; j < (int)t->y_sz; j++)
 			for (i = 0; i < (int)t->x_sz; i++)
-				link_srcsink(t, i, j, k);
+				if (!link_srcsink(t, i, j, k)) {
+					success = false;
+					goto out;
+				}
 out:
-	return;
+	return success;
 }
 
 /*
@@ -9493,7 +9496,11 @@ int torus_build_lfts(void *context)
 		(int)torus->x_sz, (int)torus->y_sz, (int)torus->z_sz,
 		(ALL_MESH(torus->flags) ? "mesh" : "torus"));
 
-	build_torus(fabric, torus);
+	if (!build_torus(fabric, torus)) {
+		OSM_LOG(&torus->osm->log, OSM_LOG_ERROR, "ERR 4E57: "
+			"build_torus finished with errors\n");
+		goto out;
+	}
 
 	OSM_LOG(&torus->osm->log, OSM_LOG_INFO,
 		"Built %d x %d x %d %s w/ %d links, %d switches, %d CA ports\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
