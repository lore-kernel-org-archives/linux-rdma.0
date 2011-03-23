From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options (repost)
Date: Wed, 23 Mar 2011 14:31:38 -0700
Message-ID: <1300915898.3128.168.camel@auk59.llnl.gov>
References: <1297388014.18394.302.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NMr7mONGyR0eoO6jmC0H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297388014.18394.302.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-NMr7mONGyR0eoO6jmC0H
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Alex,

As discussed in a private thread, here are the patches again, with some
tweaks.  Most notably, the tweak ensures that the remote_guid_sorting
option is independent of port_shifting, so users may enable either,
none, or both options at their discretion.

Al

On Thu, 2011-02-10 at 17:33 -0800, Albert Chu wrote:
> [This is a repost from Oct 2010 with rebased patches]
> 
> We recently got a new cluster and I've been experimenting with some
> routing changes to improve the average bandwidth of the cluster.  They
> are attached as patches with description of the routing goals below.
> 
> We're using mpiGraph (http://sourceforge.net/projects/mpigraph/) to
> measure min, peak, and average send/recv bandwidth across the cluster.
> What we found with the original updn routing was an average of around
> 420 MB/s send bandwidth and 508 MB/s recv bandwidth.  The following two
> patches were able to get the average send bandwidth up to 1045 MB/s and
> recv bandwidth up to 1228 MB/s.
> 
> I'm sure this is only round 1 of the patches and I'm looking for
> comments.  Many areas could be cleaned up w/ some rearchitecture, but I
> elected to implement the most non-invasive implementation first.  I'm
> also open to name changes on the options.
> 
> 1) Port Shifting
> 
> This is similar to what was done with some of the LMC > 0 code.
> Congestion would occur due to "alignment" of routes w/ common traffic
> patterns.  However, we found that it was also necessary for LMC=0 and
> only for used-ports.  For example, lets say there are 4 ports (called A,
> B, C, D) and we are routing lids 1-9 through them.  Suppose only routing
> through A, B, and C will reach lids 1-9.
> 
> The LFT would normally be:
> 
> A: 1 4 7
> B: 2 5 8
> C: 3 6 9
> D:
> 
> The Port Shifting option would make this:
> 
> A: 1 6 8
> B: 2 4 9
> C: 3 5 7
> D:
> 
> This option by itself improved the mpiGraph average send/recv bandwidth
> from 420 MB/s and 508 MB/s to to 991 MB/s and 1172 MB/s.
> 
> 2) Remote Guid Sorting
> 
> Most core/spine switches we've seen thus far have had line boards
> connected to spine boards in a consistent pattern.  However, we recently
> got some Qlogic switches that connect from line/leaf boards to spine
> boards in a (to the casual observer) random pattern.  I'm sure there was
> a good electrical/board reason for this design, but it does hurt routing
> b/c updn doesn't account for this.  Here's an output from iblinkinfo as
> an example.
> 
> Switch 0x00066a00ec0029b8 ibcore1 L123:
>          180    1[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     254   19[  ] "ibsw55" ( )
>          180    2[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     253   19[  ] "ibsw56" ( )
>          180    3[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     258   19[  ] "ibsw57" ( )
>          180    4[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     257   19[  ] "ibsw58" ( )
>          180    5[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     256   19[  ] "ibsw59" ( )
>          180    6[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     255   19[  ] "ibsw60" ( )
>          180    7[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     261   19[  ] "ibsw61" ( )
>          180    8[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     262   19[  ] "ibsw62" ( )
>          180    9[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     260   19[  ] "ibsw63" ( )
>          180   10[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     259   19[  ] "ibsw64" ( )
>          180   11[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     284   19[  ] "ibsw65" ( )
>          180   12[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     285   19[  ] "ibsw66" ( )
>          180   13[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>    2227   19[  ] "ibsw67" ( )
>          180   14[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     283   19[  ] "ibsw68" ( )
>          180   15[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     267   19[  ] "ibsw69" ( )
>          180   16[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     270   19[  ] "ibsw70" ( )
>          180   17[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     269   19[  ] "ibsw71" ( )
>          180   18[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     268   19[  ] "ibsw72" ( )
>          180   19[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     222   17[  ] "ibcore1 S117B" ( )
>          180   20[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     209   19[  ] "ibcore1 S211B" ( )
>          180   21[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     218   21[  ] "ibcore1 S117A" ( )
>          180   22[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     192   23[  ] "ibcore1 S215B" ( )
>          180   23[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      85   15[  ] "ibcore1 S209A" ( )
>          180   24[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     182   13[  ] "ibcore1 S215A" ( )
>          180   25[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     200   11[  ] "ibcore1 S115B" ( )
>          180   26[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     129   25[  ] "ibcore1 S209B" ( )
>          180   27[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     213   27[  ] "ibcore1 S115A" ( )
>          180   28[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     197   29[  ] "ibcore1 S213B" ( )
>          180   29[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     178   28[  ] "ibcore1 S111A" ( )
>          180   30[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     215    7[  ] "ibcore1 S213A" ( )
>          180   31[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     207    5[  ] "ibcore1 S113B" ( )
>          180   32[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     212    6[  ] "ibcore1 S211A" ( )
>          180   33[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     154   33[  ] "ibcore1 S113A" ( )
>          180   34[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     194   35[  ] "ibcore1 S217B" ( )
>          180   35[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     191    3[  ] "ibcore1 S111B" ( )
>          180   36[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     219    1[  ] "ibcore1 S217A" ( )
> 
> This is a line board that connects up to spine boards (ibcore1 S*
> switches) and down to leaf/edge switches (ibsw*).  As you can see the
> line board connects to the ports on the edge switches in a consistent
> fashion (always port 19), but connects to the spine switches in a (to
> the casual observer) random fashion (port 17, 19, 21, 23, 15, ...).
> 
> The "remote_guid_sorting" option will slightly tweak routing so that
> instead of finding a port to route through by searching ports 1 to N. It
> will (effectively) sort the ports based on remote connected node guid,
> then pick a port searching from lowest guid to highest guid. That way
> the routing calculations across each line/leaf board and spine switch
> will be consistent.
> 
> This patch (on top of the port_shifting one above) improved the mpiGraph
> average send/recv bandwidth from 991 MB/s & 1172 MB/s to 1045 MB/s and
> 1228 MB/s.
> 
> Al
> 
> 
> email message attachment
> > -------- Forwarded Message --------
> > From: Albert L.Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > Subject: [PATCH] Support port shifting
> > Date: Mon, 7 Feb 2011 16:52:41 -0800
> > 
> > Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  include/opensm/osm_subnet.h |    4 ++
> >  include/opensm/osm_switch.h |    6 ++-
> >  man/opensm.8.in             |    8 ++++
> >  opensm/main.c               |    8 ++++
> >  opensm/osm_dump.c           |    2 +-
> >  opensm/osm_subnet.c         |    7 +++
> >  opensm/osm_switch.c         |   98 ++++++++++++++++++++++++++++++++++++++++++-
> >  opensm/osm_ucast_mgr.c      |    3 +-
> >  8 files changed, 132 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
> > index 42ae416..59f877e 100644
> > --- a/include/opensm/osm_subnet.h
> > +++ b/include/opensm/osm_subnet.h
> > @@ -199,6 +199,7 @@ typedef struct osm_subn_opt {
> >  	char *root_guid_file;
> >  	char *cn_guid_file;
> >  	char *io_guid_file;
> > +	boolean_t port_shifting;
> >  	uint16_t max_reverse_hops;
> >  	char *ids_guid_file;
> >  	char *guid_routing_order_file;
> > @@ -418,6 +419,9 @@ typedef struct osm_subn_opt {
> >  *		Name of the file that contains list of I/O node guids that
> >  *		will be used by fat-tree routing (provided by User)
> >  *
> > +*	port_shifting
> > +*		This option will turn on port_shifting in routing.
> > +*
> >  *	ids_guid_file
> >  *		Name of the file that contains list of ids which should be
> >  *		used by Up/Down algorithm instead of node GUIDs
> > diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
> > index f407dd9..8eae119 100644
> > --- a/include/opensm/osm_switch.h
> > +++ b/include/opensm/osm_switch.h
> > @@ -919,7 +919,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  				  IN unsigned start_from,
> >  				  IN boolean_t ignore_existing,
> >  				  IN boolean_t routing_for_lmc,
> > -				  IN boolean_t dor);
> > +				  IN boolean_t dor,
> > +				  IN boolean_t port_shifting);
> >  /*
> >  * PARAMETERS
> >  *	p_sw
> > @@ -955,6 +956,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  *	dor
> >  *		[in] If TRUE, Dimension Order Routing will be done.
> >  *
> > +*	port_shifting
> > +*		[in] If TRUE, port_shifting will be done.
> > +*
> >  * RETURN VALUE
> >  *	Returns the recommended port on which to route this LID.
> >  *
> > diff --git a/man/opensm.8.in b/man/opensm.8.in
> > index cd3a24f..db48d52 100644
> > --- a/man/opensm.8.in
> > +++ b/man/opensm.8.in
> > @@ -25,6 +25,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
> >  [\-a | \-\-root_guid_file <path to file>]
> >  [\-u | \-\-cn_guid_file <path to file>]
> >  [\-G | \-\-io_guid_file <path to file>]
> > +[\-\-port\-shifting]
> >  [\-H | \-\-max_reverse_hops <max reverse hops allowed>]
> >  [\-X | \-\-guid_routing_order_file <path to file>]
> >  [\-m | \-\-ids_guid_file <path to file>]
> > @@ -208,6 +209,13 @@ to the guids provided in the given file (one to a line).
> >  I/O nodes are non-CN nodes allowed to use up to max_reverse_hops switches
> >  the wrong way around to improve connectivity.
> >  .TP
> > +\fB\-\-port\-shifting\fR
> > +This option enables a feature called \fBport shifting\fR.  In some
> > +fabrics, particularly cluster environments, routes commonly align and
> > +congest with other routes due to algorithmically unchanging traffic
> > +patterns.  This routing option will "shift" routing around in an
> > +attempt to alleviate this problem.
> > +.TP
> >  \fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
> >  Set the maximum number of reverse hops an I/O node is allowed
> >  to make. A reverse hop is the use of a switch the wrong way around.
> > diff --git a/opensm/main.c b/opensm/main.c
> > index 756fe6f..abb32ec 100644
> > --- a/opensm/main.c
> > +++ b/opensm/main.c
> > @@ -223,6 +223,9 @@ static void show_usage(void)
> >  	printf("--io_guid_file, -G <path to file>\n"
> >  	       "          Set the I/O nodes for the Fat-Tree routing algorithm\n"
> >  	       "          to the guids provided in the given file (one to a line)\n\n");
> > +	printf("--port-shifting\n"
> > +	       "          Attempt to shift port routes around to remove alignment problems\n"
> > +	       "          in routing tables\n\n");
> >  	printf("--max_reverse_hops, -H <hop_count>\n"
> >  	       "          Set the max number of hops the wrong way around\n"
> >  	       "          an I/O node is allowed to do (connectivity for I/O nodes on top swithces)\n\n");
> > @@ -601,6 +604,7 @@ int main(int argc, char *argv[])
> >  		{"root_guid_file", 1, NULL, 'a'},
> >  		{"cn_guid_file", 1, NULL, 'u'},
> >  		{"io_guid_file", 1, NULL, 'G'},
> > +		{"port-shifting", 0, NULL, 11},
> >  		{"max_reverse_hops", 1, NULL, 'H'},
> >  		{"ids_guid_file", 1, NULL, 'm'},
> >  		{"guid_routing_order_file", 1, NULL, 'X'},
> > @@ -937,6 +941,10 @@ int main(int argc, char *argv[])
> >  			opt.io_guid_file = optarg;
> >  			printf(" I/O Node Guid File: %s\n", opt.io_guid_file);
> >  			break;
> > +		case 11:
> > +			opt.port_shifting = TRUE;
> > +			printf(" Port Shifting is on\n");
> > +			break;
> >  		case 'H':
> >  			opt.max_reverse_hops = atoi(optarg);
> >  			printf(" Max Reverse Hops: %d\n", opt.max_reverse_hops);
> > diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
> > index 535a03f..a1ff168 100644
> > --- a/opensm/osm_dump.c
> > +++ b/opensm/osm_dump.c
> > @@ -221,7 +221,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
> >  			/* No LMC Optimization */
> >  			best_port = osm_switch_recommend_path(p_sw, p_port,
> >  							      lid_ho, 1, TRUE,
> > -							      FALSE, dor);
> > +							      FALSE, dor, FALSE);
> >  			fprintf(file, "No %u hop path possible via port %u!",
> >  				best_hops, best_port);
> >  		}
> > diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> > index 228418f..c62192c 100644
> > --- a/opensm/osm_subnet.c
> > +++ b/opensm/osm_subnet.c
> > @@ -347,6 +347,7 @@ static const opt_rec_t opt_tbl[] = {
> >  	{ "root_guid_file", OPT_OFFSET(root_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_parse_charp, NULL, 0 },
> > +	{ "port_shifting", OPT_OFFSET(port_shifting), opts_parse_boolean, NULL, 1 },
> >  	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
> >  	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
> > @@ -740,6 +741,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
> >  	p_opt->root_guid_file = NULL;
> >  	p_opt->cn_guid_file = NULL;
> >  	p_opt->io_guid_file = NULL;
> > +	p_opt->port_shifting = FALSE;
> >  	p_opt->max_reverse_hops = 0;
> >  	p_opt->ids_guid_file = NULL;
> >  	p_opt->guid_routing_order_file = NULL;
> > @@ -1440,6 +1442,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >  		p_opts->lash_start_vl);
> >  
> >  	fprintf(out,
> > +		"# Port Shifting (use FALSE if unsure)\n"
> > +		"port_shifting %s\n\n",
> > +		p_opts->port_shifting ? "TRUE" : "FALSE");
> > +
> > +	fprintf(out,
> >  		"# SA database file name\nsa_db_file %s\n\n",
> >  		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);
> >  
> > diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
> > index 9785a9d..f24d9ea 100644
> > --- a/opensm/osm_switch.c
> > +++ b/opensm/osm_switch.c
> > @@ -51,6 +51,14 @@
> >  #include <iba/ib_types.h>
> >  #include <opensm/osm_switch.h>
> >  
> > +struct switch_port_path {
> > +	uint8_t port_num;
> > +	uint32_t path_count;
> > +	int found_sys_guid;
> > +	int found_node_guid;
> > +	uint32_t forwarded_to;
> > +};
> > +
> >  cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
> >  				IN uint8_t port_num, IN uint8_t num_hops)
> >  {
> > @@ -217,7 +225,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  				  IN unsigned start_from,
> >  				  IN boolean_t ignore_existing,
> >  				  IN boolean_t routing_for_lmc,
> > -				  IN boolean_t dor)
> > +				  IN boolean_t dor,
> > +				  IN boolean_t port_shifting)
> >  {
> >  	/*
> >  	   We support an enhanced LMC aware routing mode:
> > @@ -259,6 +268,11 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  	osm_node_t *p_rem_node_first = NULL;
> >  	struct osm_remote_node *p_remote_guid = NULL;
> >  	struct osm_remote_node null_remote_node = {NULL, 0, 0};
> > +	struct switch_port_path port_paths[IB_NODE_NUM_PORTS_MAX];
> > +	unsigned int port_paths_total_paths = 0;
> > +	unsigned int port_paths_count = 0;
> > +	int found_sys_guid;
> > +	int found_node_guid;
> >  
> >  	CL_ASSERT(lid_ho > 0);
> >  
> > @@ -369,6 +383,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  		check_count =
> >  		    osm_port_prof_path_count_get(&p_sw->p_prof[port_num]);
> >  
> > +
> >  		if (dor) {
> >  			/* Get the Remote Node */
> >  			p_rem_physp = osm_physp_get_remote(p_physp);
> > @@ -412,7 +427,10 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  					best_port_other_sys = port_num;
> >  					least_forwarded_to = 0;
> >  				}
> > +				found_sys_guid = 0;
> >  			} else {	/* same sys found - try node */
> > +
> > +
> >  				/* Else is the node guid already used ? */
> >  				p_remote_guid = switch_find_node_guid_count(p_sw,
> >  									    p_port->priv,
> > @@ -427,9 +445,27 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  				}
> >  				/* else prior sys and node guid already used */
> >  
> > +				if (!p_remote_guid)
> > +					found_node_guid = 0;
> > +				else
> > +					found_node_guid = 1;
> > +				found_sys_guid = 1;
> >  			}	/* same sys found */
> >  		}
> >  
> > +		port_paths[port_paths_count].port_num = port_num;
> > +		port_paths[port_paths_count].path_count = check_count;
> > +		if (routing_for_lmc) {
> > +			port_paths[port_paths_count].found_sys_guid = found_sys_guid;
> > +			port_paths[port_paths_count].found_node_guid = found_node_guid;
> > +		}
> > +		if (routing_for_lmc && p_remote_guid)
> > +			port_paths[port_paths_count].forwarded_to = p_remote_guid->forwarded_to;
> > +		else
> > +			port_paths[port_paths_count].forwarded_to = 0;
> > +		port_paths_total_paths += check_count;
> > +		port_paths_count++;
> > +
> >  		/* routing for LMC mode */
> >  		/*
> >  		   the count is min but also lower then the max subscribed
> > @@ -454,6 +490,66 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  	if (port_found == FALSE)
> >  		return OSM_NO_PATH;
> >  
> > +	if (port_shifting && port_paths_count) {
> > +		/* In the port_paths[] array, we now have all the ports that we
> > +		 * can route out of.  Using some shifting math below, possibly
> > +		 * select a different one so that lids won't align in LFTs
> > +		 *
> > +		 * If lmc > 0, we need to loop through these ports to find the
> > +		 * least_forwarded_to port, best_port_other_sys, and
> > +		 * best_port_other_node just like before but through the different
> > +		 * ordering.
> > +		 */
> > +
> > +		least_paths = 0xFFFFFFFF;
> > +        	least_paths_other_sys = 0xFFFFFFFF;
> > +        	least_paths_other_nodes = 0xFFFFFFFF;
> > +	        least_forwarded_to = 0xFFFFFFFF;
> > +		best_port = 0;
> > +        	best_port_other_sys = 0;
> > +        	best_port_other_node = 0;
> > +
> > +		for (i = 0; i < port_paths_count; i++) {
> > +			unsigned int idx;
> > +
> > +			idx = (port_paths_total_paths/port_paths_count + i) % port_paths_count;
> > +
> > +			if (routing_for_lmc) {
> > +				if (!port_paths[idx].found_sys_guid
> > +				    && port_paths[idx].path_count < least_paths_other_sys) {
> > +					least_paths_other_sys = port_paths[idx].path_count;
> > +					best_port_other_sys = port_paths[idx].port_num;
> > +					least_forwarded_to = 0;
> > +				}
> > +				else if (!port_paths[idx].found_node_guid
> > +					 && port_paths[idx].path_count < least_paths_other_nodes) {
> > +					least_paths_other_nodes = port_paths[idx].path_count;
> > +					best_port_other_node = port_paths[idx].port_num;
> > +					least_forwarded_to = 0;
> > +				}
> > +			}
> > +
> > +			if (port_paths[idx].path_count < least_paths) {
> > +				best_port = port_paths[idx].port_num;
> > +				least_paths = port_paths[idx].path_count;
> > +				if (routing_for_lmc
> > +				    && (port_paths[idx].found_sys_guid
> > +					|| port_paths[idx].found_node_guid)
> > +				    && port_paths[idx].forwarded_to < least_forwarded_to)
> > +					least_forwarded_to = port_paths[idx].forwarded_to;
> > +			}
> > +			else if (routing_for_lmc
> > +				 && (port_paths[idx].found_sys_guid
> > +				     || port_paths[idx].found_node_guid)
> > +				 && port_paths[idx].path_count == least_paths
> > +				 && port_paths[idx].forwarded_to < least_forwarded_to) {
> > +				least_forwarded_to = port_paths[idx].forwarded_to;
> > +				best_port = port_paths[idx].port_num;
> > +			}
> > +				
> > +		}
> > +	}
> > +	
> >  	/*
> >  	   if we are in enhanced routing mode and the best port is not
> >  	   the local port 0
> > diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
> > index 4019589..d32eb60 100644
> > --- a/opensm/osm_ucast_mgr.c
> > +++ b/opensm/osm_ucast_mgr.c
> > @@ -255,7 +255,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
> >  	port = osm_switch_recommend_path(p_sw, p_port, lid_ho, start_from,
> >  					 p_mgr->p_subn->ignore_existing_lfts,
> >  					 p_mgr->p_subn->opt.lmc,
> > -					 p_mgr->is_dor);
> > +					 p_mgr->is_dor,
> > +					 p_mgr->p_subn->opt.port_shifting);
> >  
> >  	if (port == OSM_NO_PATH) {
> >  		/* do not try to overwrite the ppro of non existing port ... */
> email message attachment
> > -------- Forwarded Message --------
> > From: Albert L.Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > Subject: [PATCH] Support remote guid sorting
> > Date: Mon, 7 Feb 2011 16:53:39 -0800
> > 
> > Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  include/opensm/osm_subnet.h |    4 ++++
> >  include/opensm/osm_switch.h |    6 +++++-
> >  man/opensm.8.in             |    6 ++++++
> >  opensm/main.c               |    8 ++++++++
> >  opensm/osm_dump.c           |    3 ++-
> >  opensm/osm_subnet.c         |    7 +++++++
> >  opensm/osm_switch.c         |   26 +++++++++++++++++++++++++-
> >  opensm/osm_ucast_mgr.c      |    3 ++-
> >  8 files changed, 59 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
> > index 59f877e..589e96c 100644
> > --- a/include/opensm/osm_subnet.h
> > +++ b/include/opensm/osm_subnet.h
> > @@ -200,6 +200,7 @@ typedef struct osm_subn_opt {
> >  	char *cn_guid_file;
> >  	char *io_guid_file;
> >  	boolean_t port_shifting;
> > +	boolean_t remote_guid_sorting;
> >  	uint16_t max_reverse_hops;
> >  	char *ids_guid_file;
> >  	char *guid_routing_order_file;
> > @@ -422,6 +423,9 @@ typedef struct osm_subn_opt {
> >  *	port_shifting
> >  *		This option will turn on port_shifting in routing.
> >  *
> > +*	remote_guid_sorting
> > +*		This option will turn on remote_guid_sorting in routing.
> > +*
> >  *	ids_guid_file
> >  *		Name of the file that contains list of ids which should be
> >  *		used by Up/Down algorithm instead of node GUIDs
> > diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
> > index 8eae119..aef45cb 100644
> > --- a/include/opensm/osm_switch.h
> > +++ b/include/opensm/osm_switch.h
> > @@ -920,7 +920,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  				  IN boolean_t ignore_existing,
> >  				  IN boolean_t routing_for_lmc,
> >  				  IN boolean_t dor,
> > -				  IN boolean_t port_shifting);
> > +				  IN boolean_t port_shifting,
> > +				  IN boolean_t remote_guid_sorting);
> >  /*
> >  * PARAMETERS
> >  *	p_sw
> > @@ -959,6 +960,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  *	port_shifting
> >  *		[in] If TRUE, port_shifting will be done.
> >  *
> > +*	remote_guid_sorting
> > +*		[in] If TRUE, remote_guid_sorting will be done.
> > +*
> >  * RETURN VALUE
> >  *	Returns the recommended port on which to route this LID.
> >  *
> > diff --git a/man/opensm.8.in b/man/opensm.8.in
> > index db48d52..decaee7 100644
> > --- a/man/opensm.8.in
> > +++ b/man/opensm.8.in
> > @@ -216,6 +216,12 @@ congest with other routes due to algorithmically unchanging traffic
> >  patterns.  This routing option will "shift" routing around in an
> >  attempt to alleviate this problem.
> >  .TP
> > +\fB\-\-remote\-guid\-sorting\fR
> > +This option enables a feature called \fBremote guid sorting\fR.  In some
> > +fabrics, switches may be cabled in an inconsistent fashion.  This option
> > +may alleviate those issues by sorting remote guids before routing,
> > +making remote destinations appear to be ordered consistently.
> > +.TP
> >  \fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
> >  Set the maximum number of reverse hops an I/O node is allowed
> >  to make. A reverse hop is the use of a switch the wrong way around.
> > diff --git a/opensm/main.c b/opensm/main.c
> > index abb32ec..91ae940 100644
> > --- a/opensm/main.c
> > +++ b/opensm/main.c
> > @@ -226,6 +226,9 @@ static void show_usage(void)
> >  	printf("--port-shifting\n"
> >  	       "          Attempt to shift port routes around to remove alignment problems\n"
> >  	       "          in routing tables\n\n");
> > +	printf("--remote-guid-sorting\n"
> > +	       "          Sort ports by remote port guid before routing to alleviate\n"
> > +	       "          problems with inconsistent cabling across a fabric\n\n");
> >  	printf("--max_reverse_hops, -H <hop_count>\n"
> >  	       "          Set the max number of hops the wrong way around\n"
> >  	       "          an I/O node is allowed to do (connectivity for I/O nodes on top swithces)\n\n");
> > @@ -605,6 +608,7 @@ int main(int argc, char *argv[])
> >  		{"cn_guid_file", 1, NULL, 'u'},
> >  		{"io_guid_file", 1, NULL, 'G'},
> >  		{"port-shifting", 0, NULL, 11},
> > +		{"remote-guid-sorting", 0, NULL, 13},
> >  		{"max_reverse_hops", 1, NULL, 'H'},
> >  		{"ids_guid_file", 1, NULL, 'm'},
> >  		{"guid_routing_order_file", 1, NULL, 'X'},
> > @@ -945,6 +949,10 @@ int main(int argc, char *argv[])
> >  			opt.port_shifting = TRUE;
> >  			printf(" Port Shifting is on\n");
> >  			break;
> > +		case 13:
> > +			opt.remote_guid_sorting = TRUE;
> > +			printf(" Remote Guid Sorting is on\n");
> > +			break;
> >  		case 'H':
> >  			opt.max_reverse_hops = atoi(optarg);
> >  			printf(" Max Reverse Hops: %d\n", opt.max_reverse_hops);
> > diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
> > index a1ff168..bfe63c3 100644
> > --- a/opensm/osm_dump.c
> > +++ b/opensm/osm_dump.c
> > @@ -221,7 +221,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
> >  			/* No LMC Optimization */
> >  			best_port = osm_switch_recommend_path(p_sw, p_port,
> >  							      lid_ho, 1, TRUE,
> > -							      FALSE, dor, FALSE);
> > +							      FALSE, dor, FALSE,
> > +							      FALSE);
> >  			fprintf(file, "No %u hop path possible via port %u!",
> >  				best_hops, best_port);
> >  		}
> > diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> > index c62192c..b2b219f 100644
> > --- a/opensm/osm_subnet.c
> > +++ b/opensm/osm_subnet.c
> > @@ -348,6 +348,7 @@ static const opt_rec_t opt_tbl[] = {
> >  	{ "cn_guid_file", OPT_OFFSET(cn_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "io_guid_file", OPT_OFFSET(io_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "port_shifting", OPT_OFFSET(port_shifting), opts_parse_boolean, NULL, 1 },
> > +	{ "remote_guid_sorting", OPT_OFFSET(remote_guid_sorting), opts_parse_boolean, NULL, 1 },
> >  	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
> >  	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
> >  	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
> > @@ -742,6 +743,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
> >  	p_opt->cn_guid_file = NULL;
> >  	p_opt->io_guid_file = NULL;
> >  	p_opt->port_shifting = FALSE;
> > +	p_opt->remote_guid_sorting = FALSE;
> >  	p_opt->max_reverse_hops = 0;
> >  	p_opt->ids_guid_file = NULL;
> >  	p_opt->guid_routing_order_file = NULL;
> > @@ -1447,6 +1449,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >  		p_opts->port_shifting ? "TRUE" : "FALSE");
> >  
> >  	fprintf(out,
> > +		"# Remote Guid Sorting (use FALSE if unsure)\n"
> > +		"remote_guid_sorting %s\n\n",
> > +		p_opts->remote_guid_sorting ? "TRUE" : "FALSE");
> > +
> > +	fprintf(out,
> >  		"# SA database file name\nsa_db_file %s\n\n",
> >  		p_opts->sa_db_file ? p_opts->sa_db_file : null_str);
> >  
> > diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
> > index f24d9ea..0aa0137 100644
> > --- a/opensm/osm_switch.c
> > +++ b/opensm/osm_switch.c
> > @@ -57,6 +57,7 @@ struct switch_port_path {
> >  	int found_sys_guid;
> >  	int found_node_guid;
> >  	uint32_t forwarded_to;
> > +	uint64_t remote_node_guid;
> >  };
> >  
> >  cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
> > @@ -169,6 +170,19 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
> >  	return TRUE;
> >  }
> >  
> > +static int
> > +port_path_guid_cmp(IN const void *x, IN const void *y)
> > +{
> > +	struct switch_port_path *a = (struct switch_port_path *)x;
> > +	struct switch_port_path *b = (struct switch_port_path *)y;
> > +
> > +	if (a->remote_node_guid < b->remote_node_guid)
> > +		return -1;
> > +	if (a->remote_node_guid > b->remote_node_guid)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> >  static struct osm_remote_node *
> >  switch_find_guid_common(IN const osm_switch_t * p_sw,
> >  			IN struct osm_remote_guids_count *r,
> > @@ -226,7 +240,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  				  IN boolean_t ignore_existing,
> >  				  IN boolean_t routing_for_lmc,
> >  				  IN boolean_t dor,
> > -				  IN boolean_t port_shifting)
> > +				  IN boolean_t port_shifting,
> > +				  IN boolean_t remote_guid_sorting)
> >  {
> >  	/*
> >  	   We support an enhanced LMC aware routing mode:
> > @@ -428,6 +443,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  					least_forwarded_to = 0;
> >  				}
> >  				found_sys_guid = 0;
> > +				found_node_guid = 0;
> >  			} else {	/* same sys found - try node */
> >  
> > 
> > @@ -463,6 +479,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  			port_paths[port_paths_count].forwarded_to = p_remote_guid->forwarded_to;
> >  		else
> >  			port_paths[port_paths_count].forwarded_to = 0;
> > +		p_rem_physp = osm_physp_get_remote(p_physp);
> > +		p_rem_node = osm_physp_get_node_ptr(p_rem_physp);
> > +		port_paths[port_paths_count].remote_node_guid = p_rem_node->node_info.node_guid;
> >  		port_paths_total_paths += check_count;
> >  		port_paths_count++;
> >  
> > @@ -490,6 +509,11 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> >  	if (port_found == FALSE)
> >  		return OSM_NO_PATH;
> >  
> > +	if (remote_guid_sorting && port_paths_count) {
> > +		qsort(port_paths, port_paths_count, sizeof(struct switch_port_path),
> > +		      port_path_guid_cmp);
> > +	}
> > +
> >  	if (port_shifting && port_paths_count) {
> >  		/* In the port_paths[] array, we now have all the ports that we
> >  		 * can route out of.  Using some shifting math below, possibly
> > diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
> > index d32eb60..a8982df 100644
> > --- a/opensm/osm_ucast_mgr.c
> > +++ b/opensm/osm_ucast_mgr.c
> > @@ -256,7 +256,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
> >  					 p_mgr->p_subn->ignore_existing_lfts,
> >  					 p_mgr->p_subn->opt.lmc,
> >  					 p_mgr->is_dor,
> > -					 p_mgr->p_subn->opt.port_shifting);
> > +					 p_mgr->p_subn->opt.port_shifting,
> > +					 p_mgr->p_subn->opt.remote_guid_sorting);
> >  
> >  	if (port == OSM_NO_PATH) {
> >  		/* do not try to overwrite the ppro of non existing port ... */
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-NMr7mONGyR0eoO6jmC0H
Content-Disposition: attachment; filename=0001-Support-port-shifting.patch
Content-Type: message/rfc822; name=0001-Support-port-shifting.patch

From: Albert L. Chu <achu-NlKtF6KlI8yLYFxP40JT4w@public.gmane.org>
Date: Mon, 7 Feb 2011 16:52:41 -0800
Subject: [PATCH] Support port shifting
Message-Id: <1300915791.3128.165.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    4 ++
 include/opensm/osm_switch.h |    6 ++-
 man/opensm.8.in             |    8 ++++
 opensm/main.c               |    8 ++++
 opensm/osm_dump.c           |    2 +-
 opensm/osm_subnet.c         |    7 +++
 opensm/osm_switch.c         |   98 ++++++++++++++++++++++++++++++++++++++++++-
 opensm/osm_ucast_mgr.c      |    3 +-
 8 files changed, 132 insertions(+), 4 deletions(-)

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
index 535a03f..a1ff168 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -221,7 +221,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			/* No LMC Optimization */
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
-							      FALSE, dor);
+							      FALSE, dor, FALSE);
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
1.5.4.5


--=-NMr7mONGyR0eoO6jmC0H
Content-Disposition: attachment; filename=0002-Support-remote-guid-sorting.patch
Content-Type: message/rfc822; name=0002-Support-remote-guid-sorting.patch

From: Albert L. Chu <achu-NlKtF6KlI8yLYFxP40JT4w@public.gmane.org>
Date: Mon, 7 Feb 2011 16:53:39 -0800
Subject: [PATCH] Support remote guid sorting
Message-Id: <1300915791.3128.166.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    4 ++++
 include/opensm/osm_switch.h |    6 +++++-
 man/opensm.8.in             |    6 ++++++
 opensm/main.c               |    8 ++++++++
 opensm/osm_dump.c           |    3 ++-
 opensm/osm_subnet.c         |    7 +++++++
 opensm/osm_switch.c         |   42 +++++++++++++++++++++++++++++++++++++-----
 opensm/osm_ucast_mgr.c      |    3 ++-
 8 files changed, 71 insertions(+), 8 deletions(-)

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
index f5b4fb9..a642820 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -216,6 +216,12 @@ congest with other routes due to algorithmically unchanging traffic
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
index a1ff168..bfe63c3 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -221,7 +221,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			/* No LMC Optimization */
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
-							      FALSE, dor, FALSE);
+							      FALSE, dor, FALSE,
+							      FALSE);
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
1.5.4.5


--=-NMr7mONGyR0eoO6jmC0H--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
