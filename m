From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_torus.c: Use "OpenSM standard" error codes
Date: Mon, 07 Nov 2011 10:20:46 -0500
Message-ID: <4EB7F74E.20704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index a2d7b15..df46fb8 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -170,8 +170,7 @@ struct link {
  */
 struct port_grp {
 	enum endpt_type type;
-	size_t port_cnt;	/* number of attached ports in group
-				 */
+	size_t port_cnt;	/* number of attached ports in group */
 	size_t port_grp;	/* what switch port_grp we're in */
 	unsigned sw_dlid_cnt;	/* switch dlids routed through this group */
 	unsigned ca_dlid_cnt;	/* CA dlids routed through this group */
@@ -416,7 +415,7 @@ struct torus_context *torus_context_create(osm_opensm_t *osm)
 		ctx->osm = osm;
 	else
 		OSM_LOG(&osm->log, OSM_LOG_ERROR,
-			"Error: calloc: %s\n", strerror(errno));
+			"ERR 4E01: calloc: %s\n", strerror(errno));
 
 	return ctx;
 }
@@ -507,7 +506,7 @@ struct f_switch *alloc_fswitch(struct fabric *f,
 		ptr = realloc(f->sw, cnt_max * sizeof(*f->sw));
 		if (!ptr) {
 			OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-				"Error: realloc: %s\n", strerror(errno));
+				"ERR 4E02: realloc: %s\n", strerror(errno));
 			goto out;
 		}
 		f->sw = ptr;
@@ -519,7 +518,7 @@ struct f_switch *alloc_fswitch(struct fabric *f,
 	sw = calloc(1, new_sw_sz);
 	if (!sw) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: calloc: %s\n", strerror(errno));
+			"ERR 4E03: calloc: %s\n", strerror(errno));
 		goto out;
 	}
 	sw->port = (void *)(sw + 1);
@@ -543,7 +542,7 @@ struct link *alloc_flink(struct fabric *f)
 		ptr = realloc(f->link, cnt_max * sizeof(*f->link));
 		if (!ptr) {
 			OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-				"Error: realloc: %s\n", strerror(errno));
+				"ERR 4E04: realloc: %s\n", strerror(errno));
 			goto out;
 		}
 		f->link = ptr;
@@ -554,7 +553,7 @@ struct link *alloc_flink(struct fabric *f)
 	l = calloc(1, sizeof(*l));
 	if (!l) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: calloc: %s\n", strerror(errno));
+			"ERR 4E05: calloc: %s\n", strerror(errno));
 		goto out;
 	}
 	f->link[f->link_cnt++] = l;
@@ -586,7 +585,7 @@ bool build_sw_endpoint(struct fabric *f, osm_port_t *osm_port)
 	sw = find_f_sw(f, sw_guid);
 	if (!sw) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			"ERR 4E06: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid));
 		goto out;
 	}
@@ -599,7 +598,7 @@ bool build_sw_endpoint(struct fabric *f, osm_port_t *osm_port)
 			goto success;
 		} else
 			OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-				"Error: switch port %d has id "
+				"ERR 4E07: switch port %d has id "
 				"0x%04"PRIx64", expected 0x%04"PRIx64"\n",
 				sw_port, cl_ntoh64(sw->port[sw_port]->n_id),
 				cl_ntoh64(sw_guid));
@@ -608,7 +607,7 @@ bool build_sw_endpoint(struct fabric *f, osm_port_t *osm_port)
 	ep = calloc(1, sizeof(*ep));
 	if (!ep) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: allocating endpoint: %s\n", strerror(errno));
+			"ERR 4E08: allocating endpoint: %s\n", strerror(errno));
 		goto out;
 	}
 	ep->type = SRCSINK;
@@ -659,7 +658,7 @@ bool build_ca_link(struct fabric *f,
 	sw = find_f_sw(f, sw_guid);
 	if (!sw) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			"ERR 4E09: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid));
 		goto out;
 	}
@@ -715,14 +714,14 @@ bool build_link(struct fabric *f,
 	sw0 = find_f_sw(f, sw_guid0);
 	if (!sw0) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			"ERR 4E0A: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid0));
 			goto out;
 	}
 	sw1 = find_f_sw(f, sw_guid1);
 	if (!sw1) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			"ERR 4E0B: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid1));
 			goto out;
 	}
@@ -809,7 +808,7 @@ bool parse_torus(struct torus *t, const char *parse_sep)
 	t->sw_pool = calloc(t->sw_pool_sz, sizeof(*t->sw_pool));
 	if (!t->sw_pool) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: Torus switch array calloc: %s\n",
+			"ERR 4E0C: Torus switch array calloc: %s\n",
 			strerror(errno));
 		goto out;
 	}
@@ -820,7 +819,7 @@ bool parse_torus(struct torus *t, const char *parse_sep)
 	t->sw = malloc(cnt * sizeof(void *));
 	if (!t->sw) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: Torus switch array malloc: %s\n",
+			"ERR 4E0D: Torus switch array malloc: %s\n",
 			strerror(errno));
 		goto out;
 	}
@@ -960,7 +959,7 @@ bool parse_dir_link(int c_dir, struct torus *t, const char *parse_sep)
 		break;
 	default:
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: unknown link direction %d\n", c_dir);
+			"ERR 4E0E: unknown link direction %d\n", c_dir);
 		goto out;
 	}
 	l->end[0].type = PASSTHRU;
@@ -1011,14 +1010,14 @@ bool parse_dir_dateline(int c_dir, struct torus *t, const char *parse_sep)
 		break;
 	default:
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: unknown dateline direction %d\n", c_dir);
+			"ERR 4E0F: unknown dateline direction %d\n", c_dir);
 		goto out;
 	}
 	*dl = strtol(val, NULL, 0);
 
 	if ((*dl < 0 && *dl <= -max_dl) || *dl >= max_dl)
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: dateline value for coordinate direction %d "
+			"ERR 4E10: dateline value for coordinate direction %d "
 			"must be %d < dl < %d\n",
 			c_dir, -max_dl, max_dl);
 	else
@@ -1049,7 +1048,7 @@ bool parse_config(const char *fn, struct fabric *f, struct torus *t)
 	fp = fopen(fn, "r");
 	if (!fp) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Opening %s: %s\n", fn, strerror(errno));
+			"ERR 4E11: Opening %s: %s\n", fn, strerror(errno));
 		return false;
 	}
 	t->flags |= NOTIFY_CHANGES;
@@ -1118,13 +1117,13 @@ next_line:
 		goto next_line;
 	else {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: no keyword found: line %u\n",
+			"ERR 4E12: no keyword found: line %u\n",
 			(unsigned)line_cntr);
 		kw_success = false;
 	}
 	if (!kw_success) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: parsing '%s': line %u\n",
+			"ERR 4E13: parsing '%s': line %u\n",
 			keyword, (unsigned)line_cntr);
 	}
 	success = success && kw_success;
@@ -1348,7 +1347,7 @@ struct t_switch *alloc_tswitch(struct torus *t, struct f_switch *fsw)
 		 * pathological fabric can induce it.  So log an error.
 		 */
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: unexpectedly requested too many switch "
+			"ERR 4E14: unexpectedly requested too many switch "
 			"structures!\n");
 		goto out;
 	}
@@ -1358,7 +1357,7 @@ struct t_switch *alloc_tswitch(struct torus *t, struct f_switch *fsw)
 	sw = calloc(1, new_sw_sz);
 	if (!sw) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: calloc: %s\n", strerror(errno));
+			"ERR 4E15: calloc: %s\n", strerror(errno));
 		goto out;
 	}
 	sw->port = (void *)(sw + 1);
@@ -1406,7 +1405,7 @@ struct link *alloc_tlink(struct torus *t)
 {
 	if (t->link_cnt >= t->link_pool_sz) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: unexpectedly out of pre-allocated link "
+			"ERR 4E16: unexpectedly out of pre-allocated link "
 			"structures!\n");
 		return NULL;
 	}
@@ -1481,14 +1480,14 @@ bool connect_tlink(struct port_grp *pg0, struct endpoint *f_ep0,
 
 	if (pg0->port_cnt == t->portgrp_sz) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: exceeded port group max "
+			"ERR 4E17: exceeded port group max "
 			"port count (%d): switch GUID 0x%04"PRIx64"\n",
 			t->portgrp_sz, cl_ntoh64(pg0->sw->n_id));
 		goto out;
 	}
 	if (pg1->port_cnt == t->portgrp_sz) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: exceeded port group max "
+			"ERR 4E18: exceeded port group max "
 			"port count (%d): switch GUID 0x%04"PRIx64"\n",
 			t->portgrp_sz, cl_ntoh64(pg1->sw->n_id));
 		goto out;
@@ -1594,7 +1593,7 @@ bool link_tswitches(struct torus *t, int cdir,
 		break;
 	default:
 	cdir_error:
-		OSM_LOG(&t->osm->log, OSM_LOG_ERROR, "Error: "
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR, "ERR 4E19: "
 			"sw 0x%04"PRIx64" (%d,%d,%d) <--> "
 			"sw 0x%04"PRIx64" (%d,%d,%d) "
 			"invalid torus %s link orientation\n",
@@ -1609,7 +1608,7 @@ bool link_tswitches(struct torus *t, int cdir,
 
 	if (!f_sw0 || !f_sw1) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: missing fabric switches!\n"
+			"ERR 4E1A: missing fabric switches!\n"
 			"  switch GUIDs: 0x%04"PRIx64" 0x%04"PRIx64"\n",
 			cl_ntoh64(t_sw0->n_id), cl_ntoh64(t_sw1->n_id));
 		goto out;
@@ -1645,7 +1644,7 @@ bool link_tswitches(struct torus *t, int cdir,
 
 		if (!(f_ep0->type == PASSTHRU && f_ep1->type == PASSTHRU)) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: not interswitch "
+				"ERR 4E1B: not interswitch "
 				"link:\n  0x%04"PRIx64"/%d <-> 0x%04"PRIx64"/%d\n",
 				cl_ntoh64(f_ep0->n_id), f_ep0->port,
 				cl_ntoh64(f_ep1->n_id), f_ep1->port);
@@ -1698,7 +1697,7 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 	 */
 	if (!(fsw && fsw->osm_switch)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: Invalid topology discovery. "
+			"ERR 4E1C: Invalid topology discovery. "
 			"Verify torus-2QoS.conf contents.\n");
 		return false;
 	}
@@ -1723,7 +1722,7 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 			 */
 			if (pg->port_cnt == t->portgrp_sz) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: exceeded port group max port "
+					"ERR 4E1D: exceeded port group max port "
 					"count (%d): switch GUID 0x%04"PRIx64"\n",
 					t->portgrp_sz, cl_ntoh64(tsw->n_id));
 				goto out;
@@ -1758,7 +1757,7 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 
 			if (pg->port_cnt == t->portgrp_sz) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: exceeded port group max port "
+					"ERR 4E1E: exceeded port group max port "
 					"count (%d): switch GUID 0x%04"PRIx64"\n",
 					t->portgrp_sz, cl_ntoh64(tsw->n_id));
 				goto out;
@@ -1770,7 +1769,7 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 			 */
 			if (!f_ep1->osm_port) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: NULL osm_port->priv port "
+					"ERR 4E1F: NULL osm_port->priv port "
 					"GUID 0x%04"PRIx64"\n",
 					cl_ntoh64(f_ep1->n_id));
 				goto out;
@@ -7022,7 +7021,7 @@ bool verify_setup(struct torus *t, struct fabric *f)
 
 	if (!(t->x_sz && t->y_sz && t->z_sz)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: missing required torus size specification!\n");
+			"ERR 4E20: missing required torus size specification!\n");
 		goto out;
 	}
 	if (t->osm->subn.min_data_vls < 2)
@@ -7050,7 +7049,7 @@ bool verify_setup(struct torus *t, struct fabric *f)
 		for (p = 0; p < sw->port_cnt; p++) {
 			if (t->port_order[p] >= sw->port_cnt) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: port_order configured using "
+					"ERR 4E21: port_order configured using "
 					"port %u, but only %u ports in "
 					"switch w/ GUID 0x%04"PRIx64"\n",
 					t->port_order[p],  sw->port_cnt - 1,
@@ -7080,51 +7079,51 @@ again:
 	if (t->x_sz == 4 && !(t->flags & X_MESH)) {
 		if (o->xp_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive x" LINK_ERR_STR);
+				"ERR 4E22: Positive x" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->xm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Negative x" LINK_ERR_STR);
+				"ERR 4E23: Negative x" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->xp_link.end[0].n_id != o->xm_link.end[0].n_id) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive/negative x" SEED_ERR_STR);
+				"ERR 4E24: Positive/negative x" SEED_ERR_STR);
 			goto out;
 		}
 	}
 	if (t->y_sz == 4 && !(t->flags & Y_MESH)) {
 		if (o->yp_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive y" LINK_ERR_STR);
+				"ERR 4E25: Positive y" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->ym_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Negative y" LINK_ERR_STR);
+				"ERR 4E26: Negative y" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->yp_link.end[0].n_id != o->ym_link.end[0].n_id) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive/negative y" SEED_ERR_STR);
+				"ERR 4E27: Positive/negative y" SEED_ERR_STR);
 			goto out;
 		}
 	}
 	if (t->z_sz == 4 && !(t->flags & Z_MESH)) {
 		if (o->zp_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive z" LINK_ERR_STR);
+				"ERR 4E28: Positive z" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->zm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Negative z" LINK_ERR_STR);
+				"ERR 4E29: Negative z" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->zp_link.end[0].n_id != o->zm_link.end[0].n_id) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive/negative z" SEED_ERR_STR);
+				"ERR 4E2A: Positive/negative z" SEED_ERR_STR);
 			goto out;
 		}
 	}
@@ -7132,7 +7131,7 @@ again:
 		if (o->xp_link.end[0].port >= 0 &&
 		    o->xm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive or negative x" LINK_ERR_STR);
+				"ERR 4E2B: Positive or negative x" LINK_ERR_STR);
 			goto out;
 		}
 		if (o->xp_link.end[0].port < 0 &&
@@ -7155,7 +7154,7 @@ again:
 		if (o->zp_link.end[0].port >= 0 &&
 		    o->zm_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive or negative z" LINK_ERR_STR);
+				"ERR 4E2C: Positive or negative z" LINK_ERR_STR);
 			goto out;
 		}
 		if ((o->xp_link.end[0].port < 0 &&
@@ -7175,7 +7174,7 @@ again:
 		     o->zm_link.end[0].n_id != o->xm_link.end[0].n_id)) {
 
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: x and z" SEED_ERR_STR);
+				"ERR 4E2D: x and z" SEED_ERR_STR);
 			goto out;
 		}
 		if (o->zp_link.end[0].port < 0 &&
@@ -7198,7 +7197,7 @@ again:
 		if (o->yp_link.end[0].port >= 0 &&
 		    o->ym_link.end[0].port >= 0) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: Positive or negative y" LINK_ERR_STR);
+				"ERR 4E2E: Positive or negative y" LINK_ERR_STR);
 			goto out;
 		}
 		if ((o->xp_link.end[0].port < 0 &&
@@ -7218,7 +7217,7 @@ again:
 		     o->ym_link.end[0].n_id != o->xm_link.end[0].n_id)) {
 
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: x and y" SEED_ERR_STR);
+				"ERR 4E2F: x and y" SEED_ERR_STR);
 			goto out;
 		}
 		if (o->yp_link.end[0].port < 0 &&
@@ -7246,7 +7245,7 @@ again:
 
 	if (need_seed)
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: Every configured torus seed has at "
+			"ERR 4E30: Every configured torus seed has at "
 			"least one switch missing in fabric!\n");
 	else
 		success = true;
@@ -7270,7 +7269,7 @@ void build_torus(struct fabric *f, struct torus *t)
 	t->link_pool = calloc(1, t->link_pool_sz * sizeof(*t->link_pool));
 	if (!t->link_pool) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: Allocating torus link pool: %s\n",
+			"ERR 4E31: Allocating torus link pool: %s\n",
 			strerror(errno));
 		goto out;
 	}
@@ -7658,7 +7657,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt != g2b_cnt) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: strange failures in "
+					"ERR 4E32: strange failures in "
 					"x ring at y=%d  z=%d"
 					" b2g_cnt %u g2b_cnt %u\n",
 					j, k, b2g_cnt, g2b_cnt);
@@ -7666,7 +7665,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt > 1) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: disjoint failures in "
+					"ERR 4E33: disjoint failures in "
 					"x ring at y=%d  z=%d\n", j, k);
 				success = false;
 			}
@@ -7688,7 +7687,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt != g2b_cnt) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: strange failures in "
+					"ERR 4E34: strange failures in "
 					"y ring at x=%d  z=%d"
 					" b2g_cnt %u g2b_cnt %u\n",
 					i, k, b2g_cnt, g2b_cnt);
@@ -7696,7 +7695,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt > 1) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: disjoint failures in "
+					"ERR 4E35: disjoint failures in "
 					"y ring at x=%d  z=%d\n", i, k);
 				success = false;
 			}
@@ -7718,7 +7717,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt != g2b_cnt) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: strange failures in "
+					"ERR 4E36: strange failures in "
 					"z ring at x=%d  y=%d"
 					" b2g_cnt %u g2b_cnt %u\n",
 					i, j, b2g_cnt, g2b_cnt);
@@ -7726,7 +7725,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 			}
 			if (b2g_cnt > 1) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: disjoint failures in "
+					"ERR 4E37: disjoint failures in "
 					"z ring at x=%d  y=%d\n", i, j);
 				success = false;
 			}
@@ -7734,7 +7733,7 @@ bool routable_torus(struct torus *t, struct fabric *f)
 
 	if (t->flags & MSG_DEADLOCK) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch topology "
+			"ERR 4E38: missing switch topology "
 			"==> message deadlock!\n");
 		success = false;
 	}
@@ -8431,7 +8430,7 @@ no_route:
 	 * We can't get there from here.
 	 */
 	OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-		"Error: routing on sw 0x%04"PRIx64": sending "
+		"ERR 4E39: routing on sw 0x%04"PRIx64": sending "
 		"traffic for dest sw 0x%04"PRIx64" to port %u\n",
 		cl_ntoh64(sw->n_id), cl_ntoh64(dsw->n_id), OSM_NO_PATH);
 	return -1;
@@ -8446,7 +8445,7 @@ bool get_lid(struct port_grp *pg, unsigned p,
 
 	if (p >= pg->port_cnt) {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: Port group index %u too large: sw "
+			"ERR 4E3A: Port group index %u too large: sw "
 			"0x%04"PRIx64" pt_grp %u pt_grp_cnt %u\n",
 			p, cl_ntoh64(pg->sw->n_id),
 			(unsigned)pg->port_grp, (unsigned)pg->port_cnt);
@@ -8468,14 +8467,14 @@ bool get_lid(struct port_grp *pg, unsigned p,
 			*ca = true;
 	} else {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: Switch 0x%04"PRIx64" port %d improperly connected\n",
+			"ERR 4E3B: Switch 0x%04"PRIx64" port %d improperly connected\n",
 			cl_ntoh64(pg->sw->n_id), pg->port[p]->port);
 		return false;
 	}
 	osm_port = ep->osm_port;
 	if (!(osm_port && osm_port->priv == ep)) {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: ep->osm_port->priv != ep "
+			"ERR 4E3C: ep->osm_port->priv != ep "
 			"for sw 0x%04"PRIx64" port %d\n",
 			cl_ntoh64(((struct t_switch *)(ep->sw))->n_id), ep->port);
 		return false;
@@ -8502,7 +8501,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 
 	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-			"Error: sw->osm_switch->priv != sw "
+			"ERR 4E3D: sw->osm_switch->priv != sw "
 			"for sw 0x%04"PRIx64"\n", cl_ntoh64(sw->n_id));
 		return false;
 	}
@@ -8565,15 +8564,15 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 	depth++;
 
 	if (osm_sw->priv != sw) {
-		OSM_LOG(&sw->torus->osm->log, OSM_LOG_INFO,
-			"Error: osm_sw (GUID 0x%04"PRIx64") "
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+			"ERR 4E3E: osm_sw (GUID 0x%04"PRIx64") "
 			"not in our fabric description\n",
 			cl_ntoh64(osm_node_get_node_guid(osm_sw->p_node)));
 		goto out;
 	}
 	if (!osm_switch_supports_mcast(osm_sw)) {
 		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: osm_sw (GUID 0x%04"PRIx64") "
+			"ERR 4E3F: osm_sw (GUID 0x%04"PRIx64") "
 			"does not support multicast\n",
 			cl_ntoh64(osm_node_get_node_guid(osm_sw->p_node)));
 		goto out;
@@ -8614,7 +8613,7 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 		if (!(ds_node && ds_node->sw &&
 		      ds_sw->osm_switch == ds_node->sw)) {
 			OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
-				"Error: stale pointer to osm_sw "
+				"ERR 4E40: stale pointer to osm_sw "
 				"(GUID 0x%04"PRIx64")\n", cl_ntoh64(ds_sw->n_id));
 			continue;
 		}
@@ -8736,7 +8735,7 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 				guid_t id;
 				id = osm_node_get_node_guid(osm_port->p_node);
 				OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-					"Error: osm_port (GUID 0x%04"PRIx64") "
+					"ERR 4E41: osm_port (GUID 0x%04"PRIx64") "
 					"not in our fabric description\n",
 					cl_ntoh64(id));
 				continue;
@@ -8768,7 +8767,7 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 					     t->master_stree_root->n_id);
 	if (!(osm_sw && t->master_stree_root->osm_switch == osm_sw)) {
 		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-			"Error: stale pointer to osm_sw (GUID 0x%04"PRIx64")\n",
+			"ERR 4E42: stale pointer to osm_sw (GUID 0x%04"PRIx64")\n",
 			cl_ntoh64(t->master_stree_root->n_id));
 		return IB_ERROR;
 	}
@@ -9026,7 +9025,7 @@ bool torus_master_stree(struct torus *t)
 
 				success = false;
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: sw 0x%04"PRIx64" (%d,%d,%d) not in "
+					"ERR 4E43: sw 0x%04"PRIx64" (%d,%d,%d) not in "
 					"torus multicast master spanning tree\n",
 					cl_ntoh64(sw->n_id), i, j, k);
 			}
@@ -9213,7 +9212,7 @@ int torus_build_lfts(void *context)
 
 	if (!ctx->osm->subn.opt.qos) {
 		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-			"Error: Routing engine list contains torus-2QoS. "
+			"ERR 4E44: Routing engine list contains torus-2QoS. "
 			"Enable QoS for correct operation "
 			"(-Q or 'qos TRUE' in opensm.conf).\n");
 		return status;
@@ -9225,7 +9224,7 @@ int torus_build_lfts(void *context)
 	torus = calloc(1, sizeof(*torus));
 	if (!torus) {
 		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-			"Error: allocating torus: %s\n", strerror(errno));
+			"ERR 4E45: allocating torus: %s\n", strerror(errno));
 		goto out;
 	}
 	torus->osm = ctx->osm;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
