From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 10/18] opensm: Add torus-2QoS routing engine, part 4.
Date: Fri,  3 Sep 2010 10:43:06 -0600
Message-ID: <1283532194-27112-11-git-send-email-jaschut@sandia.gov>
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
 opensm/opensm/osm_torus.c | 2179 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 2179 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index 3257ec4..41eb187 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -6927,3 +6927,2182 @@ again:
 out:
 	return;
 }
+
+#define LINK_ERR_STR " direction link required!\n"
+#define SEED_ERR_STR " direction links with different seed switches!\n"
+
+static
+bool verify_setup(struct torus *t, struct fabric *f)
+{
+	struct coord_dirs *o;
+	unsigned n = 0;
+	bool success = false;
+	bool all_sw_present, need_seed = true;
+
+	if (!(t->x_sz && t->y_sz && t->z_sz)) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: missing required torus size specification!\n");
+		goto out;
+	}
+	if (t->osm->subn.min_data_vls < 2)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Warning: Too few data VLs to support torus routing "
+			"without credit loops (have %d need 2)\n",
+			(int)t->osm->subn.min_data_vls);
+	if (t->osm->subn.min_data_vls < 4)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Warning: Too few data VLs to support torus routing "
+			"with a failed switch without credit loops"
+			"(have %d need 4)\n",
+			(int)t->osm->subn.min_data_vls);
+	if (t->osm->subn.min_data_vls < 8)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Warning: Too few data VLs to support torus routing "
+			"with two QoS levels (have %d need 8)\n",
+			(int)t->osm->subn.min_data_vls);
+	/*
+	 * Unfortunately, there is a problem with non-unique topology for any
+	 * torus dimension which has radix four.  This problem requires extra
+	 * input, in the form of specifying both the positive and negative
+	 * coordinate directions from a common switch, for any torus dimension
+	 * with radix four (see also build_torus()).
+	 *
+	 * Do the checking required to ensure that the required information
+	 * is present, but more than the needed information is not required.
+	 *
+	 * So, verify that we learned the coordinate directions correctly for
+	 * the fabric.  The coordinate direction links get an invalid port
+	 * set on their ends when parsed.
+	 */
+again:
+	all_sw_present = true;
+	o = &t->seed[n];
+
+	if (t->x_sz == 4 && !(t->flags & X_MESH)) {
+		if (o->xp_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive x" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->xm_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Negative x" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->xp_link.end[0].n_id != o->xm_link.end[0].n_id) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive/negative x" SEED_ERR_STR);
+			goto out;
+		}
+	}
+	if (t->y_sz == 4 && !(t->flags & Y_MESH)) {
+		if (o->yp_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive y" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->ym_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Negative y" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->yp_link.end[0].n_id != o->ym_link.end[0].n_id) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive/negative y" SEED_ERR_STR);
+			goto out;
+		}
+	}
+	if (t->z_sz == 4 && !(t->flags & Z_MESH)) {
+		if (o->zp_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive z" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->zm_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Negative z" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->zp_link.end[0].n_id != o->zm_link.end[0].n_id) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive/negative z" SEED_ERR_STR);
+			goto out;
+		}
+	}
+	if (t->x_sz > 1) {
+		if (o->xp_link.end[0].port >= 0 &&
+		    o->xm_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive or negative x" LINK_ERR_STR);
+			goto out;
+		}
+		if (o->xp_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->xp_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->xp_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->xp_link.end[1].n_id))
+			all_sw_present = false;
+
+		if (o->xm_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->xm_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->xm_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->xm_link.end[1].n_id))
+			all_sw_present = false;
+	}
+	if (t->z_sz > 1) {
+		if (o->zp_link.end[0].port >= 0 &&
+		    o->zm_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive or negative z" LINK_ERR_STR);
+			goto out;
+		}
+		if ((o->xp_link.end[0].port < 0 &&
+		     o->zp_link.end[0].port < 0 &&
+		     o->zp_link.end[0].n_id != o->xp_link.end[0].n_id) ||
+
+		    (o->xp_link.end[0].port < 0 &&
+		     o->zm_link.end[0].port < 0 &&
+		     o->zm_link.end[0].n_id != o->xp_link.end[0].n_id) ||
+
+		    (o->xm_link.end[0].port < 0 &&
+		     o->zp_link.end[0].port < 0 &&
+		     o->zp_link.end[0].n_id != o->xm_link.end[0].n_id) ||
+
+		    (o->xm_link.end[0].port < 0 &&
+		     o->zm_link.end[0].port < 0 &&
+		     o->zm_link.end[0].n_id != o->xm_link.end[0].n_id)) {
+
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: x and z" SEED_ERR_STR);
+			goto out;
+		}
+		if (o->zp_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->zp_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->zp_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->zp_link.end[1].n_id))
+			all_sw_present = false;
+
+		if (o->zm_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->zm_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->zm_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->zm_link.end[1].n_id))
+			all_sw_present = false;
+	}
+	if (t->y_sz > 1) {
+		if (o->yp_link.end[0].port >= 0 &&
+		    o->ym_link.end[0].port >= 0) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: Positive or negative y" LINK_ERR_STR);
+			goto out;
+		}
+		if ((o->xp_link.end[0].port < 0 &&
+		     o->yp_link.end[0].port < 0 &&
+		     o->yp_link.end[0].n_id != o->xp_link.end[0].n_id) ||
+
+		    (o->xp_link.end[0].port < 0 &&
+		     o->ym_link.end[0].port < 0 &&
+		     o->ym_link.end[0].n_id != o->xp_link.end[0].n_id) ||
+
+		    (o->xm_link.end[0].port < 0 &&
+		     o->yp_link.end[0].port < 0 &&
+		     o->yp_link.end[0].n_id != o->xm_link.end[0].n_id) ||
+
+		    (o->xm_link.end[0].port < 0 &&
+		     o->ym_link.end[0].port < 0 &&
+		     o->ym_link.end[0].n_id != o->xm_link.end[0].n_id)) {
+
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: x and y" SEED_ERR_STR);
+			goto out;
+		}
+		if (o->yp_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->yp_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->yp_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->yp_link.end[1].n_id))
+			all_sw_present = false;
+
+		if (o->ym_link.end[0].port < 0 &&
+		    !find_f_sw(f, o->ym_link.end[0].n_id))
+			all_sw_present = false;
+
+		if (o->ym_link.end[1].port < 0 &&
+		    !find_f_sw(f, o->ym_link.end[1].n_id))
+			all_sw_present = false;
+	}
+	if (all_sw_present && need_seed) {
+		t->seed_idx = n;
+		need_seed = false;
+	}
+	if (++n < t->seed_cnt)
+		goto again;
+
+	if (need_seed)
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: Every configured torus seed has at "
+			"least one switch missing in fabric!\n");
+	else
+		success = true;
+out:
+	return success;
+}
+
+static
+void build_torus(struct fabric *f, struct torus *t)
+{
+	int i, j, k;
+	int im1, jm1, km1;
+	int ip1, jp1, kp1;
+	unsigned nlink;
+	struct coord_dirs *o;
+	struct f_switch *fsw0, *fsw1;
+	struct t_switch ****sw = t->sw;
+	bool success = true;
+
+	t->link_pool_sz = f->link_cnt;
+	t->link_pool = calloc(1, t->link_pool_sz * sizeof(*t->link_pool));
+	if (!t->link_pool) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: Allocating torus link pool: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	t->fabric = f;
+
+	/*
+	 * Get things started by locating the up to seven switches that
+	 * define the torus "seed", coordinate directions, and datelines.
+	 */
+	o = &t->seed[t->seed_idx];
+
+	i = canonicalize(-o->x_dateline, t->x_sz);
+	j = canonicalize(-o->y_dateline, t->y_sz);
+	k = canonicalize(-o->z_dateline, t->z_sz);
+
+	if (o->xp_link.end[0].port < 0) {
+		ip1 = canonicalize(1 - o->x_dateline, t->x_sz);
+		fsw0 = find_f_sw(f, o->xp_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->xp_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, ip1, j, k, fsw1) && success;
+	}
+	if (o->xm_link.end[0].port < 0) {
+		im1 = canonicalize(-1 - o->x_dateline, t->x_sz);
+		fsw0 = find_f_sw(f, o->xm_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->xm_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, im1, j, k, fsw1) && success;
+	}
+	if (o->yp_link.end[0].port < 0) {
+		jp1 = canonicalize(1 - o->y_dateline, t->y_sz);
+		fsw0 = find_f_sw(f, o->yp_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->yp_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, i, jp1, k, fsw1) && success;
+	}
+	if (o->ym_link.end[0].port < 0) {
+		jm1 = canonicalize(-1 - o->y_dateline, t->y_sz);
+		fsw0 = find_f_sw(f, o->ym_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->ym_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, i, jm1, k, fsw1) && success;
+	}
+	if (o->zp_link.end[0].port < 0) {
+		kp1 = canonicalize(1 - o->z_dateline, t->z_sz);
+		fsw0 = find_f_sw(f, o->zp_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->zp_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, i, j, kp1, fsw1) && success;
+	}
+	if (o->zm_link.end[0].port < 0) {
+		km1 = canonicalize(-1 - o->z_dateline, t->z_sz);
+		fsw0 = find_f_sw(f, o->zm_link.end[0].n_id);
+		fsw1 = find_f_sw(f, o->zm_link.end[1].n_id);
+		success =
+			install_tswitch(t, i, j, k, fsw0) &&
+			install_tswitch(t, i, j, km1, fsw1) && success;
+	}
+	if (!success)
+		goto out;
+
+	if (!t->seed_idx)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Using torus seed configured as default "
+			"(seed sw %d,%d,%d GUID 0x%04llx).\n",
+			i, j, k, ntohllu(sw[i][j][k]->n_id));
+	else
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Using torus seed configured as backup #%u "
+			"(seed sw %d,%d,%d GUID 0x%04llx).\n",
+			t->seed_idx, i, j, k, ntohllu(sw[i][j][k]->n_id));
+
+	/*
+	 * Search the fabric and construct the expected torus topology.
+	 *
+	 * The algorithm is to consider the "cube" formed by eight switch
+	 * locations bounded by the corners i, j, k and i+1, j+1, k+1.
+	 * For each such cube look at the topology of the switches already
+	 * placed in the torus, and deduce which new switches can be placed
+	 * into their proper locations in the torus.  Examine each cube
+	 * multiple times, until the number of links moved into the torus
+	 * topology does not change.
+	 */
+again:
+	nlink = t->link_cnt;
+
+	for (k = 0; k < (int)t->z_sz; k++)
+		for (j = 0; j < (int)t->y_sz; j++)
+			for (i = 0; i < (int)t->x_sz; i++)
+				locate_sw(t, i, j, k);
+
+	if (t->link_cnt != nlink)
+		goto again;
+
+	/*
+	 * Move all other endpoints into torus/mesh.
+	 */
+	for (k = 0; k < (int)t->z_sz; k++)
+		for (j = 0; j < (int)t->y_sz; j++)
+			for (i = 0; i < (int)t->x_sz; i++)
+				link_srcsink(t, i, j, k);
+out:
+	return;
+}
+
+/*
+ * Returns a count of differences between old and new switches.
+ */
+static
+unsigned tsw_changes(struct t_switch *nsw, struct t_switch *osw)
+{
+	unsigned p, cnt = 0, port_cnt;
+	struct endpoint *npt, *opt;
+	struct endpoint *rnpt, *ropt;
+
+	if (nsw && !osw) {
+		cnt++;
+		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+			"New torus switch %d,%d,%d GUID 0x%04llx\n",
+			nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id));
+		goto out;
+	}
+	if (osw && !nsw) {
+		cnt++;
+		OSM_LOG(&osw->torus->osm->log, OSM_LOG_INFO,
+			"Lost torus switch %d,%d,%d GUID 0x%04llx\n",
+			osw->i, osw->j, osw->k, ntohllu(osw->n_id));
+		goto out;
+	}
+	if (!(nsw && osw))
+		goto out;
+
+	if (nsw->n_id != osw->n_id) {
+		cnt++;
+		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+			"Torus switch %d,%d,%d GUID "
+			"was 0x%04llx, now 0x%04llx\n",
+			nsw->i, nsw->j, nsw->k,
+			ntohllu(osw->n_id), ntohllu(nsw->n_id));
+	}
+
+	if (nsw->port_cnt != osw->port_cnt) {
+		cnt++;
+		OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+			"Torus switch %d,%d,%d GUID 0x%04llx "
+			"had %d ports, now has %d\n",
+			nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id),
+			osw->port_cnt, nsw->port_cnt);
+	}
+	port_cnt = nsw->port_cnt;
+	if (port_cnt > osw->port_cnt)
+		port_cnt = osw->port_cnt;
+
+	for (p = 0; p < port_cnt; p++) {
+		npt = nsw->port[p];
+		opt = osw->port[p];
+
+		if (npt && npt->link) {
+			if (&npt->link->end[0] == npt)
+				rnpt = &npt->link->end[1];
+			else
+				rnpt = &npt->link->end[0];
+		} else
+			rnpt = NULL;
+
+		if (opt && opt->link) {
+			if (&opt->link->end[0] == opt)
+				ropt = &opt->link->end[1];
+			else
+				ropt = &opt->link->end[0];
+		} else
+			ropt = NULL;
+
+		if (rnpt && !ropt) {
+			++cnt;
+			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
+				"remote now %s GUID 0x%04llx[%d], "
+				"was missing\n",
+				nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id), p,
+				rnpt->type == PASSTHRU ? "sw" : "node",
+				ntohllu(rnpt->n_id), rnpt->port);
+			continue;
+		}
+		if (ropt && !rnpt) {
+			++cnt;
+			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
+				"remote now missing, "
+				"was %s GUID 0x%04llx[%d]\n",
+				osw->i, osw->j, osw->k, ntohllu(nsw->n_id), p,
+				ropt->type == PASSTHRU ? "sw" : "node",
+				ntohllu(ropt->n_id), ropt->port);
+			continue;
+		}
+		if (!(rnpt && ropt))
+			continue;
+
+		if (rnpt->n_id != ropt->n_id) {
+			++cnt;
+			OSM_LOG(&nsw->torus->osm->log, OSM_LOG_INFO,
+				"Torus switch %d,%d,%d GUID 0x%04llx[%d] "
+				"remote now %s GUID 0x%04llx[%d], "
+				"was %s GUID 0x%04llx[%d]\n",
+				nsw->i, nsw->j, nsw->k, ntohllu(nsw->n_id), p,
+				rnpt->type == PASSTHRU ? "sw" : "node",
+				ntohllu(rnpt->n_id), rnpt->port,
+				ropt->type == PASSTHRU ? "sw" : "node",
+				ntohllu(ropt->n_id), ropt->port);
+			continue;
+		}
+	}
+out:
+	return cnt;
+}
+
+static
+void report_torus_changes(struct torus *nt, struct torus *ot)
+{
+	unsigned cnt = 0;
+	unsigned i, j, k;
+	unsigned x_sz = nt->x_sz;
+	unsigned y_sz = nt->y_sz;
+	unsigned z_sz = nt->z_sz;
+
+	if (!(nt && ot))
+		return;
+
+	if (x_sz != ot->x_sz) {
+		cnt++;
+		OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
+			"Torus x radix was %d now %d\n",
+			ot->x_sz, nt->x_sz);
+		if (x_sz > ot->x_sz)
+			x_sz = ot->x_sz;
+	}
+	if (y_sz != ot->y_sz) {
+		cnt++;
+		OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
+			"Torus y radix was %d now %d\n",
+			ot->y_sz, nt->y_sz);
+		if (y_sz > ot->y_sz)
+			y_sz = ot->y_sz;
+	}
+	if (z_sz != ot->z_sz) {
+		cnt++;
+		OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
+			"Torus z radix was %d now %d\n",
+			ot->z_sz, nt->z_sz);
+		if (z_sz > ot->z_sz)
+			z_sz = ot->z_sz;
+	}
+
+	for (k = 0; k < z_sz; k++)
+		for (j = 0; j < y_sz; j++)
+			for (i = 0; i < x_sz; i++) {
+				cnt += tsw_changes(nt->sw[i][j][k],
+						   ot->sw[i][j][k]);
+				/*
+				 * Booting a big fabric will cause lots of
+				 * changes as hosts come up, so don't spew.
+				 * We want to log changes to learn more about
+				 * bouncing links, etc, so they can be fixed.
+				 */
+				if (cnt > 32) {
+					OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
+						"Too many torus changes; "
+						"stopping reporting early\n");
+					return;
+				}
+			}
+}
+
+static
+void rpt_torus_missing(struct torus *t, int i, int j, int k,
+		       struct t_switch *sw, int *missing_z)
+{
+	unsigned long long guid_ho;
+
+	if (!sw) {
+		/*
+		 * We can have multiple missing switches without deadlock
+		 * if and only if they are adajacent in the Z direction.
+		 */
+		if ((t->switch_cnt + 1) < t->sw_pool_sz) {
+			if (t->sw[i][j][canonicalize(k - 1, t->z_sz)] &&
+			    t->sw[i][j][canonicalize(k + 1, t->z_sz)])
+				t->flags |= MSG_DEADLOCK;
+		}
+		/*
+		 * There can be only one such Z-column of missing switches.
+		 */
+		if (*missing_z < 0)
+			*missing_z = i + j * t->x_sz;
+		else if (*missing_z != i + j * t->x_sz)
+			t->flags |= MSG_DEADLOCK;
+
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus switch at %d,%d,%d\n", i, j, k);
+		return;
+	}
+	guid_ho = ntohllu(sw->n_id);
+
+	if (!(sw->ptgrp[0].port_cnt || (t->x_sz == 1) ||
+	      ((t->flags & X_MESH) && i == 0)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus -x link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+	if (!(sw->ptgrp[1].port_cnt || (t->x_sz == 1) ||
+	      ((t->flags & X_MESH) && (i + 1) == t->x_sz)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus +x link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+	if (!(sw->ptgrp[2].port_cnt || (t->y_sz == 1) ||
+	      ((t->flags & Y_MESH) && j == 0)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus -y link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+	if (!(sw->ptgrp[3].port_cnt || (t->y_sz == 1) ||
+	      ((t->flags & Y_MESH) && (j + 1) == t->y_sz)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus +y link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+	if (!(sw->ptgrp[4].port_cnt || (t->z_sz == 1) ||
+	      ((t->flags & Z_MESH) && k == 0)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus -z link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+	if (!(sw->ptgrp[5].port_cnt || (t->z_sz == 1) ||
+	      ((t->flags & Z_MESH) && (k + 1) == t->z_sz)))
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Missing torus +z link on "
+			"switch %d,%d,%d GUID 0x%04llx\n",
+			i, j, k, guid_ho);
+}
+
+/*
+ * Returns true if the torus can be successfully routed, false otherwise.
+ */
+static
+bool routable_torus(struct torus *t, struct fabric *f)
+{
+	int i, j, k, tmp = -1;
+	unsigned b2g_cnt, g2b_cnt;
+	bool success = true;
+
+	t->flags &= ~MSG_DEADLOCK;
+
+	if (t->link_cnt != f->link_cnt || t->switch_cnt != f->switch_cnt)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Warning: Could not construct torus using all "
+			"known fabric switches and/or links.\n");
+
+	for (k = 0; k < (int)t->z_sz; k++)
+		for (j = 0; j < (int)t->y_sz; j++)
+			for (i = 0; i < (int)t->x_sz; i++)
+				rpt_torus_missing(t, i, j, k,
+						  t->sw[i][j][k], &tmp);
+	/*
+	 * Check for multiple failures that create disjoint regions on a ring.
+	 */
+	for (k = 0; k < (int)t->z_sz; k++)
+		for (j = 0; j < (int)t->y_sz; j++) {
+			b2g_cnt = 0;
+			g2b_cnt = 0;
+			for (i = 0; i < (int)t->x_sz; i++) {
+
+				if (!t->sw[i][j][k])
+					continue;
+
+				if (!t->sw[i][j][k]->ptgrp[0].port_cnt)
+					b2g_cnt++;
+				if (!t->sw[i][j][k]->ptgrp[1].port_cnt)
+					g2b_cnt++;
+			}
+			if (b2g_cnt != g2b_cnt) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: strange failures in "
+					"x ring at y=%d  z=%d"
+					" b2g_cnt %u g2b_cnt %u\n",
+					j, k, b2g_cnt, g2b_cnt);
+				success = false;
+			}
+			if (b2g_cnt > 1) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: disjoint failures in "
+					"x ring at y=%d  z=%d\n", j, k);
+				success = false;
+			}
+		}
+
+	for (i = 0; i < (int)t->x_sz; i++)
+		for (k = 0; k < (int)t->z_sz; k++) {
+			b2g_cnt = 0;
+			g2b_cnt = 0;
+			for (j = 0; j < (int)t->y_sz; j++) {
+
+				if (!t->sw[i][j][k])
+					continue;
+
+				if (!t->sw[i][j][k]->ptgrp[2].port_cnt)
+					b2g_cnt++;
+				if (!t->sw[i][j][k]->ptgrp[3].port_cnt)
+					g2b_cnt++;
+			}
+			if (b2g_cnt != g2b_cnt) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: strange failures in "
+					"y ring at x=%d  z=%d"
+					" b2g_cnt %u g2b_cnt %u\n",
+					i, k, b2g_cnt, g2b_cnt);
+				success = false;
+			}
+			if (b2g_cnt > 1) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: disjoint failures in "
+					"y ring at x=%d  z=%d\n", i, k);
+				success = false;
+			}
+		}
+
+	for (j = 0; j < (int)t->y_sz; j++)
+		for (i = 0; i < (int)t->x_sz; i++) {
+			b2g_cnt = 0;
+			g2b_cnt = 0;
+			for (k = 0; k < (int)t->z_sz; k++) {
+
+				if (!t->sw[i][j][k])
+					continue;
+
+				if (!t->sw[i][j][k]->ptgrp[4].port_cnt)
+					b2g_cnt++;
+				if (!t->sw[i][j][k]->ptgrp[5].port_cnt)
+					g2b_cnt++;
+			}
+			if (b2g_cnt != g2b_cnt) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: strange failures in "
+					"z ring at x=%d  y=%d"
+					" b2g_cnt %u g2b_cnt %u\n",
+					i, j, b2g_cnt, g2b_cnt);
+				success = false;
+			}
+			if (b2g_cnt > 1) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: disjoint failures in "
+					"z ring at x=%d  y=%d\n", i, j);
+				success = false;
+			}
+		}
+
+	if (t->flags & MSG_DEADLOCK) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: missing switch topology "
+			"==> message deadlock!\n");
+		success = false;
+	}
+	return success;
+}
+
+/*
+ * Use this function to re-establish the pointers between a torus endpoint
+ * and an opensm osm_port_t.
+ *
+ * Typically this is only needed when "opensm --ucast-cache" is used, and
+ * a CA link bounces.  When the CA port goes away, the osm_port_t object
+ * is destroyed, invalidating the endpoint osm_port_t pointer.  When the
+ * link comes back, a new osm_port_t object is created with a NULL priv
+ * member.  Thus, when osm_get_torus_sl() is called it is missing the data
+ * needed to do its work.  Use this function to fix things up.
+ */
+static
+struct endpoint *osm_port_relink_endpoint(const osm_port_t *osm_port)
+{
+	guid_t node_guid;
+	uint8_t port_num, r_port_num;
+	struct t_switch *sw;
+	struct endpoint *ep = NULL;
+	osm_switch_t *osm_sw;
+	osm_physp_t *osm_physp;
+	osm_node_t *osm_node, *r_osm_node;
+
+	/*
+	 * We need to find the torus endpoint that has the same GUID as
+	 * the osm_port.  Rather than search the entire set of endpoints,
+	 * we'll try to follow pointers.
+	 */
+	osm_physp = osm_port->p_physp;
+	osm_node = osm_port->p_node;
+	port_num = osm_physp_get_port_num(osm_physp);
+	node_guid = osm_node_get_node_guid(osm_node);
+	/*
+	 * Switch management port?
+	 */
+	if (port_num == 0 &&
+	    osm_node_get_type(osm_node) == IB_NODE_TYPE_SWITCH) {
+
+		osm_sw = osm_node->sw;
+		if (osm_sw && osm_sw->priv) {
+			sw = osm_sw->priv;
+			if (sw->osm_switch == osm_sw &&
+			    sw->port[0]->n_id == node_guid) {
+
+				ep = sw->port[0];
+				goto relink_priv;
+			}
+		}
+	}
+	/*
+	 * CA port?  Try other end of link.  This should also catch a
+	 * router port if it is connected to a switch.
+	 */
+	r_osm_node = osm_node_get_remote_node(osm_node, port_num, &r_port_num);
+	if (!r_osm_node)
+		goto out;
+
+	osm_sw = r_osm_node->sw;
+	if (!osm_sw)
+		goto out;
+
+	sw = osm_sw->priv;
+	if (!(sw && sw->osm_switch == osm_sw))
+		goto out;
+
+	ep = sw->port[r_port_num];
+	if (!(ep && ep->link))
+		goto out;
+
+	if (ep->link->end[0].n_id == node_guid) {
+		ep = &ep->link->end[0];
+		goto relink_priv;
+	}
+	if (ep->link->end[1].n_id == node_guid) {
+		ep = &ep->link->end[1];
+		goto relink_priv;
+	}
+	ep = NULL;
+	goto out;
+
+relink_priv:
+	/* FIXME:
+	 * Unfortunately, we need to cast away const to rebuild the links
+	 * between the torus endpoint and the osm_port_t.
+	 *
+	 * What is really needed is to check whether pr_rcv_get_path_parms()
+	 * needs its port objects to be const.  If so, why, and whether
+	 * anything can be done about it.
+	 */
+	((osm_port_t *)osm_port)->priv = ep;
+	ep->osm_port = (osm_port_t *)osm_port;
+out:
+	return ep;
+}
+
+/*
+ * Computing LFT entries and path SL values:
+ *
+ * For a pristine torus, we compute LFT entries using XYZ DOR, and select
+ * which direction to route on a ring (i.e., the 1-D torus for the coordinate
+ * in question) based on shortest path.  We compute the SL to use for the
+ * path based on whether we crossed a dateline (where a ring coordinate
+ * wraps to zero) for each coordinate.
+ *
+ * When there is a link/switch failure, we want to compute LFT entries
+ * to route around the failure, without changing the path SL.  I.e., we
+ * want the SL to reach a given destination from a given source to be
+ * independent of the presence or number of failed components in the fabric.
+ *
+ * In order to make this feasible, we will assume that no ring is broken
+ * into disjoint pieces by multiple failures
+ *
+ * We handle failure by attempting to take the long way around any ring
+ * with connectivity interrupted by failed components, unless the path
+ * requires a turn on a failed switch.
+ *
+ * For paths that require a turn on a failed switch, we head towards the
+ * failed switch, then turn when progress is blocked by a failure, using a
+ * turn allowed under XYZ DOR.  However, such a path will also require a turn
+ * that is not a legal XYZ DOR turn, so we construct the SL2VL mapping tables
+ * such that XYZ DOR turns use one set of VLs and ZYX DOR turns use a
+ * separate set of VLs.
+ *
+ * Under these rules the algorithm guarantees credit-loop-free routing for a
+ * single failed switch, without any change in path SL values.  We can also
+ * guarantee credit-loop-free routing for failures of multiple switches, if
+ * they are adjacent in the last DOR direction.  Since we use XYZ-DOR,
+ * that means failed switches at i,j,k and i,j,k+1 will not cause credit
+ * loops.
+ *
+ * These failure routing rules are intended to prevent paths that cross any
+ * coordinate dateline twice (over and back), so we don't need to worry about
+ * any ambiguity over which SL to use for such a case.  Also, we cannot have
+ * a ring deadlock when a ring is broken by failure and we route the long
+ * way around, so we don't need to worry about the impact of such routing
+ * on SL choice.
+ */
+
+/*
+ * Functions to set our SL bit encoding for routing/QoS info.  Combine the
+ * resuts of these functions with bitwise or to get final SL.
+ *
+ * SL bits 0-2 encode whether we "looped" in a given direction
+ * on the torus on the path from source to destination.
+ *
+ * SL bit 3 encodes the QoS level.  We only support two QoS levels.
+ *
+ * Below we assume TORUS_MAX_DIM == 3 and 0 <= coord_dir < TORUS_MAX_DIM.
+ */
+static inline
+unsigned sl_set_use_loop_vl(bool use_loop_vl, unsigned coord_dir)
+{
+	return (coord_dir < TORUS_MAX_DIM)
+		? ((unsigned)use_loop_vl << coord_dir) : 0;
+}
+
+static inline
+unsigned sl_set_qos(unsigned qos)
+{
+	return (unsigned)(!!qos) << TORUS_MAX_DIM;
+}
+
+/*
+ * Functions to crack our SL bit encoding for routing/QoS info.
+ */
+static inline
+bool sl_get_use_loop_vl(unsigned sl, unsigned coord_dir)
+{
+	return (coord_dir < TORUS_MAX_DIM)
+		? (sl >> coord_dir) & 0x1 : false;
+}
+
+static inline
+unsigned sl_get_qos(unsigned sl)
+{
+	return (sl >> TORUS_MAX_DIM) & 0x1;
+}
+
+/*
+ * Functions to encode routing/QoS info into VL bits.  Combine the resuts of
+ * these functions with bitwise or to get final VL.
+ *
+ * VL bit 0 encodes whether we need to leave on the "loop" VL.
+ *
+ * VL bit 1 encodes whether turn is XYZ DOR or ZYX DOR. A 3d mesh/torus
+ * has 6 turn types: x-y, y-z, x-z, y-x, z-y, z-x.  The first three are
+ * legal XYZ DOR turns, and the second three are legal ZYX DOR turns.
+ * Straight-through (x-x, y-y, z-z) paths are legal in both DOR variants,
+ * so we'll assign them to XYZ DOR VLs.
+ *
+ * Note that delivery to switch-local ports (i.e. those that source/sink
+ * traffic, rather than forwarding it) cannot cause a deadlock, so that
+ * can also use either XYZ or ZYX DOR.
+ *
+ * VL bit 2 encodes QoS level.
+ *
+ * Note that if VL bit encodings are changed here, the available fabric VL
+ * verification in verify_setup() needs to be updated as well.
+ */
+static inline
+unsigned vl_set_loop_vl(bool use_loop_vl)
+{
+	return use_loop_vl;
+}
+
+static inline
+unsigned vl_set_qos_vl(unsigned qos)
+{
+	return (qos & 0x1) << 2;
+}
+
+static inline
+unsigned vl_set_turn_vl(unsigned in_coord_dir, unsigned out_coord_dir)
+{
+	unsigned vl = 0;
+
+	if (in_coord_dir != TORUS_MAX_DIM &&
+	    out_coord_dir != TORUS_MAX_DIM)
+		vl = (in_coord_dir > out_coord_dir)
+			? 0x1 << 1 : 0;
+
+	return vl;
+}
+
+static
+unsigned sl2vl_entry(struct torus *t, struct t_switch *sw,
+		     int input_pt, int output_pt, unsigned sl)
+{
+	unsigned id, od, vl, data_vls;
+
+	if (sw && sw->port[input_pt])
+		id = sw->port[input_pt]->pgrp->port_grp / 2;
+	else
+		id = TORUS_MAX_DIM;
+
+	if (sw && sw->port[output_pt])
+		od = sw->port[output_pt]->pgrp->port_grp / 2;
+	else
+		od = TORUS_MAX_DIM;
+
+	data_vls = t->osm->subn.min_data_vls;
+	vl = 0;
+
+	if (data_vls >= 2)
+		vl |= vl_set_loop_vl(sl_get_use_loop_vl(sl, od));
+	if (data_vls >= 4)
+		vl |= vl_set_turn_vl(id, od);
+	if (data_vls >= 8)
+		vl |= vl_set_qos_vl(sl_get_qos(sl));
+
+	return vl;
+}
+
+static
+void torus_update_osm_sl2vl(void *context, osm_physp_t *osm_phys_port,
+			    uint8_t iport_num, uint8_t oport_num,
+			    ib_slvl_table_t *osm_oport_sl2vl)
+{
+	osm_node_t *node = osm_physp_get_node_ptr(osm_phys_port);
+	struct torus_context *ctx = context;
+	struct t_switch *sw = NULL;
+	int sl, vl;
+
+	if (node->sw) {
+		sw = node->sw->priv;
+		if (sw && sw->osm_switch != node->sw) {
+			osm_log_t *log = &ctx->osm->log;
+			guid_t guid;
+
+			guid = osm_node_get_node_guid(node);
+			OSM_LOG(log, OSM_LOG_INFO,
+				"Error: osm_switch (GUID 0x%04llx) "
+				"not in our fabric description\n",
+				ntohllu(guid));
+		return;
+		}
+	}
+	for (sl = 0; sl < 16; sl++) {
+		vl = sl2vl_entry(ctx->torus, sw, iport_num, oport_num, sl);
+		ib_slvl_table_set(osm_oport_sl2vl, sl, vl);
+	}
+}
+
+/*
+ * Computes the path lengths *vl0_len and *vl1_len to get from src
+ * to dst on a ring with count switches.
+ *
+ * *vl0_len is the path length for a direct path; it corresponds to a path
+ * that should be assigned to use VL0 in a switch.  *vl1_len is the path
+ * length for a path that wraps aroung the ring, i.e. where the ring index
+ * goes from count to zero or from zero to count.  It corresponds to the path
+ * that should be assigned to use VL1 in a switch.
+ */
+static
+void get_pathlen(unsigned src, unsigned dst, unsigned count,
+		 unsigned *vl0_len, unsigned *vl1_len)
+{
+	unsigned s, l;		/* assume s < l */
+
+	if (dst > src) {
+		s = src;
+		l = dst;
+	} else {
+		s = dst;
+		l = src;
+	}
+	*vl0_len = l - s;
+	*vl1_len = s + count - l;
+}
+
+/*
+ * Returns a positive number if we should take the "positive" ring direction
+ * to reach dst from src, a negative number if we should take the "negative"
+ * ring direction, and 0 if src and dst are the same.  The choice is strictly
+ * based on which path is shorter.
+ */
+static
+int ring_dir_idx(unsigned src, unsigned dst, unsigned count)
+{
+	int r;
+	unsigned vl0_len, vl1_len;
+
+	if (dst == src)
+		return 0;
+
+	get_pathlen(src, dst, count, &vl0_len, &vl1_len);
+
+	if (dst > src)
+		r = vl0_len <= vl1_len ? 1 : -1;
+	else
+		r = vl0_len <= vl1_len ? -1 : 1;
+
+	return r;
+}
+
+/*
+ * Returns true if the VL1 path should be used to reach src from dst on a
+ * ring, based on which path is shorter.
+ */
+static
+bool use_vl1(unsigned src, unsigned dst, unsigned count)
+{
+	unsigned vl0_len, vl1_len;
+
+	get_pathlen(src, dst, count, &vl0_len, &vl1_len);
+
+	return vl0_len <= vl1_len ? false : true;
+}
+
+/*
+ * Returns the next switch in the ring of switches along coordinate direction
+ * cdir, in the positive ring direction if rdir is positive, and in the
+ * negative ring direction if rdir is negative.
+ *
+ * Returns NULL if rdir is zero, or there is no next switch.
+ */
+static
+struct t_switch *ring_next_sw(struct t_switch *sw, unsigned cdir, int rdir)
+{
+	unsigned pt_grp, far_end = 0;
+
+	if (!rdir)
+		return NULL;
+	/*
+	 * Recall that links are installed into the torus so that their 1 end
+	 * is in the "positive" coordinate direction relative to their 0 end
+	 * (see link_tswitches() and connect_tlink()).  Recall also that for
+	 * interswitch links, all links in a given switch port group have the
+	 * same endpoints, so we just need to look at the first link.
+	 */
+	pt_grp = 2 * cdir;
+	if (rdir > 0) {
+		pt_grp++;
+		far_end = 1;
+	}
+
+	if (!sw->ptgrp[pt_grp].port_cnt)
+		return NULL;
+
+	return sw->ptgrp[pt_grp].port[0]->link->end[far_end].sw;
+}
+
+/*
+ * Returns a positive number if we should take the "positive" ring direction
+ * to reach dsw from ssw, a negative number if we should take the "negative"
+ * ring direction, and 0 if src and dst are the same, or if dsw is not
+ * reachable from ssw because the path is interrupted by failure.
+ */
+static
+int ring_dir_path(struct torus *t, unsigned cdir,
+		  struct t_switch *ssw, struct t_switch *dsw)
+{
+	int d = 0;
+	struct t_switch *sw;
+
+	switch (cdir) {
+	case 0:
+		d = ring_dir_idx(ssw->i, dsw->i, t->x_sz);
+		break;
+	case 1:
+		d = ring_dir_idx(ssw->j, dsw->j, t->y_sz);
+		break;
+	case 2:
+		d = ring_dir_idx(ssw->k, dsw->k, t->z_sz);
+		break;
+	default:
+		break;
+	}
+	if (!d)
+		goto out;
+
+	sw = ssw;
+	while (sw) {
+		sw = ring_next_sw(sw, cdir, d);
+		if (sw == dsw)
+			goto out;
+	}
+	d *= -1;
+	sw = ssw;
+	while (sw) {
+		sw = ring_next_sw(sw, cdir, d);
+		if (sw == dsw)
+			goto out;
+	}
+	d = 0;
+out:
+	return d;
+}
+
+/*
+ * Returns true, and sets *pt_grp to the port group index to use for the
+ * next hop, if it is possible to make progress from ssw to dsw along the
+ * coordinate direction cdir, taking into account whether there are
+ * interruptions in the path.
+ *
+ * This next hop result can be used without worrying about ring deadlocks -
+ * if we don't choose the shortest path it is because there is a failure in
+ * the ring, which removes the possibilility of a ring deadlock on that ring.
+ */
+static
+bool next_hop_path(struct torus *t, unsigned cdir,
+		   struct t_switch *ssw, struct t_switch *dsw,
+		   unsigned *pt_grp)
+{
+	struct t_switch *tsw = NULL;
+	bool success = false;
+	int d;
+
+	/*
+	 * If the path from ssw to dsw turns, this is the switch where the
+	 * turn happens.
+	 */
+	switch (cdir) {
+	case 0:
+		tsw = t->sw[dsw->i][ssw->j][ssw->k];
+		break;
+	case 1:
+		tsw = t->sw[ssw->i][dsw->j][ssw->k];
+		break;
+	case 2:
+		tsw = t->sw[ssw->i][ssw->j][dsw->k];
+		break;
+	default:
+		goto out;
+	}
+	if (tsw) {
+		d = ring_dir_path(t, cdir, ssw, tsw);
+		cdir *= 2;
+		if (d > 0)
+			*pt_grp = cdir + 1;
+		else if (d < 0)
+			*pt_grp = cdir;
+		else
+			goto out;
+		success = true;
+	}
+out:
+	return success;
+}
+
+/*
+ * Returns true, and sets *pt_grp to the port group index to use for the
+ * next hop, if it is possible to make progress from ssw to dsw along the
+ * coordinate direction cdir.  This decision is made strictly on a
+ * shortest-path basis without regard for path availability.
+ */
+static
+bool next_hop_idx(struct torus *t, unsigned cdir,
+		  struct t_switch *ssw, struct t_switch *dsw,
+		  unsigned *pt_grp)
+{
+	int d;
+	unsigned g;
+	bool success = false;
+
+	switch (cdir) {
+	case 0:
+		d = ring_dir_idx(ssw->i, dsw->i, t->x_sz);
+		break;
+	case 1:
+		d = ring_dir_idx(ssw->j, dsw->j, t->y_sz);
+		break;
+	case 2:
+		d = ring_dir_idx(ssw->k, dsw->k, t->z_sz);
+		break;
+	default:
+		goto out;
+	}
+
+	cdir *= 2;
+	if (d > 0)
+		g = cdir + 1;
+	else if (d < 0)
+		g = cdir;
+	else
+		goto out;
+
+	if (!ssw->ptgrp[g].port_cnt)
+		goto out;
+
+	*pt_grp = g;
+	success = true;
+out:
+	return success;
+}
+
+static
+void warn_on_routing(const char *msg,
+		     struct t_switch *sw, struct t_switch *dsw)
+{
+	OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+		"%s from sw 0x%04llx (%d,%d,%d) to sw 0x%04llx (%d,%d,%d)\n",
+		msg, ntohllu(sw->n_id), sw->i, sw->j, sw->k,
+		ntohllu(dsw->n_id), dsw->i, dsw->j, dsw->k);
+}
+
+static
+bool next_hop_x(struct torus *t,
+		struct t_switch *ssw, struct t_switch *dsw, unsigned *pt_grp)
+{
+	if (t->sw[dsw->i][ssw->j][ssw->k])
+		/*
+		 * The next turning switch on this path is available,
+		 * so head towards it by the shortest available path.
+		 */
+		return next_hop_path(t, 0, ssw, dsw, pt_grp);
+	else
+		/*
+		 * The next turning switch on this path is not
+		 * available, so head towards it in the shortest
+		 * path direction.
+		 */
+		return next_hop_idx(t, 0, ssw, dsw, pt_grp);
+}
+
+static
+bool next_hop_y(struct torus *t,
+		struct t_switch *ssw, struct t_switch *dsw, unsigned *pt_grp)
+{
+	if (t->sw[ssw->i][dsw->j][ssw->k])
+		/*
+		 * The next turning switch on this path is available,
+		 * so head towards it by the shortest available path.
+		 */
+		return next_hop_path(t, 1, ssw, dsw, pt_grp);
+	else
+		/*
+		 * The next turning switch on this path is not
+		 * available, so head towards it in the shortest
+		 * path direction.
+		 */
+		return next_hop_idx(t, 1, ssw, dsw, pt_grp);
+}
+
+static
+bool next_hop_z(struct torus *t,
+		struct t_switch *ssw, struct t_switch *dsw, unsigned *pt_grp)
+{
+	return next_hop_path(t, 2, ssw, dsw, pt_grp);
+}
+
+/*
+ * Returns the port number on *sw to use to reach *dsw, or -1 if unable to
+ * route.
+ */
+static
+int lft_port(struct torus *t,
+	     struct t_switch *sw, struct t_switch *dsw,
+	     bool update_port_cnt, bool ca)
+{
+	unsigned g, p;
+	struct port_grp *pg;
+
+	/*
+	 * The IBA does not provide a way to preserve path history for
+	 * routing decisions and VL assignment, and the only mechanism to
+	 * provide global fabric knowledge to the routing engine is via
+	 * the four SL bits.  This severely constrains the ability to deal
+	 * with missing/dead switches.
+	 *
+	 * Also, if routing a torus with XYZ-DOR, the only way to route
+	 * around a missing/dead switch is to introduce a turn that is
+	 * illegal under XYZ-DOR.
+	 *
+	 * But here's what we can do:
+	 *
+	 * We have a VL bit we use to flag illegal turns, thus putting the
+	 * hop directly after an illegal turn on a separate set of VLs.
+	 * Unfortunately, since there is no path history,  the _second_
+	 * and subsequent hops after an illegal turn use the standard
+	 * XYZ-DOR VL set.  This is enough to introduce credit loops in
+	 * many cases.
+	 *
+	 * To minimize the number of cases such illegal turns can introduce
+	 * credit loops, we try to introduce the illegal turn as late in a
+	 * path as possible.
+	 *
+	 * Define a turning switch as a switch where a path turns from one
+	 * coordinate direction onto another.  If a turning switch in a path
+	 * is missing, construct the LFT entries so that the path progresses
+	 * as far as possible on the shortest path to the turning switch.
+	 * When progress is not possible, turn onto the next coordinate
+	 * direction.
+	 *
+	 * The next turn after that will be an illegal turn, after which
+	 * point the path will continue to use a standard XYZ-DOR path.
+	 */
+	if (dsw->i != sw->i) {
+
+		if (next_hop_x(t, sw, dsw, &g))
+			goto done;
+		/*
+		 * This path has made as much progress in this direction as
+		 * is possible, so turn it now.
+		 */
+		if (dsw->j != sw->j && next_hop_y(t, sw, dsw, &g))
+			goto done;
+
+		if (dsw->k != sw->k && next_hop_z(t, sw, dsw, &g))
+			goto done;
+
+		warn_on_routing("Error: unable to route", sw, dsw);
+		goto no_route;
+	} else if (dsw->j != sw->j) {
+
+		if (next_hop_y(t, sw, dsw, &g))
+			goto done;
+
+		if (dsw->k != sw->k && next_hop_z(t, sw, dsw, &g))
+			goto done;
+
+		warn_on_routing("Error: unable to route", sw, dsw);
+		goto no_route;
+	} else {
+		if (dsw->k == sw->k)
+			warn_on_routing("Warning: bad routing", sw, dsw);
+
+		if (next_hop_z(t, sw, dsw, &g))
+			goto done;
+
+		warn_on_routing("Error: unable to route", sw, dsw);
+		goto no_route;
+	}
+done:
+	pg = &sw->ptgrp[g];
+	if (!pg->port_cnt)
+		goto no_route;
+
+	if (update_port_cnt) {
+		if (ca)
+			p = pg->ca_dlid_cnt++ % pg->port_cnt;
+		else
+			p = pg->sw_dlid_cnt++ % pg->port_cnt;
+	} else {
+		/*
+		 * If we're not updating port counts, then we're just running
+		 * routes for SL path checking, and it doesn't matter which
+		 * of several parallel links we use.  Use the first one.
+		 */
+		p = 0;
+	}
+	p = pg->port[p]->port;
+
+	return p;
+
+no_route:
+	/*
+	 * We can't get there from here.
+	 */
+	OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+		"Error: routing on sw 0x%04llx: sending "
+		"traffic for dest sw 0x%04llx to port %u\n",
+		ntohllu(sw->n_id), ntohllu(dsw->n_id), OSM_NO_PATH);
+	return -1;
+}
+
+static
+bool get_lid(struct port_grp *pg, unsigned p,
+	     uint16_t *dlid_base, uint8_t *dlid_lmc, bool *ca)
+{
+	struct endpoint *ep;
+	osm_port_t *osm_port;
+
+	if (p >= pg->port_cnt) {
+		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
+			"Error: Port group index %u too large: sw "
+			"0x%04llx pt_grp %u pt_grp_cnt %u\n",
+			p, ntohllu(pg->sw->n_id),
+			(unsigned)pg->port_grp, (unsigned)pg->port_cnt);
+		return false;
+	}
+	if (pg->port[p]->type == SRCSINK) {
+		ep = pg->port[p];
+		if (ca)
+			*ca = false;
+	} else if (pg->port[p]->type == PASSTHRU &&
+		   pg->port[p]->link->end[1].type == SRCSINK) {
+		/*
+		 * If this port is connected via a link to a CA, then we
+		 * know link->end[0] is the switch end and link->end[1] is
+		 * the CA end; see build_ca_link() and link_srcsink().
+		 */
+		ep = &pg->port[p]->link->end[1];
+		if (ca)
+			*ca = true;
+	} else {
+		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
+			"Error: Switch 0x%04llx port %d improperly connected\n",
+			ntohllu(pg->sw->n_id), pg->port[p]->port);
+		return false;
+	}
+	osm_port = ep->osm_port;
+	if (!(osm_port && osm_port->priv == ep)) {
+		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
+			"Error: ep->osm_port->priv != ep "
+			"for sw 0x%04llu port %d\n",
+			ntohllu(((struct t_switch *)(ep->sw))->n_id), ep->port);
+		return false;
+	}
+	*dlid_base = cl_ntoh16(osm_physp_get_base_lid(osm_port->p_physp));
+	*dlid_lmc = osm_physp_get_lmc(osm_port->p_physp);
+
+	return true;
+}
+
+static
+bool torus_lft(struct torus *t, struct t_switch *sw)
+{
+	bool success = true;
+	int dp;
+	unsigned p, s;
+	uint16_t l, dlid_base;
+	uint8_t dlid_lmc;
+	bool ca;
+	struct port_grp *pgrp;
+	struct t_switch *dsw;
+	osm_switch_t *osm_sw;
+
+	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
+		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+			"Error: sw->osm_switch->priv != sw "
+			"for sw 0x%04llu\n", ntohllu(sw->n_id));
+		return false;
+	}
+	osm_sw = sw->osm_switch;
+	memset(osm_sw->new_lft, OSM_NO_PATH, osm_sw->lft_size);
+
+	for (s = 0; s < t->switch_cnt; s++) {
+
+		dsw = t->sw_pool[s];
+		pgrp = &dsw->ptgrp[2 * TORUS_MAX_DIM];
+
+		for (p = 0; p < pgrp->port_cnt; p++) {
+
+			if (!get_lid(pgrp, p, &dlid_base, &dlid_lmc, &ca))
+				return false;
+
+			if (sw->n_id == dsw->n_id)
+				dp = pgrp->port[p]->port;
+			else
+				dp = lft_port(t, sw, dsw, true, ca);
+			/*
+			 * LMC > 0 doesn't really make sense for torus-2QoS.
+			 * So, just make sure traffic gets delivered if
+			 * non-zero LMC is used.
+			 */
+			if (dp >= 0)
+				for (l = 0; l < (1U << dlid_lmc); l++)
+					osm_sw->new_lft[dlid_base + l] = dp;
+			else
+				success = false;
+		}
+	}
+	return success;
+}
+
+static
+osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
+				     osm_mgrp_box_t *mgb, unsigned depth,
+				     unsigned *port_cnt, unsigned *max_depth)
+{
+	osm_mtree_node_t *mtn = NULL;
+	osm_mcast_tbl_t *mcast_tbl, *ds_mcast_tbl;
+	osm_node_t *ds_node;
+	struct t_switch *ds_sw;
+	struct port_grp *ptgrp;
+	struct link *link;
+	struct endpoint *port;
+	unsigned g, p;
+	unsigned mcast_fwd_ports = 0, mcast_end_ports = 0;
+
+	depth++;
+
+	if (osm_sw->priv != sw) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_INFO,
+			"Error: osm_sw (GUID 0x%04llx) "
+			"not in our fabric description\n",
+			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+		goto out;
+	}
+	if (!osm_switch_supports_mcast(osm_sw)) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+			"Error: osm_sw (GUID 0x%04llx) "
+			"does not support multicast\n",
+			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+		goto out;
+	}
+	mtn = osm_mtree_node_new(osm_sw);
+	if (!mtn) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+			"Insufficient memory to build multicast tree\n");
+		goto out;
+	}
+	mcast_tbl = osm_switch_get_mcast_tbl_ptr(osm_sw);
+	/*
+	 * Recurse to downstream switches, i.e. those closer to master
+	 * spanning tree branch tips.
+	 *
+	 * Note that if there are multiple ports in this port group, i.e.,
+	 * multiple parallel links, we can pick any one of them to use for
+	 * any individual MLID without causing loops.  Pick one based on MLID
+	 * for now, until someone turns up evidence we need to be smarter.
+	 *
+	 * Also, it might be we got called in a window between a switch getting
+	 * removed from the fabric, and torus-2QoS getting to rebuild its
+	 * fabric representation.  If that were to happen, our next hop
+	 * osm_switch pointer might be stale.  Look it up via opensm's fabric
+	 * description to be sure it's not.
+	 */
+	for (g = 0; g < 2 * TORUS_MAX_DIM; g++) {
+		ptgrp = &sw->ptgrp[g];
+		if (!ptgrp->to_stree_tip)
+			continue;
+
+		p = mgb->mlid % ptgrp->port_cnt;/* port # in port group */
+		p = ptgrp->port[p]->port;	/* now port # in switch */
+
+		ds_node = osm_node_get_remote_node(osm_sw->p_node, p, NULL);
+		ds_sw = ptgrp->to_stree_tip->sw;
+
+		if (!(ds_node && ds_node->sw &&
+		      ds_sw->osm_switch == ds_node->sw)) {
+			OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+				"Error: stale pointer to osm_sw "
+				"(GUID 0x%04llx)\n", ntohllu(ds_sw->n_id));
+			continue;
+		}
+		mtn->child_array[p] =
+			mcast_stree_branch(ds_sw, ds_node->sw, mgb,
+					   depth, port_cnt, max_depth);
+		if (!mtn->child_array[p])
+			continue;
+
+		osm_mcast_tbl_set(mcast_tbl, mgb->mlid, p);
+		mcast_fwd_ports++;
+		/*
+		 * Since we forward traffic for this multicast group on this
+		 * port, cause the switch on the other end of the link
+		 * to forward traffic back to us.  Do it now since have at
+		 * hand the link used; otherwise it'll be hard to figure out
+		 * later, and if we get it wrong we get a MC routing loop.
+		 */
+		link = sw->port[p]->link;
+		ds_mcast_tbl = osm_switch_get_mcast_tbl_ptr(ds_node->sw);
+
+		if (&link->end[0] == sw->port[p])
+			osm_mcast_tbl_set(ds_mcast_tbl, mgb->mlid,
+					  link->end[1].port);
+		else
+			osm_mcast_tbl_set(ds_mcast_tbl, mgb->mlid,
+					  link->end[0].port);
+	}
+	/*
+	 * Add any host ports marked as in mcast group into spanning tree.
+	 */
+	ptgrp = &sw->ptgrp[2 * TORUS_MAX_DIM];
+	for (p = 0; p < ptgrp->port_cnt; p++) {
+		port = ptgrp->port[p];
+		if (port->tmp) {
+			port->tmp = NULL;
+			mtn->child_array[port->port] = OSM_MTREE_LEAF;
+			osm_mcast_tbl_set(mcast_tbl, mgb->mlid, port->port);
+			mcast_end_ports++;
+		}
+	}
+	if (!(mcast_end_ports || mcast_fwd_ports)) {
+		free(mtn);
+		mtn = NULL;
+	} else if (depth > *max_depth)
+		*max_depth = depth;
+
+	*port_cnt += mcast_end_ports;
+out:
+	return mtn;
+}
+
+static
+osm_port_t *next_mgrp_box_port(osm_mgrp_box_t *mgb,
+			       cl_list_item_t **list_iterator,
+			       cl_map_item_t **map_iterator)
+{
+	osm_mgrp_t *mgrp;
+	osm_mcm_port_t *mcm_port;
+	osm_port_t *osm_port = NULL;
+	cl_map_item_t *m_item = *map_iterator;
+	cl_list_item_t *l_item = *list_iterator;
+
+next_mgrp:
+	if (!l_item)
+		l_item = cl_qlist_head(&mgb->mgrp_list);
+	if (l_item == cl_qlist_end(&mgb->mgrp_list)) {
+		l_item = NULL;
+		goto out;
+	}
+	mgrp = cl_item_obj(l_item, mgrp, list_item);
+
+	if (!m_item)
+		m_item = cl_qmap_head(&mgrp->mcm_port_tbl);
+	if (m_item == cl_qmap_end(&mgrp->mcm_port_tbl)) {
+		m_item = NULL;
+		l_item = cl_qlist_next(l_item);
+		goto next_mgrp;
+	}
+	mcm_port = cl_item_obj(m_item, mcm_port, map_item);
+	m_item = cl_qmap_next(m_item);
+	osm_port = mcm_port->port;
+out:
+	*list_iterator = l_item;
+	*map_iterator = m_item;
+	return osm_port;
+}
+
+static
+ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
+{
+	struct torus_context *ctx = context;
+	struct torus *t = ctx->torus;
+	cl_map_item_t *m_item = NULL;
+	cl_list_item_t *l_item = NULL;
+	osm_port_t *osm_port;
+	osm_switch_t *osm_sw;
+	struct endpoint *port;
+	unsigned port_cnt = 0, max_depth = 0;
+
+	osm_purge_mtree(&ctx->osm->sm, mgb);
+
+	/*
+	 * Build a spanning tree for a multicast group by first marking
+	 * the torus endpoints that are participating in the group.
+	 * Then do a depth-first search of the torus master spanning
+	 * tree to build up the spanning tree specific to this group.
+	 *
+	 * Since the torus master spanning tree is constructed specifically
+	 * to guarantee that multicast will not deadlock against unicast
+	 * when they share VLs, we can be sure that any multicast group
+	 * spanning tree constructed this way has the same property.
+	 */
+	while ((osm_port = next_mgrp_box_port(mgb, &l_item, &m_item))) {
+		port = osm_port->priv;
+		if (!(port && port->osm_port == osm_port)) {
+			port = osm_port_relink_endpoint(osm_port);
+			if (!port) {
+				guid_t id;
+				id = osm_node_get_node_guid(osm_port->p_node);
+				OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+					"Error: osm_port (GUID 0x%04llx) "
+					"not in our fabric description\n",
+					ntohllu(id));
+				continue;
+			}
+		}
+		/*
+		 * If this is a CA port, mark the switch port at the
+		 * other end of this port's link.
+		 *
+		 * By definition, a CA port is connected to end[1] of a link,
+		 * and the switch port is end[0].  See build_ca_link() and
+		 * link_srcsink().
+		 */
+		if (port->link)
+			port = &port->link->end[0];
+		port->tmp = osm_port;
+	}
+	/*
+	 * It might be we got called in a window between a switch getting
+	 * removed from the fabric, and torus-2QoS getting to rebuild its
+	 * fabric representation.  If that were to happen, our
+	 * master_stree_root->osm_switch pointer might be stale.  Look up
+	 * the osm_switch by GUID to be sure it's not.
+	 *
+	 * Also, call into mcast_stree_branch with depth = -1, because
+	 * depth at root switch needs to be 0.
+	 */
+	osm_sw = (osm_switch_t *)cl_qmap_get(&ctx->osm->subn.sw_guid_tbl,
+					     t->master_stree_root->n_id);
+	if (!(osm_sw && t->master_stree_root->osm_switch == osm_sw)) {
+		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+			"Error: stale pointer to osm_sw (GUID 0x%04llx)\n",
+			ntohllu(t->master_stree_root->n_id));
+		return IB_ERROR;
+	}
+	mgb->root = mcast_stree_branch(t->master_stree_root, osm_sw,
+				       mgb, -1, &port_cnt, &max_depth);
+
+	OSM_LOG(&ctx->osm->log, OSM_LOG_VERBOSE,
+		"Configured MLID 0x%X for %u ports, max tree depth = %u\n",
+		mgb->mlid, port_cnt, max_depth);
+
+	return IB_SUCCESS;
+}
+
+static
+bool good_xy_ring(struct torus *t, const int x, const int y, const int z)
+{
+	struct t_switch ****sw = t->sw;
+	bool good_ring = true;
+	int x_tst, y_tst;
+
+	for (x_tst = 0; x_tst < t->x_sz && good_ring; x_tst++)
+		good_ring = sw[x_tst][y][z];
+
+	for (y_tst = 0; y_tst < t->y_sz && good_ring; y_tst++)
+		good_ring = sw[x][y_tst][z];
+
+	return good_ring;
+}
+
+static
+struct t_switch *find_plane_mid(struct torus *t, const int z)
+{
+	int x, dx, xm = t->x_sz / 2;
+	int y, dy, ym = t->y_sz / 2;
+	struct t_switch ****sw = t->sw;
+
+	if (good_xy_ring(t, xm, ym, z))
+		return sw[xm][ym][z];
+
+	for (dx = 1, dy = 1; dx <= xm && dy <= ym; dx++, dy++) {
+
+		x = canonicalize(xm - dx, t->x_sz);
+		y = canonicalize(ym - dy, t->y_sz);
+		if (good_xy_ring(t, x, y, z))
+			return sw[x][y][z];
+
+		x = canonicalize(xm + dx, t->x_sz);
+		y = canonicalize(ym + dy, t->y_sz);
+		if (good_xy_ring(t, x, y, z))
+			return sw[x][y][z];
+	}
+	return NULL;
+}
+
+static
+struct t_switch *find_stree_root(struct torus *t)
+{
+	int x, y, z, dz, zm = t->z_sz / 2;
+	struct t_switch ****sw = t->sw;
+	struct t_switch *root;
+	bool good_plane;
+
+	/*
+	 * Look for a switch near the "center" (wrt. the datelines) of the
+	 * torus, as that will be the most optimum spanning tree root.  Use
+	 * a search that is not exhaustive, on the theory that this routing
+	 * engine isn't useful anyway if too many switches are missing.
+	 *
+	 * Also, want to pick an x-y plane with no missing switches, so that
+	 * the master spanning tree construction algorithm doesn't have to
+	 * deal with needing a turn on a missing switch.
+	 */
+	for (dz = 0; dz <= zm; dz++) {
+
+		z = canonicalize(zm - dz, t->z_sz);
+		good_plane = true;
+		for (y = 0; y < t->y_sz && good_plane; y++)
+			for (x = 0; x < t->x_sz && good_plane; x++)
+				good_plane = sw[x][y][z];
+
+		if (good_plane) {
+			root = find_plane_mid(t, z);
+			if (root)
+				goto out;
+		}
+		if (!dz)
+			continue;
+
+		z = canonicalize(zm + dz, t->z_sz);
+		good_plane = true;
+		for (y = 0; y < t->y_sz && good_plane; y++)
+			for (x = 0; x < t->x_sz && good_plane; x++)
+				good_plane = sw[x][y][z];
+
+		if (good_plane) {
+			root = find_plane_mid(t, z);
+			if (root)
+				goto out;
+		}
+	}
+	/*
+	 * Note that torus-2QoS can route a torus that is missing an entire
+	 * column (switches with x,y constant, for all z values) without
+	 * deadlocks.
+	 *
+	 * if we've reached this point, we must have a column of missing
+	 * switches, as routable_torus() would have returned false for
+	 * any other configuration of missing switches that made it through
+	 * the above.
+	 *
+	 * So any switch in the mid-z plane will do as the root.
+	 */
+	root = find_plane_mid(t, zm);
+out:
+	return root;
+}
+
+static
+bool sw_in_master_stree(struct t_switch *sw)
+{
+	int g;
+	bool connected;
+
+	connected = sw == sw->torus->master_stree_root;
+	for (g = 0; g < 2 * TORUS_MAX_DIM; g++)
+		connected = connected || sw->ptgrp[g].to_stree_root;
+
+	return connected;
+}
+
+static
+void grow_master_stree_branch(struct t_switch *root, struct t_switch *tip,
+			      unsigned to_root_pg, unsigned to_tip_pg)
+{
+	root->ptgrp[to_tip_pg].to_stree_tip = &tip->ptgrp[to_root_pg];
+	tip->ptgrp[to_root_pg].to_stree_root = &root->ptgrp[to_tip_pg];
+}
+
+static
+void build_master_stree_branch(struct t_switch *branch_root, int cdir)
+{
+	struct t_switch *sw, *n_sw, *p_sw;
+	unsigned l, idx, cnt, pg, ng;
+
+	switch (cdir) {
+	case 0:
+		idx = branch_root->i;
+		cnt = branch_root->torus->x_sz;
+		break;
+	case 1:
+		idx = branch_root->j;
+		cnt = branch_root->torus->y_sz;
+		break;
+	case 2:
+		idx = branch_root->k;
+		cnt = branch_root->torus->z_sz;
+		break;
+	default:
+		goto out;
+	}
+	/*
+	 * This algorithm intends that a spanning tree branch never crosses
+	 * a dateline unless the 1-D ring for which we're building the branch
+	 * is interrupted by failure.  We need that guarantee to prevent
+	 * multicast/unicast credit loops.
+	 */
+	n_sw = branch_root;		/* tip of negative cdir branch */
+	ng = 2 * cdir;			/* negative cdir port group index */
+	p_sw = branch_root;		/* tip of positive cdir branch */
+	pg = 2 * cdir + 1;		/* positive cdir port group index */
+
+	for (l = idx; n_sw && l >= 1; l--) {
+		sw = ring_next_sw(n_sw, cdir, -1);
+		if (sw && !sw_in_master_stree(sw)) {
+			grow_master_stree_branch(n_sw, sw, pg, ng);
+			n_sw = sw;
+		} else
+			n_sw = NULL;
+	}
+	for (l = idx; p_sw && l < (cnt - 1); l++) {
+		sw = ring_next_sw(p_sw, cdir, 1);
+		if (sw && !sw_in_master_stree(sw)) {
+			grow_master_stree_branch(p_sw, sw, ng, pg);
+			p_sw = sw;
+		} else
+			p_sw = NULL;
+	}
+	if (n_sw && p_sw)
+		goto out;
+	/*
+	 * At least one branch couldn't grow to the dateline for this ring.
+	 * That means it is acceptable to grow the branch by crossing the
+	 * dateline.
+	 */
+	for (l = 0; l < cnt; l++) {
+		if (n_sw) {
+			sw = ring_next_sw(n_sw, cdir, -1);
+			if (sw && !sw_in_master_stree(sw)) {
+				grow_master_stree_branch(n_sw, sw, pg, ng);
+				n_sw = sw;
+			} else
+				n_sw = NULL;
+		}
+		if (p_sw) {
+			sw = ring_next_sw(p_sw, cdir, 1);
+			if (sw && !sw_in_master_stree(sw)) {
+				grow_master_stree_branch(p_sw, sw, ng, pg);
+				p_sw = sw;
+			} else
+				p_sw = NULL;
+		}
+		if (!(n_sw || p_sw))
+			break;
+	}
+out:
+	return;
+}
+
+static
+bool torus_master_stree(struct torus *t)
+{
+	int i, j, k;
+	bool success = false;
+	struct t_switch *stree_root = find_stree_root(t);
+
+	if (stree_root)
+		build_master_stree_branch(stree_root, 0);
+	else
+		goto out;
+
+	k = stree_root->k;
+	for (i = 0; i < t->x_sz; i++) {
+		j = stree_root->j;
+		if (t->sw[i][j][k])
+			build_master_stree_branch(t->sw[i][j][k], 1);
+
+		for (j = 0; j < t->y_sz; j++)
+			if (t->sw[i][j][k])
+				build_master_stree_branch(t->sw[i][j][k], 2);
+	}
+	t->master_stree_root = stree_root;
+	/*
+	 * At this point we should have a master spanning tree that contains
+	 * every present switch, for all fabrics that torus-2QoS can route
+	 * without deadlocks.  Make sure this is the case; otherwise warn
+	 * and return failure so we get bug reports.
+	 */
+	success = true;
+	for (i = 0; i < t->x_sz; i++)
+		for (j = 0; j < t->y_sz; j++)
+			for (k = 0; k < t->z_sz; k++) {
+				struct t_switch *sw = t->sw[i][j][k];
+				if (!sw || sw_in_master_stree(sw))
+					continue;
+
+				success = false;
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: sw 0x%04llx (%d,%d,%d) not in "
+					"torus multicast master spanning tree\n",
+					ntohllu(sw->n_id), i, j, k);
+			}
+out:
+	return success;
+}
+
+int route_torus(struct torus *t)
+{
+	int s;
+	bool success = true;
+
+	for (s = 0; s < (int)t->switch_cnt; s++)
+		success = torus_lft(t, t->sw_pool[s]) && success;
+
+	success = success && torus_master_stree(t);
+
+	return success ? 0 : -1;
+}
+
+uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
+		      const osm_port_t *osm_sport,
+		      const osm_port_t *osm_dport)
+{
+	struct torus_context *ctx = context;
+	osm_log_t *log = &ctx->osm->log;
+	struct endpoint *sport, *dport;
+	struct t_switch *ssw, *dsw;
+	struct torus *t;
+	guid_t guid;
+	unsigned sl = 0, sp;
+
+	sport = osm_sport->priv;
+	if (!(sport && sport->osm_port == osm_sport)) {
+		sport = osm_port_relink_endpoint(osm_sport);
+		if (!sport) {
+			guid = osm_node_get_node_guid(osm_sport->p_node);
+			OSM_LOG(log, OSM_LOG_INFO,
+				"Error: osm_sport (GUID 0x%04llx) "
+				"not in our fabric description\n",
+				ntohllu(guid));
+			goto out;
+		}
+	}
+	dport = osm_dport->priv;
+	if (!(dport && dport->osm_port == osm_dport)) {
+		dport = osm_port_relink_endpoint(osm_dport);
+		if (!dport) {
+			guid = osm_node_get_node_guid(osm_dport->p_node);
+			OSM_LOG(log, OSM_LOG_INFO,
+				"Error: osm_dport (GUID 0x%04llx) "
+				"not in our fabric description\n",
+				ntohllu(guid));
+			goto out;
+		}
+	}
+	/*
+	 * We're only supposed to be called for CA ports, and maybe
+	 * switch management ports.
+	 */
+	if (sport->type != SRCSINK) {
+		guid = osm_node_get_node_guid(osm_sport->p_node);
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Error: osm_sport (GUID 0x%04llx) "
+			"not a data src/sink port\n", ntohllu(guid));
+		goto out;
+	}
+	if (dport->type != SRCSINK) {
+		guid = osm_node_get_node_guid(osm_dport->p_node);
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Error: osm_dport (GUID 0x%04llx) "
+			"not a data src/sink port\n", ntohllu(guid));
+		goto out;
+	}
+	/*
+	 * By definition, a CA port is connected to end[1] of a link, and
+	 * the switch port is end[0].  See build_ca_link() and link_srcsink().
+	 */
+	if (sport->link) {
+		ssw = sport->link->end[0].sw;
+		sp = sport->link->end[0].port;
+	} else {
+		ssw = sport->sw;
+		sp = sport->port;
+	}
+	if (dport->link)
+		dsw = dport->link->end[0].sw;
+	else
+		dsw = dport->sw;
+
+	t = ssw->torus;
+
+	sl  = sl_set_use_loop_vl(use_vl1(ssw->i, dsw->i, t->x_sz), 0);
+	sl |= sl_set_use_loop_vl(use_vl1(ssw->j, dsw->j, t->y_sz), 1);
+	sl |= sl_set_use_loop_vl(use_vl1(ssw->k, dsw->k, t->z_sz), 2);
+	sl |= sl_set_qos(sl_get_qos(path_sl_hint));
+out:
+	return sl;
+}
+
+static
+int torus_build_lfts(void *context)
+{
+	int status = -1;
+	struct torus_context *ctx = context;
+	struct fabric *fabric;
+	struct torus *torus;
+
+	fabric = &ctx->fabric;
+	teardown_fabric(fabric);
+
+	torus = calloc(1, sizeof(*torus));
+	if (!torus) {
+		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+			"Error: allocating torus: %s\n", strerror(errno));
+		goto out;
+	}
+	torus->osm = ctx->osm;
+	fabric->osm = ctx->osm;
+
+	if (!parse_config(OPENSM_CONFIG_DIR "/opensm-torus.conf",
+			  fabric, torus))
+		goto out;
+
+	if (!capture_fabric(fabric))
+		goto out;
+
+	OSM_LOG(&torus->osm->log, OSM_LOG_INFO,
+		"Found fabric w/ %d links, %d switches, %d CA ports, "
+		"minimum %d data VLs\n",
+		(int)fabric->link_cnt, (int)fabric->switch_cnt,
+		(int)fabric->ca_cnt, (int)ctx->osm->subn.min_data_vls);
+
+	if (!verify_setup(torus, fabric))
+		goto out;
+
+	OSM_LOG(&torus->osm->log, OSM_LOG_INFO,
+		"Looking for %d x %d x %d %s\n",
+		(int)torus->x_sz, (int)torus->y_sz, (int)torus->z_sz,
+		(ALL_MESH(torus->flags) ? "mesh" : "torus"));
+
+	build_torus(fabric, torus);
+
+	OSM_LOG(&torus->osm->log, OSM_LOG_INFO,
+		"Built %d x %d x %d %s w/ %d links, %d switches, %d CA ports\n",
+		(int)torus->x_sz, (int)torus->y_sz, (int)torus->z_sz,
+		(ALL_MESH(torus->flags) ? "mesh" : "torus"),
+		(int)torus->link_cnt, (int)torus->switch_cnt,
+		(int)torus->ca_cnt);
+
+	diagnose_fabric(fabric);
+	/*
+	 * Since we found some sort of torus fabric, report on any topology
+	 * changes vs. the last torus we found.
+	 */
+	if (torus->flags & NOTIFY_CHANGES)
+		report_torus_changes(torus, ctx->torus);
+
+	if (routable_torus(torus, fabric))
+		status = route_torus(torus);
+
+out:
+	if (status) {		/* bad torus!! */
+		if (torus)
+			teardown_torus(torus);
+	} else {
+		if (ctx->torus)
+			teardown_torus(ctx->torus);
+		ctx->torus = torus;
+	}
+	teardown_fabric(fabric);
+	return status;
+}
+
+int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
+			      osm_opensm_t *osm)
+{
+	struct torus_context *ctx;
+
+	ctx = torus_context_create(osm);
+
+	r->context = ctx;
+	r->ucast_build_fwd_tables = torus_build_lfts;
+	r->update_sl2vl = torus_update_osm_sl2vl;
+	r->path_sl = torus_path_sl;
+	r->mcast_build_stree = torus_mcast_stree;
+	r->delete = torus_context_delete;
+	return 0;
+}
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
