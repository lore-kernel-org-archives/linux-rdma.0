From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCHv2] do not use the dimn_ports_file if not using
 dor routing
Date: Tue, 28 Jun 2011 21:01:10 +0300
Message-ID: <20110628180110.GF17645@calypso.voltaire.com>
References: <1303322533.21002.121.camel@auk59.llnl.gov>
 <20110427105005.GA2410@calypso.voltaire.com>
 <1303924075.21002.273.camel@auk59.llnl.gov>
 <20110628084935.GD17645@calypso.voltaire.com>
 <1309280836.19100.69.camel@auk59.llnl.gov>
 <20110628173327.GE17645@calypso.voltaire.com>
 <20110628105255.cab217d8.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110628105255.cab217d8.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 -dimn_ports_file flag is suitable not only for DOR, but
 also for general routing algorithm. While for DOR it
 defines the mapping between ports and dimensions, for
 general case it might be used to define non default
 port order that would be chosen for routing in each
 switch.

--
Changes in v2: leave --dimn_ports_file in opensm.conf

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |    2 +-
 include/opensm/osm_switch.h |    6 ++--
 man/opensm.8.in             |   27 ++++++++++++++++++++++-
 opensm/main.c               |   17 ++++++++++----
 opensm/osm_subnet.c         |   10 +++++---
 opensm/osm_switch.c         |    4 +-
 opensm/osm_ucast_mgr.c      |   48 +++++++++++++++++++++---------------------
 7 files changed, 73 insertions(+), 41 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 3095524..d41ba13 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -189,7 +189,7 @@ typedef struct osm_subn_opt {
 	uint16_t console_port;
 	char *port_prof_ignore_file;
 	char *hop_weights_file;
-	char *dimn_ports_file;
+	char *port_search_ordering_file;
 	boolean_t port_profile_switch_nodes;
 	boolean_t sweep_on_trap;
 	char *routing_engine_names;
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index f407dd9..ccd02e0 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -100,7 +100,7 @@ typedef struct osm_switch {
 	uint16_t num_hops;
 	uint8_t **hops;
 	osm_port_profile_t *p_prof;
-	uint8_t *dimn_ports;
+	uint8_t *search_ordering_ports;
 	uint8_t *lft;
 	uint8_t *new_lft;
 	uint16_t lft_size;
@@ -885,9 +885,9 @@ static inline uint8_t osm_switch_get_dimn_port(IN const osm_switch_t * p_sw,
 					       IN uint8_t port_num)
 {
 	CL_ASSERT(p_sw);
-	if (p_sw->dimn_ports == NULL)
+	if (p_sw->search_ordering_ports == NULL)
 		return port_num;
-	return p_sw->dimn_ports[port_num];
+	return p_sw->search_ordering_ports[port_num];
 }
 /*
 * PARAMETERS
diff --git a/man/opensm.8.in b/man/opensm.8.in
index c026f3a..15512cc 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -37,7 +37,8 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-console-port <port>]
 [\-i(gnore-guids) <equalize-ignore-guids-file>]
 [\-w | \-\-hop_weights_file <path to file>]
-[\-O | \-\-dimn_ports_file <path to file>]
+[\-O | \-\-port_search_ordering_file <path to file>]
+[\-O | \-\-dimn_ports_file <path to file>] (DEPRECATED)
 [\-f <log file path> | \-\-log_file <log file path> ]
 [\-L | \-\-log_limit <size in MB>] [\-e(rase_log_file)]
 [\-P(config) <partition config file> ]
@@ -277,7 +278,29 @@ factor of 1.  Lines starting with # are comments.  Weights affect only the
 output route from the port, so many useful configurations will require weights
 to be specified in pairs.
 .TP
-\fB\-O\fR, \fB\-\-dimn_ports_file\fR <path to file>
+\fB\-O\fR, \fB\-\-port_search_ordering_file\fR <path to file>
+This option tweaks the routing. It suitable for two cases:
+1. While using DOR routing algorithm.
+This option provides a mapping between hypercube dimensions and ports
+on a per switch basis for the DOR routing engine.  The file consists
+of lines containing a switch node GUID (specified as a 64 bit hex
+number, with leading 0x) followed by a list of non-zero port numbers,
+separated by spaces, one switch per line.  The order for the port
+numbers is in one to one correspondence to the dimensions.  Ports not
+listed on a line are assigned to the remaining dimensions, in port
+order.  Anything after a # is a comment.
+2. While using general routing algorithm.
+This option provides the order of the ports that would be chosen for routing,
+from each switch rather than searching for an appropriate port from port 1 to N.
+The file consists of lines containing a switch node GUID (specified as a 64 bit
+hex number, with leading 0x) followed by a list of non-zero port numbers,
+separated by spaces, one switch per line.  In case of DOR, the order for the
+port numbers is in one to one correspondence to the dimensions.  Ports not
+listed on a line are assigned to the remaining dimensions, in port
+order.  Anything after a # is a comment.
+.TP
+\fB\-O\fR, \fB\-\-dimn_ports_file\fR <path to file> \fB(DEPRECATED)\fR
+This is a deprecated flag. Please use \fB-port_search_ordering_file\fR instead.
 This option provides a mapping between hypercube dimensions and ports
 on a per switch basis for the DOR routing engine.  The file consists
 of lines containing a switch node GUID (specified as a 64 bit hex
diff --git a/opensm/main.c b/opensm/main.c
index 5be36b6..2d4dd9f 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -282,7 +282,14 @@ static void show_usage(void)
 	       "          This option provides the means to define a weighting\n"
 	       "          factor per port for customizing the least weight\n"
 	       "          hops for the routing.\n\n");
-	printf("--dimn_ports_file, -O <path to file>\n"
+	printf("--port_search_ordering_file, -O <path to file>\n"
+	       "          This option provides the means to define a mapping\n"
+	       "          between ports and dimension (Order) for controlling\n"
+	       "          Dimension Order Routing (DOR).\n"
+	       "          Moreover this option provides the means to define non\n"
+	       "          default routing port order.\n\n");
+	printf("--dimn_ports_file, -O <path to file> (DEPRECATED)\n"
+	       "          Use --port_search_ordering_file instead.\n"
 	       "          This option provides the means to define a mapping\n"
 	       "          between ports and dimension (Order) for controlling\n"
 	       "          Dimension Order Routing (DOR).\n\n");
@@ -571,7 +578,7 @@ int main(int argc, char *argv[])
 		{"guid", 1, NULL, 'g'},
 		{"ignore_guids", 1, NULL, 'i'},
 		{"hop_weights_file", 1, NULL, 'w'},
-		{"dimn_ports_file", 1, NULL, 'O'},
+		{"port_search_ordering_file", 1, NULL, 'O'},
 		{"lmc", 1, NULL, 'l'},
 		{"sweep", 1, NULL, 's'},
 		{"timeout", 1, NULL, 't'},
@@ -713,9 +720,9 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'O':
-			opt.dimn_ports_file = optarg;
-			printf(" Dimension Ports File = %s\n",
-			       opt.dimn_ports_file);
+			opt.port_search_ordering_file = optarg;
+			printf(" Port Search Ordering/Dimension Ports File = %s\n",
+			       opt.port_search_ordering_file);
 			break;
 
 		case 'g':
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index e7ff0ec..a9ba3a0 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -329,6 +329,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "port_prof_ignore_file", OPT_OFFSET(port_prof_ignore_file), opts_parse_charp, NULL, 0 },
 	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_parse_charp, NULL, 0 },
 	{ "dimn_ports_file", OPT_OFFSET(dimn_ports_file), opts_parse_charp, NULL, 0 },
+	{ "port_search_ordering_file", OPT_OFFSET(port_search_ordering_file), opts_parse_charp, NULL, 0 },
 	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
 	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
 	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
@@ -762,7 +763,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->accum_log_file = TRUE;
 	p_opt->port_prof_ignore_file = NULL;
 	p_opt->hop_weights_file = NULL;
-	p_opt->dimn_ports_file = NULL;
+	p_opt->port_search_ordering_file = NULL;
 	p_opt->port_profile_switch_nodes = FALSE;
 	p_opt->sweep_on_trap = TRUE;
 	p_opt->use_ucast_cache = FALSE;
@@ -1402,9 +1403,10 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->hop_weights_file ? p_opts->hop_weights_file : null_str);
 
 	fprintf(out,
-		"# The file holding non-default port order per switch for DOR routing \n"
-		"dimn_ports_file %s\n\n",
-		p_opts->dimn_ports_file ? p_opts->dimn_ports_file : null_str);
+		"# The file holding non-default port order per switch for routing\n"
+		"port_search_ordering_file %s\n\n",
+		p_opts->port_search_ordering_file ?
+		p_opts->port_search_ordering_file : null_str);
 
 	fprintf(out,
 		"# Routing engine\n"
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index fbb8292..89c5c9e 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -78,8 +78,8 @@ void osm_switch_delete(IN OUT osm_switch_t ** pp_sw)
 	osm_mcast_tbl_destroy(&p_sw->mcast_tbl);
 	if (p_sw->p_prof)
 		free(p_sw->p_prof);
-	if (p_sw->dimn_ports)
-		free(p_sw->dimn_ports);
+	if (p_sw->search_ordering_ports)
+		free(p_sw->search_ordering_ports);
 	if (p_sw->lft)
 		free(p_sw->lft);
 	if (p_sw->new_lft)
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 600bb10..72fdafb 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -488,12 +488,12 @@ static void set_default_hop_wf(cl_map_item_t * p_map_item, void *ctx)
 	}
 }
 
-static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
+static int set_search_ordering_ports(void *ctx, uint64_t guid, char *p)
 {
 	osm_subn_t *p_subn = ctx;
 	osm_node_t *node = osm_get_node_by_guid(p_subn, cl_hton64(guid));
 	osm_switch_t *sw;
-	uint8_t *dimn_ports = NULL;
+	uint8_t *search_ordering_ports = NULL;
 	uint8_t port;
 	unsigned int *ports = NULL;
 	const int bpw = sizeof(*ports)*8;
@@ -507,20 +507,20 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 		return 0;
 	}
 
-	if (sw->dimn_ports) {
+	if (sw->search_ordering_ports) {
 		OSM_LOG(&p_subn->p_osm->log, OSM_LOG_VERBOSE,
 			"switch with guid 0x%016" PRIx64 " already listed\n",
 			guid);
 		return 0;
 	}
 
-	dimn_ports = malloc(sizeof(*dimn_ports)*sw->num_ports);
-	if (!dimn_ports) {
+	search_ordering_ports = malloc(sizeof(*search_ordering_ports)*sw->num_ports);
+	if (!search_ordering_ports) {
 		OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR,
-			"ERR 3A07: cannot allocate memory for dimn_ports\n");
+			"ERR 3A07: cannot allocate memory for search_ordering_ports\n");
 		return -1;
 	}
-	memset(dimn_ports, 0, sizeof(*dimn_ports)*sw->num_ports);
+	memset(search_ordering_ports, 0, sizeof(*search_ordering_ports)*sw->num_ports);
 
 	/* the ports array is for record keeping of which ports have
 	 * been seen */
@@ -529,7 +529,7 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 	if (!ports) {
 		OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR,
 			"ERR 3A08: cannot allocate memory for ports\n");
-		free(dimn_ports);
+		free(search_ordering_ports);
 		return -1;
 	}
 	memset(ports, 0, words*sizeof(*ports));
@@ -543,7 +543,7 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_VERBOSE,
 				"bad port %d specified for guid 0x%016" PRIx64 "\n",
 				port, guid);
-			free(dimn_ports);
+			free(search_ordering_ports);
 			free(ports);
 			return 0;
 		}
@@ -552,13 +552,13 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_VERBOSE,
 				"port %d already specified for guid 0x%016" PRIx64 "\n",
 				port, guid);
-			free(dimn_ports);
+			free(search_ordering_ports);
 			free(ports);
 			return 0;
 		}
 
 		ports[port/bpw] |= (1u << (port%bpw));
-		dimn_ports[i++] = port;
+		search_ordering_ports[i++] = port;
 
 		p = e;
 		while (isspace(*p)) {
@@ -568,17 +568,17 @@ static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
 
 	if (i > 1) {
 		for (port = 1; port < sw->num_ports; port++) {
-			/* fill out the rest of the dimn_ports array
+			/* fill out the rest of the search_ordering_ports array
 			 * in sequence using the remaining unspecified
 			 * ports.
 			 */
 			if (!(ports[port/bpw] & (1u << (port%bpw)))) {
-				dimn_ports[i++] = port;
+				search_ordering_ports[i++] = port;
 			}
 		}
-		sw->dimn_ports = dimn_ports;
+		sw->search_ordering_ports = search_ordering_ports;
 	} else {
-		free(dimn_ports);
+		free(search_ordering_ports);
 	}
 
 	free(ports);
@@ -684,21 +684,21 @@ static int ucast_mgr_setup_all_switches(osm_subn_t * p_subn)
 					  (p_sw->p_node)));
 			return -1;
 		}
-		if (p_sw->dimn_ports) {
-			free(p_sw->dimn_ports);
-			p_sw->dimn_ports = NULL;
+		if (p_sw->search_ordering_ports) {
+			free(p_sw->search_ordering_ports);
+			p_sw->search_ordering_ports = NULL;
 		}
 	}
 
-	if (p_subn->opt.dimn_ports_file) {
+	if (p_subn->opt.port_search_ordering_file) {
 		OSM_LOG(&p_subn->p_osm->log, OSM_LOG_DEBUG,
 			"Fetching dimension ports file \'%s\'\n",
-			p_subn->opt.dimn_ports_file);
-		if (parse_node_map(p_subn->opt.dimn_ports_file,
-				   set_dimn_ports, p_subn)) {
+			p_subn->opt.port_search_ordering_file);
+		if (parse_node_map(p_subn->opt.port_search_ordering_file,
+				   set_search_ordering_ports, p_subn)) {
 			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, "ERR 3A05: "
-				"cannot parse dimn_ports_file \'%s\'\n",
-				p_subn->opt.dimn_ports_file);
+				"cannot parse port_search_ordering_file \'%s\'\n",
+				p_subn->opt.port_search_ordering_file);
 		}
 	}
 
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
