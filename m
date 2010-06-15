From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v3 01/17] opensm: Prepare for routing engine input to
 path record SL lookup and SL2VL map setup.
Date: Tue, 15 Jun 2010 13:53:08 -0600
Message-ID: <1276631604-29230-2-git-send-email-jaschut@sandia.gov>
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

In the event a routing engine needs to participate in SL assignment and
SL2VL map setup in order to avoid credit loops in a fabric, it will be
useful to make the routing engine context more widely available.

To this end, have osm_opensm_t save a pointer to the routing engine used,
rather than its type.  This will make the routing engine context easily
available in, e.g., sl2vl_update() and pr_rcv_get_path_parms().

Make the necessary adjustments to the code that used the old
routing_engine_used as an enum _osm_routing_engine_type.  In order to
keep the behavior where minhop was used if the configured routing engines
failed, the easiest solution was to add a pointer to osm_opensm_t which
pointed to the minhop struct osm_routing_engine.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h |    4 ++-
 opensm/opensm/osm_console.c        |   10 ++++++--
 opensm/opensm/osm_dump.c           |    3 +-
 opensm/opensm/osm_link_mgr.c       |    5 ++-
 opensm/opensm/osm_opensm.c         |   43 +++++++++++++++++++++---------------
 opensm/opensm/osm_sa_path_record.c |    3 +-
 opensm/opensm/osm_ucast_lash.c     |    3 +-
 opensm/opensm/osm_ucast_mgr.c      |   17 ++++++++------
 8 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index c6c9bdb..e97142e 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -120,6 +120,7 @@ typedef enum _osm_routing_engine_type {
 *	added later.
 */
 struct osm_routing_engine {
+	osm_routing_engine_type_t type;
 	const char *name;
 	void *context;
 	int (*build_lid_matrices) (void *context);
@@ -183,7 +184,8 @@ typedef struct osm_opensm {
 	cl_dispatcher_t disp;
 	cl_plock_t lock;
 	struct osm_routing_engine *routing_engine_list;
-	osm_routing_engine_type_t routing_engine_used;
+	struct osm_routing_engine *routing_engine_used;
+	struct osm_routing_engine *default_routing_engine;
 	osm_stats_t stats;
 	osm_console_t console;
 	nn_map_t *node_name_map;
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index bc7bea3..b99bb84 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -382,6 +382,8 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 	cl_list_item_t *item;
 
 	if (out) {
+		const char *re_str;
+
 		cl_plock_acquire(&p_osm->lock);
 		fprintf(out, "   OpenSM Version       : %s\n", p_osm->osm_version);
 		fprintf(out, "   SM State             : %s\n",
@@ -390,9 +392,11 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 			p_osm->subn.opt.sm_priority);
 		fprintf(out, "   SA State             : %s\n",
 			sa_state_str(p_osm->sa.state));
-		fprintf(out, "   Routing Engine       : %s\n",
-			osm_routing_engine_type_str(p_osm->
-						    routing_engine_used));
+
+		re_str = p_osm->routing_engine_used ?
+			osm_routing_engine_type_str(p_osm->routing_engine_used->type) :
+			osm_routing_engine_type_str(OSM_ROUTING_ENGINE_TYPE_NONE);
+		fprintf(out, "   Routing Engine       : %s\n", re_str);
 
 		fprintf(out, "   Loaded event plugins :");
 		if (cl_qlist_head(&p_osm->plugin_list) ==
diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index fe2c3bc..bfff1a0 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -135,7 +135,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 		"Switch 0x%016" PRIx64 "\nLID    : Port : Hops : Optimal\n",
 		cl_ntoh64(osm_node_get_node_guid(p_node)));
 
-	dor = (p_osm->routing_engine_used == OSM_ROUTING_ENGINE_TYPE_DOR);
+	dor = (p_osm->routing_engine_used &&
+	       p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_DOR);
 
 	for (lid_ho = 1; lid_ho <= max_lid_ho; lid_ho++) {
 		fprintf(file, "0x%04X : ", lid_ho);
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index e6c9b3b..c309916 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -64,8 +64,9 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	if (p_osm->routing_engine_used != OSM_ROUTING_ENGINE_TYPE_LASH
-	    || !(slid = osm_physp_get_base_lid(p_physp))) {
+	if (!(p_osm->routing_engine_used &&
+	      p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH &&
+	      (slid = osm_physp_get_base_lid(p_physp)))) {
 		/* Use default SL if lash routing is not used */
 		OSM_LOG_EXIT(sm->p_log);
 		return sm->p_subn->opt.sm_sl;
diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
index d3dc02e..5614240 100644
--- a/opensm/opensm/osm_opensm.c
+++ b/opensm/opensm/osm_opensm.c
@@ -147,7 +147,8 @@ static void append_routing_engine(osm_opensm_t *osm,
 	r->next = routing_engine;
 }
 
-static void setup_routing_engine(osm_opensm_t *osm, const char *name)
+static struct osm_routing_engine *setup_routing_engine(osm_opensm_t *osm,
+						       const char *name)
 {
 	struct osm_routing_engine *re;
 	const struct routing_engine_module *m;
@@ -158,47 +159,53 @@ static void setup_routing_engine(osm_opensm_t *osm, const char *name)
 			if (!re) {
 				OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
 					"memory allocation failed\n");
-				return;
+				return NULL;
 			}
 			memset(re, 0, sizeof(struct osm_routing_engine));
 
 			re->name = m->name;
+			re->type = osm_routing_engine_type(m->name);
 			if (m->setup(re, osm)) {
 				OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
 					"setup of routing"
 					" engine \'%s\' failed\n", name);
-				return;
+				free(re);
+				return NULL;
 			}
 			OSM_LOG(&osm->log, OSM_LOG_DEBUG,
 				"\'%s\' routing engine set up\n", re->name);
-			append_routing_engine(osm, re);
-			return;
+			if (re->type == OSM_ROUTING_ENGINE_TYPE_MINHOP)
+				osm->default_routing_engine = re;
+			return re;
 		}
 	}
 
 	OSM_LOG(&osm->log, OSM_LOG_ERROR,
 		"cannot find or setup routing engine \'%s\'\n", name);
+	return NULL;
 }
 
 static void setup_routing_engines(osm_opensm_t *osm, const char *engine_names)
 {
 	char *name, *str, *p;
+	struct osm_routing_engine *re;
 
-	if (!engine_names || !*engine_names) {
-		setup_routing_engine(osm, "minhop");
-		return;
+	if (engine_names && *engine_names) {
+		str = strdup(engine_names);
+		name = strtok_r(str, ", \t\n", &p);
+		while (name && *name) {
+			re = setup_routing_engine(osm, name);
+			if (re)
+				append_routing_engine(osm, re);
+			name = strtok_r(NULL, ", \t\n", &p);
+		}
+		free(str);
 	}
-
-	str = strdup(engine_names);
-	name = strtok_r(str, ", \t\n", &p);
-	while (name && *name) {
-		setup_routing_engine(osm, name);
-		name = strtok_r(NULL, ", \t\n", &p);
+	if (!osm->default_routing_engine) {
+		re = setup_routing_engine(osm, "minhop");
+		if (!osm->routing_engine_list && re)
+			append_routing_engine(osm, re);
 	}
-	free(str);
-
-	if (!osm->routing_engine_list)
-		setup_routing_engine(osm, "minhop");
 }
 
 void osm_opensm_construct(IN osm_opensm_t * p_osm)
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index f0d7ca2..093c70d 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -667,7 +667,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 * Set PathRecord SL
 	 */
 
-	is_lash = (p_osm->routing_engine_used == OSM_ROUTING_ENGINE_TYPE_LASH);
+	is_lash = (p_osm->routing_engine_used &&
+		   p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH);
 
 	if (comp_mask & IB_PR_COMPMASK_SL) {
 		/*
diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index 4669946..72c4c3d 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -1284,7 +1284,8 @@ uint8_t osm_get_lash_sl(osm_opensm_t * p_osm, const osm_port_t * p_src_port,
 	unsigned src_id;
 	osm_switch_t *p_sw;
 
-	if (p_osm->routing_engine_used != OSM_ROUTING_ENGINE_TYPE_LASH)
+	if (!(p_osm->routing_engine_used &&
+	      p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH))
 		return OSM_DEFAULT_SL;
 
 	p_sw = get_osm_switch_from_port(p_dst_port);
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 37b8741..10629cb 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -1056,7 +1056,7 @@ static int ucast_mgr_route(struct osm_routing_engine *r, osm_opensm_t * osm)
 		return ret;
 	}
 
-	osm->routing_engine_used = osm_routing_engine_type(r->name);
+	osm->routing_engine_used = r;
 
 	osm_ucast_mgr_set_fwd_tables(&osm->sm.ucast_mgr);
 
@@ -1084,24 +1084,27 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	    ucast_mgr_setup_all_switches(p_mgr->p_subn) < 0)
 		goto Exit;
 
-	p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_NONE;
+	p_osm->routing_engine_used = NULL;
 	while (p_routing_eng) {
 		if (!ucast_mgr_route(p_routing_eng, p_osm))
 			break;
 		p_routing_eng = p_routing_eng->next;
 	}
 
-	if (p_osm->routing_engine_used == OSM_ROUTING_ENGINE_TYPE_NONE) {
+	if (!p_osm->routing_engine_used) {
 		/* If configured routing algorithm failed, use default MinHop */
-		osm_ucast_mgr_build_lid_matrices(p_mgr);
-		ucast_mgr_build_lfts(p_mgr);
+		struct osm_routing_engine *r = p_osm->default_routing_engine;
+
+		r->build_lid_matrices(r->context);
+		r->ucast_build_fwd_tables(r->context);
+		p_osm->routing_engine_used = r;
 		osm_ucast_mgr_set_fwd_tables(p_mgr);
-		p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_MINHOP;
 	}
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 		"%s tables configured on all switches\n",
-		osm_routing_engine_type_str(p_osm->routing_engine_used));
+		osm_routing_engine_type_str(p_osm->
+					    routing_engine_used->type));
 
 	if (p_mgr->p_subn->opt.use_ucast_cache)
 		p_mgr->cache_valid = TRUE;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
