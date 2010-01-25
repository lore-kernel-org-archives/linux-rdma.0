From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH]opensm: QOS options for switch leaf (edge) ports.
Date: Mon, 25 Jan 2010 15:03:44 +0200
Message-ID: <4B5D96B0.8030903@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

New QOS option for edge ports allows to set
different sl 2 vl mapping for switch ports
connected to HCAs.

Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    1 +
 opensm/opensm/osm_qos.c            |   21 ++++++++++++++++++---
 opensm/opensm/osm_subnet.c         |   14 ++++++++++++++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 65f687a..31681aa 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -212,6 +212,7 @@ typedef struct osm_subn_opt {
 	osm_qos_options_t qos_ca_options;
 	osm_qos_options_t qos_sw0_options;
 	osm_qos_options_t qos_swe_options;
+	osm_qos_options_t qos_sw_edge_options;
 	osm_qos_options_t qos_rtr_options;
 	boolean_t enable_quirks;
 	boolean_t no_clients_rereg;
diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 6bbbfa2..51f0aed 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -202,15 +202,21 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
 }
 
 static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
-			      const struct qos_config *qcfg)
+			      const struct qos_config *qcfg, boolean_t edge_ports_only)
 {
 	osm_physp_t *p0, *p;
+	osm_node_t *p_remote_node;
 	unsigned force_update;
 	unsigned num_ports = osm_node_get_num_physp(node);
 	int ret = 0;
 	unsigned i, j;
 
 	for (i = 1; i < num_ports; i++) {
+		if (edge_ports_only) {
+			p_remote_node = osm_node_get_remote_node(node, i, NULL);
+			if (p_remote_node && (osm_node_get_type(p_remote_node) != IB_NODE_TYPE_CA))
+				continue;
+		}
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
 		p->vl_high_limit = qcfg->vl_high_limit;
@@ -231,6 +237,11 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 	}
 
 	for (i = 1; i < num_ports; i++) {
+		if (edge_ports_only ) {
+			p_remote_node = osm_node_get_remote_node(node, i, NULL);
+			if (p_remote_node && (osm_node_get_type(p_remote_node) != IB_NODE_TYPE_CA))
+				continue;
+		}
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
 		for (j = 0; j < num_ports; j++)
@@ -262,7 +273,7 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 
 int osm_qos_setup(osm_opensm_t * p_osm)
 {
-	struct qos_config ca_config, sw0_config, swe_config, rtr_config;
+	struct qos_config ca_config, sw0_config, swe_config, sw_edge_config, rtr_config;
 	struct qos_config *cfg;
 	cl_qmap_t *p_tbl;
 	cl_map_item_t *p_next;
@@ -281,6 +292,8 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 			 &p_osm->subn.opt.qos_options);
 	qos_build_config(&swe_config, &p_osm->subn.opt.qos_swe_options,
 			 &p_osm->subn.opt.qos_options);
+	qos_build_config(&sw_edge_config, &p_osm->subn.opt.qos_sw_edge_options,
+			 &p_osm->subn.opt.qos_options);
 	qos_build_config(&rtr_config, &p_osm->subn.opt.qos_rtr_options,
 			 &p_osm->subn.opt.qos_options);
 
@@ -297,9 +310,11 @@ int osm_qos_setup(osm_opensm_t * p_osm)
 
 		p_node = p_port->p_node;
 		if (p_node->sw) {
-			if (qos_extports_setup(&p_osm->sm, p_node, &swe_config))
+			if (qos_extports_setup(&p_osm->sm, p_node, &swe_config, FALSE))
 				ret = -1;
 
+			if (qos_extports_setup(&p_osm->sm, p_node, &sw_edge_config, TRUE))
+				ret = -1;
 			/* skip base port 0 */
 			if (!ib_switch_info_is_enhanced_port0
 			    (&p_node->sw->switch_info))
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index edbffe8..aa82f32 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -385,6 +385,11 @@ static const opt_rec_t opt_tbl[] = {
 	{ "qos_swe_vlarb_high", OPT_OFFSET(qos_swe_options.vlarb_high), opts_parse_charp, NULL, 1 },
 	{ "qos_swe_vlarb_low", OPT_OFFSET(qos_swe_options.vlarb_low), opts_parse_charp, NULL, 1 },
 	{ "qos_swe_sl2vl", OPT_OFFSET(qos_swe_options.sl2vl), opts_parse_charp, NULL, 1 },
+	{ "qos_edge_max_vls", OPT_OFFSET(qos_sw_edge_options.max_vls), opts_parse_uint32, NULL, 1 },
+	{ "qos_edge_high_limit", OPT_OFFSET(qos_sw_edge_options.high_limit), opts_parse_int32, NULL, 1 },
+	{ "qos_edge_vlarb_high", OPT_OFFSET(qos_sw_edge_options.vlarb_high), opts_parse_charp, NULL, 1 },
+	{ "qos_edge_vlarb_low", OPT_OFFSET(qos_sw_edge_options.vlarb_low), opts_parse_charp, NULL, 1 },
+	{ "qos_edge_sl2vl", OPT_OFFSET(qos_sw_edge_options.sl2vl), opts_parse_charp, NULL, 1 },
 	{ "qos_rtr_max_vls", OPT_OFFSET(qos_rtr_options.max_vls), opts_parse_uint32, NULL, 1 },
 	{ "qos_rtr_high_limit", OPT_OFFSET(qos_rtr_options.high_limit), opts_parse_int32, NULL, 1 },
 	{ "qos_rtr_vlarb_high", OPT_OFFSET(qos_rtr_options.vlarb_high), opts_parse_charp, NULL, 1 },
@@ -768,6 +773,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
 	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
 	subn_init_qos_options(&p_opt->qos_swe_options, NULL);
+	subn_init_qos_options(&p_opt->qos_sw_edge_options, NULL);
 	subn_init_qos_options(&p_opt->qos_rtr_options, NULL);
 }
 
@@ -1112,6 +1118,8 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 				    &p_opts->qos_options);
 		subn_verify_qos_set(&p_opts->qos_swe_options, "qos_swe",
 				    &p_opts->qos_options);
+		subn_verify_qos_set(&p_opts->qos_sw_edge_options, "qos_edge",
+				    &p_opts->qos_options);
 		subn_verify_qos_set(&p_opts->qos_rtr_options, "qos_rtr",
 				    &p_opts->qos_options);
 	}
@@ -1220,6 +1228,8 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 			      &p_opts->file_opts->qos_sw0_options);
 	subn_init_qos_options(&p_opts->qos_swe_options,
 			      &p_opts->file_opts->qos_swe_options);
+	subn_init_qos_options(&p_opts->qos_sw_edge_options,
+			      &p_opts->file_opts->qos_sw_edge_options);
 	subn_init_qos_options(&p_opts->qos_rtr_options,
 			      &p_opts->file_opts->qos_rtr_options);
 
@@ -1620,6 +1630,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 			      &p_opts->qos_swe_options);
 	fprintf(out, "\n");
 	subn_dump_qos_options(out,
+			      "QoS Edge ports options", "qos_edge",
+			      &p_opts->qos_sw_edge_options);
+	fprintf(out, "\n");
+	subn_dump_qos_options(out,
 			      "QoS Router ports options", "qos_rtr",
 			      &p_opts->qos_rtr_options);
 	fprintf(out, "\n");
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
