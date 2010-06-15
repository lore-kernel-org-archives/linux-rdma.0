From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v3 13/17] opensm: Do not require -Q option for
 torus-2QoS routing engine.
Date: Tue, 15 Jun 2010 13:53:20 -0600
Message-ID: <1276631604-29230-14-git-send-email-jaschut@sandia.gov>
References: <1276631604-29230-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276631604-29230-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
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

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c    |    7 +++++--
 opensm/opensm/osm_subnet.c |   18 +++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index dadef29..6d2af55 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -290,7 +290,9 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	osm_node_t *p_node;
 	int ret = 0;
 
-	if (!p_osm->subn.opt.qos)
+	if (!(p_osm->subn.opt.qos ||
+	      (p_osm->routing_engine_used &&
+	       p_osm->routing_engine_used->update_sl2vl)))
 		return 0;
 
 	OSM_LOG_ENTER(&p_osm->log);
@@ -307,7 +309,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	cl_plock_excl_acquire(&p_osm->lock);
 
 	/* read QoS policy config file */
-	osm_qos_parse_policy_file(&p_osm->subn);
+	if (p_osm->subn.opt.qos)
+		osm_qos_parse_policy_file(&p_osm->subn);
 
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index bc34a0f..f714af7 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1051,6 +1051,8 @@ static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix,
 
 int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 {
+	osm_qos_options_t dflt;
+
 	if (p_opts->lmc > 7) {
 		log_report(" Invalid Cached Option Value:lmc = %u:"
 			   "Using Default:%u\n", p_opts->lmc, OSM_DEFAULT_LMC);
@@ -1101,17 +1103,15 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
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
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
