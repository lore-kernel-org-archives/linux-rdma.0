From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Cosmetic changes
Date: Sun, 15 Nov 2009 13:39:20 +0200
Message-ID: <20091115113920.GX7192@me>
References: <20091113163720.GA13938@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113163720.GA13938-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:37 Fri 13 Nov     , Hal Rosenstock wrote:
> 
> Compressed some type declarations and assignments into single line
> Removed some unneeded underbars
> Some minor reformatting including comment lines
> Fixed some tabbing
> Fixed some typos
> Eliminated trailing periods in messages
> Eliminated some unneeded braces
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied with one change (below). Thanks.

[snip]

> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 122a8d4..32b162c 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -174,8 +174,8 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
>  	mad_context.pi_context.light_sweep = TRUE;
>  	mad_context.pi_context.active_transition = FALSE;
>  
> -	/* note that with some negative logic - if the query failed it means that
> -	 * there is no point in going to heavy sweep */
> +	/* note that with some negative logic - if the query failed it means
> +	 * that there is no point in going to heavy sweep */
>  	status = osm_req_get(sm, &rem_node_dr_path,
>  			     IB_MAD_ATTR_PORT_INFO, 0, CL_DISP_MSGID_NONE,
>  			     &mad_context);
> @@ -445,12 +445,12 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
>  		break;
>  
>  	case IB_NODE_TYPE_SWITCH:
> -		/* Need to go over all the ports of the switch, and send a node_info
> -		 * from them. This doesn't include the port 0 of the switch, which
> -		 * hosts the SM.
> -		 * Note: We'll send another switchInfo on port 0, since if no ports
> -		 * are connected, we still want to get some response, and have the
> -		 * subnet come up.
> +		/* Need to go over all the ports of the switch, and send a
> +		 * node_info from them. This doesn't include the port 0 of the
> +		 * switch, which hosts the SM.
> +		 * Note: We'll send another switchInfo on port 0, since if no
> +		 * ports are connected, we still want to get some response, and
> +		 * have the subnet come up.
>  		 */
>  		num_ports = osm_node_get_num_physp(p_node);
>  		for (port_num = 1; port_num < num_ports; port_num++) {
> @@ -497,6 +497,7 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
>  	osm_sm_t *sm = cxt;
>  	ib_api_status_t ret;
>  
> +OSM_LOG(sm->p_log, OSM_LOG_ERROR, "GUID 0x%" PRIx64 "\n", cl_ntoh64(r_sm->p_port->guid));

Assuming that this whole line is a typo (please review patches visually
before hitting send) I'm removing it.

Sasha

>  	context.smi_context.port_guid = r_sm->p_port->guid;
>  	context.smi_context.set_method = FALSE;
>  	context.smi_context.light_sweep = TRUE;
> @@ -834,7 +835,7 @@ static void state_mgr_report_new_ports(IN osm_sm_t * sm)
>  		/* details of the notice */
>  		notice.generic_type = 0x83;	/* is generic subn mgt type */
>  		ib_notice_set_prod_type_ho(&notice, 4);	/* A Class Manager generator */
> -		/* endport becomes to be reachable */
> +		/* endport becomes reachable */
>  		notice.g_or_v.generic.trap_num = CL_HTON16(64);
>  		/* The sm_base_lid is saved in network order already. */
>  		notice.issuer_lid = sm->p_subn->sm_base_lid;
> @@ -1125,7 +1126,7 @@ static void do_sweep(osm_sm_t * sm)
>  	}
>  
>  	/* go to heavy sweep */
> -_repeat_discovery:
> +repeat_discovery:
>  
>  	/* First of all - unset all flags */
>  	sm->p_subn->force_heavy_sweep = FALSE;
> @@ -1162,7 +1163,7 @@ _repeat_discovery:
>  	    wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
>  		return;
>  
> -	/* discovery completed - check other sm presense */
> +	/* discovery completed - check other sm presence */
>  	if (sm->master_sm_found) {
>  		/*
>  		 * Call the sm_state_mgr with signal
> @@ -1179,7 +1180,7 @@ _repeat_discovery:
>  
>  	/* if new sweep requested - don't bother with the rest */
>  	if (sm->p_subn->force_heavy_sweep)
> -		goto _repeat_discovery;
> +		goto repeat_discovery;
>  
>  	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HEAVY SWEEP COMPLETE");
>  
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
