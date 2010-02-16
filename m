From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 1/3] opensm: Use local variables when searching for
 torus-2QoS master spanning tree root.
Date: Tue, 16 Feb 2010 09:16:43 -0700
Message-ID: <1266337005-29874-2-git-send-email-jaschut@sandia.gov>
References: <1261169461-2516-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1261169461-2516-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Otherwise 1) presence of the wrong switches is checked; and 2) the y-loop
in good_xy_ring() can segfault on an out-of-bounds switch array x index.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index e2eb324..728e56c 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -8751,22 +8751,23 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 }
 
 static
-bool good_xy_ring(struct torus *t, int x, int y, int z)
+bool good_xy_ring(struct torus *t, const int x, const int y, const int z)
 {
 	struct t_switch ****sw = t->sw;
 	bool good_ring = true;
+	int x_tst, y_tst;
 
-	for (x = 0; x < t->x_sz && good_ring; x++)
-		good_ring = sw[x][y][z];
+	for (x_tst = 0; x_tst < t->x_sz && good_ring; x_tst++)
+		good_ring = sw[x_tst][y][z];
 
-	for (y = 0; y < t->y_sz && good_ring; y++)
-		good_ring = sw[x][y][z];
+	for (y_tst = 0; y_tst < t->y_sz && good_ring; y_tst++)
+		good_ring = sw[x][y_tst][z];
 
 	return good_ring;
 }
 
 static
-struct t_switch *find_plane_mid(struct torus *t, int z)
+struct t_switch *find_plane_mid(struct torus *t, const int z)
 {
 	int x, dx, xm = t->x_sz / 2;
 	int y, dy, ym = t->y_sz / 2;
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
