From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 09/11] opensm: Make it possible to configure no
 fallback routing engine.
Date: Thu, 4 Mar 2010 14:38:53 -0700
Message-ID: <1267738733.25886.104.camel@sale659.sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
 <1258744509-11148-9-git-send-email-jaschut@sandia.gov>
 <4B8FC53C.9060605@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B8FC53C.9060605-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 2010-03-04 at 07:35 -0700, Yevgeny Kliteynik wrote:
> Hi Jim,
> 
> On 20/Nov/09 21:15, Jim Schutt wrote:
> > For a fabric that requires routing with an engine with special properties,
> > say avoiding credit loops via making use of SLs in routing, it might
> > be preferable to not fall back to minhop if the configured routing engine
> > fails.
> >
> > E.g. the torus-2QoS routing engine uses both SL2VL maps and path SL values
> > to provide routing free of credit loops, but cannot route fabrics for
> > some patterns of failed switches.  Should a switch fail that creates such
> > a pattern, it may be preferable to keep the previous routing information
> > loaded in the switches until a switch can be replaced that restores
> > torus-2QoS's ability to route the fabric.
> >
> > The alternative, having some other engine route the fabric, will immediately
> > introduce credit loops.
> 
> This is a great idea.
> Regarding the implementation: I would prefer seeing this
> as a purely OpenSM option and not as a new routing engine
> keyword.
> I think it would be cleaner to leave the list of routing
> engines w/o special keys, and have a general option
> that would prevent SM from falling back. 

That seems right to me, now.

> Actually, the
> fall-back itself is not bad, as it is defined by the list
> of routing engines, and SM should try them one by one.
> The problem is with using default routing that is not
> specified in the routing engines list.

I agree.  If a user explicitly configures which
routing engines to try, only those should be used,
and a notification logged if they all fail.

> 
> Here's the patch that implements OSM option
> "use_default_routing", and a command line parameter
> "no_default_routing" to control this option.

This looks good to me.

> 
> I'll write the patch that adds this option to the
> OSM trunk and send it to Sasha shortly.

OK, thanks.

-- Jim

> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>   opensm/include/opensm/osm_subnet.h |    2 +-
>   opensm/opensm/main.c               |    9 +++++++++
>   opensm/opensm/osm_opensm.c         |   10 ++++------
>   opensm/opensm/osm_subnet.c         |    8 ++++++++
>   opensm/opensm/osm_ucast_mgr.c      |    7 +++++--
>   5 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
> index a4133a0..905f64d 100644
> --- a/opensm/include/opensm/osm_subnet.h
> +++ b/opensm/include/opensm/osm_subnet.h
> @@ -190,6 +190,7 @@ typedef struct osm_subn_opt {
>   	boolean_t sweep_on_trap;
>   	char *routing_engine_names;
>   	boolean_t use_ucast_cache;
> +	boolean_t use_default_routing;
>   	boolean_t connect_roots;
>   	char *lid_matrix_dump_file;
>   	char *lfts_file;
> @@ -215,7 +216,6 @@ typedef struct osm_subn_opt {
>   	osm_qos_options_t qos_rtr_options;
>   	boolean_t enable_quirks;
>   	boolean_t no_clients_rereg;
> -	boolean_t no_fallback_routing_engine;
>   #ifdef ENABLE_OSM_PERF_MGR
>   	boolean_t perfmgr;
>   	boolean_t perfmgr_redir;
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index 096bf5f..47075a2 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -175,6 +175,10 @@ static void show_usage(void)
>   	       "          separated by commas so that specific ordering of routing\n"
>   	       "          algorithms will be tried if earlier routing engines fail.\n"
>   	       "          Supported engines: updn, file, ftree, lash, dor, torus-2QoS\n\n");
> +	printf("--no_default_routing\n"
> +	       "          This option prevents OpenSM from falling back to default\n"
> +	       "          routing if none of the provided engines was able to\n"
> +	       "          configure the subnet.\n\n");
>   	printf("--do_mesh_analysis\n"
>   	       "          This option enables additional analysis for the lash\n"
>   	       "          routing engine to precondition switch port assignments\n"
> @@ -612,6 +616,7 @@ int main(int argc, char *argv[])
>   		{"sm_sl", 1, NULL, 7},
>   		{"retries", 1, NULL, 8},
>   		{"torus_config", 1, NULL, 9},
> +		{"no_default_routing", 0, NULL, 10},
>   		{NULL, 0, NULL, 0}	/* Required at the end of the array */
>   	};
>   
> @@ -993,6 +998,10 @@ int main(int argc, char *argv[])
>   		case 9:
>   			SET_STR_OPT(opt.torus_conf_file, optarg);
>   			break;
> +		case 10:
> +			opt.use_default_routing = FALSE;
> +			printf(" No fall back to default routing\n");
> +			break;
>   		case 'h':
>   		case '?':
>   		case ':':
> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
> index e7ef55c..d153be5 100644
> --- a/opensm/opensm/osm_opensm.c
> +++ b/opensm/opensm/osm_opensm.c
> @@ -159,11 +159,6 @@ static struct osm_routing_engine *setup_routing_engine(osm_opensm_t *osm,
>   	struct osm_routing_engine *re;
>   	const struct routing_engine_module *m;
>   
> -	if (!strcmp(name, "no_fallback")) {
> -		osm->subn.opt.no_fallback_routing_engine = TRUE;
> -		return NULL;
> -	}
> -
>   	for (m = routing_modules; m->name && *m->name; m++) {
>   		if (!strcmp(m->name, name)) {
>   			re = malloc(sizeof(struct osm_routing_engine));
> @@ -212,7 +207,10 @@ static void setup_routing_engines(osm_opensm_t *osm, const char *engine_names)
>   		}
>   		free(str);
>   	}
> -	if (!osm->default_routing_engine) {
> +
> +	if (!engine_names || !*engine_names ||
> +	    (!osm->default_routing_engine &&
> +	     osm->subn.opt.use_default_routing)) {
>   		re = setup_routing_engine(osm, "minhop");
>   		if (!osm->routing_engine_list && re)
>   			append_routing_engine(osm, re);
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index 03d9538..274e807 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -327,6 +327,7 @@ static const opt_rec_t opt_tbl[] = {
>   	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
>   	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
>   	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
> +	{ "use_default_routing", OPT_OFFSET(use_default_routing), opts_parse_boolean, NULL, 1 },
>   	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
>   	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 1 },
>   	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
> @@ -743,6 +744,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
>   	p_opt->port_profile_switch_nodes = FALSE;
>   	p_opt->sweep_on_trap = TRUE;
>   	p_opt->use_ucast_cache = FALSE;
> +	p_opt->use_default_routing = TRUE;
>   	p_opt->routing_engine_names = NULL;
>   	p_opt->connect_roots = FALSE;
>   	p_opt->lid_matrix_dump_file = NULL;
> @@ -1392,6 +1394,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
>   		p_opts->routing_engine_names : null_str);
>   
>   	fprintf(out,
> +		"# Fall back to default routing engine if the provided\n"
> +		"# routing engine(s) failed to configure the subnet\n"
> +		"use_default_routing %s\n\n",
> +		p_opts->use_default_routing ? "TRUE" : "FALSE");
> +
> +	fprintf(out,
>   		"# Connect roots (use FALSE if unsure)\n"
>   		"connect_roots %s\n\n",
>   		p_opts->connect_roots ? "TRUE" : "FALSE");
> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> index fbc9244..9264753 100644
> --- a/opensm/opensm/osm_ucast_mgr.c
> +++ b/opensm/opensm/osm_ucast_mgr.c
> @@ -979,8 +979,11 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
>   	}
>   
>   	if (!p_osm->routing_engine_used &&
> -	    p_osm->subn.opt.no_fallback_routing_engine != TRUE) {
> -		/* If configured routing algorithm failed, use default MinHop */
> +	    p_osm->default_routing_engine) {
> +		/*
> +		 * If configured routing algorithms failed,
> +		 * and default routing has been set, use it.
> +		 */
>   		struct osm_routing_engine *r = p_osm->default_routing_engine;
>   
>   		r->build_lid_matrices(r->context);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
