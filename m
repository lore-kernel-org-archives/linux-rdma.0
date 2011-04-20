From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_state_mgr.c: Don't rely on
 PortInfo:PortState for base SP0
Date: Wed, 20 Apr 2011 17:17:13 +0300
Message-ID: <20110420141713.GD28761@calypso.voltaire.com>
References: <4DAC3CCC.4090101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DAC3CCC.4090101-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 09:29 Mon 18 Apr     , Hal Rosenstock wrote:
> 
> For base SP0, PortState in SM PortInfo attribute is not used and base SP0
> is always "active". 

How SM can be attached to base SP0?
Moreover, if during discovery we found that SM is attached to base SP0, don't
we want to act like the port is down?

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
> index 2e1ef94..dd308f2 100644
> --- a/opensm/osm_state_mgr.c
> +++ b/opensm/osm_state_mgr.c
> @@ -352,7 +352,11 @@ static boolean_t state_mgr_is_sm_port_down(IN osm_sm_t * sm)
>  
>  	CL_ASSERT(p_physp);
>  
> -	state = osm_physp_get_port_state(p_physp);
> +	if (p_port->p_node->sw &&
> +	    !ib_switch_info_is_enhanced_port0(&p_port->p_node->sw->switch_info))
> +		state = IB_LINK_ACTIVE;	/* base SP0 */
> +	else
> +		state = osm_physp_get_port_state(p_physp);
>  	CL_PLOCK_RELEASE(sm->p_lock);
>  
>  Exit:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
