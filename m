From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/8] opensm/osm_torus.c: Require only 2 data VLs supported
 (PortInfo.VLCap) and use VLs 0-1 on CA links
Date: Wed, 28 Nov 2012 14:03:11 -0500
Message-ID: <50B65FEF.4070408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


CA links preserve SLs 0-7 for QoS level 0 and SLs 8-15 for QoS level 1.
First group of SLs are mapped to VL0 and second group are mapped to VL1.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |  124 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 5bd7639..9d41297 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -7042,27 +7042,27 @@ bool verify_setup(struct torus *t, struct fabric *f)
 			"ERR 4E20: missing required torus size specification!\n");
 		goto out;
 	}
-	if (t->osm->subn.min_data_vls < 2 || t->osm->subn.min_sw_data_vls < 2)
+	if (t->osm->subn.min_sw_data_vls < 2)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-			"without credit loops (have endport %d switchport %d "
-			"need 2)\n",
-			(int)t->osm->subn.min_data_vls,
+			"without credit loops (have switchport %d need 2)\n",
 			(int)t->osm->subn.min_sw_data_vls);
-	if (t->osm->subn.min_data_vls < 4 || t->osm->subn.min_sw_data_vls < 4)
+	if (t->osm->subn.min_sw_data_vls < 4)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
 			"with a failed switch without credit loops "
-			"(have endport %d switchport %d need 4)\n",
-			(int)t->osm->subn.min_data_vls,
+			"(have switchport %d need 4)\n",
 			(int)t->osm->subn.min_sw_data_vls);
-	if (t->osm->subn.min_data_vls < 8 || t->osm->subn.min_sw_data_vls < 8)
+	if (t->osm->subn.min_sw_data_vls < 8)
 		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
 			"Warning: Too few data VLs to support torus routing "
-			"with two QoS levels (have endport %d switchport %d "
-			"need 8)\n",
-			(int)t->osm->subn.min_data_vls,
+			"with two QoS levels (have switchport %d need 8)\n",
 			(int)t->osm->subn.min_sw_data_vls);
+	if (t->osm->subn.min_data_vls < 2)
+		OSM_LOG(&t->osm->log, OSM_LOG_INFO,
+			"Warning: Too few data VLs to support torus routing "
+			"with two QoS levels (have endport %d need 2)\n",
+			(int)t->osm->subn.min_data_vls);
 	/*
 	 * Be sure all the switches in the torus support the port
 	 * ordering that might have been configured.
@@ -7944,6 +7944,7 @@ unsigned sl_get_qos(unsigned sl)
  * Functions to encode routing/QoS info into VL bits.  Combine the resuts of
  * these functions with bitwise or to get final VL.
  *
+ * For interswitch links:
  * VL bit 0 encodes whether we need to leave on the "loop" VL.
  *
  * VL bit 1 encodes whether turn is XYZ DOR or ZYX DOR. A 3d mesh/torus
@@ -7958,6 +7959,9 @@ unsigned sl_get_qos(unsigned sl)
  *
  * VL bit 2 encodes QoS level.
  *
+ * For end port links:
+ * VL bit 0 encodes QoS level.
+ *
  * Note that if VL bit encodings are changed here, the available fabric VL
  * verification in verify_setup() needs to be updated as well.
  */
@@ -7974,6 +7978,12 @@ unsigned vl_set_qos_vl(unsigned qos)
 }
 
 static inline
+unsigned vl_set_ca_qos_vl(unsigned qos)
+{
+	return qos & 0x1;
+}
+
+static inline
 unsigned vl_set_turn_vl(unsigned in_coord_dir, unsigned out_coord_dir)
 {
 	unsigned vl = 0;
@@ -8006,15 +8016,19 @@ unsigned sl2vl_entry(struct torus *t, struct t_switch *sw,
 		data_vls = t->osm->subn.min_sw_data_vls;
 	else
 		data_vls = t->osm->subn.min_data_vls;
-	vl = 0;
-
-	if (data_vls >= 2)
-		vl |= vl_set_loop_vl(sl_get_use_loop_vl(sl, od));
-	if (data_vls >= 4)
-		vl |= vl_set_turn_vl(id, od);
-	if (data_vls >= 8)
-		vl |= vl_set_qos_vl(sl_get_qos(sl));
 
+	vl = 0;
+	if (sw && od != TORUS_MAX_DIM) {
+		if (data_vls >= 2)
+			vl |= vl_set_loop_vl(sl_get_use_loop_vl(sl, od));
+		if (data_vls >= 4)
+			vl |= vl_set_turn_vl(id, od);
+		if (data_vls >= 8)
+			vl |= vl_set_qos_vl(sl_get_qos(sl));
+	} else {
+		if (data_vls >= 2)
+			vl |= vl_set_ca_qos_vl(sl_get_qos(sl));
+	}
 	return vl;
 }
 
@@ -8048,6 +8062,73 @@ void torus_update_osm_sl2vl(void *context, osm_physp_t *osm_phys_port,
 	}
 }
 
+static
+void torus_update_osm_vlarb(void *context, osm_physp_t *osm_phys_port,
+			    uint8_t port_num, ib_vl_arb_table_t *block,
+			    unsigned block_length, unsigned block_num)
+{
+	osm_node_t *node = osm_physp_get_node_ptr(osm_phys_port);
+	struct torus_context *ctx = context;
+	struct t_switch *sw = NULL;
+	unsigned i, next;
+
+	if (node->sw) {
+		sw = node->sw->priv;
+		if (sw && sw->osm_switch != node->sw) {
+			osm_log_t *log = &ctx->osm->log;
+			guid_t guid;
+
+			guid = osm_node_get_node_guid(node);
+			OSM_LOG(log, OSM_LOG_INFO,
+				"Error: osm_switch (GUID 0x%04"PRIx64") "
+				"not in our fabric description\n",
+				cl_ntoh64(guid));
+			return;
+		}
+	}
+
+	/*
+	 * If osm_phys_port is a switch port that connects to a CA, then
+	 * we're using at most VL 0 (for QoS level 0) and VL 1 (for QoS
+	 * level 1).  We've been passed the  VLarb values for a switch
+	 * external port, so we need to fix them up to avoid unexpected
+	 * results depending on how the switch handles VLarb values for
+	 * unprogrammed VLs.
+	 *
+	 * For inter-switch links torus-2QoS uses VLs 0-3 to implement
+	 * QoS level 0, and VLs 4-7 to implement QoS level 1.
+	 *
+	 * So, leave VL 0 alone, remap VL 4 to VL 1, zero out the rest,
+	 * and compress out the zero entries to the end.
+	 */
+	if (!sw || !port_num ||
+	    sw->port[port_num]->pgrp->port_grp != 2 * TORUS_MAX_DIM)
+		return;
+
+	next = 0;
+	for (i = 0; i < block_length; i++) {
+		switch (block->vl_entry[i].vl) {
+		case 4:
+			block->vl_entry[i].vl = 1;
+			/* fall through */
+		case 0:
+			block->vl_entry[next].vl = block->vl_entry[i].vl;
+			block->vl_entry[next].weight = block->vl_entry[i].weight;
+			next++;
+			/*
+			 * If we didn't update vl_entry[i] in place,
+			 * fall through to zero it out.
+			 */
+			if (next > i)
+				break;
+		default:
+			block->vl_entry[i].vl = 0;
+			block->vl_entry[i].weight = 0;
+			break;
+		}
+	}
+}
+
 /*
  * Computes the path lengths *vl0_len and *vl1_len to get from src
  * to dst on a ring with count switches.
@@ -9219,6 +9300,9 @@ void check_qos_config(osm_qos_options_t *opt, bool tgt_is_default,
 			"Warning: full torus-2QoS functionality not available "
 			"for configured %s_max_vls = %d\n", str, opt->max_vls);
 
+	if (!strcmp(str, "qos_ca"))
+		goto check_sl2vl;
+
 	if (opt->vlarb_high) {
 		is_default = false;
 		vlarb_str = opt->vlarb_high;
@@ -9244,6 +9328,7 @@ void check_qos_config(osm_qos_options_t *opt, bool tgt_is_default,
 	if (!is_default || tgt_is_default)
 		check_vlarb_config(vlarb_str, is_default, str, "low", log);
 
+check_sl2vl:
 	if (opt->sl2vl)
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: torus-2QoS must override configured "
@@ -9354,6 +9439,7 @@ int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
 	r->context = ctx;
 	r->ucast_build_fwd_tables = torus_build_lfts;
 	r->update_sl2vl = torus_update_osm_sl2vl;
+	r->update_vlarb = torus_update_osm_vlarb;
 	r->path_sl = torus_path_sl;
 	r->mcast_build_stree = torus_mcast_stree;
 	r->destroy = torus_context_delete;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
