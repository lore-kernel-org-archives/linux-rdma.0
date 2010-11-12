From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 07/13] opensm/osm_torus.c: Use PRIx64 for GUID printing.
Date: Fri, 12 Nov 2010 15:11:16 -0700
Message-ID: <1289599882-15165-8-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |  216 ++++++++++++++++++++++----------------------
 1 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 804334f..8e0435b 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -60,8 +60,6 @@
 #define SWITCH_MAX_PORTGRPS  (1 + 2 * TORUS_MAX_DIM)
 
 typedef ib_net64_t guid_t;
-#define ntohllu(v_64bit) ((unsigned long long)cl_ntoh64(v_64bit))
-
 
 /*
  * An endpoint terminates a link, and is one of three types:
@@ -584,8 +582,8 @@ bool build_sw_endpoint(struct fabric *f, osm_port_t *osm_port)
 	sw = find_f_sw(f, sw_guid);
 	if (!sw) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04llx\n",
-			ntohllu(sw_guid));
+			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			cl_ntoh64(sw_guid));
 		goto out;
 	}
 	/*
@@ -598,9 +596,9 @@ bool build_sw_endpoint(struct fabric *f, osm_port_t *osm_port)
 		} else
 			OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
 				"Error: switch port %d has id "
-				"0x%04llx, expected 0x%04llx\n",
-				sw_port, ntohllu(sw->port[sw_port]->n_id),
-				ntohllu(sw_guid));
+				"0x%04"PRIx64", expected 0x%04"PRIx64"\n",
+				sw_port, cl_ntoh64(sw->port[sw_port]->n_id),
+				cl_ntoh64(sw_guid));
 		goto out;
 	}
 	ep = calloc(1, sizeof(*ep));
@@ -657,8 +655,8 @@ bool build_ca_link(struct fabric *f,
 	sw = find_f_sw(f, sw_guid);
 	if (!sw) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04llx\n",
-			ntohllu(sw_guid));
+			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			cl_ntoh64(sw_guid));
 		goto out;
 	}
 	l = alloc_flink(f);
@@ -713,15 +711,15 @@ bool build_link(struct fabric *f,
 	sw0 = find_f_sw(f, sw_guid0);
 	if (!sw0) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04llx\n",
-			ntohllu(sw_guid0));
+			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			cl_ntoh64(sw_guid0));
 			goto out;
 	}
 	sw1 = find_f_sw(f, sw_guid1);
 	if (!sw1) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
-			"Error: missing switch w/ GUID 0x%04llx\n",
-			ntohllu(sw_guid1));
+			"Error: missing switch w/ GUID 0x%04"PRIx64"\n",
+			cl_ntoh64(sw_guid1));
 			goto out;
 	}
 	l = alloc_flink(f);
@@ -1242,10 +1240,10 @@ void diagnose_fabric(struct fabric *f)
 
 		OSM_LOG(&f->osm->log, OSM_LOG_INFO,
 			"Found non-torus fabric link:"
-			" sw GUID 0x%04llx port %d <->"
-			" sw GUID 0x%04llx port %d\n",
-			ntohllu(l->end[0].n_id), l->end[0].port,
-			ntohllu(l->end[1].n_id), l->end[1].port);
+			" sw GUID 0x%04"PRIx64" port %d <->"
+			" sw GUID 0x%04"PRIx64" port %d\n",
+			cl_ntoh64(l->end[0].n_id), l->end[0].port,
+			cl_ntoh64(l->end[1].n_id), l->end[1].port);
 	}
 	/*
 	 * Report on any switches with ports using endpoints that didn't
@@ -1267,8 +1265,8 @@ void diagnose_fabric(struct fabric *f)
 
 			OSM_LOG(&f->osm->log, OSM_LOG_INFO,
 				"Found non-torus fabric port:"
-				" sw GUID 0x%04llx port %d\n",
-				ntohllu(f->sw[k]->n_id), p);
+				" sw GUID 0x%04"PRIx64" port %d\n",
+				cl_ntoh64(f->sw[k]->n_id), p);
 		}
 }
 
@@ -1423,15 +1421,15 @@ bool connect_tlink(struct port_grp *pg0, struct endpoint *f_ep0,
 	if (pg0->port_cnt == t->portgrp_sz) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"Error: exceeded port group max "
-			"port count (%d): switch GUID 0x%04llx\n",
-			t->portgrp_sz, ntohllu(pg0->sw->n_id));
+			"port count (%d): switch GUID 0x%04"PRIx64"\n",
+			t->portgrp_sz, cl_ntoh64(pg0->sw->n_id));
 		goto out;
 	}
 	if (pg1->port_cnt == t->portgrp_sz) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"Error: exceeded port group max "
-			"port count (%d): switch GUID 0x%04llx\n",
-			t->portgrp_sz, ntohllu(pg1->sw->n_id));
+			"port count (%d): switch GUID 0x%04"PRIx64"\n",
+			t->portgrp_sz, cl_ntoh64(pg1->sw->n_id));
 		goto out;
 	}
 	l = alloc_tlink(t);
@@ -1536,10 +1534,11 @@ bool link_tswitches(struct torus *t, int cdir,
 	default:
 	cdir_error:
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR, "Error: "
-			"sw 0x%04llx (%d,%d,%d) <--> sw 0x%04llx (%d,%d,%d) "
+			"sw 0x%04"PRIx64" (%d,%d,%d) <--> "
+			"sw 0x%04"PRIx64" (%d,%d,%d) "
 			"invalid torus %s link orientation\n",
-			ntohllu(t_sw0->n_id), t_sw0->i, t_sw0->j, t_sw0->k,
-			ntohllu(t_sw1->n_id), t_sw1->i, t_sw1->j, t_sw1->k,
+			cl_ntoh64(t_sw0->n_id), t_sw0->i, t_sw0->j, t_sw0->k,
+			cl_ntoh64(t_sw1->n_id), t_sw1->i, t_sw1->j, t_sw1->k,
 			cdir_name);
 		goto out;
 	}
@@ -1550,8 +1549,8 @@ bool link_tswitches(struct torus *t, int cdir,
 	if (!f_sw0 || !f_sw1) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"Error: missing fabric switches!\n"
-			"  switch GUIDs: 0x%04llx 0x%04llx\n",
-			ntohllu(t_sw0->n_id), ntohllu(t_sw1->n_id));
+			"  switch GUIDs: 0x%04"PRIx64" 0x%04"PRIx64"\n",
+			cl_ntoh64(t_sw0->n_id), cl_ntoh64(t_sw1->n_id));
 		goto out;
 	}
 	pg0 = &t_sw0->ptgrp[2*cdir + 1];
@@ -1586,9 +1585,9 @@ bool link_tswitches(struct torus *t, int cdir,
 		if (!(f_ep0->type == PASSTHRU && f_ep1->type == PASSTHRU)) {
 			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 				"Error: not interswitch "
-				"link:\n  0x%04llx/%d <-> 0x%04llx/%d\n",
-				ntohllu(f_ep0->n_id), f_ep0->port,
-				ntohllu(f_ep1->n_id), f_ep1->port);
+				"link:\n  0x%04"PRIx64"/%d <-> 0x%04"PRIx64"/%d\n",
+				cl_ntoh64(f_ep0->n_id), f_ep0->port,
+				cl_ntoh64(f_ep1->n_id), f_ep1->port);
 			goto out;
 		}
 		/*
@@ -1664,8 +1663,8 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 			if (pg->port_cnt == t->portgrp_sz) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 					"Error: exceeded port group max port "
-					"count (%d): switch GUID 0x%04llx\n",
-					t->portgrp_sz, ntohllu(tsw->n_id));
+					"count (%d): switch GUID 0x%04"PRIx64"\n",
+					t->portgrp_sz, cl_ntoh64(tsw->n_id));
 				goto out;
 			}
 			fsw->port[p]->sw = tsw;
@@ -1699,8 +1698,8 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 			if (pg->port_cnt == t->portgrp_sz) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 					"Error: exceeded port group max port "
-					"count (%d): switch GUID 0x%04llx\n",
-					t->portgrp_sz, ntohllu(tsw->n_id));
+					"count (%d): switch GUID 0x%04"PRIx64"\n",
+					t->portgrp_sz, cl_ntoh64(tsw->n_id));
 				goto out;
 			}
 			/*
@@ -1711,8 +1710,8 @@ bool link_srcsink(struct torus *t, int i, int j, int k)
 			if (!f_ep1->osm_port) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 					"Error: NULL osm_port->priv port "
-					"GUID 0x%04llx\n",
-					ntohllu(f_ep1->n_id));
+					"GUID 0x%04"PRIx64"\n",
+					cl_ntoh64(f_ep1->n_id));
 				goto out;
 			}
 			tl = alloc_tlink(t);
@@ -7261,13 +7260,13 @@ void build_torus(struct fabric *f, struct torus *t)
 	if (!t->seed_idx)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Using torus seed configured as default "
-			"(seed sw %d,%d,%d GUID 0x%04llx).\n",
-			i, j, k, ntohllu(sw[i][j][k]->n_id));
+			"(seed sw %d,%d,%d GUID 0x%04"PRIx64").\n",
+			i, j, k, cl_ntoh64(sw[i][j][k]->n_id));
 	else
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Using torus seed configured as backup #%u "
-			"(seed sw %d,%d,%d GUID 0x%04llx).\n",
-			t->seed_idx, i, j, k, ntohllu(sw[i][j][k]->n_id));
+			"(seed sw %d,%d,%d GUID 0x%04"PRIx64").\n",
+			t->seed_idx, i, j, k, cl_ntoh64(sw[i][j][k]->n_id));
 
 	/*
 	 * Search the fabric and construct the expected torus topology.
@@ -7315,15 +7314,15 @@ unsigned tsw_changes(struct t_switch *nsw, struct t_switch *osw)
 	if (nsw && !osw) {
 		cnt++;
 		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
-			"New torus switch %d,%d,%d GUID 0x%04llx\n",
-			nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id));
+			"New torus switch %d,%d,%d GUID 0x%04"PRIx64"\n",
+			nsw->i, nsw->j, nsw->k, cl_ntoh64(nsw->n_id));
 		goto out;
 	}
 	if (osw && !nsw) {
 		cnt++;
 		OSM_LOG(&osw->torus->osm->log, OSM_LOG_INFO,
-			"Lost torus switch %d,%d,%d GUID 0x%04llx\n",
-			osw->i, osw->j, osw->k, ntohllu(osw->n_id));
+			"Lost torus switch %d,%d,%d GUID 0x%04"PRIx64"\n",
+			osw->i, osw->j, osw->k, cl_ntoh64(osw->n_id));
 		goto out;
 	}
 	if (!(nsw && osw))
@@ -7333,17 +7332,17 @@ unsigned tsw_changes(struct t_switch *nsw, struct t_switch *osw)
 		cnt++;
 		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
 			"Torus switch %d,%d,%d GUID "
-			"was 0x%04llx, now 0x%04llx\n",
+			"was 0x%04"PRIx64", now 0x%04"PRIx64"\n",
 			nsw->i, nsw->j, nsw->k,
-			ntohllu(osw->n_id), ntohllu(nsw->n_id));
+			cl_ntoh64(osw->n_id), cl_ntoh64(nsw->n_id));
 	}
 
 	if (nsw->port_cnt != osw->port_cnt) {
 		cnt++;
 		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
-			"Torus switch %d,%d,%d GUID 0x%04llx "
+			"Torus switch %d,%d,%d GUID 0x%04"PRIx64" "
 			"had %d ports, now has %d\n",
-			nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id),
+			nsw->i, nsw->j, nsw->k, cl_ntoh64(nsw->n_id),
 			osw->port_cnt, nsw->port_cnt);
 	}
 	port_cnt = nsw->port_cnt;
@@ -7373,23 +7372,23 @@ unsigned tsw_changes(struct t_switch *nsw, struct t_switch *osw)
 		if (rnpt && !ropt) {
 			++cnt;
 			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
-				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
-				"remote now %s GUID 0x%04llx[%d], "
+				"Torus switch %d,%d,%d GUID 0x%04"PRIx64"[%d] "
+				"remote now %s GUID 0x%04"PRIx64"[%d], "
 				"was missing\n",
-				nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id), p,
-				rnpt->type == PASSTHRU ? "sw" : "node",
-				ntohllu(rnpt->n_id), rnpt->port);
+				nsw->i, nsw->j, nsw->k, cl_ntoh64(nsw->n_id),
+				p, rnpt->type == PASSTHRU ? "sw" : "node",
+				cl_ntoh64(rnpt->n_id), rnpt->port);
 			continue;
 		}
 		if (ropt && !rnpt) {
 			++cnt;
 			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
-				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
+				"Torus switch %d,%d,%d GUID 0x%04"PRIx64"[%d] "
 				"remote now missing, "
-				"was %s GUID 0x%04llx[%d]\n",
-				osw->i, osw->j, osw->k, ntohllu(nsw->n_id), p,
-				ropt->type == PASSTHRU ? "sw" : "node",
-				ntohllu(ropt->n_id), ropt->port);
+				"was %s GUID 0x%04"PRIx64"[%d]\n",
+				osw->i, osw->j, osw->k, cl_ntoh64(nsw->n_id),
+				p, ropt->type == PASSTHRU ? "sw" : "node",
+				cl_ntoh64(ropt->n_id), ropt->port);
 			continue;
 		}
 		if (!(rnpt && ropt))
@@ -7398,14 +7397,14 @@ unsigned tsw_changes(struct t_switch *nsw, struct t_switch *osw)
 		if (rnpt->n_id != ropt->n_id) {
 			++cnt;
 			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
-				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
-				"remote now %s GUID 0x%04llx[%d], "
-				"was %s GUID 0x%04llx[%d]\n",
-				nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id), p,
-				rnpt->type == PASSTHRU ? "sw" : "node",
-				ntohllu(rnpt->n_id), rnpt->port,
+				"Torus switch %d,%d,%d GUID 0x%04"PRIx64"[%d] "
+				"remote now %s GUID 0x%04"PRIx64"[%d], "
+				"was %s GUID 0x%04"PRIx64"[%d]\n",
+				nsw->i, nsw->j, nsw->k, cl_ntoh64(nsw->n_id),
+				p, rnpt->type == PASSTHRU ? "sw" : "node",
+				cl_ntoh64(rnpt->n_id), rnpt->port,
 				ropt->type == PASSTHRU ? "sw" : "node",
-				ntohllu(ropt->n_id), ropt->port);
+				cl_ntoh64(ropt->n_id), ropt->port);
 			continue;
 		}
 	}
@@ -7474,7 +7473,7 @@ static
 void rpt_torus_missing(struct torus *t, int i, int j, int k,
 		       struct t_switch *sw, int *missing_z)
 {
-	unsigned long long guid_ho;
+	uint64_t guid_ho;
 
 	if (!sw) {
 		/*
@@ -7498,43 +7497,43 @@ void rpt_torus_missing(struct torus *t, int i, int j, int k,
 			"Missing torus switch at %d,%d,%d\n", i, j, k);
 		return;
 	}
-	guid_ho = ntohllu(sw->n_id);
+	guid_ho = cl_ntoh64(sw->n_id);
 
 	if (!(sw->ptgrp[0].port_cnt || (t->x_sz == 1) ||
 	      ((t->flags & X_MESH) && i == 0)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus -x link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 	if (!(sw->ptgrp[1].port_cnt || (t->x_sz == 1) ||
 	      ((t->flags & X_MESH) && (i + 1) == t->x_sz)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus +x link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 	if (!(sw->ptgrp[2].port_cnt || (t->y_sz == 1) ||
 	      ((t->flags & Y_MESH) && j == 0)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus -y link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 	if (!(sw->ptgrp[3].port_cnt || (t->y_sz == 1) ||
 	      ((t->flags & Y_MESH) && (j + 1) == t->y_sz)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus +y link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 	if (!(sw->ptgrp[4].port_cnt || (t->z_sz == 1) ||
 	      ((t->flags & Z_MESH) && k == 0)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus -z link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 	if (!(sw->ptgrp[5].port_cnt || (t->z_sz == 1) ||
 	      ((t->flags & Z_MESH) && (k + 1) == t->z_sz)))
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Missing torus +z link on "
-			"switch %d,%d,%d GUID 0x%04llx\n",
+			"switch %d,%d,%d GUID 0x%04"PRIx64"\n",
 			i, j, k, guid_ho);
 }
 
@@ -7932,9 +7931,9 @@ void torus_update_osm_sl2vl(void *context, osm_physp_t *osm_phys_port,
 
 			guid = osm_node_get_node_guid(node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_switch (GUID 0x%04llx) "
+				"Error: osm_switch (GUID 0x%04"PRIx64") "
 				"not in our fabric description\n",
-				ntohllu(guid));
+				cl_ntoh64(guid));
 		return;
 		}
 	}
@@ -8192,9 +8191,10 @@ void warn_on_routing(const char *msg,
 		     struct t_switch *sw, struct t_switch *dsw)
 {
 	OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
-		"%s from sw 0x%04llx (%d,%d,%d) to sw 0x%04llx (%d,%d,%d)\n",
-		msg, ntohllu(sw->n_id), sw->i, sw->j, sw->k,
-		ntohllu(dsw->n_id), dsw->i, dsw->j, dsw->k);
+		"%s from sw 0x%04"PRIx64" (%d,%d,%d) "
+		"to sw 0x%04"PRIx64" (%d,%d,%d)\n",
+		msg, cl_ntoh64(sw->n_id), sw->i, sw->j, sw->k,
+		cl_ntoh64(dsw->n_id), dsw->i, dsw->j, dsw->k);
 }
 
 static
@@ -8351,9 +8351,9 @@ no_route:
 	 * We can't get there from here.
 	 */
 	OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-		"Error: routing on sw 0x%04llx: sending "
-		"traffic for dest sw 0x%04llx to port %u\n",
-		ntohllu(sw->n_id), ntohllu(dsw->n_id), OSM_NO_PATH);
+		"Error: routing on sw 0x%04"PRIx64": sending "
+		"traffic for dest sw 0x%04"PRIx64" to port %u\n",
+		cl_ntoh64(sw->n_id), cl_ntoh64(dsw->n_id), OSM_NO_PATH);
 	return -1;
 }
 
@@ -8367,8 +8367,8 @@ bool get_lid(struct port_grp *pg, unsigned p,
 	if (p >= pg->port_cnt) {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
 			"Error: Port group index %u too large: sw "
-			"0x%04llx pt_grp %u pt_grp_cnt %u\n",
-			p, ntohllu(pg->sw->n_id),
+			"0x%04"PRIx64" pt_grp %u pt_grp_cnt %u\n",
+			p, cl_ntoh64(pg->sw->n_id),
 			(unsigned)pg->port_grp, (unsigned)pg->port_cnt);
 		return false;
 	}
@@ -8388,16 +8388,16 @@ bool get_lid(struct port_grp *pg, unsigned p,
 			*ca = true;
 	} else {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: Switch 0x%04llx port %d improperly connected\n",
-			ntohllu(pg->sw->n_id), pg->port[p]->port);
+			"Error: Switch 0x%04"PRIx64" port %d improperly connected\n",
+			cl_ntoh64(pg->sw->n_id), pg->port[p]->port);
 		return false;
 	}
 	osm_port = ep->osm_port;
 	if (!(osm_port && osm_port->priv == ep)) {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
 			"Error: ep->osm_port->priv != ep "
-			"for sw 0x%04llu port %d\n",
-			ntohllu(((struct t_switch *)(ep->sw))->n_id), ep->port);
+			"for sw 0x%04"PRIx64" port %d\n",
+			cl_ntoh64(((struct t_switch *)(ep->sw))->n_id), ep->port);
 		return false;
 	}
 	*dlid_base = cl_ntoh16(osm_physp_get_base_lid(osm_port->p_physp));
@@ -8422,7 +8422,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
 			"Error: sw->osm_switch->priv != sw "
-			"for sw 0x%04llu\n", ntohllu(sw->n_id));
+			"for sw 0x%04"PRIx64"\n", cl_ntoh64(sw->n_id));
 		return false;
 	}
 	osm_sw = sw->osm_switch;
@@ -8476,16 +8476,16 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 
 	if (osm_sw->priv != sw) {
 		OSM_LOG(&sw->torus->osm->log, OSM_LOG_INFO,
-			"Error: osm_sw (GUID 0x%04llx) "
+			"Error: osm_sw (GUID 0x%04"PRIx64") "
 			"not in our fabric description\n",
-			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+			cl_ntoh64(osm_node_get_node_guid(osm_sw->p_node)));
 		goto out;
 	}
 	if (!osm_switch_supports_mcast(osm_sw)) {
 		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: osm_sw (GUID 0x%04llx) "
+			"Error: osm_sw (GUID 0x%04"PRIx64") "
 			"does not support multicast\n",
-			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+			cl_ntoh64(osm_node_get_node_guid(osm_sw->p_node)));
 		goto out;
 	}
 	mtn = osm_mtree_node_new(osm_sw);
@@ -8525,7 +8525,7 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 		      ds_sw->osm_switch == ds_node->sw)) {
 			OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
 				"Error: stale pointer to osm_sw "
-				"(GUID 0x%04llx)\n", ntohllu(ds_sw->n_id));
+				"(GUID 0x%04"PRIx64")\n", cl_ntoh64(ds_sw->n_id));
 			continue;
 		}
 		mtn->child_array[p] =
@@ -8646,9 +8646,9 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 				guid_t id;
 				id = osm_node_get_node_guid(osm_port->p_node);
 				OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-					"Error: osm_port (GUID 0x%04llx) "
+					"Error: osm_port (GUID 0x%04"PRIx64") "
 					"not in our fabric description\n",
-					ntohllu(id));
+					cl_ntoh64(id));
 				continue;
 			}
 		}
@@ -8678,8 +8678,8 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 					     t->master_stree_root->n_id);
 	if (!(osm_sw && t->master_stree_root->osm_switch == osm_sw)) {
 		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
-			"Error: stale pointer to osm_sw (GUID 0x%04llx)\n",
-			ntohllu(t->master_stree_root->n_id));
+			"Error: stale pointer to osm_sw (GUID 0x%04"PRIx64")\n",
+			cl_ntoh64(t->master_stree_root->n_id));
 		return IB_ERROR;
 	}
 	mgb->root = mcast_stree_branch(t->master_stree_root, osm_sw,
@@ -8936,9 +8936,9 @@ bool torus_master_stree(struct torus *t)
 
 				success = false;
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-					"Error: sw 0x%04llx (%d,%d,%d) not in "
+					"Error: sw 0x%04"PRIx64" (%d,%d,%d) not in "
 					"torus multicast master spanning tree\n",
-					ntohllu(sw->n_id), i, j, k);
+					cl_ntoh64(sw->n_id), i, j, k);
 			}
 out:
 	return success;
@@ -8975,9 +8975,9 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!sport) {
 			guid = osm_node_get_node_guid(osm_sport->p_node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_sport (GUID 0x%04llx) "
+				"Error: osm_sport (GUID 0x%04"PRIx64") "
 				"not in our fabric description\n",
-				ntohllu(guid));
+				cl_ntoh64(guid));
 			goto out;
 		}
 	}
@@ -8987,9 +8987,9 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!dport) {
 			guid = osm_node_get_node_guid(osm_dport->p_node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_dport (GUID 0x%04llx) "
+				"Error: osm_dport (GUID 0x%04"PRIx64") "
 				"not in our fabric description\n",
-				ntohllu(guid));
+				cl_ntoh64(guid));
 			goto out;
 		}
 	}
@@ -9000,15 +9000,15 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	if (sport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_sport->p_node);
 		OSM_LOG(log, OSM_LOG_INFO,
-			"Error: osm_sport (GUID 0x%04llx) "
-			"not a data src/sink port\n", ntohllu(guid));
+			"Error: osm_sport (GUID 0x%04"PRIx64") "
+			"not a data src/sink port\n", cl_ntoh64(guid));
 		goto out;
 	}
 	if (dport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_dport->p_node);
 		OSM_LOG(log, OSM_LOG_INFO,
-			"Error: osm_dport (GUID 0x%04llx) "
-			"not a data src/sink port\n", ntohllu(guid));
+			"Error: osm_dport (GUID 0x%04"PRIx64") "
+			"not a data src/sink port\n", cl_ntoh64(guid));
 		goto out;
 	}
 	/*
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
