From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v3 02/17] opensm: Allow the routing engine to influence
 SL2VL calculations.
Date: Tue, 15 Jun 2010 13:53:09 -0600
Message-ID: <1276631604-29230-3-git-send-email-jaschut@sandia.gov>
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

Note that the original code assumes that QoS setup is mostly static and
based only on user configuration.  As a result, there is no provision for
routing engines that want to compute contributions to the SL2VL maps.

Fix this up by adding a callback to struct osm_routing_engine that computes
a per-port SL2VL map, and call it from the appropriate place in the QoS
setup path.  Assume that if a routing engine provides a update_sl2vl()
callback that there will input-port dependence in the SL2VL maps, and
so do not attempt to use optimized SL2VL map programming even if the
switch supports it.

Also need to move the call to osm_qos_setup() in do_sweep() to after the
call to the routing engine, so that any SL2VL map contributions from the
routing engine are based on the latest information.  Need to call
osm_qos_setup() for requested reroute for the same reason.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h |   12 ++++++++++++
 opensm/opensm/osm_qos.c            |   27 +++++++++++++++++++++++----
 opensm/opensm/osm_state_mgr.c      |    5 +++--
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index e97142e..25a6f90 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -126,6 +126,9 @@ struct osm_routing_engine {
 	int (*build_lid_matrices) (void *context);
 	int (*ucast_build_fwd_tables) (void *context);
 	void (*ucast_dump_tables) (void *context);
+	void (*update_sl2vl)(void *context, IN osm_physp_t *port,
+			     IN uint8_t in_port_num, IN uint8_t out_port_num,
+			     IN OUT ib_slvl_table_t *t);
 	void (*delete) (void *context);
 	struct osm_routing_engine *next;
 };
@@ -147,6 +150,15 @@ struct osm_routing_engine {
 *	ucast_dump_tables
 *		The callback for dumping unicast routing tables.
 *
+*	update_sl2vl(void *context, IN osm_physp_t *port,
+*		     IN uint8_t in_port_num, IN uint8_t out_port_num,
+*		     OUT ib_slvl_table_t *t)
+*		The callback to allow routing engine input for SL2VL maps.
+*		*port is the phyical port for which the SL2VL map is to be
+*		updated. For switches, in_port_num/out_port_num identify
+*		which part of the SL2VL map to update.  For router/HCA ports,
+*		in_port_num/out_port_num should be ignored.
+*
 *	delete
 *		The delete method, may be used for routing engine
 *		internals cleanup.
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index cce59ee..dadef29 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -207,6 +207,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	osm_physp_t *p0, *p;
 	unsigned force_update;
 	unsigned num_ports = osm_node_get_num_physp(node);
+	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	int ret = 0;
 	unsigned i, j;
 
@@ -223,7 +224,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 		return ret;
 
 	if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
-	    sm->p_subn->opt.use_optimized_slvl) {
+	    sm->p_subn->opt.use_optimized_slvl && !re->update_sl2vl) {
 		p = osm_node_get_physp_ptr(node, 1);
 		force_update = p->need_update || sm->p_subn->need_update;
 		return sl2vl_update_table(sm, p, 1, 0x30000, force_update,
@@ -234,10 +235,20 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
 		j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
-		for (; j < num_ports; j++)
+		for (; j < num_ports; j++) {
+			const ib_slvl_table_t *port_sl2vl = &qcfg->sl2vl;
+			ib_slvl_table_t routing_sl2vl;
+
+			if (re->update_sl2vl) {
+				routing_sl2vl = *port_sl2vl;
+				re->update_sl2vl(re->context,
+						 p, i, j, &routing_sl2vl);
+				port_sl2vl = &routing_sl2vl;
+			}
 			if (sl2vl_update_table(sm, p, i, i << 8 | j,
-					       force_update, &qcfg->sl2vl))
+					       force_update, port_sl2vl))
 				ret = -1;
+		}
 	}
 
 	return ret;
@@ -247,6 +258,9 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 			     const struct qos_config *qcfg)
 {
 	unsigned force_update = p->need_update || sm->p_subn->need_update;
+	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
+	const ib_slvl_table_t *port_sl2vl = &qcfg->sl2vl;
+	ib_slvl_table_t routing_sl2vl;
 
 	p->vl_high_limit = qcfg->vl_high_limit;
 	if (vlarb_update(sm, p, 0, force_update, qcfg))
@@ -255,7 +269,12 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 	if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
 		return 0;
 
-	if (sl2vl_update_table(sm, p, 0, 0, force_update, &qcfg->sl2vl))
+	if (re->update_sl2vl) {
+		routing_sl2vl = *port_sl2vl;
+		re->update_sl2vl(re->context, p, 0, 0, &routing_sl2vl);
+		port_sl2vl = &routing_sl2vl;
+	}
+	if (sl2vl_update_table(sm, p, 0, 0, force_update, port_sl2vl))
 		return -1;
 
 	return 0;
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 81c8f54..cdd72c1 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1141,6 +1141,7 @@ static void do_sweep(osm_sm_t * sm)
 		sm->p_subn->ignore_existing_lfts = TRUE;
 
 		osm_ucast_mgr_process(&sm->ucast_mgr);
+		osm_qos_setup(sm->p_subn->p_osm);
 
 		/* Reset flag */
 		sm->p_subn->ignore_existing_lfts = FALSE;
@@ -1259,8 +1260,6 @@ repeat_discovery:
 
 	osm_pkey_mgr_process(sm->p_subn->p_osm);
 
-	osm_qos_setup(sm->p_subn->p_osm);
-
 	/* try to restore SA DB (this should be before lid_mgr
 	   because we may want to disable clients reregistration
 	   when SA DB is restored) */
@@ -1301,6 +1300,8 @@ repeat_discovery:
 	    osm_ucast_cache_process(&sm->ucast_mgr))
 		osm_ucast_mgr_process(&sm->ucast_mgr);
 
+	osm_qos_setup(sm->p_subn->p_osm);
+
 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
 
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
