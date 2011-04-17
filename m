From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] OpenSM - The DnUp routing algorithm.
Date: Sun, 17 Apr 2011 09:37:46 +0300
Message-ID: <20110417063746.GB31523@calypso.voltaire.com>
References: <20110324170633.55C82451A77@cu0login3.emsl.pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110324170633.55C82451A77-3GowgxBEfRkyPe/kX8gMlWWJnu75u/By@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi Ken,

This is the first round of comments.
First of all, I noticed that there is a big amount of code that is almost
identical to UpDn. Have you considered to 'tweak' osm_ucast_updn.c instead of
creating a new file? I'm not sure that it's the best way to go, but it might
reduce the code. The question is whether this approach will keep the code
readable and clean enough.

On 16:04 Wed 23 Mar     , Ken Schmidt wrote:
> This routing algorithm operates in a very similar fashion to UpDn, but
> is modified to allow optimal routing on certain network structures in
> which uplinks and CA nodes are connected to the same switch nodes. (For
> example Chinook at EMSL and RoadRunner at LANL.) In these networks the
> optimal paths between nodes connected to a single chassis would remain
> within the chassis.  However due to the uplinks being connected at the
> same level of the network as the CA nodes UpDn will not allow these paths
> to be used for communication between the CA nodes.
> 
> DnUp follows the same procedure as UpDn with a few differences.  Ranking
> is based solely on the relative distance from CA nodes, any switch node
> with a CA node directly attached is assigned a rank of 0 any switch
> node without a CA node attached is assigned a rank of one greater than
> the minimum rank of their neighbors. Transitions are also reversed;
> The initial direction is down and only one transition to up
> is allowed.  There is also an option which relaxes this restriction to
> allow communication with switches nodes similar to the functionality of
> connect_roots in UpDn.
> 
> ---
>  include/opensm/osm_opensm.h |    1 +
>  include/opensm/osm_subnet.h |    5 +
>  man/opensm.8.in             |   18 ++-
>  opensm/Makefile.am          |    4 +-
>  opensm/main.c               |    2 +-
>  opensm/osm_opensm.c         |    6 +
>  opensm/osm_subnet.c         |   14 ++-
>  opensm/osm_ucast_dnup.c     |  467 +++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 512 insertions(+), 5 deletions(-)
>  create mode 100644 opensm/osm_ucast_dnup.c
> 
> diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
> index 8d63111..3ebf533 100644
> --- a/include/opensm/osm_opensm.h
> +++ b/include/opensm/osm_opensm.h
> @@ -101,6 +101,7 @@ typedef enum _osm_routing_engine_type {
>  	OSM_ROUTING_ENGINE_TYPE_NONE = 0,
>  	OSM_ROUTING_ENGINE_TYPE_MINHOP,
>  	OSM_ROUTING_ENGINE_TYPE_UPDN,
> +	OSM_ROUTING_ENGINE_TYPE_DNUP,
>  	OSM_ROUTING_ENGINE_TYPE_FILE,
>  	OSM_ROUTING_ENGINE_TYPE_FTREE,
>  	OSM_ROUTING_ENGINE_TYPE_LASH,
> diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
> index 42ae416..465f220 100644
> --- a/include/opensm/osm_subnet.h
> +++ b/include/opensm/osm_subnet.h
> @@ -236,6 +236,7 @@ typedef struct osm_subn_opt {
>  	struct osm_subn_opt *file_opts; /* used for update */
>  	uint8_t lash_start_vl;			/* starting vl to use in lash */
>  	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
> +	uint8_t prune_weight;
>  } osm_subn_opt_t;
>  /*
>  * FIELDS
> @@ -503,6 +504,10 @@ typedef struct osm_subn_opt {
>  *	no_clients_rereg
>  *		When TRUE disables clients reregistration request.
>  *
> +*	prune_weight
> +*		when not zero, add the value to hops which should be
> +*		pruned by DnUp to allow a completely connected subnet.
> +*
>  * SEE ALSO
>  *	Subnet object
>  *********/
> diff --git a/man/opensm.8.in b/man/opensm.8.in
> index cd3a24f..58ef291 100644
> --- a/man/opensm.8.in
> +++ b/man/opensm.8.in
> @@ -152,7 +152,7 @@ separated by commas so that specific ordering of routing algorithms
>  will be tried if earlier routing engines fail.  If all configured
>  routing engines fail, OpenSM will always attempt to route with Min Hop
>  unless 'no_fallback' is included in the list of routing engines.
> -Supported engines: minhop, updn, file, ftree, lash, dor, torus-2QoS.
> +Supported engines: minhop, updn, dnup, file, ftree, lash, dor, torus-2QoS.
>  .TP
>  \fB\-\-do_mesh_analysis\fR
>  This option enables additional analysis for the lash routing engine to
> @@ -667,6 +667,10 @@ node, but it is constrained to ranking rules. This algorithm should be chosen
>  if the subnet is not a pure Fat Tree, and deadlock may occur due to a
>  loop in the subnet.
>  
> +3. DNUP Unicast routing algorithm - similar to UPDN but allows routing in
> +fabrics which have some Ca nodes attached closer to the roots than some switch
> +nodes.
> +
>  3.  Fat Tree Unicast routing algorithm - this algorithm optimizes routing
>  for congestion-free "shift" communication pattern.
>  It should be chosen if a subnet is a symmetrical or almost symmetrical
> @@ -836,6 +840,18 @@ format will be discarded.
>  possible to specify CA guids; OpenSM will use the guid of the switch (if
>  it exists) that connects the CA to the subnet as a root node.
>  
> +Purpose of DNUP Algorithm
> +
> +The DNUP algorithm is designed to serve a similar purpose to UPDN. However
> +it is intended to work in network topologies which are unsuited to
> +UPDN due to nodes being connected closer to the roots than some of
> +the switches.  An example would be a fabric which contains nodes and
> +uplinks connected to the same switch. The operation of DNUP is the
> +same as UPDN with the exception of the ranking process.  In DNUP all
> +switch nodes are ranked based solely on their distance from Ca Nodes,
> +all switch nodes directly connected to at least one Ca are assigned a
> +value of 1 all other switch nodes are assigned a value of one more than
> +the minimum rank of all neighbor swich nodes.

Typo: should be "switch nodes"

>  
>  Fat-tree Routing Algorithm
>  
> diff --git a/opensm/Makefile.am b/opensm/Makefile.am
> index 69ff593..074d90f 100644
> --- a/opensm/Makefile.am
> +++ b/opensm/Makefile.am
> @@ -53,8 +53,8 @@ opensm_SOURCES = main.c osm_console_io.c osm_console.c osm_db_files.c \
>  		 osm_prtn.c osm_prtn_config.c osm_qos.c osm_router.c \
>  		 osm_trap_rcv.c osm_ucast_mgr.c osm_ucast_updn.c \
>  		 osm_ucast_lash.c osm_ucast_file.c osm_ucast_ftree.c \
> -		 osm_torus.c osm_vl15intf.c osm_vl_arb_rcv.c \
> -		 st.c osm_perfmgr.c osm_perfmgr_db.c \
> +		 osm_torus.c  osm_ucast_dnup.c osm_vl15intf.c \
                            /\
Extra space         ---------

> +		 osm_vl_arb_rcv.c st.c osm_perfmgr.c osm_perfmgr_db.c \
>  		 osm_event_plugin.c osm_dump.c osm_ucast_cache.c \
>  		 osm_qos_parser_y.y osm_qos_parser_l.l osm_qos_policy.c
>  
> diff --git a/opensm/main.c b/opensm/main.c
> index 756fe6f..9c40ead 100644
> --- a/opensm/main.c
> +++ b/opensm/main.c
> @@ -177,7 +177,7 @@ static void show_usage(void)
>  	       "          If all configured routing engines fail, OpenSM will always\n"
>  	       "          attempt to route with Min Hop unless 'no_fallback' is\n"
>  	       "          included in the list of routing engines.\n"
> -	       "          Supported engines: updn, file, ftree, lash, dor, torus-2QoS\n\n");
> +	       "          Supported engines: updn, dnup, file, ftree, lash, dor, torus-2QoS\n\n");
>  	printf("--do_mesh_analysis\n"
>  	       "          This option enables additional analysis for the lash\n"
>  	       "          routing engine to precondition switch port assignments\n"
> diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
> index 82aa987..d464331 100644
> --- a/opensm/osm_opensm.c
> +++ b/opensm/osm_opensm.c
> @@ -66,6 +66,7 @@ struct routing_engine_module {
>  
>  extern int osm_ucast_minhop_setup(struct osm_routing_engine *, osm_opensm_t *);
>  extern int osm_ucast_updn_setup(struct osm_routing_engine *, osm_opensm_t *);
> +extern int osm_ucast_dnup_setup(struct osm_routing_engine *, osm_opensm_t *);
>  extern int osm_ucast_file_setup(struct osm_routing_engine *, osm_opensm_t *);
>  extern int osm_ucast_ftree_setup(struct osm_routing_engine *, osm_opensm_t *);
>  extern int osm_ucast_lash_setup(struct osm_routing_engine *, osm_opensm_t *);
> @@ -75,6 +76,7 @@ extern int osm_ucast_torus2QoS_setup(struct osm_routing_engine *, osm_opensm_t *
>  const static struct routing_engine_module routing_modules[] = {
>  	{"minhop", osm_ucast_minhop_setup},
>  	{"updn", osm_ucast_updn_setup},
> +	{"dnup", osm_ucast_dnup_setup},
>  	{"file", osm_ucast_file_setup},
>  	{"ftree", osm_ucast_ftree_setup},
>  	{"lash", osm_ucast_lash_setup},
> @@ -92,6 +94,8 @@ const char *osm_routing_engine_type_str(IN osm_routing_engine_type_t type)
>  		return "minhop";
>  	case OSM_ROUTING_ENGINE_TYPE_UPDN:
>  		return "updn";
> +	case OSM_ROUTING_ENGINE_TYPE_DNUP:
> +		return "dnup";
>  	case OSM_ROUTING_ENGINE_TYPE_FILE:
>  		return "file";
>  	case OSM_ROUTING_ENGINE_TYPE_FTREE:
> @@ -120,6 +124,8 @@ osm_routing_engine_type_t osm_routing_engine_type(IN const char *str)
>  		return OSM_ROUTING_ENGINE_TYPE_NONE;
>  	else if (!strcasecmp(str, "updn"))
>  		return OSM_ROUTING_ENGINE_TYPE_UPDN;
> +	else if (!strcasecmp(str, "dnup"))
> +		return OSM_ROUTING_ENGINE_TYPE_DNUP;
>  	else if (!strcasecmp(str, "file"))
>  		return OSM_ROUTING_ENGINE_TYPE_FILE;
>  	else if (!strcasecmp(str, "ftree"))
> diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> index 228418f..b549a1b 100644
> --- a/opensm/osm_subnet.c
> +++ b/opensm/osm_subnet.c
> @@ -402,6 +402,7 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
>  	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
>  	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
> +	{ "prune_weight", OPT_OFFSET(prune_weight), opts_parse_uint8, NULL, 1 },

Isn't it enough for "prune_weight" to be just enable/disable? prune_weight can
be defined as diameter of the graph + 1. Diameter could be calculated as max
min_hop from each switch to each lid.

>  	{0}
>  };
>  
> @@ -755,6 +756,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>  	p_opt->lash_start_vl = 0;
>  	p_opt->sm_sl = OSM_DEFAULT_SL;
>  	p_opt->log_prefix = NULL;
> +	p_opt->prune_weight = 0;
>  	subn_init_qos_options(&p_opt->qos_options, NULL);
>  	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
>  	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
> @@ -1375,7 +1377,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		"# Multiple routing engines can be specified separated by\n"
>  		"# commas so that specific ordering of routing algorithms will\n"
>  		"# be tried if earlier routing engines fail.\n"
> -		"# Supported engines: minhop, updn, file, ftree, lash, dor\n"
> +		"# Supported engines: minhop, updn, dnup, file, ftree, lash, dor\n"
>  		"routing_engine %s\n\n", p_opts->routing_engine_names ?
>  		p_opts->routing_engine_names : null_str);
>  
> @@ -1454,6 +1456,16 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>  		p_opts->torus_conf_file ? p_opts->torus_conf_file : null_str);
>  
>  	fprintf(out,
> +		"# Weight added to hops which violate DnUp rules.\n"
> +		"# This allows connections to nodes that wouldn't otherwise\n"
> +		"# be reachable. This should be set to a value greater than\n"
> +		"# the largest hop on the subnet (e.g. 32)\n"
> +		"# If zero, don't allow hops to cross links that violate\n"
> +		"# DnUp rules.\n"
> +		"prune_weight %d\n\n",
> +		p_opts->prune_weight);
> +
> +	fprintf(out,
>  		"#\n# HANDOVER - MULTIPLE SMs OPTIONS\n#\n"
>  		"# SM priority used for deciding who is the master\n"
>  		"# Range goes from 0 (lowest priority) to 15 (highest).\n"
> diff --git a/opensm/osm_ucast_dnup.c b/opensm/osm_ucast_dnup.c
> new file mode 100644
> index 0000000..8a6a9fd
> --- /dev/null
> +++ b/opensm/osm_ucast_dnup.c
> @@ -0,0 +1,467 @@
> +/*
> + * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> + * Copyright (c) 2002-2007,2009 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.

You should use your copyright message

> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +/*
> + * Abstract:
> + *      Implementation of Up Down Algorithm using ranking & Min Hop
> + *      Calculation functions
> + */
> +
> +#if HAVE_CONFIG_H
> +#  include <config.h>
> +#endif				/* HAVE_CONFIG_H */
> +
> +#include <stdlib.h>
> +#include <ctype.h>
> +#include <complib/cl_debug.h>
> +#include <complib/cl_qmap.h>
> +#include <opensm/osm_switch.h>
> +#include <opensm/osm_opensm.h>
> +#include <opensm/osm_ucast_mgr.h>
> +
> +/* //////////////////////////// */
> +/*  Local types                 */
> +/* //////////////////////////// */
> +
> +/* direction */
> +typedef enum dnup_switch_dir {
> +	UP = 0,
> +	DOWN,
> +	EQUAL
> +} dnup_switch_dir_t;
> +
> +/* dnup structure */
> +typedef struct dnup {
> +	osm_opensm_t *p_osm;
> +} dnup_t;
> +
> +struct dnup_node {
> +	cl_list_item_t list;
> +	osm_switch_t *sw;
> +	dnup_switch_dir_t dir;
> +	unsigned rank;
> +	unsigned visited;
> +};
> +
> +/* This function returns direction based on rank and guid info of current &
> +   remote ports */
> +static dnup_switch_dir_t dnup_get_dir(unsigned cur_rank, unsigned rem_rank)
> +{
> +	/* HACK: comes to solve root nodes connection, in a classic subnet root nodes do not connect
> +	   directly, but in case they are we assign to root node an UP direction to allow DNUP to discover
> +	   the subnet correctly (and not from the point of view of the last root node).
> +	 */
> +	if (!cur_rank && !rem_rank)
> +		return UP;
> +

Can't you return EQUAL for this case also?

> +	if (cur_rank < rem_rank)
> +		return DOWN;
> +	else if (cur_rank > rem_rank)
> +		return UP;
> +	else
> +		return EQUAL;
> +}
> +
> +/**********************************************************************
> + * This function does the bfs of min hop table calculation by guid index
> + * as a starting point.
> + **********************************************************************/
> +static int dnup_bfs_by_node(IN osm_log_t * p_log, IN osm_subn_t * p_subn,
> +			    IN osm_switch_t * p_sw)
> +{
> +	uint8_t pn, pn_rem;
> +	cl_qlist_t list;
> +	uint16_t lid;
> +	struct dnup_node *u;
> +	dnup_switch_dir_t next_dir, current_dir;
> +
> +	OSM_LOG_ENTER(p_log);
> +
> +	lid = osm_node_get_base_lid(p_sw->p_node, 0);
> +	lid = cl_ntoh16(lid);
> +	osm_switch_set_hops(p_sw, lid, 0, 0);
> +
> +	OSM_LOG(p_log, OSM_LOG_DEBUG,
> +		"Starting from switch - port GUID 0x%" PRIx64 " lid %u\n",
> +		cl_ntoh64(p_sw->p_node->node_info.port_guid), lid);
> +
> +	u = p_sw->priv;
> +	u->dir = DOWN;
> +
> +	/* Update list with the new element */
> +	cl_qlist_init(&list);
> +	cl_qlist_insert_tail(&list, &u->list);
> +
> +	/* BFS the list till no next element */
> +	while (!cl_is_qlist_empty(&list)) {
> +		u = (struct dnup_node *)cl_qlist_remove_head(&list);
> +		u->visited = 0;	/* cleanup */
> +		current_dir = u->dir;
> +		/* Go over all ports of the switch and find unvisited remote nodes */
> +		for (pn = 1; pn < u->sw->num_ports; pn++) {
> +			osm_node_t *p_remote_node;
> +			struct dnup_node *rem_u;
> +			uint8_t current_min_hop, remote_min_hop,
> +			    set_hop_return_value;
> +			osm_switch_t *p_remote_sw;
> +
> +			p_remote_node =
> +			    osm_node_get_remote_node(u->sw->p_node, pn,
> +						     &pn_rem);
> +			/* If no remote node OR remote node is not a SWITCH
> +			   continue to next pn */
> +			if (!p_remote_node || !p_remote_node->sw)
> +				continue;
> +			/* Fetch remote guid only after validation of remote node */
> +			p_remote_sw = p_remote_node->sw;
> +			rem_u = p_remote_sw->priv;
> +			/* Decide which direction to mark it (UP/DOWN) */
> +			next_dir = dnup_get_dir(u->rank, rem_u->rank);
> +
> +			/* Set MinHop value for the current lid */
> +			current_min_hop = osm_switch_get_least_hops(u->sw, lid);
> +			/* Check hop count if better insert into list && update
> +			   the remote node Min Hop Table */
> +			remote_min_hop =
> +			    osm_switch_get_hop_count(p_remote_sw, lid, pn_rem);
> +
> +			/* Check if this is a legal step : the only illegal step is going
> +			   from UP to DOWN */
> +			if ((current_dir == UP) && (next_dir == DOWN)) {
> +				OSM_LOG(p_log, OSM_LOG_DEBUG,
> +					"Avoiding move from 0x%016" PRIx64
> +					" to 0x%016" PRIx64 "\n",
> +					cl_ntoh64(osm_node_get_node_guid(u->sw->p_node)),
> +					cl_ntoh64(osm_node_get_node_guid(p_remote_node)));
> +				/* Illegal step */
> +				if(p_subn->opt.prune_weight) {
> +					current_min_hop+=p_subn->opt.prune_weight;

You can go out of limit here (>64 hops). 

> +				} else {
> +					continue;
> +				}
> +			}
> +			if (current_min_hop + 1 < remote_min_hop) {
> +				set_hop_return_value =
> +				    osm_switch_set_hops(p_remote_sw, lid,
> +							pn_rem,
> +							current_min_hop + 1);
> +				if (set_hop_return_value) {
> +					OSM_LOG(p_log, OSM_LOG_ERROR, "ERR AA01: "

"ERR XXYY" should be unique within the opensm code. XX - should be unique
within the whole opensm code and YY - should be unique within the file.

> +						"Invalid value returned from set min hop is: %d\n",
> +						set_hop_return_value);
> +				}
> +				/* Check if remote port has already been visited */
> +				if (!rem_u->visited) {
> +					/* Insert dnup_switch item into the list */
> +					rem_u->dir = next_dir;
> +					rem_u->visited = 1;
> +					cl_qlist_insert_tail(&list,
> +							     &rem_u->list);
> +				}
> +			}
> +		}
> +	}
> +
> +	OSM_LOG_EXIT(p_log);
> +	return 0;
> +}
> +
> +/* NOTE : PLS check if we need to decide that the first */
> +/*        rank is a SWITCH for BFS purpose */
> +static int dnup_subn_rank(IN dnup_t * p_dnup)
> +{
> +	osm_switch_t *p_sw;
> +	osm_physp_t *p_physp, *p_remote_physp;
> +	cl_qlist_t list;
> +	cl_map_item_t *item;
> +	struct dnup_node *u, *remote_u;
> +	uint8_t num_ports, port_num;
> +	osm_log_t *p_log = &p_dnup->p_osm->log;
> +	unsigned max_rank = 0;
> +
> +	OSM_LOG_ENTER(p_log);
> +	cl_qlist_init(&list);
> +
> +	/* add all node level switches to the list */
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		u = p_sw->priv;
> +		if (u->rank == 0)
> +			cl_qlist_insert_tail(&list, &u->list);

I'm not sure how this works. In dnup_lid_matrices(), you initialized u->rank=1
> +	}
> +
> +	/* BFS the list till it's empty */
> +	while (!cl_is_qlist_empty(&list)) {
> +		u = (struct dnup_node *)cl_qlist_remove_head(&list);
> +		/* Go over all remote nodes and rank them (if not already visited) */
> +		p_sw = u->sw;
> +		num_ports = p_sw->num_ports;
> +		OSM_LOG(p_log, OSM_LOG_DEBUG,
> +			"Handling switch GUID 0x%" PRIx64 "\n",
> +			cl_ntoh64(osm_node_get_node_guid(p_sw->p_node)));
> +		for (port_num = 1; port_num < num_ports; port_num++) {
> +			ib_net64_t port_guid;
> +
> +			/* Current port fetched in order to get remote side */
> +			p_physp =
> +			    osm_node_get_physp_ptr(p_sw->p_node, port_num);
> +
> +			if (!p_physp)
> +				continue;
> +
> +			p_remote_physp = p_physp->p_remote_physp;
> +
> +			/*
> +			   make sure that all the following occur on p_remote_physp:
> +			   1. The port isn't NULL
> +			   2. It is a switch
> +			 */
> +			if (p_remote_physp && p_remote_physp->p_node->sw) {
> +				remote_u = p_remote_physp->p_node->sw->priv;
> +				port_guid = p_remote_physp->port_guid;
> +
> +				if (remote_u->rank > u->rank + 1) {
> +					remote_u->rank = u->rank + 1;
> +					max_rank = remote_u->rank;
> +					cl_qlist_insert_tail(&list,
> +							     &remote_u->list);
> +					OSM_LOG(p_log, OSM_LOG_DEBUG,
> +						"Rank of port GUID 0x%" PRIx64
> +						" = %u\n", cl_ntoh64(port_guid),
> +						remote_u->rank);
> +				}
> +			}
> +		}
> +	}
> +
> +	/* Print Summary of ranking */
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE,
> +		"Subnet ranking completed. Max Node Rank = %d\n", max_rank);
> +	OSM_LOG_EXIT(p_log);
> +	return 0;
> +}
> +
> +static int dnup_set_min_hop_table(IN dnup_t * p_dnup)
> +{
> +	osm_subn_t *p_subn = &p_dnup->p_osm->subn;
> +	osm_log_t *p_log = &p_dnup->p_osm->log;
> +	osm_switch_t *p_sw;
> +	cl_map_item_t *item;
> +
> +	OSM_LOG_ENTER(p_log);
> +
> +	/* Go over all the switches in the subnet - for each init their Min Hop
> +	   Table */
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE,
> +		"Init Min Hop Table of all switches [\n");
> +
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		/* Clear Min Hop Table */
> +		osm_switch_clear_hops(p_sw);
> +	}
> +
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE,
> +		"Init Min Hop Table of all switches ]\n");
> +
> +	/* Now do the BFS for each port  in the subnet */
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE,
> +		"BFS through all port guids in the subnet [\n");
> +
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		dnup_bfs_by_node(p_log, p_subn, p_sw);
> +	}
> +
> +	OSM_LOG(p_log, OSM_LOG_VERBOSE,
> +		"BFS through all port guids in the subnet ]\n");
> +	/* Cleanup */
> +	OSM_LOG_EXIT(p_log);
> +	return 0;
> +}
> +
> +static int dnup_build_lid_matrices(IN dnup_t * p_dnup)
> +{
> +	int status;
> +
> +	OSM_LOG_ENTER(&p_dnup->p_osm->log);
> +
> +	OSM_LOG(&p_dnup->p_osm->log, OSM_LOG_VERBOSE,
> +		"Ranking all port guids in the list\n");
> +	/* Check if it's not a switched subnet */
> +	if (cl_is_qmap_empty(&p_dnup->p_osm->subn.sw_guid_tbl)) {
> +		OSM_LOG(&p_dnup->p_osm->log, OSM_LOG_ERROR, "ERR AAOB: "
> +			"This is not a switched subnet, cannot perform DNUP algorithm\n");
> +		status = -1;
> +		goto _exit;
> +	}
> +
> +	/* Rank the subnet switches */
> +	dnup_subn_rank(p_dnup);
> +
> +	/* After multiple ranking need to set Min Hop Table by DnUp algorithm  */
> +	OSM_LOG(&p_dnup->p_osm->log, OSM_LOG_VERBOSE,
> +		"Setting all switches' Min Hop Table\n");
> +	status = dnup_set_min_hop_table(p_dnup);
> +
> +_exit:
> +	OSM_LOG_EXIT(&p_dnup->p_osm->log);
> +	return status;
> +}
> +
> +static struct dnup_node *create_dnup_node(osm_switch_t * sw)
> +{
> +	struct dnup_node *u;
> +
> +	u = malloc(sizeof(*u));
> +	if (!u)
> +		return NULL;
> +	memset(u, 0, sizeof(*u));
> +	u->sw = sw;
> +	u->rank = 0xffffffff;
> +	return u;
> +}
> +
> +static void delete_dnup_node(struct dnup_node *u)
> +{
> +	u->sw->priv = NULL;
> +	free(u);
> +}
> +
> +static void dump_roots(cl_map_item_t *item, FILE *file, void *cxt)
> +{
> +	osm_switch_t *sw = (osm_switch_t *)item;
> +	if (!((struct dnup_node *)sw->priv)->rank)
> +		fprintf(file, "0x%" PRIx64 "\n",
> +			cl_ntoh64(osm_node_get_node_guid(sw->p_node)));
> +}
> +
> +/* DNUP callback function */
> +static int dnup_lid_matrices(void *ctx)
> +{
> +	dnup_t *p_dnup = ctx;
> +	cl_map_item_t *item;
> +	osm_switch_t *p_sw;
> +	int ret = 0;
> +	uint8_t pn, pn_rem, end_points;
> +
> +	OSM_LOG_ENTER(&p_dnup->p_osm->log);
> +
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		p_sw->priv = create_dnup_node(p_sw);
> +		if (!p_sw->priv) {
> +			OSM_LOG(&(p_dnup->p_osm->log), OSM_LOG_ERROR, "ERR AA0C: "
> +				"cannot create dnup node\n");
> +			OSM_LOG_EXIT(&p_dnup->p_osm->log);
> +			return -1;
> +		}
> +	}
> +
> +
> +	/* First setup node level nodes */
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +
> +		end_points = 0;
> +		for (pn = 0; pn < p_sw->num_ports; pn++) {
> +			osm_node_t *p_remote_node;
> +			p_remote_node = osm_node_get_remote_node(p_sw->p_node, pn, &pn_rem);
> +			if(p_remote_node && !p_remote_node->sw) {
> +				end_points++;

Isn't it enough to find at least end_port per switch and use "break" here?
> +			}
> +		}
> +		if (end_points) {
> +			struct dnup_node *u = p_sw->priv;
> +			u->rank = 1;
> +			OSM_LOG(&(p_dnup->p_osm->log), OSM_LOG_ERROR, "(%s) host level node: %d\n", p_sw->p_node->print_desc, end_points);
> +		} else {
> +			OSM_LOG(&(p_dnup->p_osm->log), OSM_LOG_ERROR, "(%s) switch level node\n", p_sw->p_node->print_desc);
> +		}
                                                            /\
                                                     --------
These log messages should be with OSM_LOG_DEBUG or OSM_LOG_VERBOSE
verbosity

> +	}
> +	ret = dnup_build_lid_matrices(p_dnup);

What do you expect to happen in fabric with no end_ports at all?
> +
> +	if (osm_log_is_active(&p_dnup->p_osm->log, OSM_LOG_ROUTING))
> +		osm_dump_qmap_to_file(p_dnup->p_osm, "opensm-dnup-roots.dump",
> +				      &p_dnup->p_osm->subn.sw_guid_tbl,
> +				      dump_roots, NULL);

What is the purpose of opensm-dnup-roots.dump file?

> +
> +	for (item = cl_qmap_head(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_dnup->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *) item;
> +		delete_dnup_node(p_sw->priv);
> +	}
> +
> +	OSM_LOG_EXIT(&p_dnup->p_osm->log);
> +	return ret;
> +}
> +
> +static void dnup_delete(void *context)
> +{
> +	free(context);
> +}
> +
> +int osm_ucast_dnup_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
> +{
> +	dnup_t *dnup;
> +
> +	OSM_LOG_ENTER(&osm->log);
> +
> +	dnup = malloc(sizeof(dnup_t));
> +	if (!dnup)
> +		return -1;
> +	memset(dnup, 0, sizeof(dnup_t));
> +
> +	dnup->p_osm = osm;
> +
> +	r->context = dnup;
> +	r->delete = dnup_delete;
> +	r->build_lid_matrices = dnup_lid_matrices;
> +
> +	OSM_LOG_EXIT(&osm->log);
> +	return 0;
> +}
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
i> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- Alex 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
