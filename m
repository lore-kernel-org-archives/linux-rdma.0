From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 2/5] Move no_fallback_routing_engine from
	osm_subn_opt_t to osm_opensm_t.
Date: Mon, 14 Nov 2011 14:50:43 -0800
Message-ID: <1321311043.5518.51.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

no_fallback_routing_engine is a convenience flag and not a configurable
option, so it should not be in osm_subn_opt_t.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_opensm.h |    4 ++++
 include/opensm/osm_subnet.h |    1 -
 opensm/osm_opensm.c         |    4 +++-
 opensm/osm_ucast_mgr.c      |    2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 3ebf533..78237bc 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -212,6 +212,7 @@ typedef struct osm_opensm {
 	struct osm_routing_engine *routing_engine_list;
 	struct osm_routing_engine *routing_engine_used;
 	struct osm_routing_engine *default_routing_engine;
+	boolean_t no_fallback_routing_engine;
 	osm_stats_t stats;
 	osm_console_t console;
 	nn_map_t *node_name_map;
@@ -259,6 +260,9 @@ typedef struct osm_opensm {
 *	routing_engine_used
 *		Indicates which routing engine was used to route a subnet.
 *
+*	no_fallback_routing_engine
+*		Indicates if default routing engine should not be used.
+*
 *	stats
 *		Open SM statistics block
 *
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 2e88479..90eae8b 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -224,7 +224,6 @@ typedef struct osm_subn_opt {
 	osm_qos_options_t qos_rtr_options;
 	boolean_t enable_quirks;
 	boolean_t no_clients_rereg;
-	boolean_t no_fallback_routing_engine;
 #ifdef ENABLE_OSM_PERF_MGR
 	boolean_t perfmgr;
 	boolean_t perfmgr_redir;
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 1784388..61aeb7e 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -166,7 +166,7 @@ static struct osm_routing_engine *setup_routing_engine(osm_opensm_t *osm,
 	const struct routing_engine_module *m;
 
 	if (!strcmp(name, "no_fallback")) {
-		osm->subn.opt.no_fallback_routing_engine = TRUE;
+		osm->no_fallback_routing_engine = TRUE;
 		return NULL;
 	}
 
@@ -448,6 +448,8 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 		goto Exit;
 #endif				/* ENABLE_OSM_PERF_MGR */
 
+	p_osm->no_fallback_routing_engine = FALSE;
+
 	setup_routing_engines(p_osm, p_opt->routing_engine_names);
 
 	p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_NONE;
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 1b17d68..b850009 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1103,7 +1103,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	}
 
 	if (!p_osm->routing_engine_used &&
-	    p_osm->subn.opt.no_fallback_routing_engine != TRUE) {
+	    p_osm->no_fallback_routing_engine != TRUE) {
 		/* If configured routing algorithm failed, use default MinHop */
 		struct osm_routing_engine *r = p_osm->default_routing_engine;
 
-- 
1.7.1





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
