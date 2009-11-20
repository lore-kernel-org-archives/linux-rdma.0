From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 08/11] opensm: Do not require -Q option for torus-2QoS
 routing engine.
Date: Fri, 20 Nov 2009 12:15:06 -0700
Message-ID: <1258744509-11148-8-git-send-email-jaschut@sandia.gov>
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

The torus-2QoS engine provides a deadlock-free routing for a 2D/3D torus,
but requires that switch SL2VL maps be programmed.  Before this change,
"opensm -Q" was required for that to happen.

When a routing engine sets the struct osm_routing_engine:update_sl2vl
pointer, it is signalling its intent to participate in SL2VL map programming.
So, don't return early from osm_qos_setup() in that case; instead do everything
except attempt to read QoS configuration information.

For that to work properly, need to also always set up the default QoS config
information, instead of just when QoS is requested via -Q.

With that in place, the -Q option now means the same thing to torus-2QoS that
it means to other routing engines: QoS configuration is requested.

Otherwise, torus-2QoS can confine its unicast traffic to SLs 8-15, leaving
SL 0 free, e.g. for multicast.  This is useful until such time as
torus-2QoS can be extended to implement a spanning tree for multicast that
will not deadlock against the routing used for unicast.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c         |    7 +++++--
 opensm/opensm/osm_subnet.c      |   18 +++++++++---------
 opensm/opensm/osm_ucast_torus.c |   24 +++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index f42c334..0f0b24f 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -288,7 +288,9 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	int ret = 0;
 	uint8_t i;
 
-	if (!p_osm->subn.opt.qos)
+	if (!(p_osm->subn.opt.qos ||
+	      (p_osm->routing_engine_used &&
+	       p_osm->routing_engine_used->update_sl2vl)))
 		return 0;
 
 	OSM_LOG_ENTER(&p_osm->log);
@@ -305,7 +307,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	cl_plock_excl_acquire(&p_osm->lock);
 
 	/* read QoS policy config file */
-	osm_qos_parse_policy_file(&p_osm->subn);
+	if (p_osm->subn.opt.qos)
+		osm_qos_parse_policy_file(&p_osm->subn);
 
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index c9bb20c..cc81545 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1044,6 +1044,8 @@ static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix,
 
 int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 {
+	osm_qos_options_t dflt;
+
 	if (p_opts->lmc > 7) {
 		log_report(" Invalid Cached Option Value:lmc = %u:"
 			   "Using Default:%u\n", p_opts->lmc, OSM_DEFAULT_LMC);
@@ -1087,17 +1089,15 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->console = OSM_DEFAULT_CONSOLE;
 	}
 
-	if (p_opts->qos) {
-		osm_qos_options_t dflt;
-
-		/* the default options in qos_options must be correct.
-		 * every other one need not be, b/c those will default
-		 * back to whatever is in qos_options.
-		 */
 
-		subn_set_default_qos_options(&dflt);
+	/* the default options in qos_options must be correct.
+	 * every other one need not be, b/c those will default
+	 * back to whatever is in qos_options.
+	 */
+	subn_set_default_qos_options(&dflt);
+	subn_verify_qos_set(&p_opts->qos_options, "qos", &dflt);
 
-		subn_verify_qos_set(&p_opts->qos_options, "qos", &dflt);
+	if (p_opts->qos) {
 		subn_verify_qos_set(&p_opts->qos_ca_options, "qos_ca",
 				    &p_opts->qos_options);
 		subn_verify_qos_set(&p_opts->qos_sw0_options, "qos_sw0",
diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 6fff73e..8eb2880 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -298,6 +298,7 @@ struct torus {
 #define Z_MESH (1U << 2)
 #define MSG_DEADLOCK (1U << 29)
 #define NOTIFY_CHANGES (1U << 30)
+#define QOS_ENABLED (1U << 31)
 
 #define ALL_MESH(flags) \
 	((flags & (X_MESH | Y_MESH | Z_MESH)) == (X_MESH | Y_MESH | Z_MESH))
@@ -8548,7 +8549,25 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	sl  = sl_set_use_loop_vl(use_vl1(ssw->i, dsw->i, t->x_sz), 0);
 	sl |= sl_set_use_loop_vl(use_vl1(ssw->j, dsw->j, t->y_sz), 1);
 	sl |= sl_set_use_loop_vl(use_vl1(ssw->k, dsw->k, t->z_sz), 2);
-	sl |= sl_set_qos(sl_get_qos(path_sl_hint));
+
+	/*
+	 * If QoS was not requested by user, force path SLs into 8-15 range.
+	 * This leaves SL 0 available for multicast, and SL2VL mappings
+	 * will keep multicast traffic from deadlocking with unicast traffic.
+	 *
+	 * However, multicast might still deadlock against itself if multiple
+	 * multicast groups each use their own spanning tree.
+	 *
+	 * FIXME: it is possible to construct a spanning tree that can
+	 * overlay the DOR routing used for unicast in a way that multicast
+	 * and unicast can share VLs but cannot deadlock against each other.
+	 * Need to implement that and cause it to be used whenever the
+	 * torus-2QoS routing engine is used.
+	 */
+	if (t->flags & QOS_ENABLED)
+		sl |= sl_set_qos(sl_get_qos(path_sl_hint));
+	else
+		sl |= sl_set_qos(1);
 out:
 	return sl;
 }
@@ -8570,6 +8589,9 @@ int torus_build_lfts(void *context)
 			"Error: allocating torus: %s\n", strerror(errno));
 		goto out;
 	}
+	if (ctx->osm->subn.opt.qos)
+		torus->flags |= QOS_ENABLED;
+
 	torus->osm = ctx->osm;
 	fabric->osm = ctx->osm;
 
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
