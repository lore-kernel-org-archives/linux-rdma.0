From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] Dimension port order file support
Date: Wed, 24 Mar 2010 15:32:21 +0200
Message-ID: <20100324133221.GK4808@me>
References: <alpine.DEB.2.00.1003031803390.14048@cantor.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003031803390.14048-QmwFlmbGB5cTG1waqwXmH7Cf4lofQVJ7@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dale,

On 18:06 Wed 03 Mar     , Dale Purdy wrote:
> 
> Provide a means to specify on a per switch basis the mapping (order)
> between switch ports and dimensions for Dimension Order Routing.  This
> allows the DOR routing engine to be used when the cabling is not
> properly aligned for DOR, either initially, or for an upgrade.

Nice stuff.

Is this something useful with ! '-R dor'?

> 
> Signed-off-by: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>

The patch itself is broken somehow - it has double space at start of
non-changed line (it is fixable with sed -e 's/^  / /', so don't resend
patch only for this).

Some more minor comments are below.

> ---
>   opensm/include/opensm/osm_subnet.h |    1 +
>   opensm/include/opensm/osm_switch.h |   30 +++++++++
>   opensm/man/opensm.8.in             |   31 +++++++--
>   opensm/opensm/main.c               |   13 ++++-
>   opensm/opensm/osm_subnet.c         |    7 ++
>   opensm/opensm/osm_switch.c         |    2 +-
>   opensm/opensm/osm_ucast_mgr.c      |  120 ++++++++++++++++++++++++++++++++++++
>   7 files changed, 195 insertions(+), 9 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index 3970e98..e4e298e 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -186,6 +186,7 @@ typedef struct osm_subn_opt {
>   	uint16_t console_port;
>   	char *port_prof_ignore_file;
>   	char *hop_weights_file;
> +	char *dimn_ports_file;
>   	boolean_t port_profile_switch_nodes;
>   	boolean_t sweep_on_trap;
>   	char *routing_engine_names;
> diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
> index cb6e5ac..1c6807e 100644
> --- a/opensm/include/opensm/osm_switch.h
> +++ b/opensm/include/opensm/osm_switch.h
> @@ -100,6 +100,7 @@ typedef struct osm_switch {
>   	uint16_t num_hops;
>   	uint8_t **hops;
>   	osm_port_profile_t *p_prof;
> +	uint8_t *dimn_ports;
>   	uint8_t *lft;
>   	uint8_t *new_lft;
>   	uint16_t lft_size;
> @@ -871,6 +872,35 @@ static inline uint8_t osm_switch_get_mft_max_position(IN osm_switch_t * p_sw)
>   * RETURN VALUE
>   */
> 
> +/****f* OpenSM: Switch/osm_switch_get_dimn_port
> +* NAME
> +*	osm_switch_get_dimn_port
> +*
> +* DESCRIPTION
> +*       Get the routing ordered port
> +*
> +* SYNOPSIS
> +*/
> +static inline uint8_t osm_switch_get_dimn_port(IN const osm_switch_t * p_sw,
> +					       IN uint8_t port_num)
> +{
> +	CL_ASSERT(p_sw);
> +	if (p_sw->dimn_ports == NULL)
> +		return port_num;
> +	return p_sw->dimn_ports[port_num];
> +}
> +/*
> +* PARAMETERS
> +*	p_sw
> +*		[in] Pointer to the switch object.
> +*
> +*	port_num
> +*		[in] Port number in the switch
> +*
> +* RETURN VALUES
> +*	Returns the port number ordered for routing purposes.
> +*/
> +
>   /****f* OpenSM: Switch/osm_switch_recommend_path
>   * NAME
>   *	osm_switch_recommend_path
> diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
> index 7aca8f9..9053611 100644
> --- a/opensm/man/opensm.8.in
> +++ b/opensm/man/opensm.8.in
> @@ -37,6 +37,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
>   [\-console-port <port>]
>   [\-i(gnore-guids) <equalize-ignore-guids-file>]
>   [\-w | \-\-hop_weights_file <path to file>]
> +[\-O | \-\-dimn_ports_file <path to file>]
>   [\-f <log file path> | \-\-log_file <log file path> ]
>   [\-L | \-\-log_limit <size in MB>] [\-e(rase_log_file)]
>   [\-P(config) <partition config file> ]
> @@ -273,6 +274,16 @@ factor of 1.  Lines starting with # are comments.  Weights affect only the
>   output route from the port, so many useful configurations will require weights
>   to be specified in pairs.
>   .TP
> +\fB\-O\fR, \fB\-\-dimn_ports_file\fR <path to file>
> +This option provides a mapping between hypercube dimensions and ports
> +on a per switch basis for the DOR routing engine.  The file consists
> +of lines containing a switch node GUID (specified as a 64 bit hex
> +number, with leading 0x) followed by a list of non-zero port numbers,
> +separated by spaces, one switch per line.  The order for the port
> +numbers is in one to one correspondence to the dimensions.  Ports not
> +listed on a line are assigned to the remaining dimensions, in port
> +order.  Anything after a # is a comment.
> +.TP
>   \fB\-x\fR, \fB\-\-honor_guid2lid\fR
>   This option forces OpenSM to honor the guid2lid file,
>   when it comes out of Standby state, if such file exists
> @@ -969,17 +980,20 @@ algorithm and so uses shortest paths.  Instead of spreading traffic
>   out across different paths with the same shortest distance, it chooses
>   among the available shortest paths based on an ordering of dimensions.
>   Each port must be consistently cabled to represent a hypercube
> -dimension or a mesh dimension.  Paths are grown from a destination
> -back to a source using the lowest dimension (port) of available paths
> -at each step.  This provides the ordering necessary to avoid deadlock.
> +dimension or a mesh dimension.  Alternatively, the -O option can be
> +used to assign a custom mapping between the ports on a given switch,
> +and the associated dimension.  Paths are grown from a destination back
> +to a source using the lowest dimension (port) of available paths at
> +each step.  This provides the ordering necessary to avoid deadlock.
>   When there are multiple links between any two switches, they still
>   represent only one dimension and traffic is balanced across them
>   unless port equalization is turned off.  In the case of hypercubes,
>   the same port must be used throughout the fabric to represent the
> -hypercube dimension and match on both ends of the cable.  In the case
> -of meshes, the dimension should consistently use the same pair of
> -ports, one port on one end of the cable, and the other port on the
> -other end, continuing along the mesh dimension.
> +hypercube dimension and match on both ends of the cable, or the -O
> +option used to accomplish the alignment.  In the case of meshes, the
> +dimension should consistently use the same pair of ports, one port on
> +one end of the cable, and the other port on the other end, continuing
> +along the mesh dimension, or the -O option used as an override.
> 
>   Use '-R dor' option to activate the DOR algorithm.
> 
> @@ -1111,3 +1125,6 @@ Thomas Sodring
>   .TP
>   Ira Weiny
>   .RI < weiny2-i2BcT+NCU+M@public.gmane.org >
> +.TP
> +Dale Purdy
> +.RI < purdy-sJ/iWh9BUns@public.gmane.org >
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index f9a33af..0093aa7 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -275,6 +275,10 @@ static void show_usage(void)
>   	       "          This option provides the means to define a weighting\n"
>   	       "          factor per port for customizing the least weight\n"
>   	       "          hops for the routing.\n\n");
> +	printf("--dimn_ports_file, -O <path to file>\n"
> +	       "          This option provides the means to define a mapping\n"
> +	       "          between ports and dimension (Order) for controlling\n"
> +	       "          Dimension Order Routing (DOR).\n\n");
>   	printf("--honor_guid2lid, -x\n"
>   	       "          This option forces OpenSM to honor the guid2lid file,\n"
>   	       "          when it comes out of Standby state, if such file exists\n"
> @@ -543,7 +547,7 @@ int main(int argc, char *argv[])
>   	char *conf_template = NULL, *config_file = NULL;
>   	uint32_t val;
>   	const char *const short_option =
> -	    "F:c:i:w:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:k:C:G:H:";
> +	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:k:C:G:H:";
> 
>   	/*
>   	   In the array below, the 2nd parameter specifies the number
> @@ -560,6 +564,7 @@ int main(int argc, char *argv[])
>   		{"guid", 1, NULL, 'g'},
>   		{"ignore_guids", 1, NULL, 'i'},
>   		{"hop_weights_file", 1, NULL, 'w'},
> +		{"dimn_ports_file", 1, NULL, 'O'},
>   		{"lmc", 1, NULL, 'l'},
>   		{"sweep", 1, NULL, 's'},
>   		{"timeout", 1, NULL, 't'},
> @@ -696,6 +701,12 @@ int main(int argc, char *argv[])
>   			       opt.hop_weights_file);
>   			break;
> 
> +		case 'O':
> +			opt.dimn_ports_file = optarg;
> +			printf(" Dimension Ports File = %s\n",
> +			       opt.dimn_ports_file);
> +			break;
> +
>   		case 'g':
>   			/*
>   			   Specifies port guid with which to bind.
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index e4126bc..e3f118b 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -324,6 +324,7 @@ static const opt_rec_t opt_tbl[] = {
>   	{ "force_heavy_sweep", OPT_OFFSET(force_heavy_sweep), opts_parse_boolean, NULL, 1 },
>   	{ "port_prof_ignore_file", OPT_OFFSET(port_prof_ignore_file), opts_parse_charp, NULL, 0 },
>   	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_parse_charp, NULL, 0 },
> +	{ "dimn_ports_file", OPT_OFFSET(dimn_ports_file), opts_parse_charp, NULL, 0 },
>   	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
>   	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
>   	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
> @@ -742,6 +743,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>   	p_opt->accum_log_file = TRUE;
>   	p_opt->port_prof_ignore_file = NULL;
>   	p_opt->hop_weights_file = NULL;
> +	p_opt->dimn_ports_file = NULL;
>   	p_opt->port_profile_switch_nodes = FALSE;
>   	p_opt->sweep_on_trap = TRUE;
>   	p_opt->use_ucast_cache = FALSE;
> @@ -1385,6 +1387,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>   		p_opts->hop_weights_file ? p_opts->hop_weights_file : null_str);
> 
>   	fprintf(out,
> +		"# The file holding non-default port order per switch for DOR routing \n"
> +		"dimn_ports_file %s\n\n",
> +		p_opts->dimn_ports_file ? p_opts->dimn_ports_file : null_str);
> +
> +	fprintf(out,
>   		"# Routing engine\n"
>   		"# Multiple routing engines can be specified separated by\n"
>   		"# commas so that specific ordering of routing algorithms will\n"
> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
> index 1cd8bfc..398fd65 100644
> --- a/opensm/opensm/osm_switch.c
> +++ b/opensm/opensm/osm_switch.c
> @@ -341,7 +341,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
> 
>   	/* port number starts with one and num_ports is 1 + num phys ports */
>   	for (i = start_from; i < start_from + num_ports; i++) {
> -		port_num = i%num_ports;
> +		port_num = osm_switch_get_dimn_port(p_sw, i%num_ports);
>   		if (!port_num ||
>   		    osm_switch_get_hop_count(p_sw, base_lid, port_num) !=
>   		    least_hops)
> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> index 7ec58b5..e74775c 100644
> --- a/opensm/opensm/osm_ucast_mgr.c
> +++ b/opensm/opensm/osm_ucast_mgr.c
> @@ -46,6 +46,7 @@
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
> +#include <ctype.h>
>   #include <iba/ib_types.h>
>   #include <complib/cl_qmap.h>
>   #include <complib/cl_debug.h>
> @@ -488,6 +489,112 @@ static void set_default_hop_wf(cl_map_item_t * p_map_item, void *ctx)
>   	}
>   }
> 
> +static void free_dimn_ports(cl_map_item_t * p_map_item, void *ctx)
> +{
> +	osm_switch_t *sw = (osm_switch_t *) p_map_item;
> +
> +	if (sw->dimn_ports) {
> +		free(sw->dimn_ports);
> +		sw->dimn_ports = NULL;
> +	}
> +}
> +
> +static int set_dimn_ports(void *ctx, uint64_t guid, char *p)
> +{
> +	osm_ucast_mgr_t *m = ctx;
> +	osm_node_t *node = osm_get_node_by_guid(m->p_subn, cl_hton64(guid));
> +	osm_switch_t *sw;
> +	uint8_t *dimn_ports = NULL;
> +	uint8_t port;
> +	uint *ports = NULL;

'uint' is not something standard (we had some build compatibility issues
with 'uint' in infiniband-diags in the past), so what about 'unsigned
int'?

> +	const int bpw = sizeof(*ports)*8;
> +	int words;
> +	int i = 1; /* port 0 maps to port 0 */
> +
> +	if (!node || !(sw = node->sw)) {
> +		OSM_LOG(m->p_log, OSM_LOG_DEBUG,
> +			"switch with guid 0x%016" PRIx64 " is not found\n",
> +			guid);
> +		return 0;
> +	}
> +
> +	if (sw->dimn_ports) {
> +		OSM_LOG(m->p_log, OSM_LOG_DEBUG,
> +			"switch with guid 0x%016" PRIx64 " already listed\n",
> +			guid);

It is GIUD double listed case, right? Wouldn't OSM_LOG_VERBOSE be more
appropriate?

> +		return 0;
> +	}
> +
> +	dimn_ports = malloc(sizeof(*dimn_ports)*sw->num_ports);
> +	if (!dimn_ports) {
> +		OSM_LOG(m->p_log, OSM_LOG_ERROR,
> +			"ERR 3A07: cannot allocate memory for dimn_ports\n");
> +		return -1;
> +	}
> +	memset(dimn_ports, 0, sizeof(*dimn_ports)*sw->num_ports);
> +
> +	/* the ports array is for record keeping of which ports have
> +	 * been seen */
> +	words = (sw->num_ports + bpw - 1)/bpw;
> +	ports = malloc(words*sizeof(*ports));
> +	if (!ports) {
> +		OSM_LOG(m->p_log, OSM_LOG_ERROR,
> +			"ERR 3A08: cannot allocate memory for ports\n");
> +		return -1;
> +	}
> +	memset(ports, 0, words*sizeof(*ports));
> +
> +	while ((*p != '\0') && (*p != '#')) {
> +		char *e;
> +
> +		port = strtoul(p, &e, 0);
> +		if ((p == e) || (port == 0) || (port >= sw->num_ports) ||
> +		    !osm_node_get_physp_ptr(node, port)) {
> +			OSM_LOG(m->p_log, OSM_LOG_DEBUG,
> +				"bad port %d specified for guid 0x%016" PRIx64 "\n",
> +				port, guid);
> +			free(dimn_ports);
> +			free(ports);

Ditto.

> +			return 0;
> +		}
> +
> +		if (ports[port/bpw] & (1u << (port%bpw))) {
> +			OSM_LOG(m->p_log, OSM_LOG_DEBUG,
> +				"port %d already specified for guid 0x%016" PRIx64 "\n",
> +				port, guid);

Ditto.

> +			free(dimn_ports);
> +			free(ports);
> +			return 0;
> +		}
> +
> +		ports[port/bpw] |= (1u << (port%bpw));
> +		dimn_ports[i++] = port;
> +
> +		p = e;
> +		while (isspace(*p)) {
> +			p++;
> +		}
> +	}
> +
> +	if (i > 1) {
> +		for (port = 1; port < sw->num_ports; port++) {
> +			/* fill out the rest of the dimn_ports array
> +			 * in sequence using the remaining unspecified
> +			 * ports.
> +			 */
> +			if (!(ports[port/bpw] & (1u << (port%bpw)))) {
> +				dimn_ports[i++] = port;
> +			}
> +		}
> +		sw->dimn_ports = dimn_ports;
> +	} else {
> +		free(dimn_ports);
> +	}
> +
> +	free(ports);
> +	return 0;
> +}
> +
>   int osm_ucast_mgr_build_lid_matrices(IN osm_ucast_mgr_t * p_mgr)
>   {
>   	uint32_t i;
> @@ -515,6 +622,19 @@ int osm_ucast_mgr_build_lid_matrices(IN osm_ucast_mgr_t * p_mgr)
>   		}
>   	}
> 
> +	cl_qmap_apply_func(p_sw_guid_tbl, free_dimn_ports, NULL);
> +	if (p_mgr->p_subn->opt.dimn_ports_file) {
> +		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
> +			"Fetching dimension ports file \'%s\'\n",
> +			p_mgr->p_subn->opt.dimn_ports_file);
> +		if (parse_node_map(p_mgr->p_subn->opt.dimn_ports_file,
> +				   set_dimn_ports, p_mgr)) {
> +			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A05: "
> +				"cannot parse dimn_ports_file \'%s\'\n",
> +				p_mgr->p_subn->opt.dimn_ports_file);
> +		}
> +	}
> +

Hmm, if it is DOR only it can be done under 'if (is_dor)' (to save
cycles of other REs). Otherwise (generic usability)
ucast_mgr_setup_all_switches() seems as more appropriate place to have
such setup, no?

And what about adding:

	if (sw->dimn_ports)
		free(dimn_ports);

in osm_switch_delete()?

Sasha

>   	/*
>   	   Set the switch matrices for each switch's own port 0 LID(s)
>   	   then set the lid matrices for the each switch's leaf nodes.
> -- 
> 1.7.0
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
