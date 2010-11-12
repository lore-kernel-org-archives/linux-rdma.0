From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 01/13] Revert
 "opensm: Do not require -Q option for torus-2QoS routing engine."
Date: Fri, 12 Nov 2010 15:11:10 -0700
Message-ID: <1289599882-15165-2-git-send-email-jaschut@sandia.gov>
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

This reverts commit b9691580e29c6a8cf1f45995988350c02826786d.

Since all other routing engines require -Q to cause SL2VL maps to
be programmed, torus-2QoS should do the same.

Of course, torus-2QoS requires SL2VL maps to be programmed for correct
routing, so a check for that will need to be added.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c    |    7 ++-----
 opensm/opensm/osm_subnet.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index ab55918..ba198a0 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -314,9 +314,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	int ret = 0;
 	int vlarb_only;
 
-	if (!(p_osm->subn.opt.qos ||
-	      (p_osm->routing_engine_used &&
-	       p_osm->routing_engine_used->update_sl2vl)))
+	if (!p_osm->subn.opt.qos)
 		return 0;
 
 	OSM_LOG_ENTER(&p_osm->log);
@@ -333,8 +331,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 	cl_plock_excl_acquire(&p_osm->lock);
 
 	/* read QoS policy config file */
-	if (p_osm->subn.opt.qos)
-		osm_qos_parse_policy_file(&p_osm->subn);
+	osm_qos_parse_policy_file(&p_osm->subn);
 
 	p_tbl = &p_osm->subn.port_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index f714af7..bc34a0f 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -1051,8 +1051,6 @@ static void subn_verify_qos_set(osm_qos_options_t *set, const char *prefix,
 
 int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 {
-	osm_qos_options_t dflt;
-
 	if (p_opts->lmc > 7) {
 		log_report(" Invalid Cached Option Value:lmc = %u:"
 			   "Using Default:%u\n", p_opts->lmc, OSM_DEFAULT_LMC);
@@ -1103,15 +1101,17 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		p_opts->console = OSM_DEFAULT_CONSOLE;
 	}
 
+	if (p_opts->qos) {
+		osm_qos_options_t dflt;
 
-	/* the default options in qos_options must be correct.
-	 * every other one need not be, b/c those will default
-	 * back to whatever is in qos_options.
-	 */
-	subn_set_default_qos_options(&dflt);
-	subn_verify_qos_set(&p_opts->qos_options, "qos", &dflt);
+		/* the default options in qos_options must be correct.
+		 * every other one need not be, b/c those will default
+		 * back to whatever is in qos_options.
+		 */
 
-	if (p_opts->qos) {
+		subn_set_default_qos_options(&dflt);
+
+		subn_verify_qos_set(&p_opts->qos_options, "qos", &dflt);
 		subn_verify_qos_set(&p_opts->qos_ca_options, "qos_ca",
 				    &p_opts->qos_options);
 		subn_verify_qos_set(&p_opts->qos_sw0_options, "qos_sw0",
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
