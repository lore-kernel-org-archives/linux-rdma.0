From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 08/18] opensm: Add torus-2QoS routing engine, part 2.
Date: Fri,  3 Sep 2010 10:43:04 -0600
Message-ID: <1283532194-27112-9-git-send-email-jaschut@sandia.gov>
References: <1283532194-27112-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283532194-27112-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c | 2332 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 2332 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index adb3b23..8aa0c18 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -2171,3 +2171,2335 @@ bool safe_z_perpendicular(struct torus *t, int i, int j, int k)
 	 */
 	return safe_x_ring(t, i, j, k) && safe_y_ring(t, i, j, k);
 }
+
+/*
+ * Templates for determining 2D/3D case fingerprints. Recall that if
+ * a fingerprint bit is set the corresponding switch is absent from
+ * the all-switches-present template.
+ *
+ * I.e., for the 2D case where the x,y dimensions have a radix greater
+ * than one, and the z dimension has radix 1, fingerprint bits 4-7 are
+ * always zero.
+ *
+ * For the 2D case where the x,z dimensions have a radix greater than
+ * one, and the y dimension has radix 1, fingerprint bits 2,3,6,7 are
+ * always zero.
+ *
+ * For the 2D case where the y,z dimensions have a radix greater than
+ * one, and the x dimension has radix 1, fingerprint bits 1,3,5,7 are
+ * always zero.
+ *
+ * Recall also that bits 8-10 distinguish between 2D and 3D cases.
+ * If bit 8+d is set, for 0 <= d < 3;  the d dimension of the desired
+ * torus has radix greater than 1.
+ */
+
+/*
+ * 2D case 0x300
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O . . . . . O
+ * 2D case 0x500                      .           .
+ *  b0: t->sw[i  ][0  ][k  ]          .           .
+ *  b1: t->sw[i+1][0  ][k  ]          .           .
+ *  b4: t->sw[i  ][0  ][k+1]          .           .
+ *  b5: t->sw[i+1][0  ][k+1]          .           .
+ *                                    @ . . . . . O
+ * 2D case 0x600
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+
+/*
+ * 3D case 0x700:                           O
+ *                                        . . .
+ *  b0: t->sw[i  ][j  ][k  ]            .   .   .
+ *  b1: t->sw[i+1][j  ][k  ]          .     .     .
+ *  b2: t->sw[i  ][j+1][k  ]        .       .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4: t->sw[i  ][j  ][k+1]      . .       O       . .
+ *  b5: t->sw[i+1][j  ][k+1]      .   .   .   .   .   .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .       .     .
+ *  b7: t->sw[i+1][j+1][k+1]      .   .   .   .   .   .
+ *                                . .       O       . .
+ *                                O         .         O
+ *                                  .       .       .
+ *                                    .     .     .
+ *                                      .   .   .
+ *                                        . . .
+ *                                          @
+ */
+
+static
+void log_no_crnr(struct torus *t, unsigned n,
+		 int case_i, int case_j, int case_k,
+		 int crnr_i, int crnr_j, int crnr_k)
+{
+	if (t->debug)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO, "Case 0x%03x "
+			"@ %d %d %d: no corner @ %d %d %d\n",
+			n, case_i, case_j, case_k, crnr_i, crnr_j, crnr_k);
+}
+
+static
+void log_no_perp(struct torus *t, unsigned n,
+		 int case_i, int case_j, int case_k,
+		 int perp_i, int perp_j, int perp_k)
+{
+	if (t->debug)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO, "Case 0x%03x "
+			"@ %d %d %d: no perpendicular @ %d %d %d\n",
+			n, case_i, case_j, case_k, perp_i, perp_j, perp_k);
+}
+
+/*
+ * Handle the 2D cases with a single existing edge.
+ *
+ */
+
+/*
+ * 2D case 0x30c
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2:
+ *  b3:
+ *                                    O           O
+ * 2D case 0x530
+ *  b0: t->sw[i  ][0  ][k  ]
+ *  b1: t->sw[i+1][0  ][k  ]
+ *  b4:
+ *  b5:
+ *                                    @ . . . . . O
+ * 2D case 0x650
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4:
+ *  b6:
+ */
+static
+bool handle_case_0x30c(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (safe_y_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_2d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[i][j][k],
+						   t->sw[i][jm1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x30c, i, j, k, i, j, k);
+
+	if (safe_y_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, ip1, jp1, k,
+			    tfind_2d_perpendicular(t->sw[i][j][k],
+						   t->sw[ip1][j][k],
+						   t->sw[ip1][jm1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x30c, i, j, k, ip1, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x530(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_2d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[i][j][k],
+						   t->sw[i][j][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x530, i, j, k, i, j, k);
+
+	if (safe_z_perpendicular(t, ip1, j, k) &&
+	      install_tswitch(t, ip1, j, kp1,
+			      tfind_2d_perpendicular(t->sw[i][j][k],
+						     t->sw[ip1][j][k],
+						     t->sw[ip1][j][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x530, i, j, k, ip1, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x650(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_2d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[i][j][k],
+						   t->sw[i][j][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x650, i, j, k, i, j, k);
+
+	if (safe_z_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, i, jp1, kp1,
+			    tfind_2d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[i][jp1][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x650, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 2D case 0x305
+ *  b0:
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2:
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O           O
+ * 2D case 0x511                                  .
+ *  b0:                                           .
+ *  b1: t->sw[i+1][0  ][k  ]                      .
+ *  b4:                                           .
+ *  b5: t->sw[i+1][0  ][k+1]                      .
+ *                                    @           O
+ * 2D case 0x611
+ *  b0:
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4:
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+static
+bool handle_case_0x305(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (safe_x_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[ip1][jp1][k],
+						   t->sw[ip1][j][k],
+						   t->sw[ip2][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x305, i, j, k, ip1, j, k);
+
+	if (safe_x_perpendicular(t, ip1, jp1, k) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_2d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip2][jp1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x305, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+static
+bool handle_case_0x511(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[ip1][j][k],
+						   t->sw[ip2][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x511, i, j, k, ip1, j, k);
+
+	if (safe_x_perpendicular(t, ip1, j, kp1) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_2d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip2][j][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x511, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+static
+bool handle_case_0x611(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[i][jp1][kp1],
+						   t->sw[i][jp1][k],
+						   t->sw[i][jp2][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x611, i, j, k, i, jp1, k);
+
+	if (safe_y_perpendicular(t, i, jp1, kp1) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_2d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[i][jp1][kp1],
+						   t->sw[i][jp2][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x611, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 2D case 0x303
+ *  b0:
+ *  b1:
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O . . . . . O
+ * 2D case 0x503
+ *  b0:
+ *  b1:
+ *  b4: t->sw[i  ][0  ][k+1]
+ *  b5: t->sw[i+1][0  ][k+1]
+ *                                    @           O
+ * 2D case 0x605
+ *  b0:
+ *  b2:
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+static
+bool handle_case_0x303(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+
+	if (safe_y_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[ip1][jp1][k],
+						   t->sw[i][jp1][k],
+						   t->sw[i][jp2][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x303, i, j, k, i, jp1, k);
+
+	if (safe_y_perpendicular(t, ip1, jp1, k) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_2d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip1][jp2][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x303, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+static
+bool handle_case_0x503(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[i][j][kp1],
+						   t->sw[i][j][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x503, i, j, k, i, j, kp1);
+
+	if (safe_z_perpendicular(t, ip1, j, kp1) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_2d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip1][j][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x503, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+static
+bool handle_case_0x605(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_2d_perpendicular(t->sw[i][jp1][kp1],
+						   t->sw[i][j][kp1],
+						   t->sw[i][j][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x605, i, j, k, i, j, kp1);
+
+	if (safe_z_perpendicular(t, i, jp1, kp1) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_2d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[i][jp1][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x605, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 2D case 0x30a
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3:
+ *                                    O           O
+ * 2D case 0x522                      .
+ *  b0: t->sw[i  ][0  ][k  ]          .
+ *  b1:                               .
+ *  b4: t->sw[i  ][0  ][k+1]          .
+ *  b5:                               .
+ *                                    @           O
+ * 2D case 0x644
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2:
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6:
+ */
+static
+bool handle_case_0x30a(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (safe_x_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_2d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[i][j][k],
+						   t->sw[im1][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x30a, i, j, k, i, j, k);
+
+	if (safe_x_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, ip1, jp1, k,
+			    tfind_2d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[im1][jp1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x30a, i, j, k, i, jp1, k);
+	return false;
+}
+
+static
+bool handle_case_0x522(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_2d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][j][k],
+						   t->sw[im1][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x522, i, j, k, i, j, k);
+
+	if (safe_x_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, ip1, j, kp1,
+			    tfind_2d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][j][kp1],
+						   t->sw[im1][j][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x522, i, j, k, i, j, kp1);
+	return false;
+}
+
+static
+bool handle_case_0x644(struct torus *t, int i, int j, int k)
+{
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_2d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][j][k],
+						   t->sw[i][jm1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x644, i, j, k, i, j, k);
+
+	if (safe_y_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, i, jp1, kp1,
+			    tfind_2d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][j][kp1],
+						   t->sw[i][jm1][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x644, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * Handle the 2D cases where two existing edges meet at a corner.
+ *
+ */
+
+/*
+ * 2D case 0x301
+ *  b0:
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O . . . . . O
+ * 2D case 0x501                                  .
+ *  b0:                                           .
+ *  b1: t->sw[i+1][0  ][k  ]                      .
+ *  b4: t->sw[i  ][0  ][k+1]                      .
+ *  b5: t->sw[i+1][0  ][k+1]                      .
+ *                                    @           O
+ * 2D case 0x601
+ *  b0:
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+static
+bool handle_case_0x301(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[ip1][jp1][k],
+					      t->sw[i][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x301, i, j, k, i, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x501(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[ip1][j][kp1],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x501, i, j, k, i, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x601(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[i][jp1][kp1],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x601, i, j, k, i, j, k);
+	return false;
+}
+
+/*
+ * 2D case 0x302
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O . . . . . O
+ * 2D case 0x502                      .
+ *  b0: t->sw[i  ][0  ][k  ]          .
+ *  b1:                               .
+ *  b4: t->sw[i  ][0  ][k+1]          .
+ *  b5: t->sw[i+1][0  ][k+1]          .
+ *                                    @           O
+ * 2D case 0x604
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2:
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+static
+bool handle_case_0x302(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (install_tswitch(t, ip1, j, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][jp1][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x302, i, j, k, ip1, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x502(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, j, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][j][kp1],
+					      t->sw[ip1][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x502, i, j, k, ip1, j, k);
+	return false;
+}
+
+static
+bool handle_case_0x604(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, jp1, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][j][kp1],
+					      t->sw[i][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x604, i, j, k, i, jp1, k);
+	return false;
+}
+
+
+/*
+ * 2D case 0x308
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2: t->sw[i  ][j+1][0  ]
+ *  b3:
+ *                                    O           O
+ * 2D case 0x520                      .
+ *  b0: t->sw[i  ][0  ][k  ]          .
+ *  b1: t->sw[i+1][0  ][k  ]          .
+ *  b4: t->sw[i  ][0  ][k+1]          .
+ *  b5:                               .
+ *                                    @ . . . . . O
+ * 2D case 0x640
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4: t->sw[0  ][j  ][k+1]
+ *  b6:
+ */
+static
+bool handle_case_0x308(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (install_tswitch(t, ip1, jp1, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[i][j][k],
+					      t->sw[i][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x308, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+static
+bool handle_case_0x520(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, j, kp1,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[i][j][k],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x520, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+static
+bool handle_case_0x640(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, jp1, kp1,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[i][j][k],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x640, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 2D case 0x304
+ *  b0: t->sw[i  ][j  ][0  ]
+ *  b1: t->sw[i+1][j  ][0  ]
+ *  b2:
+ *  b3: t->sw[i+1][j+1][0  ]
+ *                                    O           O
+ * 2D case 0x510                                  .
+ *  b0: t->sw[i  ][0  ][k  ]                      .
+ *  b1: t->sw[i+1][0  ][k  ]                      .
+ *  b4:                                           .
+ *  b5: t->sw[i+1][0  ][k+1]                      .
+ *                                    @ . . . . . O
+ * 2D case 0x610
+ *  b0: t->sw[0  ][j  ][k  ]
+ *  b2: t->sw[0  ][j+1][k  ]
+ *  b4:
+ *  b6: t->sw[0  ][j+1][k+1]
+ */
+static
+bool handle_case_0x304(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+
+	if (install_tswitch(t, i, jp1, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[ip1][j][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x304, i, j, k, i, jp1, k);
+	return false;
+}
+
+static
+bool handle_case_0x510(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, kp1,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[ip1][j][k],
+					      t->sw[ip1][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x510, i, j, k, i, j, kp1);
+	return false;
+}
+
+static
+bool handle_case_0x610(struct torus *t, int i, int j, int k)
+{
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, kp1,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][jp1][k],
+					      t->sw[i][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x610, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * Handle the 3D cases where two existing edges meet at a corner.
+ *
+ */
+
+/*
+ * 3D case 0x71f:                           O
+ *                                        .   .
+ *  b0:                                 .       .
+ *  b1:                               .           .
+ *  b2:                             .               .
+ *  b3:                           O                   O
+ *  b4:                                     O
+ *  b5: t->sw[i+1][j  ][k+1]
+ *  b6: t->sw[i  ][j+1][k+1]
+ *  b7: t->sw[i+1][j+1][k+1]
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x71f(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, ip1, jp1, kp1) &&
+	    install_tswitch(t, ip1, jp1, k,
+			    tfind_3d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[ip1][jp1][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x71f, i, j, k, ip1, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x72f:                           O
+ *                                        .
+ *  b0:                                 .
+ *  b1:                               .
+ *  b2:                             .
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]        .       O
+ *  b5:                               .
+ *  b6: t->sw[i  ][j+1][k+1]            .
+ *  b7: t->sw[i+1][j+1][k+1]              .
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x72f(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, jp1, kp1) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[i][jp1][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x72f, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x737:                           O
+ *                                        . .
+ *  b0:                                 .   .
+ *  b1:                               .     .
+ *  b2:                             .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5:
+ *  b6: t->sw[i  ][j+1][k+1]
+ *  b7: t->sw[i+1][j+1][k+1]
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x737(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, ip1, jp1, kp1) &&
+	    install_tswitch(t, ip1, j, kp1,
+			    tfind_3d_perpendicular(t->sw[i][jp1][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip1][jp2][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x737, i, j, k, ip1, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x73b:                           O
+ *                                        .
+ *  b0:                                 .
+ *  b1:                               .
+ *  b2: t->sw[i  ][j+1][k  ]        .
+ *  b3:                           O                   O
+ *  b4:                           .         O
+ *  b5:                           .
+ *  b6: t->sw[i  ][j+1][k+1]      .
+ *  b7: t->sw[i+1][j+1][k+1]      .
+ *                                .         O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x73b(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, jp1, kp1) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_3d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[i][jp1][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[i][jp2][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x73b, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x74f:                           O
+ *                                            .
+ *  b0:                                         .
+ *  b1:                                           .
+ *  b2:                                             .
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O       .
+ *  b5: t->sw[i+1][j  ][k+1]                      .
+ *  b6:                                         .
+ *  b7: t->sw[i+1][j+1][k+1]                  .
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x74f(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, ip1, j, kp1) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip1][j][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x74f, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x757:                           O
+ *                                          . .
+ *  b0:                                     .   .
+ *  b1:                                     .     .
+ *  b2:                                     .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5: t->sw[i+1][j  ][k+1]
+ *  b6:
+ *  b7: t->sw[i+1][j+1][k+1]
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x757(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, ip1, jp1, kp1) &&
+	    install_tswitch(t, i, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip2][jp1][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x757, i, j, k, ip1, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x75d:                           O
+ *                                            .
+ *  b0:                                         .
+ *  b1: t->sw[i+1][j  ][k  ]                      .
+ *  b2:                                             .
+ *  b3:                           O                   O
+ *  b4:                                     O         .
+ *  b5: t->sw[i+1][j  ][k+1]                          .
+ *  b6:                                               .
+ *  b7: t->sw[i+1][j+1][k+1]                          .
+ *                                          O         .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x75d(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, ip1, j, kp1) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_3d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip2][j][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x75d, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x773:                           O
+ *                                          .
+ *  b0:                                     .
+ *  b1:                                     .
+ *  b2: t->sw[i  ][j+1][k  ]                .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5:                                   .
+ *  b6:                                 .
+ *  b7: t->sw[i+1][j+1][k+1]          .
+ *                                  .       O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x773(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, ip1, jp1, k) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_3d_perpendicular(t->sw[i][jp1][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip1][jp2][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x773, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x775:                           O
+ *                                          .
+ *  b0:                                     .
+ *  b1: t->sw[i+1][j  ][k  ]                .
+ *  b2:                                     .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5:                                       .
+ *  b6:                                         .
+ *  b7: t->sw[i+1][j+1][k+1]                      .
+ *                                          O       .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x775(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, ip1, jp1, k) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_3d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip1][jp1][kp1],
+						   t->sw[ip2][jp1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x775, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x78f:                           O
+ *
+ *  b0:
+ *  b1:
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]        .       O       .
+ *  b5: t->sw[i+1][j  ][k+1]          .           .
+ *  b6: t->sw[i  ][j+1][k+1]            .       .
+ *  b7:                                   .   .
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x78f(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+	int kp2 = canonicalize(k + 2, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_3d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[i][j][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[i][j][kp2]))) {
+		return true;
+	}
+	log_no_perp(t, 0x78f, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7ab:                           O
+ *
+ *  b0:
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]      . .       O
+ *  b5:                           .   .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7:                           .       .
+ *                                .         O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x7ab(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, i, jp1, kp1) &&
+	    install_tswitch(t, ip1, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[i][jp1][k],
+						   t->sw[im1][jp1][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ab, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7ae:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]        .       O
+ *  b5:                               .
+ *  b6: t->sw[i  ][j+1][k+1]            .
+ *  b7:                                   .
+ *                                          O
+ *                                O         .         O
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          @
+ */
+static
+bool handle_case_0x7ae(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, ip1, j, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][j][kp1],
+						   t->sw[i][jp1][kp1],
+						   t->sw[im1][j][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ae, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7b3:                           O
+ *
+ *  b0:
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                           .         O
+ *  b5:                           .       .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7:                           .   .
+ *                                . .       O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x7b3(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jp2 = canonicalize(j + 2, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_3d_perpendicular(t->sw[i][jp1][kp1],
+						   t->sw[i][jp1][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[i][jp2][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7b3, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7ba:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                           O                   O
+ *  b4:                           .         O
+ *  b5:                           .
+ *  b6: t->sw[i  ][j+1][k+1]      .
+ *  b7:                           .
+ *                                .         O
+ *                                O                   O
+ *                                  .
+ *                                    .
+ *                                      .
+ *                                        .
+ *                                          @
+ */
+static
+bool handle_case_0x7ba(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, ip1, jp1, k,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[i][jp1][kp1],
+						   t->sw[im1][jp1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ba, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7cd:                           O
+ *
+ *  b0:
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O       . .
+ *  b5: t->sw[i+1][j  ][k+1]                      .   .
+ *  b6:                                         .     .
+ *  b7:                                       .       .
+ *                                          O         .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x7cd(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, ip1, j, kp1) &&
+	    install_tswitch(t, ip1, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip1][j][k],
+						   t->sw[ip1][jm1][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7cd, i, j, k, ip1, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7ce:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O       .
+ *  b5: t->sw[i+1][j  ][k+1]                      .
+ *  b6:                                         .
+ *  b7:                                       .
+ *                                          O
+ *                                O         .         O
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          @
+ */
+static
+bool handle_case_0x7ce(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, j, kp1) &&
+	    install_tswitch(t, i, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][j][kp1],
+						   t->sw[ip1][j][kp1],
+						   t->sw[i][jm1][kp1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ce, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7d5:                           O
+ *
+ *  b0:
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O         .
+ *  b5: t->sw[i+1][j  ][k+1]                  .       .
+ *  b6:                                         .     .
+ *  b7:                                           .   .
+ *                                          O       . .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x7d5(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int ip2 = canonicalize(i + 2, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, i, j, k,
+			    tfind_3d_perpendicular(t->sw[ip1][j][kp1],
+						   t->sw[ip1][j][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip2][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7d5, i, j, k, ip1, j, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7dc:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3:                           O                   O
+ *  b4:                                     O         .
+ *  b5: t->sw[i+1][j  ][k+1]                          .
+ *  b6:                                               .
+ *  b7:                                               .
+ *                                          O         .
+ *                                O                   O
+ *                                                  .
+ *                                                .
+ *                                              .
+ *                                            .
+ *                                          @
+ */
+static
+bool handle_case_0x7dc(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, ip1, jp1, k,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[ip1][j][k],
+						   t->sw[ip1][j][kp1],
+						   t->sw[ip1][jm1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7dc, i, j, k, ip1, j, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7ea:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                            O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                 O
+ *  b5:
+ *  b6:
+ *  b7:
+ *                                          O
+ *                                O         .         O
+ *                                  .       .
+ *                                    .     .
+ *                                      .   .
+ *                                        . .
+ *                                          @
+ */
+static
+bool handle_case_0x7ea(struct torus *t, int i, int j, int k)
+{
+	int im1 = canonicalize(i - 1, t->x_sz);
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_x_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, ip1, j, k,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[im1][j][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ea, i, j, k, i, j, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7ec:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O
+ *  b5:
+ *  b6:
+ *  b7:
+ *                                          O
+ *                                O         .         O
+ *                                          .       .
+ *                                          .     .
+ *                                          .   .
+ *                                          . .
+ *                                          @
+ */
+static
+bool handle_case_0x7ec(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int jm1 = canonicalize(j - 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_y_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, jp1, k,
+			    tfind_3d_perpendicular(t->sw[i][j][kp1],
+						   t->sw[i][j][k],
+						   t->sw[ip1][j][k],
+						   t->sw[i][jm1][k]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7ec, i, j, k, i, j, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7f1:                           O
+ *
+ *  b0:
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O
+ *  b5:                                   .   .
+ *  b6:                                 .       .
+ *  b7:                               .           .
+ *                                  .       O       .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x7f1(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, ip1, jp1, k) &&
+	    install_tswitch(t, ip1, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[i][jp1][k],
+						   t->sw[ip1][jp1][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7f1, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7f2:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O
+ *  b5:                                   .
+ *  b6:                                 .
+ *  b7:                               .
+ *                                  .       O
+ *                                O                   O
+ *                                  .
+ *                                    .
+ *                                      .
+ *                                        .
+ *                                          @
+ */
+static
+bool handle_case_0x7f2(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, jp1, k) &&
+	    install_tswitch(t, i, jp1, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[i][jp1][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7f2, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7f4:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O
+ *  b5:                                       .
+ *  b6:                                         .
+ *  b7:                                           .
+ *                                          O       .
+ *                                O                   O
+ *                                                  .
+ *                                                .
+ *                                              .
+ *                                            .
+ *                                          @
+ */
+static
+bool handle_case_0x7f4(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, ip1, j, k) &&
+	    install_tswitch(t, ip1, j, kp1,
+			    tfind_3d_perpendicular(t->sw[i][j][k],
+						   t->sw[ip1][j][k],
+						   t->sw[ip1][jp1][k],
+						   t->sw[ip1][j][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7f4, i, j, k, ip1, j, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7f8:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                           O                   O
+ *  b4:                                     O
+ *  b5:
+ *  b6:
+ *  b7:
+ *                                          O
+ *                                O                   O
+ *                                  .               .
+ *                                    .           .
+ *                                      .       .
+ *                                        .   .
+ *                                          @
+ */
+static
+bool handle_case_0x7f8(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int km1 = canonicalize(k - 1, t->z_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (safe_z_perpendicular(t, i, j, k) &&
+	    install_tswitch(t, i, j, kp1,
+			    tfind_3d_perpendicular(t->sw[ip1][j][k],
+						   t->sw[i][j][k],
+						   t->sw[i][jp1][k],
+						   t->sw[i][j][km1]))) {
+		return true;
+	}
+	log_no_perp(t, 0x7f8, i, j, k, i, j, k);
+	return false;
+}
+
+/*
+ * Handle the cases where three existing edges meet at a corner.
+ */
+
+/*
+ * 3D case 0x717:                           O
+ *                                        . . .
+ *  b0:                                 .   .   .
+ *  b1:                               .     .     .
+ *  b2:                             .       .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5: t->sw[i+1][j  ][k+1]
+ *  b6: t->sw[i  ][j+1][k+1]
+ *  b7: t->sw[i+1][j+1][k+1]
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x717(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, kp1,
+			    tfind_face_corner(t->sw[i][jp1][kp1],
+					      t->sw[ip1][jp1][kp1],
+					      t->sw[ip1][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x717, i, j, k, i, j, kp1);
+
+	if (install_tswitch(t, ip1, j, k,
+			    tfind_face_corner(t->sw[ip1][jp1][k],
+					      t->sw[ip1][jp1][kp1],
+					      t->sw[ip1][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x717, i, j, k, ip1, j, k);
+
+	if (install_tswitch(t, i, jp1, k,
+			    tfind_face_corner(t->sw[ip1][jp1][k],
+					      t->sw[ip1][jp1][kp1],
+					      t->sw[i][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x717, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x72b:                           O
+ *                                        .
+ *  b0:                                 .
+ *  b1:                               .
+ *  b2: t->sw[i  ][j+1][k  ]        .
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]      . .       O
+ *  b5:                           .   .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7: t->sw[i+1][j+1][k+1]      .       .
+ *                                .         O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x72b(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, j, kp1,
+			    tfind_face_corner(t->sw[i][j][kp1],
+					      t->sw[i][jp1][kp1],
+					      t->sw[ip1][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x72b, i, j, k, ip1, j, kp1);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[i][jp1][kp1],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x72b, i, j, k, i, j, k);
+
+	if (install_tswitch(t, ip1, jp1, k,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[i][jp1][kp1],
+					      t->sw[ip1][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x72b, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x74d:                           O
+ *                                            .
+ *  b0:                                         .
+ *  b1: t->sw[i+1][j  ][k  ]                      .
+ *  b2:                                             .
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O       . .
+ *  b5: t->sw[i+1][j  ][k+1]                      .   .
+ *  b6:                                         .     .
+ *  b7: t->sw[i+1][j+1][k+1]                  .       .
+ *                                          O         .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x74d(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, jp1, kp1,
+			    tfind_face_corner(t->sw[i][j][kp1],
+					      t->sw[ip1][j][kp1],
+					      t->sw[ip1][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x74d, i, j, k, i, jp1, kp1);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[ip1][j][kp1],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x74d, i, j, k, i, j, k);
+
+	if (install_tswitch(t, ip1, jp1, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[ip1][j][kp1],
+					      t->sw[ip1][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x74d, i, j, k, ip1, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x771:                           O
+ *                                          .
+ *  b0:                                     .
+ *  b1: t->sw[i+1][j  ][k  ]                .
+ *  b2: t->sw[i  ][j+1][k  ]                .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O
+ *  b5:                                   .   .
+ *  b6:                                 .       .
+ *  b7: t->sw[i+1][j+1][k+1]          .           .
+ *                                  .       O       .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x771(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, j, k,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[ip1][jp1][k],
+					      t->sw[ip1][j][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x771, i, j, k, i, j, k);
+
+	if (install_tswitch(t, ip1, j, kp1,
+			    tfind_face_corner(t->sw[ip1][jp1][kp1],
+					      t->sw[ip1][jp1][k],
+					      t->sw[ip1][j][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x771, i, j, k, ip1, j, kp1);
+
+	if (install_tswitch(t, i, jp1, kp1,
+			    tfind_face_corner(t->sw[ip1][jp1][kp1],
+					      t->sw[ip1][jp1][k],
+					      t->sw[i][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x771, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x78e:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]        .       O       .
+ *  b5: t->sw[i+1][j  ][k+1]          .           .
+ *  b6: t->sw[i  ][j+1][k+1]            .       .
+ *  b7:                                   .   .
+ *                                          O
+ *                                O         .         O
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          .
+ *                                          @
+ */
+static
+bool handle_case_0x78e(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, jp1, kp1,
+			    tfind_face_corner(t->sw[ip1][j][kp1],
+					      t->sw[i][j][kp1],
+					      t->sw[i][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x78e, i, j, k, ip1, jp1, kp1);
+
+	if (install_tswitch(t, ip1, j, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][j][kp1],
+					      t->sw[ip1][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x78e, i, j, k, ip1, j, k);
+
+	if (install_tswitch(t, i, jp1, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][j][kp1],
+					      t->sw[i][jp1][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x78e, i, j, k, i, jp1, k);
+	return false;
+}
+
+/*
+ * 3D case 0x7b2:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                           .         O
+ *  b5:                           .       .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7:                           .   .
+ *                                . .       O
+ *                                O                   O
+ *                                  .
+ *                                    .
+ *                                      .
+ *                                        .
+ *                                          @
+ */
+static
+bool handle_case_0x7b2(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, j, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[i][jp1][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7b2, i, j, k, ip1, j, k);
+
+	if (install_tswitch(t, ip1, jp1, kp1,
+			    tfind_face_corner(t->sw[i][jp1][kp1],
+					      t->sw[i][jp1][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7b2, i, j, k, ip1, jp1, kp1);
+
+	if (install_tswitch(t, i, j, kp1,
+			    tfind_face_corner(t->sw[i][jp1][kp1],
+					      t->sw[i][jp1][k],
+					      t->sw[i][j][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7b2, i, j, k, i, j, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7d4:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O         .
+ *  b5: t->sw[i+1][j  ][k+1]                  .       .
+ *  b6:                                         .     .
+ *  b7:                                           .   .
+ *                                          O       . .
+ *                                O                   O
+ *                                                  .
+ *                                                .
+ *                                              .
+ *                                            .
+ *                                          @
+ */
+static
+bool handle_case_0x7d4(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, i, jp1, k,
+			    tfind_face_corner(t->sw[i][j][k],
+					      t->sw[ip1][j][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7d4, i, j, k, i, jp1, k);
+
+	if (install_tswitch(t, i, j, kp1,
+			    tfind_face_corner(t->sw[ip1][j][kp1],
+					      t->sw[ip1][j][k],
+					      t->sw[i][j][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7d4, i, j, k, i, j, kp1);
+
+	if (install_tswitch(t, ip1, jp1, kp1,
+			    tfind_face_corner(t->sw[ip1][j][kp1],
+					      t->sw[ip1][j][k],
+					      t->sw[ip1][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7d4, i, j, k, ip1, jp1, kp1);
+	return false;
+}
+
+/*
+ * 3D case 0x7e8:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O
+ *  b5:
+ *  b6:
+ *  b7:
+ *                                          O
+ *                                O         .         O
+ *                                  .       .       .
+ *                                    .     .     .
+ *                                      .   .   .
+ *                                        . . .
+ *                                          @
+ */
+static
+bool handle_case_0x7e8(struct torus *t, int i, int j, int k)
+{
+	int ip1 = canonicalize(i + 1, t->x_sz);
+	int jp1 = canonicalize(j + 1, t->y_sz);
+	int kp1 = canonicalize(k + 1, t->z_sz);
+
+	if (install_tswitch(t, ip1, jp1, k,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[i][j][k],
+					      t->sw[i][jp1][k]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7e8, i, j, k, ip1, jp1, k);
+
+	if (install_tswitch(t, ip1, j, kp1,
+			    tfind_face_corner(t->sw[ip1][j][k],
+					      t->sw[i][j][k],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7e8, i, j, k, ip1, j, kp1);
+
+	if (install_tswitch(t, i, jp1, kp1,
+			    tfind_face_corner(t->sw[i][jp1][k],
+					      t->sw[i][j][k],
+					      t->sw[i][j][kp1]))) {
+		return true;
+	}
+	log_no_crnr(t, 0x7e8, i, j, k, i, jp1, kp1);
+	return false;
+}
+
+/*
+ * Handle the cases where four corners on a single face are missing.
+ */
+
+/*
+ * 3D case 0x70f:                           O
+ *                                        .   .
+ *  b0:                                 .       .
+ *  b1:                               .           .
+ *  b2:                             .               .
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]        .       O       .
+ *  b5: t->sw[i+1][j  ][k+1]          .           .
+ *  b6: t->sw[i  ][j+1][k+1]            .       .
+ *  b7: t->sw[i+1][j+1][k+1]              .   .
+ *                                          O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x70f(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x71f(t, i, j, k))
+		return true;
+
+	if (handle_case_0x72f(t, i, j, k))
+		return true;
+
+	if (handle_case_0x74f(t, i, j, k))
+		return true;
+
+	return handle_case_0x78f(t, i, j, k);
+}
+
+/*
+ * 3D case 0x733:                           O
+ *                                        . .
+ *  b0:                                 .   .
+ *  b1:                               .     .
+ *  b2: t->sw[i  ][j+1][k  ]        .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                           .         O
+ *  b5:                           .       .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7: t->sw[i+1][j+1][k+1]      .   .
+ *                                . .       O
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x733(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x737(t, i, j, k))
+		return true;
+
+	if (handle_case_0x73b(t, i, j, k))
+		return true;
+
+	if (handle_case_0x773(t, i, j, k))
+		return true;
+
+	return handle_case_0x7b3(t, i, j, k);
+}
+
+/*
+ * 3D case 0x755:                           O
+ *                                          . .
+ *  b0:                                     .   .
+ *  b1: t->sw[i+1][j  ][k  ]                .     .
+ *  b2:                                     .       .
+ *  b3: t->sw[i+1][j+1][k  ]      O         .         O
+ *  b4:                                     O         .
+ *  b5: t->sw[i+1][j  ][k+1]                  .       .
+ *  b6:                                         .     .
+ *  b7: t->sw[i+1][j+1][k+1]                      .   .
+ *                                          O       . .
+ *                                O                   O
+ *
+ *
+ *
+ *
+ *                                          @
+ */
+static
+bool handle_case_0x755(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x757(t, i, j, k))
+		return true;
+
+	if (handle_case_0x75d(t, i, j, k))
+		return true;
+
+	if (handle_case_0x775(t, i, j, k))
+		return true;
+
+	return handle_case_0x7d5(t, i, j, k);
+}
+
+/*
+ * 3D case 0x7aa:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1:
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]      . .       O
+ *  b5:                           .   .
+ *  b6: t->sw[i  ][j+1][k+1]      .     .
+ *  b7:                           .       .
+ *                                .         O
+ *                                O         .         O
+ *                                  .       .
+ *                                    .     .
+ *                                      .   .
+ *                                        . .
+ *                                          @
+ */
+static
+bool handle_case_0x7aa(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x7ab(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7ae(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7ba(t, i, j, k))
+		return true;
+
+	return handle_case_0x7ea(t, i, j, k);
+}
+
+/*
+ * 3D case 0x7cc:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2:
+ *  b3:                           O                   O
+ *  b4: t->sw[i  ][j  ][k+1]                O       . .
+ *  b5: t->sw[i+1][j  ][k+1]                      .   .
+ *  b6:                                         .     .
+ *  b7:                                       .       .
+ *                                          O         .
+ *                                O         .         O
+ *                                          .       .
+ *                                          .     .
+ *                                          .   .
+ *                                          . .
+ *                                          @
+ */
+static
+bool handle_case_0x7cc(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x7cd(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7ce(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7dc(t, i, j, k))
+		return true;
+
+	return handle_case_0x7ec(t, i, j, k);
+}
+
+/*
+ * 3D case 0x7f0:                           O
+ *
+ *  b0: t->sw[i  ][j  ][k  ]
+ *  b1: t->sw[i+1][j  ][k  ]
+ *  b2: t->sw[i  ][j+1][k  ]
+ *  b3: t->sw[i+1][j+1][k  ]      O                   O
+ *  b4:                                     O
+ *  b5:                                   .   .
+ *  b6:                                 .       .
+ *  b7:                               .           .
+ *                                  .       O       .
+ *                                O                   O
+ *                                  .               .
+ *                                    .           .
+ *                                      .       .
+ *                                        .   .
+ *                                          @
+ */
+static
+bool handle_case_0x7f0(struct torus *t, int i, int j, int k)
+{
+	if (handle_case_0x7f1(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7f2(t, i, j, k))
+		return true;
+
+	if (handle_case_0x7f4(t, i, j, k))
+		return true;
+
+	return handle_case_0x7f8(t, i, j, k);
+}
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
