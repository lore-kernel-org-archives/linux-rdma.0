From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: update internal PortInfo state for any ports
Date: Fri, 12 Jul 2013 09:37:57 -0400
Message-ID: <51E006B5.3060808@dev.mellanox.co.il>
References: <20130707205219.GA6084@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130707205219.GA6084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/7/2013 4:56 PM, Sasha Khapyorsky wrote:
> Should not be matter to keep internal SM's PortInfo data for ports
> in any states.

What difference does it make ? Does this patch fix some operational
issue ? Is there any harm in not keeping the complete PortInfo when port
is DOWN ?

At worst, the current implementation is a minor efficiency improvement:
to only copy the 2 required to be valid fields rather than all 64 bytes
in PortInfo. Also, it seems safer to only save the guaranteed valid fields.

-- Hal

> Signed-off-by: Sasha Khapyorsky <sashakh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> diff --git a/opensm/osm_port.c b/opensm/osm_port.c
> index 6e73e66..d59d404 100644
> --- a/opensm/osm_port.c
> +++ b/opensm/osm_port.c
> @@ -669,25 +669,16 @@ void osm_physp_set_port_info(IN osm_physp_t * p_physp,
>  	CL_ASSERT(p_pi);
>  	CL_ASSERT(osm_physp_is_valid(p_physp));
>  
> -	if (ib_port_info_get_port_state(p_pi) == IB_LINK_DOWN) {
> -		/* If PortState is down, only copy PortState */
> -		/* and PortPhysicalState per C14-24-2.1 */
> -		ib_port_info_set_port_state(&p_physp->port_info, IB_LINK_DOWN);
> -		ib_port_info_set_port_phys_state
> -		    (ib_port_info_get_port_phys_state(p_pi),
> -		     &p_physp->port_info);
> -	} else {
> -		p_physp->port_info = *p_pi;
> -
> -		/* The MKey in p_pi can only be considered valid if it's
> -		 * for a HCA/router or switch port 0, and it's either
> -		 * non-zero or the MKeyProtect bits are also zero.
> -		 */
> -		if ((osm_node_get_type(p_physp->p_node) !=
> -		     IB_NODE_TYPE_SWITCH || p_physp->port_num == 0) &&
> -		    (p_pi->m_key != 0 || ib_port_info_get_mpb(p_pi) == 0))
> -			osm_db_guid2mkey_set(p_sm->p_subn->p_g2m,
> -					     cl_ntoh64(p_physp->port_guid),
> -					     cl_ntoh64(p_pi->m_key));
> -	}
> +	p_physp->port_info = *p_pi;
> +
> +	/* The MKey in p_pi can only be considered valid if it's
> +	 * for a HCA/router or switch port 0, and it's either
> +	 * non-zero or the MKeyProtect bits are also zero.
> +	 */
> +	if ((osm_node_get_type(p_physp->p_node) != IB_NODE_TYPE_SWITCH ||
> +	     p_physp->port_num == 0) &&
> +	    (p_pi->m_key != 0 || ib_port_info_get_mpb(p_pi) == 0))
> +		osm_db_guid2mkey_set(p_sm->p_subn->p_g2m,
> +				     cl_ntoh64(p_physp->port_guid),
> +				     cl_ntoh64(p_pi->m_key));
>  }
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
