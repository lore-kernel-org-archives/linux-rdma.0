From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] opensm: support routing engine update
Date: Sun, 06 Dec 2009 18:03:02 +0200
Message-ID: <4B1BD5B6.6000005@dev.mellanox.co.il>
References: <4AED461B.5040302@Voltaire.COM>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AED461B.5040302-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Slava,

Slava Strebkov wrote:
> setup routing engine when in use and delete when failed.
> setup routing engine before use.
> delete resources when routing algorithm fails.
> this will save allocation for routing algorithms that are not used.

Suppose a user runs SM with ftree & updn routings (in that order),
and SM manages to route the fabric with ftree. At some point 
some switch reboots and causes ftree to fail and SM routes the
fabric with updn.
Does this mean that ftree will be removed from the list, and
when the switch comes back, SM won't try ftree any more?

-- Yevgeny
 
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/include/opensm/osm_opensm.h |    5 +++
>  opensm/opensm/osm_opensm.c         |   57 +++++++++++++++++++++++++++++++-----
>  opensm/opensm/osm_subnet.c         |    7 ++++-
>  opensm/opensm/osm_ucast_mgr.c      |   28 +++++++++++++++++
>  4 files changed, 88 insertions(+), 9 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
> index c121be4..ca0fddb 100644
> --- a/opensm/include/opensm/osm_opensm.h
> +++ b/opensm/include/opensm/osm_opensm.h
> @@ -109,6 +109,7 @@ typedef enum _osm_routing_engine_type {
>  } osm_routing_engine_type_t;
>  /***********/
>  
> +struct osm_opensm;
>  /****s* OpenSM: OpenSM/osm_routing_engine
>  * NAME
>  *	struct osm_routing_engine
> @@ -122,6 +123,8 @@ typedef enum _osm_routing_engine_type {
>  struct osm_routing_engine {
>  	const char *name;
>  	void *context;
> +	int initialized;
> +	int (*setup) (struct osm_routing_engine *re, struct osm_opensm *p_osm);
>  	int (*build_lid_matrices) (void *context);
>  	int (*ucast_build_fwd_tables) (void *context);
>  	void (*ucast_dump_tables) (void *context);
> @@ -183,6 +186,7 @@ typedef struct osm_opensm {
>  	cl_dispatcher_t disp;
>  	cl_plock_t lock;
>  	struct osm_routing_engine *routing_engine_list;
> +	struct osm_routing_engine *last_routing_engine;
>  	osm_routing_engine_type_t routing_engine_used;
>  	osm_stats_t stats;
>  	osm_console_t console;
> @@ -522,6 +526,7 @@ extern volatile unsigned int osm_exit_flag;
>  * DESCRIPTION
>  *  Set to one to cause all threads to leave
>  *********/
> +void osm_update_routing_engines(osm_opensm_t *osm, const char *engine_names);
>  
>  END_C_DECLS
>  #endif				/* _OSM_OPENSM_H_ */
> diff --git a/opensm/opensm/osm_opensm.c b/opensm/opensm/osm_opensm.c
> index 50d1349..f90584d 100644
> --- a/opensm/opensm/osm_opensm.c
> +++ b/opensm/opensm/osm_opensm.c
> @@ -169,14 +169,7 @@ static void setup_routing_engine(osm_opensm_t *osm, const char *name)
>  			memset(re, 0, sizeof(struct osm_routing_engine));
>  
>  			re->name = m->name;
> -			if (m->setup(re, osm)) {
> -				OSM_LOG(&osm->log, OSM_LOG_VERBOSE,
> -					"setup of routing"
> -					" engine \'%s\' failed\n", name);
> -				return;
> -			}
> -			OSM_LOG(&osm->log, OSM_LOG_DEBUG,
> -				"\'%s\' routing engine set up\n", re->name);
> +			re->setup = m->setup;
>  			append_routing_engine(osm, re);
>  			return;
>  		}
> @@ -236,6 +229,54 @@ static void destroy_routing_engines(osm_opensm_t *osm)
>  			r->delete(r->context);
>  		free(r);
>  	}
> +    osm->routing_engine_list = NULL;
> +}
> +
> +static void update_routing_engine(
> +       struct osm_routing_engine *cur,
> +       struct osm_routing_engine *last)
> +{
> +	struct osm_routing_engine *next = cur->next;
> +	if (!last)
> +		return; /* no last routing engine */
> +	memcpy(cur, last, sizeof(*cur));
> +	/* restore next */
> +	cur->next = next;
> +}
> +
> +void osm_update_routing_engines(osm_opensm_t *osm, const char *engine_names)
> +{
> +	struct osm_routing_engine *r, *l;
> +	/* find used routing engine and save as last */
> +	l = r = osm->routing_engine_list;
> +	if (r && osm->routing_engine_used == osm_routing_engine_type(r->name)) {
> +		osm->last_routing_engine = r;
> +		osm->routing_engine_list = r->next;
> +	}
> +	else while ((r = r->next)) {
> +		if (osm->routing_engine_used ==
> +			osm_routing_engine_type(r->name)) {
> +				osm->last_routing_engine = r;
> +				l->next = r->next;
> +				break;
> +		}
> +		l = r;
> +	}
> +	/* cleanup prev routing engine list and replace with current list */
> +	destroy_routing_engines(osm);
> +	setup_routing_engines(osm, engine_names);
> +	/* check if last routing engine exist in new list and update callbacks */
> +	r = osm->routing_engine_list;
> +	while (r) {
> +		if (osm->routing_engine_used ==
> +			osm_routing_engine_type(r->name)) {
> +				update_routing_engine(r, osm->last_routing_engine);
> +				free(osm->last_routing_engine);
> +				osm->last_routing_engine = NULL;
> +				break;
> +		}
> +	r = r->next;
> +	}
>  }
>  
>  /**********************************************************************
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index 8d63a75..742ae64 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -152,6 +152,11 @@ static void opts_setup_sm_priority(osm_subn_t *p_subn, void *p_val)
>  	osm_set_sm_priority(p_sm, sm_priority);
>  }
>  
> +static void opts_setup_routing_engine(osm_subn_t *p_subn, void *p_val)
> +{
> +	osm_update_routing_engines(p_subn->p_osm, p_val);
> +}
> +
>  static void opts_parse_net64(IN osm_subn_t *p_subn, IN char *p_key,
>  			     IN char *p_val_str, void *p_v1, void *p_v2,
>  			     void (*pfn)(osm_subn_t *, void *))
> @@ -324,7 +329,7 @@ static const opt_rec_t opt_tbl[] = {
>  	{ "hop_weights_file", OPT_OFFSET(hop_weights_file), opts_parse_charp, NULL, 0 },
>  	{ "port_profile_switch_nodes", OPT_OFFSET(port_profile_switch_nodes), opts_parse_boolean, NULL, 1 },
>  	{ "sweep_on_trap", OPT_OFFSET(sweep_on_trap), opts_parse_boolean, NULL, 1 },
> -	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, NULL, 0 },
> +	{ "routing_engine", OPT_OFFSET(routing_engine_names), opts_parse_charp, opts_setup_routing_engine, 1 },
>  	{ "connect_roots", OPT_OFFSET(connect_roots), opts_parse_boolean, NULL, 1 },
>  	{ "use_ucast_cache", OPT_OFFSET(use_ucast_cache), opts_parse_boolean, NULL, 1 },
>  	{ "log_file", OPT_OFFSET(log_file), opts_parse_charp, NULL, 0 },
> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> index 39d825c..d6294ac 100644
> --- a/opensm/opensm/osm_ucast_mgr.c
> +++ b/opensm/opensm/osm_ucast_mgr.c
> @@ -998,8 +998,23 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
>  
>  	p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_NONE;
>  	while (p_routing_eng) {
> +		if (!p_routing_eng->initialized &&
> +			p_routing_eng->setup(p_routing_eng, p_osm)) {
> +			OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
> +				"ERR 3A0F: setup of routing engine \'%s\' failed\n",
> +					p_routing_eng->name);
> +					p_routing_eng = p_routing_eng->next;
> +					continue;
> +		}
> +		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
> +			"\'%s\' routing engine set up\n", p_routing_eng->name);
> +		p_routing_eng->initialized = 1;
>  		if (!ucast_mgr_route(p_routing_eng, p_osm))
>  			break;
> +		/* delete unused routing engine */
> +		if (p_routing_eng->delete)
> +			p_routing_eng->delete(p_routing_eng->context);
> +		p_routing_eng->initialized = 0;
>  		p_routing_eng = p_routing_eng->next;
>  	}
>  
> @@ -1011,6 +1026,19 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
>  		p_osm->routing_engine_used = OSM_ROUTING_ENGINE_TYPE_MINHOP;
>  	}
>  
> +	/* if for some reason different routing engine is used */
> +	/* cleanup last unused routing engine */
> +	p_routing_eng = p_osm->last_routing_engine;
> +	if (p_routing_eng) {
> +			if (p_routing_eng->initialized &&
> +					p_routing_eng->delete &&
> +					p_osm->routing_engine_used !=
> +						osm_routing_engine_type(p_routing_eng->name))
> +					p_routing_eng->delete(p_routing_eng->context);
> +			free(p_routing_eng);
> +			p_osm->last_routing_engine = NULL;
> +	}
> +
>  	OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
>  		"%s tables configured on all switches\n",
>  		osm_routing_engine_type_str(p_osm->routing_engine_used));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
