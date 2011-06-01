From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 1/2] opensm: fail if configured torus port order
 references a port not available in all switches
Date: Wed,  1 Jun 2011 16:33:00 -0600
Message-ID: <1306967581-1015-1-git-send-email-jaschut@sandia.gov>
References: <4DE6BD7A.9030102@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE6BD7A.9030102-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/osm_torus.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 29c1bb4..47654ce 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -856,9 +856,6 @@ bool parse_port(unsigned *pnum, const char *parse_sep)
 	if (!val)
 		return false;
 	*pnum = strtoul(val, &nextchar, 0);
-	if (*pnum > IB_NODE_NUM_PORTS_MAX) {
-		*pnum = 0;
-	}
 	return true;
 }
 
@@ -7018,7 +7015,8 @@ static
 bool verify_setup(struct torus *t, struct fabric *f)
 {
 	struct coord_dirs *o;
-	unsigned n = 0;
+	struct f_switch *sw;
+	unsigned p, s, n = 0;
 	bool success = false;
 	bool all_sw_present, need_seed = true;
 
@@ -7044,6 +7042,24 @@ bool verify_setup(struct torus *t, struct fabric *f)
 			"with two QoS levels (have %d need 8)\n",
 			(int)t->osm->subn.min_data_vls);
 	/*
+	 * Be sure all the switches in the torus support the port
+	 * ordering that might have been configured.
+	 */
+	for (s = 0; s < f->switch_cnt; s++) {
+		sw = f->sw[s];
+		for (p = 0; p < sw->port_cnt; p++) {
+			if (t->port_order[p] >= sw->port_cnt) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: port_order configured using "
+					"port %u, but only %u ports in "
+					"switch w/ GUID 0x%04"PRIx64"\n",
+					t->port_order[p],  sw->port_cnt - 1,
+					cl_ntoh64(sw->n_id));
+				goto out;
+			}
+		}
+	}
+	/*
 	 * Unfortunately, there is a problem with non-unique topology for any
 	 * torus dimension which has radix four.  This problem requires extra
 	 * input, in the form of specifying both the positive and negative
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
