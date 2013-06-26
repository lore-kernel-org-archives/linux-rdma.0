From: Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>
Subject: PATCH: opensm enhancements
Date: Wed, 26 Jun 2013 14:24:01 -0700
Message-ID: <51CB5BF1.1090601@nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------080009060609010008060203"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ciotti, Robert B. (ARC-TNE)" <bob.ciotti-NSQ8wuThN14@public.gmane.org>, Dale Talcott <Dale.R.Talcott-NSQ8wuThN14@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------080009060609010008060203
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hi Hal. At the OFA workshop, I mentioned that I've been working on some 
modifications to opensm that we use at NASA. Following extensive testing 
of these applied to opensm 3.3.13 (the version we run here), I have 
ported these to top of tree opensm, and have tested them on a small 
cluster.

The first patch modifies the console logflush command to take "on" or 
"off" as an argument for toggling. The second (more extensive) patch 
adds a command line option to specify a file in which each line contains 
a switch GUID/port pair to be ignored by opensm. The idea is to specify 
this file when you start opensm (it can be empty), and add ports to 
ignore (one per line for each end of a connection) to the file. At the 
next heavy sweep (or HUP) the sm will reprogram the forwarding tables 
without including the ignored links. We use this for replacing cables, 
as well as for system expansion (adding new racks).

Please let me know if you have any questions/issues with these. Thanks.

-jeff

--------------080009060609010008060203
Content-Type: text/plain; charset="UTF-8";
	name="0001-opensm-permit-toggling-log-flush-from-console.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-opensm-permit-toggling-log-flush-from-console.patch"

>From cfb1c75a2b3fe7862f376bba44ebe3671b976ccd Mon Sep 17 00:00:00 2001
From: Jeffrey C. Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date: Tue, 25 Jun 2013 10:29:45 -0700
Subject: [PATCH 1/2] opensm: permit toggling log flush from console
 Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

---
 opensm/osm_console.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 0f80bdb..c065453 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -178,7 +178,7 @@ static void help_status(FILE * out, int detail)
 
 static void help_logflush(FILE * out, int detail)
 {
-	fprintf(out, "logflush -- flush the opensm.log file\n");
+	fprintf(out, "logflush [on|off] -- toggle opensm.log file flushing\n");
 }
 
 static void help_querylid(FILE * out, int detail)
@@ -599,7 +599,21 @@ static void sweep_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 
 static void logflush_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 {
-	fflush(p_osm->log.out_port);
+	char *p_cmd;
+
+	p_cmd = next_token(p_last);
+	if (!p_cmd ||
+	    (strcmp(p_cmd, "on") != 0 && strcmp(p_cmd, "off") != 0)) {
+		fprintf(out, "Invalid logflush command\n");
+		help_sweep(out, 1);
+	} else {
+		if (strcmp(p_cmd, "on") == 0) {
+			p_osm->log.flush = TRUE;
+	                fflush(p_osm->log.out_port);
+                }
+		else
+			p_osm->log.flush = FALSE;
+	}
 }
 
 static void querylid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
-- 
1.7.1


--------------080009060609010008060203
Content-Type: text/plain; charset="UTF-8";
	name="0002-opensm-add-option-to-ignore-guid-port-pairs-specifie.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-opensm-add-option-to-ignore-guid-port-pairs-specifie.pa";
	filename*1="tch"

>From 12a80ef0a81134edc0be779ae14ceafd41c2c124 Mon Sep 17 00:00:00 2001
From: Jeffrey C. Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date: Tue, 25 Jun 2013 10:36:17 -0700
Subject: [PATCH 2/2] opensm: add option to ignore guid/port pairs specified in a file
 Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

---
 include/opensm/osm_subnet.h    |    4 ++
 include/opensm/osm_ucast_mgr.h |   18 +++++++
 opensm/main.c                  |   15 ++++++-
 opensm/osm_drop_mgr.c          |   40 +++++++++++++++++
 opensm/osm_node_info_rcv.c     |    8 +++-
 opensm/osm_state_mgr.c         |    9 ++++
 opensm/osm_subnet.c            |    8 +++
 opensm/osm_ucast_mgr.c         |   96 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 196 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 2f98ae0..6dac079 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -298,6 +298,7 @@ typedef struct osm_subn_opt {
 	char *console;
 	uint16_t console_port;
 	char *port_prof_ignore_file;
+	char *ignore_ports_file;
 	char *hop_weights_file;
 	char *port_search_ordering_file;
 	boolean_t port_profile_switch_nodes;
@@ -512,6 +513,9 @@ typedef struct osm_subn_opt {
 *	port_prof_ignore_file
 *		Name of file with port guids to be ignored by port profiling.
 *
+*	ignore_ports_file
+*		Name of file with port guids to be ignored in discovery
+*
 *	port_profile_switch_nodes
 *		If TRUE will count the number of switch nodes routed through
 *		the link. If FALSE - only CA/RT nodes are counted.
diff --git a/include/opensm/osm_ucast_mgr.h b/include/opensm/osm_ucast_mgr.h
index c534b7e..5f79ad0 100644
--- a/include/opensm/osm_ucast_mgr.h
+++ b/include/opensm/osm_ucast_mgr.h
@@ -101,6 +101,7 @@ typedef struct osm_ucast_mgr {
 	boolean_t some_hop_count_set;
 	cl_qmap_t cache_sw_tbl;
 	boolean_t cache_valid;
+	cl_qlist_t ports_to_ignore;
 } osm_ucast_mgr_t;
 /*
 * FIELDS
@@ -137,6 +138,23 @@ typedef struct osm_ucast_mgr {
 *	Unicast Manager object
 *********/
 
+/* struct to keep track of ports to be ignored in discovery */
+
+typedef struct port_to_ignore {
+	uint64_t guid;
+	unsigned port;
+} port_to_ignore_t;
+
+/* delete list of ports to ignore */
+boolean_t delete_ports_to_ignore(IN osm_ucast_mgr_t * p_mgr);
+
+/* initialize list of ports to ignore */
+boolean_t setup_ports_to_ignore(IN osm_ucast_mgr_t * p_mgr);
+
+/* lookup guid,port in list of ports to ignore */
+boolean_t lookup_ignore_port(IN osm_ucast_mgr_t * p_mgr, osm_node_t * p_node,
+                                    const uint8_t port_num);
+
 /****f* OpenSM: Unicast Manager/osm_ucast_mgr_construct
 * NAME
 *	osm_ucast_mgr_construct
diff --git a/opensm/main.c b/opensm/main.c
index 9349d79..5152134 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -290,6 +290,9 @@ static void show_usage(void)
 	       "          This option provides the means to define a set of ports\n"
 	       "          (by guid) that will be ignored by the link load\n"
 	       "          equalization algorithm.\n\n");
+	printf("--ignore_ports, -j <ignore-ports-file>\n"
+	       "          This option provides the means to define a set of ports\n"
+	       "          (by guid) that will be ignored by opensm.\n\n");
 	printf("--hop_weights_file, -w <path to file>\n"
 	       "          This option provides the means to define a weighting\n"
 	       "          factor per port for customizing the least weight\n"
@@ -607,7 +610,7 @@ int main(int argc, char *argv[])
 	const char *config_file = NULL;
 	uint32_t val;
 	const char *const short_option =
-	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANZ:WBIQvVhoryxp:n:q:k:C:G:H:";
+	    "F:c:i:j:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANZ:WBIQvVhoryxp:n:q:k:C:G:H:";
 
 	/*
 	   In the array below, the 2nd parameter specifies the number
@@ -623,6 +626,7 @@ int main(int argc, char *argv[])
 		{"debug", 1, NULL, 'd'},
 		{"guid", 1, NULL, 'g'},
 		{"ignore_guids", 1, NULL, 'i'},
+		{"ignore_ports", 1, NULL, 'j'},
 		{"hop_weights_file", 1, NULL, 'w'},
 		{"dimn_ports_file", 1, NULL, 'O'},
 		{"port_search_ordering_file", 1, NULL, 'O'},
@@ -766,6 +770,15 @@ int main(int argc, char *argv[])
 			       opt.port_prof_ignore_file);
 			break;
 
+		case 'j':
+			/*
+			   Specifies ignore ports file.
+			 */
+			SET_STR_OPT(opt.ignore_ports_file, optarg);
+			printf(" Ignore Ports File = %s\n",
+			       opt.ignore_ports_file);
+			break;
+
 		case 'w':
 			SET_STR_OPT(opt.hop_weights_file, optarg);
 			printf(" Hop Weights File = %s\n",
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index b309273..6886827 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -480,6 +480,46 @@ static void drop_mgr_check_node(osm_sm_t * sm, IN osm_node_t * p_node)
 			}
 		}
 	}
+       /* Unlink ignored links */
+       if (sm->p_subn->opt.ignore_ports_file) {
+                for (port_num = 1; port_num < p_node->physp_tbl_size; port_num++) {
+                        if (lookup_ignore_port(&sm->ucast_mgr, p_node, port_num)) {
+                                p_physp = osm_node_get_physp_ptr(p_node, port_num);
+                                if (!p_physp)
+                                        continue;
+                                p_remote_physp = osm_physp_get_remote(p_physp);
+                                if (!p_remote_physp)
+                                        continue;
+
+                                p_remote_node =
+                                    osm_physp_get_node_ptr(p_remote_physp);
+                                remote_port_num =
+                                    osm_physp_get_port_num(p_remote_physp);
+
+                                OSM_LOG(sm->p_log, OSM_LOG_INFO,
+                                        "Ignored link: "
+                                        "Unlinking local node 0x%" PRIx64
+                                        ", port %u"
+                                        "\n\t\t\t\tand remote node 0x%" PRIx64
+                                        ", port %u\n.",
+                                        cl_ntoh64(osm_node_get_node_guid
+                                                  (p_node)), port_num,
+                                        cl_ntoh64(osm_node_get_node_guid
+                                                  (p_remote_node)),
+                                        remote_port_num);
+
+                                if (sm->ucast_mgr.cache_valid)
+                                        osm_ucast_cache_add_link(&sm->ucast_mgr,
+                                                                 p_physp,
+                                                                 p_remote_physp);
+
+                                osm_node_unlink(p_node, (uint8_t) port_num,
+                                                p_remote_node,
+                                                (uint8_t) remote_port_num);
+                        }
+                }
+        }
+
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
 	return;
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 592f2de..eab14a2 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -166,6 +166,7 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 						p_neighbor_node,
 						p_ni_context->port_num));
 
+
 	if (osm_node_link_exists(p_node, port_num,
 				 p_neighbor_node, p_ni_context->port_num)) {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "Link already exists\n");
@@ -256,8 +257,9 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 					       p_neighbor_node,
 					       p_ni_context->port_num);
 
+
 	osm_node_link(p_node, port_num, p_neighbor_node,
-		      p_ni_context->port_num);
+			      p_ni_context->port_num);
 
 	p_physp = osm_node_get_physp_ptr(p_node, port_num);
 	p_remote_physp = osm_node_get_physp_ptr(p_neighbor_node,
@@ -309,6 +311,10 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	context.pi_context.active_transition = FALSE;
 
 	for (; port < num_ports; port++) {
+		if (sm->p_subn->opt.ignore_ports_file &&
+		    lookup_ignore_port(&sm->ucast_mgr, node, port)) {
+                	continue;
+		}
 		status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
 				     IB_MAD_ATTR_PORT_INFO, cl_hton32(port),
 				     CL_DISP_MSGID_NONE, &context);
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 1b73834..8ed7557 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1087,6 +1087,15 @@ static void do_sweep(osm_sm_t * sm)
 				"osm_subn_rescan_conf_file failed\n");
 		else
 			config_parsed = 1;
+		if (sm->p_subn->opt.ignore_ports_file) {
+                        boolean_t ports_removed, ports_added;
+			ports_removed = delete_ports_to_ignore(&sm->ucast_mgr);
+			ports_added = setup_ports_to_ignore(&sm->ucast_mgr);
+                        if (ports_removed || ports_added) {
+                                sm->p_subn->force_reroute = TRUE;
+		                sm->p_subn->ignore_existing_lfts = TRUE;
+                        }
+		}
 	}
 
 	if (sm->p_subn->sm_state != IB_SMINFO_STATE_MASTER &&
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7ab1671..cfbf85e 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -735,6 +735,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "polling_retry_number", OPT_OFFSET(polling_retry_number), opts_parse_uint32, NULL, 1 },
 	{ "force_heavy_sweep", OPT_OFFSET(force_heavy_sweep), opts_parse_boolean, NULL, 1 },
 	{ "port_prof_ignore_file", OPT_OFFSET(port_prof_ignore_file), opts_parse_charp, NULL, 0 },
+	{ "ignore_ports_file", OPT_OFFSET(ignore_ports_file), opts_parse_charp, NULL, 0 },
 	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_parse_charp, NULL, 0 },
 	{ "dimn_ports_file", OPT_OFFSET(port_search_ordering_file), opts_parse_charp, NULL, 0 },
 	{ "port_search_ordering_file", OPT_OFFSET(port_search_ordering_file), opts_parse_charp, NULL, 0 },
@@ -1009,6 +1010,7 @@ static void subn_opt_destroy(IN osm_subn_opt_t * p_opt)
 {
 	free(p_opt->console);
 	free(p_opt->port_prof_ignore_file);
+	free(p_opt->ignore_ports_file);
 	free(p_opt->hop_weights_file);
 	free(p_opt->port_search_ordering_file);
 	free(p_opt->routing_engine_names);
@@ -1511,6 +1513,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->qos_policy_file = strdup(OSM_DEFAULT_QOS_POLICY_FILE);
 	p_opt->accum_log_file = TRUE;
 	p_opt->port_prof_ignore_file = NULL;
+	p_opt->ignore_ports_file = NULL;
 	p_opt->hop_weights_file = NULL;
 	p_opt->port_search_ordering_file = NULL;
 	p_opt->port_profile_switch_nodes = FALSE;
@@ -2363,6 +2366,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->port_prof_ignore_file : null_str);
 
 	fprintf(out,
+		"# Name of file with port guids to be ignored in discovery\n"
+		"ignore_ports_file %s\n\n", p_opts->ignore_ports_file ?
+		p_opts->ignore_ports_file : null_str);
+
+	fprintf(out,
 		"# The file holding routing weighting factors per output port\n"
 		"hop_weights_file %s\n\n",
 		p_opts->hop_weights_file ? p_opts->hop_weights_file : null_str);
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 12db434..153231a 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -79,6 +79,99 @@ void osm_ucast_mgr_destroy(IN osm_ucast_mgr_t * p_mgr)
 	OSM_LOG_EXIT(p_mgr->p_log);
 }
 
+static int set_ports_to_ignore(void *ctx, uint64_t guid, char *p)
+{
+	osm_ucast_mgr_t *m = ctx;
+	unsigned port;
+	port_to_ignore_t *p_p2i;
+	cl_list_obj_t *p_obj;
+	
+	if (!p || !*p || !(port = strtoul(p, NULL, 0))) {
+		OSM_LOG(m->p_log, OSM_LOG_DEBUG,
+			"bad port specified for guid 0x%016" PRIx64 "\n", guid);
+		return 1;
+	}
+
+	p_p2i = malloc(sizeof(port_to_ignore_t));
+	if (NULL == p_p2i) {
+		OSM_LOG(m->p_log, OSM_LOG_ERROR,
+			"could not allocate the port to ignore object\n");
+		return 1;
+	}
+
+	memset(p_p2i, 0, sizeof(port_to_ignore_t));
+	p_p2i->guid = guid;
+	p_p2i->port = port;
+	p_obj = malloc(sizeof(cl_list_obj_t));
+	if (NULL == p_obj) {
+		OSM_LOG(m->p_log, OSM_LOG_ERROR,
+			"could not allocate the port to ignore list item\n");
+		return 1;
+	}
+
+	memset(p_obj, 0, sizeof(cl_list_obj_t));
+	cl_qlist_set_obj(p_obj, p_p2i);
+
+	cl_qlist_insert_head(&m->ports_to_ignore, &p_obj->list_item);
+	return 0;
+}
+
+boolean_t delete_ports_to_ignore(IN osm_ucast_mgr_t * p_mgr)
+{
+	cl_list_obj_t *p_obj;
+	port_to_ignore_t *p2i;
+
+        if (cl_is_qlist_empty(&p_mgr->ports_to_ignore))
+                return FALSE;
+        while (!cl_is_qlist_empty(&p_mgr->ports_to_ignore)) {
+		cl_list_item_t *item = cl_qlist_remove_head(&p_mgr->ports_to_ignore);
+		p_obj = PARENT_STRUCT(item, cl_list_obj_t, list_item);
+		p2i = (port_to_ignore_t *) cl_qlist_obj(p_obj);
+		free(p2i);
+		free(item);
+        }
+        return TRUE;
+}
+
+boolean_t setup_ports_to_ignore(IN osm_ucast_mgr_t * p_mgr)
+{
+	cl_qlist_init(&p_mgr->ports_to_ignore);
+	OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
+		"Fetching ignore ports file \'%s\'\n",
+		p_mgr->p_subn->opt.ignore_ports_file);
+	if (parse_node_map(p_mgr->p_subn->opt.ignore_ports_file,
+			   set_ports_to_ignore, p_mgr)) {
+		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR: "
+			"cannot parse ignore_ports_file \'%s\'\n",
+			p_mgr->p_subn->opt.ignore_ports_file);
+	}
+        return (!cl_is_qlist_empty(&p_mgr->ports_to_ignore));
+}
+
+boolean_t lookup_ignore_port(IN osm_ucast_mgr_t * p_mgr, osm_node_t * p_node,
+                                    const uint8_t port_num)
+{
+        cl_list_item_t *item;
+        cl_list_obj_t *p_obj = NULL;
+        port_to_ignore_t *p2i;
+
+        for (item = cl_qlist_head(&p_mgr->ports_to_ignore);
+             item != cl_qlist_end(&p_mgr->ports_to_ignore);
+             item = cl_qlist_next(item)) {
+                p_obj = PARENT_STRUCT(item, cl_list_obj_t, list_item);
+                p2i = (port_to_ignore_t *) cl_qlist_obj(p_obj);
+                if (cl_ntoh64(osm_node_get_node_guid(p_node)) ==
+                    p2i->guid && port_num == p2i->port) {
+                        OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
+                                "Ignoring guid 0x%016" PRIx64 ", port %d\n",
+                                p2i->guid, p2i->port);
+                        return TRUE;
+                }
+        }
+        return FALSE;
+}
+
+
 ib_api_status_t osm_ucast_mgr_init(IN osm_ucast_mgr_t * p_mgr, IN osm_sm_t * sm)
 {
 	ib_api_status_t status = IB_SUCCESS;
@@ -95,6 +188,9 @@ ib_api_status_t osm_ucast_mgr_init(IN osm_ucast_mgr_t * p_mgr, IN osm_sm_t * sm)
 	if (sm->p_subn->opt.use_ucast_cache)
 		cl_qmap_init(&p_mgr->cache_sw_tbl);
 
+	if (p_mgr->p_subn->opt.ignore_ports_file)
+		setup_ports_to_ignore(p_mgr);
+
 	OSM_LOG_EXIT(p_mgr->p_log);
 	return status;
 }
-- 
1.7.1


--------------080009060609010008060203--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
