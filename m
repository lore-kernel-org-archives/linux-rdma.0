From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] opensm: Changed sl_path API to include slid and dlid only
Date: Sat, 19 May 2012 22:47:09 +0300
Message-ID: <20120519194709.GC2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

src_port and dst_oprt are redundant.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_opensm.h |    3 +--
 opensm/osm_link_mgr.c       |    8 +-------
 opensm/osm_sa_path_record.c |    3 +--
 opensm/osm_torus.c          |   15 ++++++++++++---
 opensm/osm_ucast_dfsssp.c   |   13 +++++++++++--
 opensm/osm_ucast_lash.c     |   13 +++++++++++--
 6 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index b3b7353..9f2c2fa 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -135,8 +135,7 @@ struct osm_routing_engine {
 			     IN uint8_t in_port_num, IN uint8_t out_port_num,
 			     IN OUT ib_slvl_table_t *t);
 	uint8_t (*path_sl)(void *context, IN uint8_t path_sl_hint,
-			   IN const osm_port_t *src_port, IN const uint16_t slid,
-			   IN const osm_port_t *dst_port, IN const uint16_t dlid);
+			   IN const ib_net16_t slid, IN const ib_net16_t dlid);
 	ib_api_status_t (*mcast_build_stree)(void *context,
 					     IN OUT osm_mgrp_box_t *mgb);
 	void (*destroy) (void *context);
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 276dce2..a901023 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -59,7 +59,6 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
 	osm_opensm_t *p_osm = sm->p_subn->p_osm;
 	struct osm_routing_engine *re = p_osm->routing_engine_used;
-	const osm_port_t *p_sm_port, *p_src_port;
 	ib_net16_t slid;
 	ib_net16_t smlid;
 	uint8_t sl;
@@ -76,16 +75,11 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 		return sm->p_subn->opt.sm_sl;
 	}
 
-	/* Find osm_port of the SM itself = dest_port */
 	smlid = sm->p_subn->sm_base_lid;
-	p_sm_port = osm_get_port_by_lid(sm->p_subn, sm->p_subn->sm_base_lid);
-
-	/* Find osm_port of the source = p_physp */
-	p_src_port = osm_get_port_by_lid(sm->p_subn, slid);
 
 	/* Call into routing engine to find proper SL */
 	sl = re->path_sl(re->context, sm->p_subn->opt.sm_sl,
-			 p_src_port, slid, p_sm_port, smlid);
+			 slid, smlid);
 
 	OSM_LOG_EXIT(sm->p_log);
 	return sl;
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index fc3b7ab..0e2dae2 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -822,8 +822,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 */
 	if (p_re && p_re->path_sl)
 		sl = p_re->path_sl(p_re->context, sl,
-				   p_src_alias_guid->p_base_port, src_lid_ho,
-				   p_dest_alias_guid->p_base_port, dest_lid_ho);
+				   cl_hton16(src_lid_ho), cl_hton16(dest_lid_ho));
 
 	/* reset pkey when raw traffic */
 	if (comp_mask & IB_PR_COMPMASK_RAWTRAFFIC &&
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 366adad..94b978a 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -9048,17 +9048,26 @@ int route_torus(struct torus *t)
 }
 
 uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
-		      const osm_port_t *osm_sport, const uint16_t slid,
-		      const osm_port_t *osm_dport, const uint16_t dlid)
+		      const ib_net16_t slid, const ib_net16_t dlid)
 {
 	struct torus_context *ctx = context;
-	osm_log_t *log = &ctx->osm->log;
+	osm_opensm_t *p_osm = ctx->osm;
+	osm_log_t *log = &p_osm->log;
+	osm_port_t *osm_sport, *osm_dport;
 	struct endpoint *sport, *dport;
 	struct t_switch *ssw, *dsw;
 	struct torus *t;
 	guid_t guid;
 	unsigned sl = 0;
 
+	osm_sport = osm_get_port_by_lid(&p_osm->subn, slid);
+	if (!osm_sport)
+		goto out;
+
+	osm_dport = osm_get_port_by_lid(&p_osm->subn, dlid);
+	if (!osm_dport)
+		goto out;
+
 	sport = osm_sport->priv;
 	if (!(sport && sport->osm_port == osm_sport)) {
 		sport = osm_port_relink_endpoint(osm_sport);
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index d91ea40..e4cf017 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2059,10 +2059,11 @@ static int dfsssp_do_dijkstra_routing(void *context)
    the virtual lane respectively for a <s,d> pair
 */
 static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
-			     const osm_port_t * src_port, const uint16_t slid,
-			     const osm_port_t * dest_port, const uint16_t dlid)
+			     const ib_net16_t slid, const ib_net16_t dlid)
 {
 	dfsssp_context_t *dfsssp_ctx = (dfsssp_context_t *) context;
+	osm_ucast_mgr_t *p_mgr = (osm_ucast_mgr_t *) dfsssp_ctx->p_mgr;
+	osm_port_t *src_port, *dest_port;
 	vltable_t *srcdest2vl_table = NULL;
 	int32_t res = 0;
 
@@ -2072,6 +2073,14 @@ static uint8_t get_dfsssp_sl(void *context, uint8_t hint_for_default_sl,
 	else
 		return hint_for_default_sl;
 
+	src_port = osm_get_port_by_lid(p_mgr->p_subn, slid);
+	if (!src_port)
+		return hint_for_default_sl;
+
+	dest_port = osm_get_port_by_lid(p_mgr->p_subn, dlid);
+	if (!dest_port)
+		return hint_for_default_sl;
+
 	if (!srcdest2vl_table)
 		return hint_for_default_sl;
 
diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index 77bdba7..648c42e 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -1277,19 +1277,28 @@ static void lash_delete(void *context)
 }
 
 static uint8_t get_lash_sl(void *context, uint8_t path_sl_hint,
-			   const osm_port_t *p_src_port, const uint16_t slid,
-			   const osm_port_t *p_dst_port, const uint16_t dlid)
+			   const ib_net16_t slid, const ib_net16_t dlid)
 {
 	unsigned dst_id;
 	unsigned src_id;
+	osm_port_t *p_src_port, *p_dst_port;
 	osm_switch_t *p_sw;
 	lash_t *p_lash = context;
 	osm_opensm_t *p_osm = p_lash->p_osm;
 
+
 	if (!(p_osm->routing_engine_used &&
 	      p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH))
 		return OSM_DEFAULT_SL;
 
+	p_src_port = osm_get_port_by_lid(&p_osm->subn, slid);
+	if (!p_src_port)
+		return OSM_DEFAULT_SL;
+
+	p_dst_port = osm_get_port_by_lid(&p_osm->subn, dlid);
+	if (!p_dst_port)
+		return OSM_DEFAULT_SL;
+
 	p_sw = get_osm_switch_from_port(p_dst_port);
 	if (!p_sw || !p_sw->priv)
 		return OSM_DEFAULT_SL;
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
