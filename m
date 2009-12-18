From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 10/12] opensm: Implement master spanning tree for
 torus-2QoS multicast support.
Date: Fri, 18 Dec 2009 13:50:59 -0700
Message-ID: <1261169461-2516-10-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to route a 2D/3D torus without credit loops while providing
support for two QoS levels, torus-2QoS needs to use 3 VL bits and
all 4 available SL bits.  This means that multicast traffic must
share SL values with unicast traffic, which in turn means that
multicast routing must be compatible with unicast routing to prevent
credit loops.

Torus-2QoS unicast routing is based on DOR, and it turns out to
be possible to construct spanning trees so that when multicast
and unicast traffic are overlaid, credit loops are not possible.

Here is a 2D example of such a spanning tree, where "x" is the
root switch, and each "+" is a non-root switch:

   +  +  +  +  +
   |  |  |  |  |
   +  +  +  +  +
   |  |  |  |  |
   +--+--x--+--+
   |  |  |  |  |
   +  +  +  +  +

For multicast traffic routed from root to tip, every turn in the
above spanning tree is a legal DOR turn.

For traffic routed from tip to root, and traffic routed through
the root, turns are not legal DOR turns.  However, to construct
a credit loop, the union of multicast routing on this spanning
tree with DOR unicast routing can only provide 3 of the 4 turns
needed for the loop.

In addition, if none of the above spanning tree branches crosses
a dateline used for unicast credit loop avoidance on a torus,
and multicast traffic is confined to SL 0 or SL 8 (recall that
torus-2QoS uses SL bit 3 to differentiate QoS level), then
multicast traffic also cannot contribute to the "ring" credit
loops that are otherwise possible in a torus.

Torus-2QoS uses these ideas to create a master spanning tree.
Every multicast group spanning tree will be constructed as a
subset of the master tree, with the same root as the master
tree.

Such multicast group spanning trees will in general not be
optimal for groups which are a subset of the full fabric.
However, this compromise must be made to enable support for
two QoS levels on a torus while preventing credit loops.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |  267 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 267 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 61e0bf3..082fcf5 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -154,6 +154,19 @@ struct link {
  * type.  Furthermore, if that type is PASSTHRU, then the connected links:
  *   1) are parallel to a given coordinate direction
  *   2) share the same two switches as endpoints.
+ *
+ * Torus-2QoS uses one master spanning tree for multicast, of which every
+ * multicast group spanning tree is a subtree.  to_stree_root is a pointer
+ * to the next port_grp on the path to the master spanning tree root.
+ * to_stree_tip is a pointer to the next port_grp on the path to a master
+ * spanning tree branch tip.
+ *
+ * Each t_switch can have at most one port_grp with a non-NULL to_stree_root.
+ * Exactly one t_switch in the fabric will have all port_grp objects with
+ * to_stree_root NULL; it is the master spanning tree root.
+ *
+ * A t_switch with all port_grp objects where to_stree_tip is NULL is at a
+ * master spanning tree branch tip.
  */
 struct port_grp {
 	enum endpt_type type;
@@ -163,6 +176,8 @@ struct port_grp {
 	unsigned sw_dlid_cnt;	/* switch dlids routed through this group */
 	unsigned ca_dlid_cnt;	/* CA dlids routed through this group */
 	struct t_switch *sw;	/* what switch we're attached to */
+	struct port_grp *to_stree_root;
+	struct port_grp *to_stree_tip;
 	struct endpoint **port;
 };
 
@@ -8499,6 +8514,256 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 	return success;
 }
 
+static
+bool good_xy_ring(struct torus *t, int x, int y, int z)
+{
+	struct t_switch ****sw = t->sw;
+	bool good_ring = true;
+
+	for (x = 0; x < t->x_sz && good_ring; x++)
+		good_ring = sw[x][y][z];
+
+	for (y = 0; y < t->y_sz && good_ring; y++)
+		good_ring = sw[x][y][z];
+
+	return good_ring;
+}
+
+static
+struct t_switch *find_plane_mid(struct torus *t, int z)
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
 int route_torus(struct torus *t)
 {
 	int s;
@@ -8507,6 +8772,8 @@ int route_torus(struct torus *t)
 	for (s = 0; s < (int)t->switch_cnt; s++)
 		success = torus_lft(t, t->sw_pool[s]) && success;
 
+	success = success && torus_master_stree(t);
+
 	return success ? 0 : -1;
 }
 
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
