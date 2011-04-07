From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options (repost)
Date: Wed, 06 Apr 2011 17:56:56 -0700
Message-ID: <1302137816.4906.403.camel@auk59.llnl.gov>
References: <1297388014.18394.302.camel@auk59.llnl.gov>
	 <1300915898.3128.168.camel@auk59.llnl.gov>
	 <20110406140929.GA21920@calypso.voltaire.com>
	 <1302113667.4906.336.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-fnQCic+KhKCO13AgaJoB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302113667.4906.336.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-fnQCic+KhKCO13AgaJoB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Alex, Jared,

On Wed, 2011-04-06 at 11:14 -0700, Albert Chu wrote:
> Hey Alex,
> 
> On Wed, 2011-04-06 at 07:09 -0700, Alex Netes wrote:
> > Hi Al, Jared,
> > 
> > On 14:31 Wed 23 Mar     , Albert Chu wrote:
> > > > 
> > > > 1) Port Shifting
> > > > 
> > > > This is similar to what was done with some of the LMC > 0 code.
> > > > Congestion would occur due to "alignment" of routes w/ common traffic
> > > > patterns.  However, we found that it was also necessary for LMC=0 and
> > > > only for used-ports.  For example, lets say there are 4 ports (called A,
> > > > B, C, D) and we are routing lids 1-9 through them.  Suppose only routing
> > > > through A, B, and C will reach lids 1-9.
> > > > 
> > > > The LFT would normally be:
> > > > 
> > > > A: 1 4 7
> > > > B: 2 5 8
> > > > C: 3 6 9
> > > > D:
> > > > 
> > > > The Port Shifting option would make this:
> > > > 
> > > > A: 1 6 8
> > > > B: 2 4 9
> > > > C: 3 5 7
> > > > D:
> > > > 
> > > > This option by itself improved the mpiGraph average send/recv bandwidth
> > > > from 420 MB/s and 508 MB/s to to 991 MB/s and 1172 MB/s.
> > > > 
> > 
> > After thinking about this a little more and reviewing Jared Carr's - Scatter ports
> > patch, I think we should combine these efforts into one framework as Al
> > suggested.

As I was beginning to integrate Jared's patch with mine, it ends up that
algorithmically/architecturally, it isn't as easy (or similar) as I had
originally thought.  In particular, it has issues with LMC > 0.
Normally you want to route through a port that is least forwarded
through or goes through systems it hasn't seen yet.  This sort of
conflicts with the idea of selecting a port randomly.

I'm going to throw out the following patch series as a starting point
for discussion on scatter ports.  My original two patches have been
updated with new log messages and some minor tweaks.

My attempt of integration of Jared's scatter patch is included.  It has
a variety of cleanup (b/c of conflicts w/ my patches), 1 or 2 gotchas I
caught, and various tweaks for code consistency with my patches/other
OpenSM code.  Jared's original code algorithm is largely unchanged, but
I did modify it to deal with LMC > 0 better (by basically ignoring LMC).

Jared, LMK what you think and if it'll work for you.

Al

P.S.  Jared, I made you author on the 3rd patch naturally.

> Moreover, isn't "port_shifting" too much fabric oriented? Do
> > general OpenSM users will find this useful for them?
> > Moreover, how can user identify that port_shifting may improve performance for
> > him.
> 
> I will admit, I'm unsure of how much non-HPC users would benefit from
> this option, be hurt by it, or if they would even care.  I can't speak
> for all users, but here at LLNL and at most of the lab HPC sites, people
> play with the options and experiment to find the best routing algorithm
> + settings that support their environment.  I would imagine the
> port_shifting option would just be another option for people to
> experiment with.
> 
> I think adding Jared's Scatter Ports would be easy to merge into my line
> of patches.  Let me see if I can integrate his patch into my line
> easily.
> 
> > Is providing shift factor (more than the suggested 1) will help to make it
> > suitable foo a general case?
> 
> That seems like a good idea, we certainly could support an arbitrary
> shift, allowing users to experiment if there is a better one for their
> particular environment.
> 
> > > > 2) Remote Guid Sorting
> > > > 
> > > > Most core/spine switches we've seen thus far have had line boards
> > > > connected to spine boards in a consistent pattern.  However, we recently
> > > > got some Qlogic switches that connect from line/leaf boards to spine
> > > > boards in a (to the casual observer) random pattern.  I'm sure there was
> > > > a good electrical/board reason for this design, but it does hurt routing
> > > > b/c updn doesn't account for this.  Here's an output from iblinkinfo as
> > > > an example.
> > > > 
> > 
> > Why this problem can't be addressed by guid_routing_order_file option?
> 
> The problem we encountered in our fabric is predominantly a
> switch-to-switch routing issue with a spine switch.  The
> guid_routing_order_file wouldn't be able to solve this, since its input
> is just end ports.
> 
> Or another way to say it, this option directly affects the routing
> decisions made.  The guid_routing_order_file does not, it only affects
> the order in which routes are chosen (which can have consequences, but
> the routing algorithm itself is unchanged).
> 
> Al
> 
> > 
> > --Alex
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-fnQCic+KhKCO13AgaJoB
Content-Disposition: attachment; filename=0001-Support-port-shifting.patch
Content-Type: message/rfc822; name=0001-Support-port-shifting.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 6 Apr 2011 15:27:20 -0700
Subject: [PATCH 1/4] Support port shifting.
Message-Id: <1302137778.4906.399.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Similar to issues with LMC > 0, congestion can occur due to
"alignment" of routes w/ common traffic patterns.  For example, lets
say there are 4 ports (called A, B, C, D) and we are routing lids 1-9
through them.  Suppose only routing through A, B, and C will reach
lids 1-9.

The LFT would normally be:

A: 1 4 7
B: 2 5 8
C: 3 6 9
D:

The Port Shifting option would make this:

A: 1 6 8
B: 2 4 9
C: 3 5 7
D:

For some communication patterns, this can be superior.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    4 ++
 include/opensm/osm_switch.h |    6 ++-
 man/opensm.8.in             |    8 ++++
 opensm/main.c               |    8 ++++
 opensm/osm_dump.c           |    3 +-
 opensm/osm_subnet.c         |    7 +++
 opensm/osm_switch.c         |   98 ++++++++++++++++++++++++++++++++++++++++++-
 opensm/osm_ucast_mgr.c      |    3 +-
 8 files changed, 133 insertions(+), 4 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 42ae416..59f877e 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -199,6 +199,7 @@ typedef struct osm_subn_opt {
 	char *root_guid_file;
 	char *cn_guid_file;
 	char *io_guid_file;
+	boolean_t port_shifting;
 	uint16_t max_reverse_hops;
 	char *ids_guid_file;
 	char *guid_routing_order_file;
@@ -418,6 +419,9 @@ typedef struct osm_subn_opt {
 *		Name of the file that contains list of I/O node guids that
 *		will be used by fat-tree routing (provided by User)
 *
+*	port_shifting
+*		This option will turn on port_shifting in routing.
+*
 *	ids_guid_file
 *		Name of the file that contains list of ids which should be
 *		used by Up/Down algorithm instead of node GUIDs
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index f407dd9..8eae119 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -919,7 +919,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
-				  IN boolean_t dor);
+				  IN boolean_t dor,
+				  IN boolean_t port_shifting);
 /*
 * PARAMETERS
 *	p_sw
@@ -955,6 +956,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 *	dor
 *		[in] If TRUE, Dimension Order Routing will be done.
 *
+*	port_shifting
+*		[in] If TRUE, port_shifting will be done.
+*
 * RETURN VALUE
 *	Returns the recommended port on which to route this LID.
 *
diff --git a/man/opensm.8.in b/man/opensm.8.in
index c026f3a..f5b4fb9 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -25,6 +25,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-a | \-\-root_guid_file <path to file>]
 [\-u | \-\-cn_guid_file <path to file>]
 [\-G | \-\-io_guid_file <path to file>]
+[\-\-port\-shifting]
 [\-H | \-\-max_reverse_hops <max reverse hops allowed>]
 [\-X | \-\-guid_routing_order_file <path to file>]
 [\-m | \-\-ids_guid_file <path to file>]
@@ -208,6 +209,13 @@ to the guids provided in the given file (one to a line).
 I/O nodes are non-CN nodes allowed to use up to max_reverse_hops switches
 the wrong way around to improve connectivity.
 .TP
+\fB\-\-port\-shifting\fR
+This option enables a feature called \fBport shifting\fR.  In some
+fabrics, particularly cluster environments, routes commonly align and
+congest with other routes due to algorithmically unchanging traffic
+patterns.  This routing option will "shift" routing around in an
+attempt to alleviate this problem.
+.TP
 \fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
 Set the maximum number of reverse hops an I/O node is allowed
 to make. A reverse hop is the use of a switch the wrong way around.
diff --git a/opensm/main.c b/opensm/main.c
index 5be36b6..5d5bbe1 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -223,6 +223,9 @@ static void show_usage(void)
 	printf("--io_guid_file, -G <path to file>\n"
 	       "          Set the I/O nodes for the Fat-Tree routing algorithm\n"
 	       "          to the guids provided in the given file (one to a line)\n\n");
+	printf("--port-shifting\n"
+	       "          Attempt to shift port routes around to remove alignment problems\n"
+	       "          in routing tables\n\n");
 	printf("--max_reverse_hops, -H <hop_count>\n"
 	       "          Set the max number of hops the wrong way around\n"
 	       "          an I/O node is allowed to do (connectivity for I/O nodes on top swithces)\n\n");
@@ -601,6 +604,7 @@ int main(int argc, char *argv[])
 		{"root_guid_file", 1, NULL, 'a'},
 		{"cn_guid_file", 1, NULL, 'u'},
 		{"io_guid_file", 1, NULL, 'G'},
+		{"port-shifting", 0, NULL, 11},
 		{"max_reverse_hops", 1, NULL, 'H'},
 		{"ids_guid_file", 1, NULL, 'm'},
 		{"guid_routing_order_file", 1, NULL, 'X'},
@@ -943,6 +947,10 @@ int main(int argc, char *argv[])
 			opt.io_guid_file = optarg;
 			printf(" I/O Node Guid File: %s\n", opt.io_guid_file);
 			break;
+		case 11:
+			opt.port_shifting = TRUE;
+			printf(" Port Shifting is on\n");
+			break;
 		case 'H':
 			opt.max_reverse_hops = atoi(optarg);
 			printf(" Max Reverse Hops: %d\n", opt.max_reverse_hops);
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 535a03f..b128ddb 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -221,7 +221,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			/* No LMC Optimization */
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
-							      FALSE, dor);
+							      FALSE, dor,
+							      p_osm->subn.opt.port_shifting);
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 228418f..c62192c 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -347,6 +347,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "root_guid_file", OPT_OFFSET(root_guid_file), opts_parse_charp, NULL, 0 },
 	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_parse_charp, NULL, 0 },
 	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_parse_charp, NULL, 0 },
+	{ "port_shifting", OPT_OFFSET(port_shifting), opts_parse_boolean, NULL, 1 },
 	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
 	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
@@ -740,6 +741,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->root_guid_file = NULL;
 	p_opt->cn_guid_file = NULL;
 	p_opt->io_guid_file = NULL;
+	p_opt->port_shifting = FALSE;
 	p_opt->max_reverse_hops = 0;
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
@@ -1440,6 +1442,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->lash_start_vl);
 
 	fprintf(out,
+		"# Port Shifting (use FALSE if unsure)\n"
+		"port_shifting %s\n\n",
+		p_opts->port_shifting ? "TRUE" : "FALSE");
+
+	fprintf(out,
 		"# SA database file name\nsa_db_file %s\n\n",
 		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);
 
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 9785a9d..f24d9ea 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -51,6 +51,14 @@
 #include <iba/ib_types.h>
 #include <opensm/osm_switch.h>
 
+struct switch_port_path {
+	uint8_t port_num;
+	uint32_t path_count;
+	int found_sys_guid;
+	int found_node_guid;
+	uint32_t forwarded_to;
+};
+
 cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
 				IN uint8_t port_num, IN uint8_t num_hops)
 {
@@ -217,7 +225,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
-				  IN boolean_t dor)
+				  IN boolean_t dor,
+				  IN boolean_t port_shifting)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -259,6 +268,11 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	osm_node_t *p_rem_node_first = NULL;
 	struct osm_remote_node *p_remote_guid = NULL;
 	struct osm_remote_node null_remote_node = {NULL, 0, 0};
+	struct switch_port_path port_paths[IB_NODE_NUM_PORTS_MAX];
+	unsigned int port_paths_total_paths = 0;
+	unsigned int port_paths_count = 0;
+	int found_sys_guid;
+	int found_node_guid;
 
 	CL_ASSERT(lid_ho > 0);
 
@@ -369,6 +383,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 		check_count =
 		    osm_port_prof_path_count_get(&p_sw->p_prof[port_num]);
 
+
 		if (dor) {
 			/* Get the Remote Node */
 			p_rem_physp = osm_physp_get_remote(p_physp);
@@ -412,7 +427,10 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 					best_port_other_sys = port_num;
 					least_forwarded_to = 0;
 				}
+				found_sys_guid = 0;
 			} else {	/* same sys found - try node */
+
+
 				/* Else is the node guid already used ? */
 				p_remote_guid = switch_find_node_guid_count(p_sw,
 									    p_port->priv,
@@ -427,9 +445,27 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				}
 				/* else prior sys and node guid already used */
 
+				if (!p_remote_guid)
+					found_node_guid = 0;
+				else
+					found_node_guid = 1;
+				found_sys_guid = 1;
 			}	/* same sys found */
 		}
 
+		port_paths[port_paths_count].port_num = port_num;
+		port_paths[port_paths_count].path_count = check_count;
+		if (routing_for_lmc) {
+			port_paths[port_paths_count].found_sys_guid = found_sys_guid;
+			port_paths[port_paths_count].found_node_guid = found_node_guid;
+		}
+		if (routing_for_lmc && p_remote_guid)
+			port_paths[port_paths_count].forwarded_to = p_remote_guid->forwarded_to;
+		else
+			port_paths[port_paths_count].forwarded_to = 0;
+		port_paths_total_paths += check_count;
+		port_paths_count++;
+
 		/* routing for LMC mode */
 		/*
 		   the count is min but also lower then the max subscribed
@@ -454,6 +490,66 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	if (port_found == FALSE)
 		return OSM_NO_PATH;
 
+	if (port_shifting && port_paths_count) {
+		/* In the port_paths[] array, we now have all the ports that we
+		 * can route out of.  Using some shifting math below, possibly
+		 * select a different one so that lids won't align in LFTs
+		 *
+		 * If lmc > 0, we need to loop through these ports to find the
+		 * least_forwarded_to port, best_port_other_sys, and
+		 * best_port_other_node just like before but through the different
+		 * ordering.
+		 */
+
+		least_paths = 0xFFFFFFFF;
+        	least_paths_other_sys = 0xFFFFFFFF;
+        	least_paths_other_nodes = 0xFFFFFFFF;
+	        least_forwarded_to = 0xFFFFFFFF;
+		best_port = 0;
+        	best_port_other_sys = 0;
+        	best_port_other_node = 0;
+
+		for (i = 0; i < port_paths_count; i++) {
+			unsigned int idx;
+
+			idx = (port_paths_total_paths/port_paths_count + i) % port_paths_count;
+
+			if (routing_for_lmc) {
+				if (!port_paths[idx].found_sys_guid
+				    && port_paths[idx].path_count < least_paths_other_sys) {
+					least_paths_other_sys = port_paths[idx].path_count;
+					best_port_other_sys = port_paths[idx].port_num;
+					least_forwarded_to = 0;
+				}
+				else if (!port_paths[idx].found_node_guid
+					 && port_paths[idx].path_count < least_paths_other_nodes) {
+					least_paths_other_nodes = port_paths[idx].path_count;
+					best_port_other_node = port_paths[idx].port_num;
+					least_forwarded_to = 0;
+				}
+			}
+
+			if (port_paths[idx].path_count < least_paths) {
+				best_port = port_paths[idx].port_num;
+				least_paths = port_paths[idx].path_count;
+				if (routing_for_lmc
+				    && (port_paths[idx].found_sys_guid
+					|| port_paths[idx].found_node_guid)
+				    && port_paths[idx].forwarded_to < least_forwarded_to)
+					least_forwarded_to = port_paths[idx].forwarded_to;
+			}
+			else if (routing_for_lmc
+				 && (port_paths[idx].found_sys_guid
+				     || port_paths[idx].found_node_guid)
+				 && port_paths[idx].path_count == least_paths
+				 && port_paths[idx].forwarded_to < least_forwarded_to) {
+				least_forwarded_to = port_paths[idx].forwarded_to;
+				best_port = port_paths[idx].port_num;
+			}
+				
+		}
+	}
+	
 	/*
 	   if we are in enhanced routing mode and the best port is not
 	   the local port 0
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 4019589..d32eb60 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -255,7 +255,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 	port = osm_switch_recommend_path(p_sw, p_port, lid_ho, start_from,
 					 p_mgr->p_subn->ignore_existing_lfts,
 					 p_mgr->p_subn->opt.lmc,
-					 p_mgr->is_dor);
+					 p_mgr->is_dor,
+					 p_mgr->p_subn->opt.port_shifting);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
-- 
1.7.1


--=-fnQCic+KhKCO13AgaJoB
Content-Disposition: attachment; filename=0002-Support-remote-guid-sorting.patch
Content-Type: message/rfc822; name=0002-Support-remote-guid-sorting.patch

From: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>
Date: Wed, 6 Apr 2011 15:27:50 -0700
Subject: [PATCH 2/4] Support remote guid sorting.
Message-Id: <1302137778.4906.400.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Most core/spine switches have line boards connected to spine boards in
a consistent pattern.  For example (using 8 port switches as an
example):

Switch Lineboard L1
Port 5 - Uplink to Spine Switch S1 Port 1
Port 6 - Uplink to Spine Switch S2 Port 1
Port 7 - Uplink to Spine Switch S3 Port 1
Port 8 - Uplink to Spine Switch S4 Port 1

Switch Lineboard L2
Port 5 - Uplink to Spine Switch S1 Port 2
Port 6 - Uplink to Spine Switch S2 Port 2
Port 7 - Uplink to Spine Switch S3 Port 2
Port 8 - Uplink to Spine Switch S4 Port 2

However, some switches connect from line boards to spine
boards in a (to the casual observer) random pattern.  For example:

Switch Lineboard L1
Port 5 - Uplink to Spine Switch S4 Port 1
Port 6 - Uplink to Spine Switch S2 Port 3
Port 7 - Uplink to Spine Switch S1 Port 4
Port 8 - Uplink to Spine Switch S3 Port 2

Switch Lineboard L2
Port 5 - Uplink to Spine Switch S1 Port 3
Port 6 - Uplink to Spine Switch S4 Port 2
Port 7 - Uplink to Spine Switch S3 Port 1
Port 8 - Uplink to Spine Switch S2 Port 4

This option will slightly tweak routing so that rather than searching
for an appropriate port from port 1 to N, ports will be sorted by
remote guid, then chosen.  This ensures routing calculations across
multiple switches will be routed consistently, leading to better
performance for numerous communication patterns.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    4 ++++
 include/opensm/osm_switch.h |    6 +++++-
 man/opensm.8.in             |    7 +++++++
 opensm/main.c               |    8 ++++++++
 opensm/osm_dump.c           |    3 ++-
 opensm/osm_subnet.c         |    7 +++++++
 opensm/osm_switch.c         |   42 +++++++++++++++++++++++++++++++++++++-----
 opensm/osm_ucast_mgr.c      |    3 ++-
 8 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 59f877e..589e96c 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -200,6 +200,7 @@ typedef struct osm_subn_opt {
 	char *cn_guid_file;
 	char *io_guid_file;
 	boolean_t port_shifting;
+	boolean_t remote_guid_sorting;
 	uint16_t max_reverse_hops;
 	char *ids_guid_file;
 	char *guid_routing_order_file;
@@ -422,6 +423,9 @@ typedef struct osm_subn_opt {
 *	port_shifting
 *		This option will turn on port_shifting in routing.
 *
+*	remote_guid_sorting
+*		This option will turn on remote_guid_sorting in routing.
+*
 *	ids_guid_file
 *		Name of the file that contains list of ids which should be
 *		used by Up/Down algorithm instead of node GUIDs
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index 8eae119..aef45cb 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -920,7 +920,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
-				  IN boolean_t port_shifting);
+				  IN boolean_t port_shifting,
+				  IN boolean_t remote_guid_sorting);
 /*
 * PARAMETERS
 *	p_sw
@@ -959,6 +960,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 *	port_shifting
 *		[in] If TRUE, port_shifting will be done.
 *
+*	remote_guid_sorting
+*		[in] If TRUE, remote_guid_sorting will be done.
+*
 * RETURN VALUE
 *	Returns the recommended port on which to route this LID.
 *
diff --git a/man/opensm.8.in b/man/opensm.8.in
index f5b4fb9..b4456a8 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -26,6 +26,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-u | \-\-cn_guid_file <path to file>]
 [\-G | \-\-io_guid_file <path to file>]
 [\-\-port\-shifting]
+[\-\-remote\-guid\-sorting]
 [\-H | \-\-max_reverse_hops <max reverse hops allowed>]
 [\-X | \-\-guid_routing_order_file <path to file>]
 [\-m | \-\-ids_guid_file <path to file>]
@@ -216,6 +217,12 @@ congest with other routes due to algorithmically unchanging traffic
 patterns.  This routing option will "shift" routing around in an
 attempt to alleviate this problem.
 .TP
+\fB\-\-remote\-guid\-sorting\fR
+This option enables a feature called \fBremote guid sorting\fR.  In some
+fabrics, switches may be cabled in an inconsistent fashion.  This option
+may alleviate those issues by sorting remote guids before routing,
+making remote destinations appear to be ordered consistently.
+.TP
 \fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
 Set the maximum number of reverse hops an I/O node is allowed
 to make. A reverse hop is the use of a switch the wrong way around.
diff --git a/opensm/main.c b/opensm/main.c
index 5d5bbe1..e2e7355 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -226,6 +226,9 @@ static void show_usage(void)
 	printf("--port-shifting\n"
 	       "          Attempt to shift port routes around to remove alignment problems\n"
 	       "          in routing tables\n\n");
+	printf("--remote-guid-sorting\n"
+	       "          Sort ports by remote port guid before routing to alleviate\n"
+	       "          problems with inconsistent cabling across a fabric\n\n");
 	printf("--max_reverse_hops, -H <hop_count>\n"
 	       "          Set the max number of hops the wrong way around\n"
 	       "          an I/O node is allowed to do (connectivity for I/O nodes on top swithces)\n\n");
@@ -605,6 +608,7 @@ int main(int argc, char *argv[])
 		{"cn_guid_file", 1, NULL, 'u'},
 		{"io_guid_file", 1, NULL, 'G'},
 		{"port-shifting", 0, NULL, 11},
+		{"remote-guid-sorting", 0, NULL, 13},
 		{"max_reverse_hops", 1, NULL, 'H'},
 		{"ids_guid_file", 1, NULL, 'm'},
 		{"guid_routing_order_file", 1, NULL, 'X'},
@@ -951,6 +955,10 @@ int main(int argc, char *argv[])
 			opt.port_shifting = TRUE;
 			printf(" Port Shifting is on\n");
 			break;
+		case 13:
+			opt.remote_guid_sorting = TRUE;
+			printf(" Remote Guid Sorting is on\n");
+			break;
 		case 'H':
 			opt.max_reverse_hops = atoi(optarg);
 			printf(" Max Reverse Hops: %d\n", opt.max_reverse_hops);
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index b128ddb..b129737 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -222,7 +222,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
 							      FALSE, dor,
-							      p_osm->subn.opt.port_shifting);
+							      p_osm->subn.opt.port_shifting,
+							      p_osm->subn.opt.remote_guid_sorting);
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index c62192c..b2b219f 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -348,6 +348,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_parse_charp, NULL, 0 },
 	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_parse_charp, NULL, 0 },
 	{ "port_shifting", OPT_OFFSET(port_shifting), opts_parse_boolean, NULL, 1 },
+	{ "remote_guid_sorting", OPT_OFFSET(remote_guid_sorting), opts_parse_boolean, NULL, 1 },
 	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
 	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
@@ -742,6 +743,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->cn_guid_file = NULL;
 	p_opt->io_guid_file = NULL;
 	p_opt->port_shifting = FALSE;
+	p_opt->remote_guid_sorting = FALSE;
 	p_opt->max_reverse_hops = 0;
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
@@ -1447,6 +1449,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->port_shifting ? "TRUE" : "FALSE");
 
 	fprintf(out,
+		"# Remote Guid Sorting (use FALSE if unsure)\n"
+		"remote_guid_sorting %s\n\n",
+		p_opts->remote_guid_sorting ? "TRUE" : "FALSE");
+
+	fprintf(out,
 		"# SA database file name\nsa_db_file %s\n\n",
 		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);
 
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index f24d9ea..2584563 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -57,6 +57,7 @@ struct switch_port_path {
 	int found_sys_guid;
 	int found_node_guid;
 	uint32_t forwarded_to;
+	uint64_t remote_node_guid;
 };
 
 cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
@@ -169,6 +170,19 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
 	return TRUE;
 }
 
+static int
+port_path_guid_cmp(IN const void *x, IN const void *y)
+{
+	struct switch_port_path *a = (struct switch_port_path *)x;
+	struct switch_port_path *b = (struct switch_port_path *)y;
+
+	if (a->remote_node_guid < b->remote_node_guid)
+		return -1;
+	if (a->remote_node_guid > b->remote_node_guid)
+		return 1;
+	return 0;
+}
+
 static struct osm_remote_node *
 switch_find_guid_common(IN const osm_switch_t * p_sw,
 			IN struct osm_remote_guids_count *r,
@@ -226,7 +240,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t ignore_existing,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
-				  IN boolean_t port_shifting)
+				  IN boolean_t port_shifting,
+				  IN boolean_t remote_guid_sorting)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -428,6 +443,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 					least_forwarded_to = 0;
 				}
 				found_sys_guid = 0;
+				found_node_guid = 0;
 			} else {	/* same sys found - try node */
 
 
@@ -463,6 +479,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 			port_paths[port_paths_count].forwarded_to = p_remote_guid->forwarded_to;
 		else
 			port_paths[port_paths_count].forwarded_to = 0;
+		p_rem_physp = osm_physp_get_remote(p_physp);
+		p_rem_node = osm_physp_get_node_ptr(p_rem_physp);
+		port_paths[port_paths_count].remote_node_guid = p_rem_node->node_info.node_guid;
 		port_paths_total_paths += check_count;
 		port_paths_count++;
 
@@ -490,10 +509,15 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	if (port_found == FALSE)
 		return OSM_NO_PATH;
 
-	if (port_shifting && port_paths_count) {
+	if ((port_shifting
+	     || remote_guid_sorting)
+	    && port_paths_count) {
 		/* In the port_paths[] array, we now have all the ports that we
-		 * can route out of.  Using some shifting math below, possibly
-		 * select a different one so that lids won't align in LFTs
+		 * can route out of.  If port_shifting is set, using some shifting
+		 * math below, possibly select a different one so that lids won't
+		 * align in LFTs.  If it is not set, iterate through the array
+		 * normally.  New ports will be selected by virtue of a sort
+		 * done prior to port selection.
 		 *
 		 * If lmc > 0, we need to loop through these ports to find the
 		 * least_forwarded_to port, best_port_other_sys, and
@@ -508,11 +532,19 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 		best_port = 0;
         	best_port_other_sys = 0;
         	best_port_other_node = 0;
+	
+		if (remote_guid_sorting) {
+			qsort(port_paths, port_paths_count, sizeof(struct switch_port_path),
+			      port_path_guid_cmp);
+		}
 
 		for (i = 0; i < port_paths_count; i++) {
 			unsigned int idx;
 
-			idx = (port_paths_total_paths/port_paths_count + i) % port_paths_count;
+			if (port_shifting)
+				idx = (port_paths_total_paths/port_paths_count + i) % port_paths_count;
+			else
+				idx = i;
 
 			if (routing_for_lmc) {
 				if (!port_paths[idx].found_sys_guid
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index d32eb60..a8982df 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -256,7 +256,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 					 p_mgr->p_subn->ignore_existing_lfts,
 					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor,
-					 p_mgr->p_subn->opt.port_shifting);
+					 p_mgr->p_subn->opt.port_shifting,
+					 p_mgr->p_subn->opt.remote_guid_sorting);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
-- 
1.7.1


--=-fnQCic+KhKCO13AgaJoB
Content-Disposition: attachment; filename=0003-Support-scatter-ports.patch
Content-Type: message/rfc822; name=0003-Support-scatter-ports.patch

From: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>
Date: Wed, 6 Apr 2011 17:35:43 -0700
Subject: [PATCH 3/4] Support scatter ports.
Message-Id: <1302137778.4906.401.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

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

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_base.h   |   11 +++++++++++
 include/opensm/osm_subnet.h |    5 +++++
 include/opensm/osm_switch.h |    6 +++++-
 opensm/osm_dump.c           |    9 ++++++++-
 opensm/osm_subnet.c         |    8 ++++++++
 opensm/osm_switch.c         |   30 ++++++++++++++++++++++++++++--
 opensm/osm_ucast_mgr.c      |    8 +++++++-
 7 files changed, 72 insertions(+), 5 deletions(-)

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
index 589e96c..938084e 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -238,6 +238,7 @@ typedef struct osm_subn_opt {
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
+	uint32_t scatter_ports;
 } osm_subn_opt_t;
 /*
 * FIELDS
@@ -511,6 +512,10 @@ typedef struct osm_subn_opt {
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
index aef45cb..c3a0585 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -921,7 +921,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
 				  IN boolean_t port_shifting,
-				  IN boolean_t remote_guid_sorting);
+				  IN boolean_t remote_guid_sorting,
+				  IN uint32_t scatter_ports);
 /*
 * PARAMETERS
 *	p_sw
@@ -963,6 +964,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 *	remote_guid_sorting
 *		[in] If TRUE, remote_guid_sorting will be done.
 *
+*	scatter_ports
+*		[in] If not zero, randomize the selection of the best ports.
+*
 * RETURN VALUE
 *	Returns the recommended port on which to route this LID.
 *
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index b129737..f88ecbf 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -223,7 +223,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 							      lid_ho, 1, TRUE,
 							      FALSE, dor,
 							      p_osm->subn.opt.port_shifting,
-							      p_osm->subn.opt.remote_guid_sorting);
+							      p_osm->subn.opt.remote_guid_sorting,
+							      p_osm->subn.opt.scatter_ports);
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
@@ -626,6 +627,12 @@ void osm_dump_all(osm_opensm_t * osm)
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
index b2b219f..68bb7d3 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -404,6 +404,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
 	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
+	{ "scatter_ports", OPT_OFFSET(scatter_ports), opts_parse_uint32, NULL, 1 },
 	{0}
 };
 
@@ -759,6 +760,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
+	p_opt->scatter_ports = OSM_DEFAULT_SCATTER_PORTS;
 	subn_init_qos_options(&p_opt->qos_options, NULL);
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
 	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
@@ -1466,6 +1468,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
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
index 2584563..3c3a488 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -241,7 +241,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
 				  IN boolean_t port_shifting,
-				  IN boolean_t remote_guid_sorting)
+				  IN boolean_t remote_guid_sorting,
+				  IN uint32_t scatter_ports)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -258,9 +259,12 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
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
@@ -310,6 +314,14 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 
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
@@ -493,10 +505,17 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
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
@@ -592,8 +611,15 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
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
index a8982df..05af7e5 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -257,7 +257,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor,
 					 p_mgr->p_subn->opt.port_shifting,
-					 p_mgr->p_subn->opt.remote_guid_sorting);
+					 p_mgr->p_subn->opt.remote_guid_sorting,
+					 p_mgr->p_subn->opt.scatter_ports);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
@@ -1041,6 +1042,11 @@ static int ucast_mgr_route(struct osm_routing_engine *r, osm_opensm_t * osm)
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
1.7.1


--=-fnQCic+KhKCO13AgaJoB
Content-Disposition: attachment; filename=0004-Cleanup-scatter-ports-patch.patch
Content-Type: message/rfc822; name=0004-Cleanup-scatter-ports-patch.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 6 Apr 2011 17:40:22 -0700
Subject: [PATCH 4/4] Cleanup scatter ports patch.
Message-Id: <1302137778.4906.402.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Fix style issues and conflicts given port_shifting and remote_guid_sorting patches.
Handle LMC > 0 case more gracefully.  Add command line option and manpage entry.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    2 +-
 man/opensm.8.in             |    4 ++++
 opensm/main.c               |    7 +++++++
 opensm/osm_dump.c           |    8 ++++----
 opensm/osm_subnet.c         |   13 +++++++------
 opensm/osm_switch.c         |   41 +++++++++++++++--------------------------
 opensm/osm_ucast_mgr.c      |    3 +--
 7 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 938084e..ad8ed90 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -201,6 +201,7 @@ typedef struct osm_subn_opt {
 	char *io_guid_file;
 	boolean_t port_shifting;
 	boolean_t remote_guid_sorting;
+	uint32_t scatter_ports;
 	uint16_t max_reverse_hops;
 	char *ids_guid_file;
 	char *guid_routing_order_file;
@@ -238,7 +239,6 @@ typedef struct osm_subn_opt {
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
-	uint32_t scatter_ports;
 } osm_subn_opt_t;
 /*
 * FIELDS
diff --git a/man/opensm.8.in b/man/opensm.8.in
index b4456a8..26f7f4d 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -27,6 +27,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-G | \-\-io_guid_file <path to file>]
 [\-\-port\-shifting]
 [\-\-remote\-guid\-sorting]
+[\-\-scatter\-ports]
 [\-H | \-\-max_reverse_hops <max reverse hops allowed>]
 [\-X | \-\-guid_routing_order_file <path to file>]
 [\-m | \-\-ids_guid_file <path to file>]
@@ -223,6 +224,9 @@ fabrics, switches may be cabled in an inconsistent fashion.  This option
 may alleviate those issues by sorting remote guids before routing,
 making remote destinations appear to be ordered consistently.
 .TP
+\fB\-\-scatter\-ports\fR
+This option will randomize port selecting in routing.
+.TP
 \fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
 Set the maximum number of reverse hops an I/O node is allowed
 to make. A reverse hop is the use of a switch the wrong way around.
diff --git a/opensm/main.c b/opensm/main.c
index e2e7355..2b87ca5 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -229,6 +229,8 @@ static void show_usage(void)
 	printf("--remote-guid-sorting\n"
 	       "          Sort ports by remote port guid before routing to alleviate\n"
 	       "          problems with inconsistent cabling across a fabric\n\n");
+	printf("--scatter-ports <random seed>\n"
+	       "          Randomize best port chosen for a route\n\n");
 	printf("--max_reverse_hops, -H <hop_count>\n"
 	       "          Set the max number of hops the wrong way around\n"
 	       "          an I/O node is allowed to do (connectivity for I/O nodes on top swithces)\n\n");
@@ -609,6 +611,7 @@ int main(int argc, char *argv[])
 		{"io_guid_file", 1, NULL, 'G'},
 		{"port-shifting", 0, NULL, 11},
 		{"remote-guid-sorting", 0, NULL, 13},
+		{"scatter-ports", 1, NULL, 14},
 		{"max_reverse_hops", 1, NULL, 'H'},
 		{"ids_guid_file", 1, NULL, 'm'},
 		{"guid_routing_order_file", 1, NULL, 'X'},
@@ -959,6 +962,10 @@ int main(int argc, char *argv[])
 			opt.remote_guid_sorting = TRUE;
 			printf(" Remote Guid Sorting is on\n");
 			break;
+		case 14:
+			opt.scatter_ports = strtol(optarg, NULL, 0);
+			printf(" Scatter Ports is on\n");
+			break;
 		case 'H':
 			opt.max_reverse_hops = atoi(optarg);
 			printf(" Max Reverse Hops: %d\n", opt.max_reverse_hops);
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index f88ecbf..638ec19 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -627,12 +627,12 @@ void osm_dump_all(osm_opensm_t * osm)
 		if (osm_log_is_active(&osm->log, OSM_LOG_DEBUG))
 			dump_qmap(stdout, &osm->subn.sw_guid_tbl,
 				  dump_ucast_path_distribution, osm);
+
 		/* An attempt to get osm_switch_recommend_path to report the
-		   same routes that a sweep would assign.  No idea if it works
-		   or not */
-		if(osm->subn.opt.scatter_ports) {
+		   same routes that a sweep would assign. */
+		if (osm->subn.opt.scatter_ports)
 			srandom(osm->subn.opt.scatter_ports);
-		}
+
 		osm_dump_qmap_to_file(osm, "opensm.fdbs",
 				      &osm->subn.sw_guid_tbl,
 				      dump_ucast_routes, osm);
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 68bb7d3..8e4f872 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -745,6 +745,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->io_guid_file = NULL;
 	p_opt->port_shifting = FALSE;
 	p_opt->remote_guid_sorting = FALSE;
+	p_opt->scatter_ports = OSM_DEFAULT_SCATTER_PORTS;
 	p_opt->max_reverse_hops = 0;
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
@@ -1454,6 +1455,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Remote Guid Sorting (use FALSE if unsure)\n"
 		"remote_guid_sorting %s\n\n",
 		p_opts->remote_guid_sorting ? "TRUE" : "FALSE");
+	
+	fprintf(out,
+		"# Assign ports in a random order instead of round-robin.\n"
+		"# If zero disable, otherwise use the value as a random seed\n"
+		"scatter_ports %d\n\n",
+		p_opts->scatter_ports);
 
 	fprintf(out,
 		"# SA database file name\nsa_db_file %s\n\n",
@@ -1468,12 +1475,6 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 	fprintf(out,
 		"# Torus-2QoS configuration file name\ntorus_config %s\n\n",
 		p_opts->torus_conf_file ? p_opts->torus_conf_file : null_str);
-	
-	fprintf(out,
-		"# Assign ports in a random order instead of round-robin.\n"
-		"# If zero disable, otherwise use the value as a random seed\n"
-		"scatter_ports %d\n\n",
-		p_opts->scatter_ports);
 
 	fprintf(out,
 		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 3c3a488..bbbc9f2 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -259,12 +259,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	uint8_t hops;
 	uint8_t least_hops;
 	uint8_t port_num;
-	uint8_t *possible_ports;
-	uint8_t num_possible = 0;
 	uint8_t num_ports;
 	uint32_t least_paths = 0xFFFFFFFF;
 	unsigned i;
-	unsigned j;
 	/*
 	   The follwing will track the least paths if the
 	   route should go through a new system/node
@@ -290,6 +287,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	struct switch_port_path port_paths[IB_NODE_NUM_PORTS_MAX];
 	unsigned int port_paths_total_paths = 0;
 	unsigned int port_paths_count = 0;
+	uint8_t scatter_possible_ports[IB_NODE_NUM_PORTS_MAX];
+	unsigned int scatter_possible_ports_count = 0;
 	int found_sys_guid;
 	int found_node_guid;
 
@@ -314,14 +313,6 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 
 	num_ports = p_sw->num_ports;
 
-	possible_ports = malloc(num_ports * sizeof(uint8_t));
-	if (!possible_ports)
-		/*
-		 * This really isn't ideal, but we don't appear to have a log manager
-		 * context here.
-		 */
-		return OSM_NO_PATH;
-
 	least_hops = osm_switch_get_least_hops(p_sw, base_lid);
 	if (least_hops == OSM_NO_PATH)
 		return OSM_NO_PATH;
@@ -505,17 +496,15 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 			port_found = TRUE;
 			best_port = port_num;
 			least_paths = check_count;
-			for (j = 0; j < num_ports; j++) {
-				possible_ports[j] = 0;
-			}
-			num_possible = 0;
-			possible_ports[num_possible++] = port_num;
+			scatter_possible_ports_count = 0;
+			scatter_possible_ports[scatter_possible_ports_count++] = port_num;
 			if (routing_for_lmc
 			    && p_remote_guid
 			    && p_remote_guid->forwarded_to < least_forwarded_to)
 				least_forwarded_to = p_remote_guid->forwarded_to;
-		} else if (check_count == least_paths) {
-			possible_ports[num_possible++] = port_num;
+		} else if (scatter_ports
+			   && check_count == least_paths) {
+			scatter_possible_ports[scatter_possible_ports_count++] = port_num;
 		} else if (routing_for_lmc
 			   && p_remote_guid
 			   && check_count == least_paths
@@ -605,20 +594,20 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	   if we are in enhanced routing mode and the best port is not
 	   the local port 0
 	 */
-	if (routing_for_lmc && best_port) {
+	if (routing_for_lmc && best_port && !scatter_ports) {
 		/* Select the least hop port of the non used sys first */
 		if (best_port_other_sys)
 			best_port = best_port_other_sys;
 		else if (best_port_other_node)
 			best_port = best_port_other_node;
 	} else if (scatter_ports) {
-	/*
-	 * There is some danger that this random could "rebalance" the routes
-	 * every time, to combat this there is a global srandom that
-	 * occurs at the start of every sweep.
-	 */
-		j = random() % num_possible;
-		best_port = possible_ports[j];
+		/*
+		 * There is some danger that this random could "rebalance" the routes
+		 * every time, to combat this there is a global srandom that
+		 * occurs at the start of every sweep.
+		 */
+		unsigned int idx = random() % scatter_possible_ports_count;
+		best_port = scatter_possible_ports[idx];
 	}
 	return best_port;
 }
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 05af7e5..f52b6ab 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1043,9 +1043,8 @@ static int ucast_mgr_route(struct osm_routing_engine *r, osm_opensm_t * osm)
 		"building routing with \'%s\' routing algorithm...\n", r->name);
 
 	/* Set the before each lft build to keep the routes in place between sweeps */
-	if(osm->subn.opt.scatter_ports) {
+	if(osm->subn.opt.scatter_ports)
 		srandom(osm->subn.opt.scatter_ports);
-	}
 
 	if (!r->build_lid_matrices ||
 	    (ret = r->build_lid_matrices(r->context)) > 0)
-- 
1.7.1


--=-fnQCic+KhKCO13AgaJoB--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
