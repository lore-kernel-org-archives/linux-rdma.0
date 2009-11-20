From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 02/11] opensm: Allow the routing engine to influence
 SL2VL calculations.
Date: Fri, 20 Nov 2009 12:15:01 -0700
Message-ID: <1258744509-11148-3-git-send-email-jaschut@sandia.gov>
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

Note that the original code assumes that QoS setup is mostly static and
based only on user configuration.  As a result, there is no provision for
routing engines that want to compute contributions to the SL2VL maps.

Fix this up by adding a callback to struct osm_routing_engine that computes
a per-port SL2VL map, and call it from the appropriate place in the QoS
setup path.

Also need to move the call to osm_qos_setup() in do_sweep() to after the
call to the routing engine, so that any SL2VL map contributions from the
routing engine are based on the latest information.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h |   13 +++++++++++++
 opensm/opensm/osm_qos.c            |   19 ++++++++++++++++++-
 opensm/opensm/osm_state_mgr.c      |    4 ++--
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index e97142e..616113b 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -126,6 +126,9 @@ struct osm_routing_engine {
 	int (*build_lid_matrices) (void *context);
 	int (*ucast_build_fwd_tables) (void *context);
 	void (*ucast_dump_tables) (void *context);
+	void (*update_sl2vl)(void *context, IN osm_port_t *port,
+			     IN uint8_t in_port_num, IN uint8_t out_port_num,
+			     IN OUT ib_slvl_table_t *t);
 	void (*delete) (void *context);
 	struct osm_routing_engine *next;
 };
@@ -147,6 +150,16 @@ struct osm_routing_engine {
 *	ucast_dump_tables
 *		The callback for dumping unicast routing tables.
 *
+*	update_sl2vl(void *context, IN osm_port_t *port,
+*		     IN uint8_t in_port_num, IN uint8_t out_port_num,
+*		     OUT ib_slvl_table_t *t)
+*		The callback to allow routing engine input for SL2VL maps.
+*		For switches, *port is the switch management port, and
+*		in_port_num/out_port_num identify which part of the SL2VL
+*		map to update.  For router/HCA ports, *port is the port
+*		for which the SL2VL map should be updated, and in_port_num/
+*		out_port_num should be ignored.
+*
 *	delete
 *		The delete method, may be used for routing engine
 *		internals cleanup.
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 08f9a60..f42c334 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -194,6 +194,7 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
 {
 	ib_api_status_t status;
 	uint8_t i, num_ports;
+	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	osm_physp_t *p_physp;
 
 	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
@@ -213,8 +214,24 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
 	}
 
 	for (i = 0; i < num_ports; i++) {
+		ib_slvl_table_t routing_sl2vl;
+		const ib_slvl_table_t *port_sl2vl;
+		const ib_slvl_table_t *port_sl2vl_old;
+
+		if (re->update_sl2vl) {
+			routing_sl2vl = qcfg->sl2vl;
+			re->update_sl2vl(re->context,
+					 p_port, i, port_num, &routing_sl2vl);
+			port_sl2vl = &routing_sl2vl;
+			port_sl2vl_old = osm_physp_get_slvl_tbl(p, i);
+			if (memcmp(port_sl2vl, port_sl2vl_old,
+				   sizeof(*port_sl2vl)) != 0)
+				force_update = 1;
+		} else
+			port_sl2vl = &qcfg->sl2vl;
+
 		status = sl2vl_update_table(sm, p, i, port_num, force_update,
-					    &qcfg->sl2vl);
+					    port_sl2vl);
 		if (status != IB_SUCCESS)
 			return status;
 	}
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 7540adc..c3f49dc 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1228,8 +1228,6 @@ repeat_discovery:
 
 	osm_pkey_mgr_process(sm->p_subn->p_osm);
 
-	osm_qos_setup(sm->p_subn->p_osm);
-
 	/* try to restore SA DB (this should be before lid_mgr
 	   because we may want to disable clients reregistration
 	   when SA DB is restored) */
@@ -1270,6 +1268,8 @@ repeat_discovery:
 	    osm_ucast_cache_process(&sm->ucast_mgr))
 		osm_ucast_mgr_process(&sm->ucast_mgr);
 
+	osm_qos_setup(sm->p_subn->p_osm);
+
 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
 
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
