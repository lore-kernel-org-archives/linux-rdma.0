From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_mesh.c: Add dump_mesh routine at
	OSM_LOG_DEBUG level
Date: Tue, 29 Sep 2009 17:55:40 -0400
Message-ID: <20090929215540.GA28635@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Use snprintf rather than sprintf
Also, moved output of ]

diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
index 260e2f8..53f0f58 100644
--- a/opensm/opensm/osm_mesh.c
+++ b/opensm/opensm/osm_mesh.c
@@ -1565,6 +1565,63 @@ err:
 	return -1;
 }
 
+static void dump_mesh(lash_t *p_lash)
+{
+	osm_log_t *p_log = &p_lash->p_osm->log;
+	int sw;
+	int num_switches = p_lash->num_switches;
+	int dimension;
+	int i, j, k, n;
+	switch_t *s, *s2;
+	char buf[256];
+
+	OSM_LOG_ENTER(p_log);
+
+	for (sw = 0; sw < num_switches; sw++) {
+		s = p_lash->switches[sw];
+		dimension = s->node->dimension;
+		n = sprintf(buf, "[");
+		for (i = 0; i < dimension; i++) {
+			n += snprintf(buf + n, sizeof(buf) - n,
+				      "%2d", s->node->coord[i]);
+			if (n > sizeof(buf))
+				n = sizeof(buf);
+			if (i != dimension - 1) {
+				n += snprintf(buf + n, sizeof(buf) - n, "%s", ",");
+				if (n > sizeof(buf))
+					n = sizeof(buf);
+			}
+		}
+		n += snprintf(buf + n, sizeof(buf) - n, "]");
+		if (n > sizeof(buf))
+			n = sizeof(buf);
+		for (j = 0; j < s->node->num_links; j++) {
+			s2 = p_lash->switches[s->node->links[j]->switch_id];
+			n += snprintf(buf + n, sizeof(buf) - n, " [%d]->[", j);
+			if (n > sizeof(buf))
+				n = sizeof(buf);
+			for (k = 0; k < dimension; k++) {
+				n += snprintf(buf + n, sizeof(buf) - n, "%2d",
+					      s2->node->coord[k]);
+				if (n > sizeof(buf))
+					n = sizeof(buf);
+				if (k != dimension - 1) {
+					n += snprintf(buf + n, sizeof(buf) - n,
+						      ",");
+					if (n > sizeof(buf))
+						n = sizeof(buf);
+				}
+			}
+			n += snprintf(buf + n, sizeof(buf) - n, "]");
+			if (n > sizeof(buf))
+				n = sizeof(buf);
+		}
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "%s\n", buf);
+	}
+
+	OSM_LOG_EXIT(p_log);
+}
+
 /*
  * osm_do_mesh_analysis
  */
@@ -1653,6 +1710,9 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 		OSM_LOG(p_log, OSM_LOG_INFO, "%s", buf);
 	}
 
+	if (osm_log_is_active(p_log, OSM_LOG_DEBUG))
+		dump_mesh(p_lash);
+
 done:
 	mesh_delete(mesh);
 	OSM_LOG_EXIT(p_log);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
