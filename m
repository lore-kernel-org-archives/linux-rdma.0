From: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>
Subject: [PATCH] OpenSM - Scatter Ports
Date: Wed, 23 Mar 2011 17:10:24 -0700
Message-ID: <20110324170633.64860451AF4@cu0login3.emsl.pnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the scatter_ports option to remedy the situation which we
have deemed resonance imbalance.  This occurs when the port assignments
are being set in a round-robin order.  Under some circumstances, the port
assignments will hand out the ports for each LID in a pattern that will
cause packets to heavily favor some switch links, and leave others idle
because the decision for port assignment is made at the switch level with
little regard to the assignments on the other switches in the subnet.
This means that, while each switch in the subnet looks balanced from
the perspective of their LFT, the packets will never make it into the
switch to take advantage of the balance.

The scatter_ports option fixes this situation by remembering all the
currently optimal ports for each lid it is assigning, and picking one at
random instead of just picking the first one.  In order to ensure the
routes stay in the same location each time a sweep occurs, an srandom is
called before the sweep starts using the value of the scatter_port option.
---
 include/opensm/osm_base.h   |   11 +++++++++++
 include/opensm/osm_subnet.h |    5 +++++
 include/opensm/osm_switch.h |    6 +++++-
 opensm/osm_dump.c           |   11 ++++++++++-
 opensm/osm_subnet.c         |    8 ++++++++
 opensm/osm_switch.c         |   30 ++++++++++++++++++++++++++++--
 opensm/osm_ucast_mgr.c      |    8 +++++++-
 7 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index fa4c78d..eb2d05b 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -158,6 +158,17 @@ BEGIN_C_DECLS
 */
 #define OSM_DEFAULT_SL 0
 /********/
+/****s* OpenSM: Base/OSM_DEFAULT_SCATTER_PORTS
+* NAME
+*	OSM_DEFAULT_SCATTER_PORTS
+*
+* DESCRIPTION
+*	Default Scatter Ports value used by OpenSM.
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_SCATTER_PORTS 0
+/********/
 /****s* OpenSM: Base/OSM_DEFAULT_SM_PRIORITY
 * NAME
 *	OSM_DEFAULT_SM_PRIORITY
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 42ae416..85c4f5a 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -236,6 +236,7 @@ typedef struct osm_subn_opt {
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
+	uint32_t scatter_ports;
 } osm_subn_opt_t;
 /*
 * FIELDS
@@ -503,6 +504,10 @@ typedef struct osm_subn_opt {
 *	no_clients_rereg
 *		When TRUE disables clients reregistration request.
 *
+*	scatter_ports
+*		When not zero, randomize best possible ports chosen
+*		for a route. The value is used as a random key seed.
+*
 * SEE ALSO
 *	Subnet object
 *********/
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index f407dd9..dd65c38 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -919,7 +919,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
-				  IN boolean_t dor);
+				  IN boolean_t dor,
+				  IN uint32_t scatter_ports);
 /*
 * PARAMETERS
 *	p_sw
@@ -955,6 +956,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 *	dor
 *		[in] If TRUE, Dimension Order Routing will be done.
 *
+*	scatter_ports
+*		[in] If not zero, randomize the selection of the best ports.
+*
 * RETURN VALUE
 *	Returns the recommended port on which to route this LID.
 *
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 535a03f..a472d57 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -221,7 +221,10 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			/* No LMC Optimization */
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
-							      FALSE, dor);
+							      FALSE,
+							      dor,
+							      p_osm->subn.opt.scatter_ports);
+			/* FIXME This will probably end up lying if scatter_ports is set*/
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
@@ -624,6 +627,12 @@ void osm_dump_all(osm_opensm_t * osm)
 		if (osm_log_is_active(&osm->log, OSM_LOG_DEBUG))
 			dump_qmap(stdout, &osm->subn.sw_guid_tbl,
 				  dump_ucast_path_distribution, osm);
+		/* An attempt to get osm_switch_recommend_path to report the
+		   same routes that a sweep would assign.  No idea if it works
+		   or not */
+		if(osm->subn.opt.scatter_ports) {
+			srandom(osm->subn.opt.scatter_ports);
+		}
 		osm_dump_qmap_to_file(osm, "opensm.fdbs",
 				      &osm->subn.sw_guid_tbl,
 				      dump_ucast_routes, osm);
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 228418f..28578ef 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -402,6 +402,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
 	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
+	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_parse_uint32, NULL, 1 },
 	{0}
 };
 
@@ -755,6 +756,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
+	p_opt->scatter_ports = OSM_DEFAULT_SCATTER_PORTS;
 	subn_init_qos_options(&p_opt->qos_options, NULL);
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
 	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
@@ -1452,6 +1454,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 	fprintf(out,
 		"# Torus-2QoS configuration file name\ntorus_config %s\n\n",
 		p_opts->torus_conf_file ? p_opts->torus_conf_file : null_str);
+	
+	fprintf(out,
+		"# Assign ports in a random order instead of round-robin.\n"
+		"# If zero disable, otherwise use the value as a random seed\n"
+		"scatter_ports %d\n\n",
+		p_opts->scatter_ports);
 
 	fprintf(out,
 		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 9785a9d..99c6a27 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -217,7 +217,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
-				  IN boolean_t dor)
+				  IN boolean_t dor,
+				  IN uint32_t scatter_ports)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -234,9 +235,12 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	uint8_t hops;
 	uint8_t least_hops;
 	uint8_t port_num;
+	uint8_t *possible_ports;
+	uint8_t num_possible = 0;
 	uint8_t num_ports;
 	uint32_t least_paths = 0xFFFFFFFF;
 	unsigned i;
+	unsigned j;
 	/*
 	   The follwing will track the least paths if the
 	   route should go through a new system/node
@@ -281,6 +285,14 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 
 	num_ports = p_sw->num_ports;
 
+	possible_ports = malloc(num_ports * sizeof(uint8_t));
+	if (!possible_ports)
+		/*
+		 * This really isn't ideal, but we don't appear to have a log manager
+		 * context here.
+		 */
+		return OSM_NO_PATH;
+
 	least_hops = osm_switch_get_least_hops(p_sw, base_lid);
 	if (least_hops == OSM_NO_PATH)
 		return OSM_NO_PATH;
@@ -438,10 +450,17 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 			port_found = TRUE;
 			best_port = port_num;
 			least_paths = check_count;
+			for (j = 0; j < num_ports; j++) {
+				possible_ports[j] = 0;
+			}
+			num_possible = 0;
+			possible_ports[num_possible++] = port_num;
 			if (routing_for_lmc
 			    && p_remote_guid
 			    && p_remote_guid->forwarded_to < least_forwarded_to)
 				least_forwarded_to = p_remote_guid->forwarded_to;
+		} else if (check_count == least_paths) {
+			possible_ports[num_possible++] = port_num;
 		} else if (routing_for_lmc
 			   && p_remote_guid
 			   && check_count == least_paths
@@ -464,8 +483,15 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 			best_port = best_port_other_sys;
 		else if (best_port_other_node)
 			best_port = best_port_other_node;
+	} else if (scatter_ports) {
+	/*
+	 * There is some danger that this random could "rebalance" the routes
+	 * every time, to combat this there is a global srandom that
+	 * occurs at the start of every sweep.
+	 */
+		j = random() % num_possible;
+		best_port = possible_ports[j];
 	}
-
 	return best_port;
 }
 
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 4019589..6946546 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -255,7 +255,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 	port = osm_switch_recommend_path(p_sw, p_port, lid_ho, start_from,
 					 p_mgr->p_subn->ignore_existing_lfts,
 					 p_mgr->p_subn->opt.lmc,
-					 p_mgr->is_dor);
+					 p_mgr->is_dor,
+					 p_mgr->p_subn->opt.scatter_ports);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
@@ -1039,6 +1040,11 @@ static int ucast_mgr_route(struct osm_routing_engine *r, osm_opensm_t * osm)
 	OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
 		"building routing with \'%s\' routing algorithm...\n", r->name);
 
+	/* Set the before each lft build to keep the routes in place between sweeps */
+	if(osm->subn.opt.scatter_ports) {
+		srandom(osm->subn.opt.scatter_ports);
+	}
+
 	if (!r->build_lid_matrices ||
 	    (ret = r->build_lid_matrices(r->context)) > 0)
 		ret = osm_ucast_mgr_build_lid_matrices(&osm->sm.ucast_mgr);
-- 
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
