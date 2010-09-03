From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 15/18] opensm: Make it possible to configure no
 fallback routing engine.
Date: Fri,  3 Sep 2010 10:43:11 -0600
Message-ID: <1283532194-27112-16-git-send-email-jaschut@sandia.gov>
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

For a fabric that requires routing with an engine with special properties,
say avoiding credit loops via making use of SLs in routing, it might
be preferable to not fall back to minhop if the configured routing engine
fails.

E.g. the torus-2QoS routing engine uses both SL2VL maps and path SL values
to provide routing free of credit loops, but cannot route fabrics for
some patterns of failed switches.  Should a switch fail that creates such
a pattern, it may be preferable to keep the previous routing information
loaded in the switches until a switch can be replaced that restores
torus-2QoS's ability to route the fabric.

The alternative, having some other engine route the fabric, will immediately
introduce credit loops.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    1 +
 opensm/opensm/osm_opensm.c         |    5 +++++
 opensm/opensm/osm_qos.c            |    6 ++++++
 opensm/opensm/osm_ucast_mgr.c      |   23 +++++++++++++++--------
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index fa3e46e..42ae416 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -219,6 +219,7 @@ typedef struct osm_subn_opt {
 	osm_qos_options_t qos_rtr_options;
 	boolean_t enable_quirks;
 	boolean_t no_clients_rereg;
+	boolean_t no_fallback_routing_engine;
 #ifdef ENABLE_OSM_PERF_MGR
 	boolean_t perfmgr;
 	boolean_t perfmgr_redir;
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index a69b7bb..82aa987 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -159,6 +159,11 @@ static struct osm_routing_engine *setup_routing_engine(osm_opensm_t *osm,
 	struct osm_routing_engine *re;
 	const struct routing_engine_module *m;
 
+	if (!strcmp(name, "no_fallback")) {
+		osm->subn.opt.no_fallback_routing_engine = TRUE;
+		return NULL;
+	}
+
 	for (m = routing_modules; m->name && *m->name; m++) {
 		if (!strcmp(m->name, name)) {
 			re = malloc(sizeof(struct osm_routing_engine));
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 204c69c..ab55918 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -212,6 +212,12 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	unsigned in, out;
 	uint8_t op_vl1;
 
+	/*
+	 * Do nothing unless the most recent routing attempt was successful.
+	 */
+	if (!re)
+		return ret;
+
 	for (out = 1; out < num_ports; out++) {
 		p = osm_node_get_physp_ptr(node, out);
 		force_update = p->need_update || sm->p_subn->need_update;
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 10629cb..d1c485f 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -1091,7 +1091,8 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 		p_routing_eng = p_routing_eng->next;
 	}
 
-	if (!p_osm->routing_engine_used) {
+	if (!p_osm->routing_engine_used &&
+	    p_osm->subn.opt.no_fallback_routing_engine != TRUE) {
 		/* If configured routing algorithm failed, use default MinHop */
 		struct osm_routing_engine *r = p_osm->default_routing_engine;
 
@@ -1101,14 +1102,20 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 		osm_ucast_mgr_set_fwd_tables(p_mgr);
 	}
 
-	OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
-		"%s tables configured on all switches\n",
-		osm_routing_engine_type_str(p_osm->
-					    routing_engine_used->type));
-
-	if (p_mgr->p_subn->opt.use_ucast_cache)
-		p_mgr->cache_valid = TRUE;
+	if (p_osm->routing_engine_used) {
+		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
+			"%s tables configured on all switches\n",
+			osm_routing_engine_type_str(p_osm->
+						    routing_engine_used->type));
 
+		if (p_mgr->p_subn->opt.use_ucast_cache)
+			p_mgr->cache_valid = TRUE;
+	} else {
+		p_mgr->p_subn->subnet_initialization_error = TRUE;
+		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
+			"No routing engine able to successfully configure "
+			" switch tables on current fabric\n");
+	}
 Exit:
 	CL_PLOCK_RELEASE(p_mgr->p_lock);
 	OSM_LOG_EXIT(p_mgr->p_log);
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
