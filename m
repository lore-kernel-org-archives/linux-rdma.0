From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_torus.c: Improve some misconfiguration error messages
Date: Thu, 29 Nov 2012 14:11:42 -0500
Message-ID: <50B7B36E.1030400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 43343c7..4d1bec7 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7025,8 +7025,9 @@ out:
 	return;
 }
 
-#define LINK_ERR_STR " direction link required!\n"
-#define SEED_ERR_STR " direction links with different seed switches!\n"
+#define LINK_ERR_STR " direction link required for topology seed configuration since radix == 4! See torus-2QoS.conf(5).\n"
+#define LINK_ERR2_STR " direction link required for topology seed configuration! See torus-2QoS.conf(5).\n"
+#define SEED_ERR_STR " direction links for topology seed do not share a common switch! See torus-2QoS.conf(5).\n"
 
 static
 bool verify_setup(struct torus *t, struct fabric *f)
@@ -7154,7 +7155,7 @@ again:
 		if (o->xp_link.end[0].port >= 0 &&
 		    o->xm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"ERR 4E2B: Positive or negative x" LINK_ERR_STR);
+				"ERR 4E2B: Positive or negative x" LINK_ERR2_STR);
 			goto out;
 		}
 		if (o->xp_link.end[0].port < 0 &&
@@ -7177,7 +7178,7 @@ again:
 		if (o->zp_link.end[0].port >= 0 &&
 		    o->zm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"ERR 4E2C: Positive or negative z" LINK_ERR_STR);
+				"ERR 4E2C: Positive or negative z" LINK_ERR2_STR);
 			goto out;
 		}
 		if ((o->xp_link.end[0].port < 0 &&
@@ -7220,7 +7221,7 @@ again:
 		if (o->yp_link.end[0].port >= 0 &&
 		    o->ym_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"ERR 4E2E: Positive or negative y" LINK_ERR_STR);
+				"ERR 4E2E: Positive or negative y" LINK_ERR2_STR);
 			goto out;
 		}
 		if ((o->xp_link.end[0].port < 0 &&
@@ -7269,7 +7270,9 @@ again:
 	if (need_seed)
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"ERR 4E30: Every configured torus seed has at "
-			"least one switch missing in fabric!\n");
+			"least one switch missing in fabric! See "
+			"torus-2QoS.conf(5) and TORUS TOPOLOGY DISCOVERY "
+			"in torus-2QoS(8)\n");
 	else
 		success = true;
 out:
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
