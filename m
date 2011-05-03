From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_pkey_mgr: clean partition enforcement on
 inter-switch links
Date: Tue, 3 May 2011 18:48:47 +0300
Message-ID: <20110503154847.GA2303@calypso.voltaire.com>
References: <4DBFB67F.2090400@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DBFB67F.2090400-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

On 11:02 Tue 03 May     , Eli Dorfman wrote:
> clean partition enforcement on inter-switch links
> 
> after connectivity change from switch-host to switch-switch the
> partition enforcement bits were not cleared on the port.
> since the pkey table is not set on inter-switch links,
> packets with pkey other than default are dropped.
> 
> Signed-off-by: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/osm_pkey_mgr.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
> index f6bc9d1..b135cf9 100644
> --- a/opensm/osm_pkey_mgr.c
> +++ b/opensm/osm_pkey_mgr.c
> @@ -507,6 +507,10 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
>  	cl_map_item_t *p_next;
>  	osm_prtn_t *p_prtn;
>  	osm_port_t *p_port;
> +	osm_switch_t *p_sw;
> +	osm_physp_t *p_physp;
> +	osm_node_t *p_remote_node;
> +	uint8_t i;
>  	int ret = 0;
>  
>  	CL_ASSERT(p_osm);
> @@ -550,6 +554,26 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
>  			ret = -1;
>  	}
>  
> +	/* clear partition enforcement on inter-switch links */
> +	p_tbl = &p_osm->subn.sw_guid_tbl;
> +	p_next = cl_qmap_head(p_tbl);
> +	while (p_next != cl_qmap_end(p_tbl)) {
> +		p_sw = (osm_switch_t * *) p_next;
> +		p_next = cl_qmap_next(p_next);
> +		for (i = 1; i < p_sw->num_ports; i++) {
> +			p_physp = osm_node_get_physp_ptr(p_sw->p_node, i);
> +			if (p_physp && p_physp->p_remote_physp)
> +				p_remote_node = p_physp->p_remote_physp->p_node;
> +			else
> +				continue;
> +			if (osm_node_get_type(p_remote_node) != IB_NODE_TYPE_SWITCH)
> +				continue;
> +
> +			/* clear partition enforcement */

Don't you want limit the pkey_mgr_enforce_partition() only on ports that have
these bits enable in portinfo?
Something like:

			if(! p_physp->p_remote_physp->port_info.vl_enforce && 0xc )
				continue;

> +			if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, FALSE))
> +				ret = -1;
> +		}
> +	}
>  _err:
>  	CL_PLOCK_RELEASE(&p_osm->lock);
>  	OSM_LOG_EXIT(&p_osm->log);
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
