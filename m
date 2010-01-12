From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add update_desc command to opensm console
Date: Tue, 12 Jan 2010 14:14:23 +0200
Message-ID: <20100112121423.GA574@me>
References: <4B4C3386.5040205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B4C3386.5040205-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

On 10:32 Tue 12 Jan     , Eli Dorfman (Voltaire) wrote:
> Add update_desc command to opensm console
> 
> Sometimes nodes are discovered by the opensm with their default
> name before real host name was resolves and updated in the HCA.
> Since Mellanox ConnectX HCA do not support NodeDescription
> change trap (as part of trap 144) we need an option to refresh
> NodeDescription from console.
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

I understand the reason for the patch. Two questions are below.

> ---
>  opensm/opensm/osm_console.c   |   16 +++++++++++++
>  opensm/opensm/osm_state_mgr.c |   48 +++++++++++++++++++++++++++++-----------
>  2 files changed, 51 insertions(+), 13 deletions(-)
> 
> diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
> index 206e7f7..e90cb99 100644
> --- a/opensm/opensm/osm_console.c
> +++ b/opensm/opensm/osm_console.c
> @@ -56,6 +56,8 @@
>  #include <opensm/osm_perfmgr.h>
>  #include <opensm/osm_subnet.h>
>  
> +extern void osm_update_node_desc(IN osm_sm_t *sm);
> +
>  struct command {
>  	char *name;
>  	void (*help_function) (FILE * out, int detail);
> @@ -207,6 +209,14 @@ static void help_dump_conf(FILE *out, int detail)
>  	}
>  }
>  
> +static void help_update_desc(FILE *out, int detail)
> +{
> +	fprintf(out, "update_desc\n");
> +	if (detail) {
> +		fprintf(out, "update node description for all nodes\n");
> +	}
> +}
> +
>  #ifdef ENABLE_OSM_PERF_MGR
>  static void help_perfmgr(FILE * out, int detail)
>  {
> @@ -1134,6 +1144,11 @@ static void dump_conf_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
>  	osm_subn_output_conf(out, &p_osm->subn.opt);
>  }
>  
> +static void update_desc_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
> +{
> +	osm_update_node_desc(&p_osm->sm);
> +}
> +
>  #ifdef ENABLE_OSM_PERF_MGR
>  static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
>  {
> @@ -1326,6 +1341,7 @@ static const struct command console_cmds[] = {
>  	{"switchbalance", &help_switchbalance, &switchbalance_parse},
>  	{"lidbalance", &help_lidbalance, &lidbalance_parse},
>  	{"dump_conf", &help_dump_conf, &dump_conf_parse},
> +	{"update_desc", &help_update_desc, &update_desc_parse},
>  	{"version", &help_version, &version_parse},
>  #ifdef ENABLE_OSM_PERF_MGR
>  	{"perfmgr", &help_perfmgr, &perfmgr_parse},
> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 6296f21..01dfba6 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -510,11 +510,7 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
>  			ib_get_err_str(ret));
>  }
>  
> -/**********************************************************************
> - During a light sweep, check each node to see if the node description
> - is valid and if not issue a ND query.
> -**********************************************************************/
> -static void state_mgr_get_node_desc(IN cl_map_item_t * obj, IN void *context)
> +static void state_mgr_update_node_desc(IN cl_map_item_t * obj, IN void *context)
>  {
>  	osm_madw_context_t mad_context;
>  	osm_node_t *p_node = (osm_node_t *) obj;
> @@ -527,14 +523,8 @@ static void state_mgr_get_node_desc(IN cl_map_item_t * obj, IN void *context)
>  
>  	CL_ASSERT(p_node);
>  
> -	if (p_node->print_desc
> -	    && strcmp(p_node->print_desc, OSM_NODE_DESC_UNKNOWN))
> -		/* if ND is valid, do nothing */
> -		goto exit;
> -
> -	OSM_LOG(sm->p_log, OSM_LOG_ERROR,
> -		"ERR 3319: Unknown node description for node GUID "
> -		"0x%016" PRIx64 ".  Reissuing ND query\n",
> +	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
> +		"Updating NodeDesc for 0x%016" PRIx64 "\n",
>  		cl_ntoh64(osm_node_get_node_guid(p_node)));
>  
>  	/* get a physp to request from. */
> @@ -563,6 +553,38 @@ exit:
>  	OSM_LOG_EXIT(sm->p_log);
>  }
>  
> +void osm_update_node_desc(IN osm_sm_t *sm)
> +{
> +	CL_PLOCK_ACQUIRE(sm->p_lock);

Wouldn't you need exclusive locking here (CL_PLOCK_EXCL_ACQUIRE())?

> +	cl_qmap_apply_func(&sm->p_subn->node_guid_tbl, state_mgr_update_node_desc,
> +			   sm);
> +	CL_PLOCK_RELEASE(sm->p_lock);
> +}
> +
> +/**********************************************************************
> + During a light sweep, check each node to see if the node description
> + is valid and if not issue a ND query.
> +**********************************************************************/
> +static void state_mgr_get_node_desc(IN cl_map_item_t * obj, IN void *context)
> +{
> +	osm_node_t *p_node = (osm_node_t *) obj;
> +	osm_sm_t *sm = context;
> +
> +	OSM_LOG_ENTER(sm->p_log);
> +
> +	CL_ASSERT(p_node);
> +
> +	if (p_node->print_desc
> +	    && strcmp(p_node->print_desc, OSM_NODE_DESC_UNKNOWN))
> +		/* if ND is valid, do nothing */
> +		goto exit;
> +

Seems that "ERR 3319:"  error message was dropped forever. Any reason
for doing this?

Sasha

> +	state_mgr_update_node_desc(obj, context);
> +
> +exit:
> +	OSM_LOG_EXIT(sm->p_log);
> +}
> +
>  /**********************************************************************
>   Initiates a lightweight sweep of the subnet.
>   Used during normal sweeps after the subnet is up.
> -- 
> 1.5.5
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
