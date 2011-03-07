From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fixed pointer validity check in
 report_torus_changes()
Date: Mon, 7 Mar 2011 11:59:30 +0200
Message-ID: <20110307095930.GH5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

struct torus *nt should be checked for validity before getting assignments.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index add3cf9..7a2c252 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7423,13 +7423,17 @@ void report_torus_changes(struct torus *nt, struct torus *ot)
 {
 	unsigned cnt = 0;
 	unsigned i, j, k;
-	unsigned x_sz = nt->x_sz;
-	unsigned y_sz = nt->y_sz;
-	unsigned z_sz = nt->z_sz;
+	unsigned x_sz;
+	unsigned y_sz;
+	unsigned z_sz;
 
 	if (!(nt && ot))
 		return;
 
+	x_sz = nt->x_sz;
+	y_sz = nt->y_sz;
+	z_sz = nt->z_sz;
+
 	if (x_sz != ot->x_sz) {
 		cnt++;
 		OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
