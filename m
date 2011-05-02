From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv2] OpenSM torus routing order list
Date: Mon, 2 May 2011 18:41:31 +0300
Message-ID: <20110502154131.GF2088@calypso.voltaire.com>
References: <20110321095823.GA22502@calypso.voltaire.com>
 <1300746824.7744.71.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1300746824.7744.71.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enables to define list of switch ports so the SM will
go over this list when creating a routing.
It helps balancing links load on some communication patterns
where multipile links connect between the switches.

Signed-off-by: David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Added detailed description in man/torus-2QoS.conf.5.in
Added error messages on configuration file parsing
Fixed some styling
---
 man/torus-2QoS.conf.5.in |   26 ++++++++++++++-
 opensm/osm_torus.c       |   76 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 97 insertions(+), 5 deletions(-)

diff --git a/man/torus-2QoS.conf.5.in b/man/torus-2QoS.conf.5.in
index 147a7b1..df38ad3 100644
--- a/man/torus-2QoS.conf.5.in
+++ b/man/torus-2QoS.conf.5.in
@@ -62,7 +62,7 @@ see \fBUNICAST ROUTING\fR in torus-2QoS(8).
 \fIsw0_GUID sw1_GUID
 \fR
 .RS
-These keywords are used to seed the torus/mesh topolgy.
+These keywords are used to seed the torus/mesh topology.
 For example, "xp_link 0x2000 0x2001" specifies that a link from
 the switch with node GUID 0x2000 to the switch with node GUID 0x2001
 would point in the positive x direction,
@@ -78,7 +78,7 @@ for torus dimensions of radix four (see \fBTOPOLOGY DISCOVERY\fR in
 torus-2QoS(8)).  For such cases both the positive and negative coordinate
 directions must be specified.
 .P
-Based on the topology specifed via the \fBtorus\fR/\fBmesh\fR keyword,
+Based on the topology specified via the \fBtorus\fR/\fBmesh\fR keyword,
 torus-2QoS will detect and log when it has insufficient seed configuration.
 .RE
 .
@@ -140,6 +140,24 @@ parameter needs to be increased.
 If this keyword appears multiple times, the last instance prevails.
 .RE
 .
+.P
+\fBport_order
+\fIp1 p2 p3 ...
+\fR
+.RS
+This keyword specifies the order in which CA ports on a destination switch
+are visited when computing routes. When the fabric contains switches connected
+with multiple parallel links, routes are distributed in a round-robin fashion
+across such links, and so changing the order that CA ports are visited changes
+the distribution of routes across such links.  This may be advantageous for
+some specific traffic patterns.
+.P
+The default is to visit CA ports in increasing port
+order on destination switches.
+.P
+Duplicate values in the list will be ignored.
+.RE
+.
 .SH EXAMPLE
 .
 \f(RC
@@ -171,6 +189,10 @@ z_dateline -1  # back to its original position.
 # on a host attached to a switch from the second seed.
 # Both instances should use this torus-2QoS.conf to ensure
 # path SL values do not change in the event of SM failover.
+
+# port_order defines the order on which the ports would be
+# chosen for routing.
+port_order 7 10 8 11 9 12 25 28 26 29 27 30
 .fi
 \fR
 .
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index add3cf9..cd3d490 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -59,6 +59,8 @@
 #define PORTGRP_MAX_PORTS    16
 #define SWITCH_MAX_PORTGRPS  (1 + 2 * TORUS_MAX_DIM)
 
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
 typedef ib_net64_t guid_t;
 
 /*
@@ -287,6 +289,8 @@ struct torus {
 	unsigned seed_cnt, seed_idx;
 	unsigned x_sz, y_sz, z_sz;
 
+	unsigned port_order[IB_NODE_NUM_PORTS_MAX+1];
+
 	unsigned sw_pool_sz;
 	unsigned link_pool_sz;
 	unsigned seed_sz;
@@ -844,6 +848,56 @@ out:
 }
 
 static
+bool parse_port(unsigned *pnum, const char *parse_sep)
+{
+	char *val, *nextchar;
+
+	val = strtok(NULL, parse_sep);
+	if (!val)
+		return false;
+	*pnum = strtoul(val, &nextchar, 0);
+	if (*pnum > IB_NODE_NUM_PORTS_MAX) {
+		*pnum = 0;
+	}
+	return true;
+}
+
+static
+bool parse_port_order(struct torus *t, const char *parse_sep)
+{
+	unsigned i, j, k, n;
+
+	for (i = 0; i < ARRAY_SIZE(t->port_order); i++) {
+		if (!parse_port(&(t->port_order[i]), parse_sep)) {
+			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+				"Error: cannot parse port_order");
+			break;
+		}
+		for (j = 0; j < i; j++) {
+			if (t->port_order[j] == t->port_order[i]) {
+				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
+					"Error: ignoring duplicate port %u in "
+					" port_order parsing\n",
+					t->port_order[j]);
+				i--;	/* Ignore duplicate port number */
+				break;
+			}
+		}
+	}
+
+	n = i;
+	for (j = 0; j < ARRAY_SIZE(t->port_order); j++) {
+		for (k = 0; k < i; k++)
+			if (t->port_order[k] == j)
+				break;
+		if (k >= i)
+			t->port_order[n++] = j;
+	}
+
+	return true;
+}
+
+static
 bool parse_pg_max_ports(struct torus *t, const char *parse_sep)
 {
 	char *val, *nextchar;
@@ -982,6 +1036,7 @@ static
 bool parse_config(const char *fn, struct fabric *f, struct torus *t)
 {
 	FILE *fp;
+	unsigned i;
 	char *keyword;
 	char *line_buf = NULL;
 	const char *parse_sep = " \n\t\015";
@@ -993,6 +1048,9 @@ bool parse_config(const char *fn, struct fabric *f, struct torus *t)
 	if (!grow_seed_array(t, 2))
 		return false;
 
+	for (i = 0; i < ARRAY_SIZE(t->port_order); i++)
+		t->port_order[i] = i;
+
 	fp = fopen(fn, "r");
 	if (!fp) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
@@ -1018,6 +1076,8 @@ next_line:
 	} else if (strcmp("mesh", keyword) == 0) {
 		t->flags |= X_MESH | Y_MESH | Z_MESH;
 		kw_success = parse_torus(t, parse_sep);
+	} else if (strcmp("port_order", keyword) == 0) {
+		kw_success = parse_port_order(t, parse_sep);
 	} else if (strcmp("next_seed", keyword) == 0) {
 		kw_success = grow_seed_array(t, 1);
 		t->seed_cnt++;
@@ -8424,6 +8484,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 	struct port_grp *pgrp;
 	struct t_switch *dsw;
 	osm_switch_t *osm_sw;
+	unsigned order[IB_NODE_NUM_PORTS_MAX+1];
 
 	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
@@ -8439,13 +8500,22 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 		dsw = t->sw_pool[s];
 		pgrp = &dsw->ptgrp[2 * TORUS_MAX_DIM];
 
-		for (p = 0; p < pgrp->port_cnt; p++) {
+		memset(order, IB_INVALID_PORT_NUM, sizeof(order));
+		for (p = 0; p < pgrp->port_cnt; p++)
+			order[pgrp->port[p]->port] = p;
+
+		for (p = 0; p < ARRAY_SIZE(order); p++) {
+
+			unsigned px = order[t->port_order[p]];
+
+			if (px == IB_INVALID_PORT_NUM)
+				continue;
 
-			if (!get_lid(pgrp, p, &dlid_base, &dlid_lmc, &ca))
+			if (!get_lid(pgrp, px, &dlid_base, &dlid_lmc, &ca))
 				return false;
 
 			if (sw->n_id == dsw->n_id)
-				dp = pgrp->port[p]->port;
+				dp = pgrp->port[px]->port;
 			else
 				dp = lft_port(t, sw, dsw, true, ca);
 			/*
-- 
1.7.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
