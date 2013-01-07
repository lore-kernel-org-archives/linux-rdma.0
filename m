From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] opensm/torus: Add configuration for max_changes to report
Date: Mon, 07 Jan 2013 14:50:31 -0500
Message-ID: <50EB2707.5020404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Rather than hard coded constant of 32 for max torus changes to
be reported, allow this to be configured with max_changes
parameter in torus conf file. Default for max_changes parameter
is same as hard coded constant (32).

Also, update torus conf documentation for this new parameter.

Reviewed-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/torus-2QoS.conf.5.in b/man/torus-2QoS.conf.5.in
index d806ab5..1ab0d2e 100644
--- a/man/torus-2QoS.conf.5.in
+++ b/man/torus-2QoS.conf.5.in
@@ -1,4 +1,4 @@
-.TH TORUS\-2QOS.CONF 5 "November 7, 2011" "OpenIB" "OpenIB Management"
+.TH TORUS\-2QOS.CONF 5 "January 4, 2013" "OpenIB" "OpenIB Management"
 .
 .SH NAME
 torus\-2QoS.conf \- Torus-2QoS configuration for OpenSM subnet manager
@@ -162,6 +162,15 @@ order on destination switches.
 Duplicate values in the list will be ignored.
 .RE
 .
+.P
+\fBmax_changes
+\fImax
+\fR
+.RS
+This keyword specifies the maximum number of torus changes reported.
+The default value is 32.
+.RE
+.
 .SH EXAMPLE
 .
 \f(RC
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 1d847b3..85ea9de 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -61,6 +61,7 @@
 #define TORUS_MAX_DIM        3
 #define PORTGRP_MAX_PORTS    16
 #define SWITCH_MAX_PORTGRPS  (1 + 2 * TORUS_MAX_DIM)
+#define DEFAULT_MAX_CHANGES  32
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
@@ -310,6 +311,7 @@ struct torus {
 	struct t_switch *master_stree_root;
 
 	unsigned flags;
+	unsigned max_changes;
 	int debug;
 };
 
@@ -1065,6 +1055,7 @@ bool parse_config(const char *fn, struct fabric *f, struct torus *t)
 	}
 	t->flags |= NOTIFY_CHANGES;
 	t->portgrp_sz = PORTGRP_MAX_PORTS;
+	t->max_changes = DEFAULT_MAX_CHANGES;
 
 next_line:
 	llen = getline(&line_buf, &line_buf_sz, fp);
@@ -1131,6 +1122,8 @@ next_line:
 		if (!t->seed_cnt)
 			t->seed_cnt++;
 		kw_success = parse_dir_dateline(3, t, parse_sep);
+	} else if (strcmp("max_changes", keyword) == 0) {
+		kw_success = parse_unsigned(&t->max_changes, parse_sep);
 	} else if (keyword[0] == '#')
 		goto next_line;
 	else {
@@ -7525,6 +7518,7 @@ void report_torus_changes(struct torus *nt, struct torus *ot)
 	unsigned x_sz = nt->x_sz;
 	unsigned y_sz = nt->y_sz;
 	unsigned z_sz = nt->z_sz;
+	unsigned max_changes = nt->max_changes;
 
 	if (!(nt && ot))
 		return;
@@ -7565,7 +7559,7 @@ void report_torus_changes(struct torus *nt, struct torus *ot)
 				 * We want to log changes to learn more about
 				 * bouncing links, etc, so they can be fixed.
 				 */
-				if (cnt > 32) {
+				if (cnt > max_changes) {
 					OSM_LOG(&nt->osm->log, OSM_LOG_INFO,
 						"Too many torus changes; "
 						"stopping reporting early\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
