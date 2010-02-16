From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 2/3] opensm: Fix handling of torus-2QoS topology
 discovery for radix 4 torus dimensions.
Date: Tue, 16 Feb 2010 09:16:44 -0700
Message-ID: <1266337005-29874-3-git-send-email-jaschut@sandia.gov>
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

Torus-2QoS finds the torus topology in a fabric using an algorithm that
looks for 8 adjacent switches which form the corners of a cube, by looking
for 4 adjacent switches which form the corners of a face on that cube.

When a torus dimension has radix 4 (e.g. the y dimension in a 5x4x8 torus),
1-D rings which span that dimension cannot be distinguished topologically
from the faces the algorithm is trying to construct.

Code that prevents that situation from arising should only be applied in
cases where a torus dimension has radix 4, but due to a missing test, it
could be applied inappropriately.

This commit fixes the bug by adding the missing test.  It also restructures
the code in question to remove code duplication by adding helper functions.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |  405 ++++++++++++++++-----------------------
 1 files changed, 168 insertions(+), 237 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 728e56c..ab0e6a6 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -1956,38 +1956,16 @@ struct f_switch *tfind_2d_perpendicular(struct t_switch *tsw0,
 	return ffind_2d_perpendicular(tsw0->tmp, tsw1->tmp, tsw2->tmp);
 }
 
-/*
- * These functions return true when it safe to call
- * tfind_3d_perpendicular()/ffind_3d_perpendicular().
- */
 static
-bool safe_x_perpendicular(struct torus *t, int i, int j, int k)
+bool safe_x_ring(struct torus *t, int i, int j, int k)
 {
-	int jm1, jp1, jp2, km1, kp1, kp2;
-
-	/*
-	 * If the dimensions perpendicular to the search direction are
-	 * not radix 4 torus dimensions, it is always safe to search for
-	 * a perpendicular.
-	 */
-	if ((t->y_sz != 4 && t->z_sz != 4) ||
-	    (t->flags & Y_MESH && t->flags & Z_MESH) ||
-	    (t->y_sz != 4 && (t->flags & Z_MESH)) ||
-	    (t->z_sz != 4 && (t->flags & Y_MESH)))
-		return true;
-
-	jm1 = canonicalize(j - 1, t->y_sz);
-	jp1 = canonicalize(j + 1, t->y_sz);
-	jp2 = canonicalize(j + 2, t->y_sz);
-
-	km1 = canonicalize(k - 1, t->z_sz);
-	kp1 = canonicalize(k + 1, t->z_sz);
-	kp2 = canonicalize(k + 2, t->z_sz);
+	int im1, ip1, ip2;
+	bool success = true;
 
 	/*
-	 * Here we are checking for enough appropriate links having been
-	 * installed into the torus to prevent an incorrect link from being
-	 * considered as a perpendicular candidate.
+	 * If this x-direction radix-4 ring has at least two links
+	 * already installed into the torus,  then this ring does not
+	 * prevent us from looking for y or z direction perpendiculars.
 	 *
 	 * It is easier to check for the appropriate switches being installed
 	 * into the torus than it is to check for the links, so force the
@@ -1995,93 +1973,111 @@ bool safe_x_perpendicular(struct torus *t, int i, int j, int k)
 	 *
 	 * Recall that canonicalize(n - 2, 4) == canonicalize(n + 2, 4).
 	 */
-	if (((!!t->sw[i][jm1][k] +
-	      !!t->sw[i][jp1][k] + !!t->sw[i][jp2][k] >= 2) &&
-	     (!!t->sw[i][j][km1] +
-	      !!t->sw[i][j][kp1] + !!t->sw[i][j][kp2] >= 2))) {
-
-		bool success = true;
-
-		if (t->sw[i][jp2][k] && t->sw[i][jm1][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jp2][k],
-						 t->sw[i][jm1][k])
-				&& success;
-
-		if (t->sw[i][jm1][k] && t->sw[i][j][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jm1][k],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[i][jp1][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][j][k],
-						 t->sw[i][jp1][k])
-				&& success;
-
-		if (t->sw[i][jp1][k] && t->sw[i][jp2][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jp1][k],
-						 t->sw[i][jp2][k])
-				&& success;
-
-		if (t->sw[i][j][kp2] && t->sw[i][j][km1])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][kp2],
-						 t->sw[i][j][km1])
-				&& success;
-
-		if (t->sw[i][j][km1] && t->sw[i][j][k])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][km1],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[i][j][kp1])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][k],
-						 t->sw[i][j][kp1])
-				&& success;
-
-		if (t->sw[i][j][kp1] && t->sw[i][j][kp2])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][kp1],
-						 t->sw[i][j][kp2])
-				&& success;
-		return success;
+	if (t->x_sz != 4 || t->flags & X_MESH)
+		goto out;
+
+	im1 = canonicalize(i - 1, t->x_sz);
+	ip1 = canonicalize(i + 1, t->x_sz);
+	ip2 = canonicalize(i + 2, t->x_sz);
+
+	if (!!t->sw[im1][j][k] +
+	    !!t->sw[ip1][j][k] + !!t->sw[ip2][j][k] < 2) {
+		success = false;
+		goto out;
 	}
-	return false;
+	if (t->sw[ip2][j][k] && t->sw[im1][j][k])
+		success = link_tswitches(t, 0,
+					 t->sw[ip2][j][k],
+					 t->sw[im1][j][k])
+			&& success;
+
+	if (t->sw[im1][j][k] && t->sw[i][j][k])
+		success = link_tswitches(t, 0,
+					 t->sw[im1][j][k],
+					 t->sw[i][j][k])
+			&& success;
+
+	if (t->sw[i][j][k] && t->sw[ip1][j][k])
+		success = link_tswitches(t, 0,
+					 t->sw[i][j][k],
+					 t->sw[ip1][j][k])
+			&& success;
+
+	if (t->sw[ip1][j][k] && t->sw[ip2][j][k])
+		success = link_tswitches(t, 0,
+					 t->sw[ip1][j][k],
+					 t->sw[ip2][j][k])
+			&& success;
+out:
+	return success;
 }
 
 static
-bool safe_y_perpendicular(struct torus *t, int i, int j, int k)
+bool safe_y_ring(struct torus *t, int i, int j, int k)
 {
-	int im1, ip1, ip2, km1, kp1, kp2;
+	int jm1, jp1, jp2;
+	bool success = true;
 
 	/*
-	 * If the dimensions perpendicular to the search direction are
-	 * not radix 4 torus dimensions, it is always safe to search for
-	 * a perpendicular.
+	 * If this y-direction radix-4 ring has at least two links
+	 * already installed into the torus,  then this ring does not
+	 * prevent us from looking for x or z direction perpendiculars.
+	 *
+	 * It is easier to check for the appropriate switches being installed
+	 * into the torus than it is to check for the links, so force the
+	 * link installation if the appropriate switches are installed.
+	 *
+	 * Recall that canonicalize(n - 2, 4) == canonicalize(n + 2, 4).
 	 */
-	if ((t->x_sz != 4 && t->z_sz != 4) ||
-	    (t->flags & X_MESH && t->flags & Z_MESH) ||
-	    (t->x_sz != 4 && (t->flags & Z_MESH)) ||
-	    (t->z_sz != 4 && (t->flags & X_MESH)))
-		return true;
+	if (t->y_sz != 4 || (t->flags & Y_MESH))
+		goto out;
 
-	im1 = canonicalize(i - 1, t->x_sz);
-	ip1 = canonicalize(i + 1, t->x_sz);
-	ip2 = canonicalize(i + 2, t->x_sz);
+	jm1 = canonicalize(j - 1, t->y_sz);
+	jp1 = canonicalize(j + 1, t->y_sz);
+	jp2 = canonicalize(j + 2, t->y_sz);
 
-	km1 = canonicalize(k - 1, t->z_sz);
-	kp1 = canonicalize(k + 1, t->z_sz);
-	kp2 = canonicalize(k + 2, t->z_sz);
+	if (!!t->sw[i][jm1][k] +
+	    !!t->sw[i][jp1][k] + !!t->sw[i][jp2][k] < 2) {
+		success = false;
+		goto out;
+	}
+	if (t->sw[i][jp2][k] && t->sw[i][jm1][k])
+		success = link_tswitches(t, 1,
+					 t->sw[i][jp2][k],
+					 t->sw[i][jm1][k])
+			&& success;
+
+	if (t->sw[i][jm1][k] && t->sw[i][j][k])
+		success = link_tswitches(t, 1,
+					 t->sw[i][jm1][k],
+					 t->sw[i][j][k])
+			&& success;
+
+	if (t->sw[i][j][k] && t->sw[i][jp1][k])
+		success = link_tswitches(t, 1,
+					 t->sw[i][j][k],
+					 t->sw[i][jp1][k])
+			&& success;
+
+	if (t->sw[i][jp1][k] && t->sw[i][jp2][k])
+		success = link_tswitches(t, 1,
+					 t->sw[i][jp1][k],
+					 t->sw[i][jp2][k])
+			&& success;
+out:
+	return success;
+}
+
+static
+bool safe_z_ring(struct torus *t, int i, int j, int k)
+{
+	int km1, kp1, kp2;
+	bool success = true;
 
 	/*
-	 * Here we are checking for enough appropriate links having been
-	 * installed into the torus to prevent an incorrect link from being
-	 * considered as a perpendicular candidate.
+	 * If this z-direction radix-4 ring has at least two links
+	 * already installed into the torus,  then this ring does not
+	 * prevent us from looking for x or y direction perpendiculars.
 	 *
 	 * It is easier to check for the appropriate switches being installed
 	 * into the torus than it is to check for the links, so force the
@@ -2089,157 +2085,92 @@ bool safe_y_perpendicular(struct torus *t, int i, int j, int k)
 	 *
 	 * Recall that canonicalize(n - 2, 4) == canonicalize(n + 2, 4).
 	 */
-	if (((!!t->sw[im1][j][k] +
-	      !!t->sw[ip1][j][k] + !!t->sw[ip2][j][k] >= 2) &&
-	     (!!t->sw[i][j][km1] +
-	      !!t->sw[i][j][kp1] + !!t->sw[i][j][kp2] >= 2))) {
-
-		bool success = true;
-
-		if (t->sw[ip2][j][k] && t->sw[im1][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[ip2][j][k],
-						 t->sw[im1][j][k])
-				&& success;
-
-		if (t->sw[im1][j][k] && t->sw[i][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[im1][j][k],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[ip1][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[i][j][k],
-						 t->sw[ip1][j][k])
-				&& success;
-
-		if (t->sw[ip1][j][k] && t->sw[ip2][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[ip1][j][k],
-						 t->sw[ip2][j][k])
-				&& success;
-
-		if (t->sw[i][j][kp2] && t->sw[i][j][km1])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][kp2],
-						 t->sw[i][j][km1])
-				&& success;
-
-		if (t->sw[i][j][km1] && t->sw[i][j][k])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][km1],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[i][j][kp1])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][k],
-						 t->sw[i][j][kp1])
-				&& success;
-
-		if (t->sw[i][j][kp1] && t->sw[i][j][kp2])
-			success = link_tswitches(t, 2,
-						 t->sw[i][j][kp1],
-						 t->sw[i][j][kp2])
-				&& success;
-		return success;
+	if (t->z_sz != 4 || t->flags & Z_MESH)
+		goto out;
+
+	km1 = canonicalize(k - 1, t->z_sz);
+	kp1 = canonicalize(k + 1, t->z_sz);
+	kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (!!t->sw[i][j][km1] +
+	    !!t->sw[i][j][kp1] + !!t->sw[i][j][kp2] < 2) {
+		success = false;
+		goto out;
 	}
-	return false;
+	if (t->sw[i][j][kp2] && t->sw[i][j][km1])
+		success = link_tswitches(t, 2,
+					 t->sw[i][j][kp2],
+					 t->sw[i][j][km1])
+			&& success;
+
+	if (t->sw[i][j][km1] && t->sw[i][j][k])
+		success = link_tswitches(t, 2,
+					 t->sw[i][j][km1],
+					 t->sw[i][j][k])
+			&& success;
+
+	if (t->sw[i][j][k] && t->sw[i][j][kp1])
+		success = link_tswitches(t, 2,
+					 t->sw[i][j][k],
+					 t->sw[i][j][kp1])
+			&& success;
+
+	if (t->sw[i][j][kp1] && t->sw[i][j][kp2])
+		success = link_tswitches(t, 2,
+					 t->sw[i][j][kp1],
+					 t->sw[i][j][kp2])
+			&& success;
+out:
+	return success;
 }
 
+/*
+ * These functions return true when it safe to call
+ * tfind_3d_perpendicular()/ffind_3d_perpendicular().
+ */
 static
-bool safe_z_perpendicular(struct torus *t, int i, int j, int k)
+bool safe_x_perpendicular(struct torus *t, int i, int j, int k)
 {
-	int im1, ip1, ip2, jm1, jp1, jp2;
-
 	/*
 	 * If the dimensions perpendicular to the search direction are
 	 * not radix 4 torus dimensions, it is always safe to search for
 	 * a perpendicular.
+	 *
+	 * Here we are checking for enough appropriate links having been
+	 * installed into the torus to prevent an incorrect link from being
+	 * considered as a perpendicular candidate.
 	 */
-	if ((t->x_sz != 4 && t->y_sz != 4) ||
-	    (t->flags & X_MESH && t->flags & Y_MESH) ||
-	    (t->x_sz != 4 && (t->flags & Y_MESH)) ||
-	    (t->y_sz != 4 && (t->flags & X_MESH)))
-		return true;
-
-	im1 = canonicalize(i - 1, t->x_sz);
-	ip1 = canonicalize(i + 1, t->x_sz);
-	ip2 = canonicalize(i + 2, t->x_sz);
-
-	jm1 = canonicalize(j - 1, t->y_sz);
-	jp1 = canonicalize(j + 1, t->y_sz);
-	jp2 = canonicalize(j + 2, t->y_sz);
+	return safe_y_ring(t, i, j, k) && safe_z_ring(t, i, j, k);
+}
 
+static
+bool safe_y_perpendicular(struct torus *t, int i, int j, int k)
+{
 	/*
+	 * If the dimensions perpendicular to the search direction are
+	 * not radix 4 torus dimensions, it is always safe to search for
+	 * a perpendicular.
+	 *
 	 * Here we are checking for enough appropriate links having been
 	 * installed into the torus to prevent an incorrect link from being
 	 * considered as a perpendicular candidate.
+	 */
+	return safe_x_ring(t, i, j, k) && safe_z_ring(t, i, j, k);
+}
+
+static
+bool safe_z_perpendicular(struct torus *t, int i, int j, int k)
+{
+	/*
+	 * If the dimensions perpendicular to the search direction are
+	 * not radix 4 torus dimensions, it is always safe to search for
+	 * a perpendicular.
 	 *
-	 * It is easier to check for the appropriate switches being installed
-	 * into the torus than it is to check for the links, so force the
-	 * link installation if the appropriate switches are installed.
-	 *
-	 * Recall that canonicalize(n - 2, 4) == canonicalize(n + 2, 4).
+	 * Implement this by checking for enough appropriate links having
+	 * been installed into the torus to prevent an incorrect link from
+	 * being considered as a perpendicular candidate.
 	 */
-	if (((!!t->sw[im1][j][k] +
-	      !!t->sw[ip1][j][k] + !!t->sw[ip2][j][k] >= 2) &&
-	     (!!t->sw[i][jm1][k] +
-	      !!t->sw[i][jp1][k] + !!t->sw[i][jp2][k] >= 2))) {
-
-		bool success = true;
-
-		if (t->sw[ip2][j][k] && t->sw[im1][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[ip2][j][k],
-						 t->sw[im1][j][k])
-				&& success;
-
-		if (t->sw[im1][j][k] && t->sw[i][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[im1][j][k],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[ip1][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[i][j][k],
-						 t->sw[ip1][j][k])
-				&& success;
-
-		if (t->sw[ip1][j][k] && t->sw[ip2][j][k])
-			success = link_tswitches(t, 0,
-						 t->sw[ip1][j][k],
-						 t->sw[ip2][j][k])
-				&& success;
-
-		if (t->sw[i][jp2][k] && t->sw[i][jm1][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jp2][k],
-						 t->sw[i][jm1][k])
-				&& success;
-
-		if (t->sw[i][jm1][k] && t->sw[i][j][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jm1][k],
-						 t->sw[i][j][k])
-				&& success;
-
-		if (t->sw[i][j][k] && t->sw[i][jp1][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][j][k],
-						 t->sw[i][jp1][k])
-				&& success;
-
-		if (t->sw[i][jp1][k] && t->sw[i][jp2][k])
-			success = link_tswitches(t, 1,
-						 t->sw[i][jp1][k],
-						 t->sw[i][jp2][k])
-				&& success;
-		return true;
-	}
-	return false;
+	return safe_x_ring(t, i, j, k) && safe_y_ring(t, i, j, k);
 }
 
 /*
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
