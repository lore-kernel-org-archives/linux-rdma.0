From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_trap_rcv.c: In trap_rcv_process_request, no
 need to sweep on trap 145 and certain trap 144s
Date: Fri, 30 Oct 2009 03:57:11 +0200
Message-ID: <20091030015711.GS20136@me>
References: <20090805222737.GA8523@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090805222737.GA8523-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 18:27 Wed 05 Aug     , Hal Rosenstock wrote:
> 
> NodeDescription changed trap only needs to query the new NodeDescription
> and not cause sweep
> 
> Similarly for SystemImageGUID changed (trap 145)
> 
> LinkWidth/SpeedEnabled changed traps (at least right now) and
> SM priority changed traps do need to sweep.
> 
> In the future, LinkWidth/SpeedEnabled changed trap handling
> can query PortInfo (may also need to bounce port too).
> 
> Also, as noted in related email thread, it's unclear what
> sweeping on non generic traps accomplishes but this behavior
> is preserved.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
> index d2e4202..e5bd529 100644
> --- a/opensm/opensm/osm_trap_rcv.c
> +++ b/opensm/opensm/osm_trap_rcv.c
> @@ -291,8 +291,9 @@ trap_rcv_process_request(IN osm_sm_t * sm,
>  	osm_physp_t *p_physp;
>  	cl_ptr_vector_t *p_tbl;
>  	osm_port_t *p_port;
> +	osm_node_t *p_node;
>  	ib_net16_t source_lid = 0;
> -	boolean_t is_gsi = TRUE;
> +	boolean_t is_gsi = TRUE, is_trap144_sweep = FALSE;

What about reusing already existing 'run_heavy_sweep' variable and not
introduce new one?

>  	uint8_t port_num = 0;
>  	boolean_t physp_change_trap = FALSE;
>  	uint64_t event_wheel_timeout = OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT;
> @@ -547,44 +548,59 @@ trap_rcv_process_request(IN osm_sm_t * sm,
>  		}
>  	}

In general: function trap_rcv_process_request() already has 400 lines of
code and adding there more lines without simplifying flows makes me
nervous.

>  
> -	/* Check for node description update. IB Spec v1.2.1 pg 823 */
> -	if (ib_notice_is_generic(p_ntci) &&
> -	    cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 &&
> -	    p_ntci->data_details.ntc_144.local_changes & TRAP_144_MASK_OTHER_LOCAL_CHANGES &&
> -	    p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) {
> -		OSM_LOG(sm->p_log, OSM_LOG_INFO, "Trap 144 Node description update\n");
> -
> -		if (p_physp) {
> -			CL_PLOCK_ACQUIRE(sm->p_lock);
> -			osm_req_get_node_desc(sm, p_physp);
> -			CL_PLOCK_RELEASE(sm->p_lock);
> -		} else
> -			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
> -				"ERR 3812: No physical port found for "
> -				"trap 144: \"node description update\"\n");
> -	}
> +	if (ib_notice_is_generic(p_ntci)) {
> +		/* Check for node description update. IB Spec v1.2.1 pg 823 */
> +		if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144) {
> +			/* update port's capability mask (in PortInfo) */
> +			p_physp->port_info.capability_mask = p_ntci->data_details.ntc_144.new_cap_mask;

Hmm, could this introduce some issues?

> +			if (p_ntci->data_details.ntc_144.local_changes & TRAP_144_MASK_OTHER_LOCAL_CHANGES) {
> +				if (p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_NODE_DESCRIPTION_CHANGE) {

	if ((p_ntci->data_details.ntc_144.local_changes &
	     TRAP_144_MASK_OTHER_LOCAL_CHANGES) &&
	    (p_ntci->data_details.ntc_144.change_flgs &
	     TRAP_144_MASK_NODE_DESCRIPTION_CHANGE)) {

> +					OSM_LOG(sm->p_log, OSM_LOG_INFO,
> +						"Trap 144 Node description update\n");
> +
> +					if (p_physp) {
> +						CL_PLOCK_ACQUIRE(sm->p_lock);
> +						osm_req_get_node_desc(sm, p_physp);
> +						CL_PLOCK_RELEASE(sm->p_lock);
> +					} else
> +						OSM_LOG(sm->p_log, OSM_LOG_ERROR,
> +							"ERR 3812: No physical port found for "
> +							"trap 144: \"node description update\"\n");
> +				}
> +			}
> +			if (p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_LINK_WIDTH_ENABLE_CHANGE ||
> +			    p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_LINK_SPEED_ENABLE_CHANGE ||
> +			    p_ntci->data_details.ntc_144.change_flgs & TRAP_144_MASK_SM_PRIORITY_CHANGE)

	if ((p_ntci->data_details.ntc_144.change_flgs &
	     (TRAP_144_MASK_LINK_WIDTH_ENABLE_CHANGE |
	      TRAP_144_MASK_LINK_SPEED_ENABLE_CHANGE |
	      TRAP_144_MASK_SM_PRIORITY_CHANGE)))


> +				is_trap144_sweep = TRUE;
> +		}
>  
> -	/* do a sweep if we received a trap */
> -	if (sm->p_subn->opt.sweep_on_trap) {
> -		/* if this is trap number 128 or run_heavy_sweep is TRUE -
> -		   update the force_heavy_sweep flag of the subnet.
> -		   Sweep also on traps 144/145 - these traps signal a change of
> -		   certain port capabilities/system image guid.
> -		   TODO: In the future this can be changed to just getting
> -		   PortInfo on this port instead of sweeping the entire subnet. */
> -		if (ib_notice_is_generic(p_ntci) &&
> -		    (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
> -		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 144 ||
> -		     cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145 ||
> -		     run_heavy_sweep)) {
> -			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> -				"Forcing heavy sweep. Received trap:%u\n",
> -				cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
> +		if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
> +			/* update system image guid (in NodeInfo) */
> +			p_node = osm_physp_get_node_ptr(p_physp);
> +			if (p_node)

When 'p_node' could be NULL?

> +				p_node->node_info.node_guid = p_ntci->data_details.ntc_145.new_sys_guid;

Didn't you mean 'node_info.sys_guid' and 'node_info.node_guid'?

> +		}
> +
> +		/* do a sweep if we received a trap */
> +		if (sm->p_subn->opt.sweep_on_trap) {
> +			/* if this is trap number 128 or run_heavy_sweep is
> +			   TRUE - update the force_heavy_sweep flag of the
> +			   subnet. Also, sweep on certain types of trap 144.
> +			   TODO: In the future this can be changed to just
> +			   getting PortInfo on this port instead of sweeping
> +			   the entire subnet. */
> +		    	if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 128 ||
> +			    is_trap144_sweep || run_heavy_sweep) {

It looks that prevents sweeping on PortInfo:CapMask change which
is effectively breaks at least SM handover - new SM will be undetected.

> +				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> +					"Forcing heavy sweep. Received trap:%u\n",
> +					cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
>  
> -			sm->p_subn->force_heavy_sweep = TRUE;
> +				sm->p_subn->force_heavy_sweep = TRUE;
> +			}
> +			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
>  		}
> +	} else if (sm->p_subn->opt.sweep_on_trap)
>  		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
> -	}
>  
>  	/* If we reached here due to trap 129/130/131 - do not need to do
>  	   the notice report. Just goto exit. We know this is the case
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
