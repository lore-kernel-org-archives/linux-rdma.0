From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 03/18] opensm: Allow the routing engine to
 participate in path SL calculations.
Date: Fri,  3 Sep 2010 10:42:59 -0600
Message-ID: <1283532194-27112-4-git-send-email-jaschut@sandia.gov>
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

LASH already does this, in a hard-coded fashion.

Generalize this by adding a callback to struct osm_routing_engine that
computes a path SL value, and fix up LASH to use it.

This patchset causes the requested or QoS-computed SL value to be passed
to the routing engine path SL computation as a hint.  In the event the
routing engine's use of SLs allows it to support more than one QoS level,
it may be able to make use of the SL hint to do so.

For now, LASH just ignores the hint.

Note that before this change, if LASH was configured and a specific path
SL value was requested that differed from what LASH needed to route the
fabric without credit loops, the path SL lookup would fail.  Now LASH's
SL value is always used.

Possibly the choice between failing a path SL request when it conflicts
with routing, vs. always providing an SL value that gives a credit-loop-
free routing, should be user-configurable?

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h     |    6 +++++
 opensm/include/opensm/osm_ucast_lash.h |    3 --
 opensm/opensm/osm_link_mgr.c           |   15 ++++++++-----
 opensm/opensm/osm_sa_path_record.c     |   34 +++++++++++--------------------
 opensm/opensm/osm_ucast_lash.c         |    8 +++++-
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index 25a6f90..734a6db 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -129,6 +129,9 @@ struct osm_routing_engine {
 	void (*update_sl2vl)(void *context, IN osm_physp_t *port,
 			     IN uint8_t in_port_num, IN uint8_t out_port_num,
 			     IN OUT ib_slvl_table_t *t);
+	uint8_t (*path_sl)(void *context, IN uint8_t path_sl_hint,
+			   IN const osm_port_t *src_port,
+			   IN const osm_port_t *dst_port);
 	void (*delete) (void *context);
 	struct osm_routing_engine *next;
 };
@@ -159,6 +162,9 @@ struct osm_routing_engine {
 *		which part of the SL2VL map to update.  For router/HCA ports,
 *		in_port_num/out_port_num should be ignored.
 *
+*	path_sl
+*		The callback for computing path SL.
+*
 *	delete
 *		The delete method, may be used for routing engine
 *		internals cleanup.
diff --git a/opensm/include/opensm/osm_ucast_lash.h b/opensm/include/opensm/osm_ucast_lash.h
index 9e15d38..dd90d5d 100644
--- a/opensm/include/opensm/osm_ucast_lash.h
+++ b/opensm/include/opensm/osm_ucast_lash.h
@@ -94,7 +94,4 @@ typedef struct _lash {
 	int ***virtual_location;
 } lash_t;
 
-uint8_t osm_get_lash_sl(osm_opensm_t * p_osm, const osm_port_t * p_src_port,
-			const osm_port_t * p_dst_port);
-
 #endif
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index c309916..e446e16 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -53,21 +53,23 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
-#include <opensm/osm_ucast_lash.h>
 
 static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
 	osm_opensm_t *p_osm = sm->p_subn->p_osm;
+	struct osm_routing_engine *re = p_osm->routing_engine_used;
 	const osm_port_t *p_sm_port, *p_src_port;
 	ib_net16_t slid;
 	uint8_t sl;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	if (!(p_osm->routing_engine_used &&
-	      p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH &&
+	if (!(re && re->path_sl &&
 	      (slid = osm_physp_get_base_lid(p_physp)))) {
-		/* Use default SL if lash routing is not used */
+		/*
+		 * Use default SL if routing engine does not provide a
+		 * path SL lookup callback.
+		 */
 		OSM_LOG_EXIT(sm->p_log);
 		return sm->p_subn->opt.sm_sl;
 	}
@@ -78,8 +80,9 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 	/* Find osm_port of the source = p_physp */
 	p_src_port = osm_get_port_by_lid(sm->p_subn, slid);
 
-	/* Call lash to find proper SL */
-	sl = osm_get_lash_sl(p_osm, p_src_port, p_sm_port);
+	/* Call into routing engine to find proper SL */
+	sl = re->path_sl(re->context, sm->p_subn->opt.sm_sl,
+			 p_src_port, p_sm_port);
 
 	OSM_LOG_EXIT(sm->p_log);
 	return sl;
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index c41beb1..47eed18 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -164,6 +164,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	const osm_physp_t *p_dest_physp;
 	const osm_prtn_t *p_prtn = NULL;
 	osm_opensm_t *p_osm;
+	struct osm_routing_engine *p_re;
 	const ib_port_info_t *p_pi;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_net16_t pkey;
@@ -180,7 +181,6 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	ib_slvl_table_t *p_slvl_tbl = NULL;
 	osm_qos_level_t *p_qos_level = NULL;
 	uint16_t valid_sl_mask = 0xffff;
-	int is_lash;
 	int hops = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -192,6 +192,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_src_physp = p_physp;
 	p_pi = &p_physp->port_info;
 	p_osm = sa->p_subn->p_osm;
+	p_re = p_osm->routing_engine_used;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
 	rate = ib_port_info_compute_rate(p_pi);
@@ -667,9 +668,6 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 * Set PathRecord SL
 	 */
 
-	is_lash = (p_osm->routing_engine_used &&
-		   p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH);
-
 	if (comp_mask & IB_PR_COMPMASK_SL) {
 		/*
 		 * Specific SL was requested
@@ -686,26 +684,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			goto Exit;
 		}
 
-		if (is_lash
-		    && osm_get_lash_sl(p_osm, p_src_port, p_dest_port) != sl) {
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F23: "
-				"Required PathRecord SL (%u) doesn't "
-				"match LASH SL\n", sl);
-			status = IB_NOT_FOUND;
-			goto Exit;
-		}
-
-	} else if (is_lash) {
-		/*
-		 * No specific SL in PathRecord request.
-		 * If it's LASH routing - use its SL.
-		 * slid and dest_lid are stored in network in lash.
-		 */
-		sl = osm_get_lash_sl(p_osm, p_src_port, p_dest_port);
 	} else if (p_qos_level && p_qos_level->sl_set) {
 		/*
-		 * No specific SL was requested, and we're not in
-		 * LASH routing, but there is an SL in QoS level.
+		 * No specific SL was requested, but there is an SL in
+		 * QoS level.
 		 */
 		sl = p_qos_level->sl;
 
@@ -746,6 +728,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
+	/*
+	 * If the routing engine wants to have a say in path SL selection,
+	 * send the currently computed SL value as a hint and let the routing
+	 * engine override it.
+	 */
+	if (p_re && p_re->path_sl)
+		sl = p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port);
+
 	/* reset pkey when raw traffic */
 	if (comp_mask & IB_PR_COMPMASK_RAWTRAFFIC &&
 	    cl_ntoh32(p_pr->hop_flow_raw) & (1 << 31))
diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index 72c4c3d..8746c37 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -1277,12 +1277,15 @@ static void lash_delete(void *context)
 	free(p_lash);
 }
 
-uint8_t osm_get_lash_sl(osm_opensm_t * p_osm, const osm_port_t * p_src_port,
-			const osm_port_t * p_dst_port)
+static uint8_t get_lash_sl(void *context, uint8_t path_sl_hint,
+			   const osm_port_t *p_src_port,
+			   const osm_port_t *p_dst_port)
 {
 	unsigned dst_id;
 	unsigned src_id;
 	osm_switch_t *p_sw;
+	lash_t *p_lash = context;
+	osm_opensm_t *p_osm = p_lash->p_osm;
 
 	if (!(p_osm->routing_engine_used &&
 	      p_osm->routing_engine_used->type == OSM_ROUTING_ENGINE_TYPE_LASH))
@@ -1312,6 +1315,7 @@ int osm_ucast_lash_setup(struct osm_routing_engine *r, osm_opensm_t *p_osm)
 
 	r->context = p_lash;
 	r->ucast_build_fwd_tables = lash_process;
+	r->path_sl = get_lash_sl;
 	r->delete = lash_delete;
 
 	return 0;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
