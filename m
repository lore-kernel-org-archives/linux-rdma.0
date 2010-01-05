From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
 programming
Date: Tue, 5 Jan 2010 13:18:41 +0200
Message-ID: <20100105111841.GO26940@me>
References: <20091201194110.GA26753@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091201194110.GA26753-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 14:41 Tue 01 Dec     , Hal Rosenstock wrote:
> 
> Optimized SLtoVLMappingTable programming reduces the number of MADs
> needed from O(n**2) to O(n). See IBA 1.2.1 vol 1 p. 843 14.2.5.8
> SLtoVLMappingTable.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

[snip]

> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index 08f9a60..617a86e 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c

[snip]

> @@ -290,6 +306,44 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>  	/* read QoS policy config file */
>  	osm_qos_parse_policy_file(&p_osm->subn);
>  
> +	/* loop on switches that support optimized SL2VL programming first */
> +	p_tbl = &p_osm->subn.sw_guid_tbl;
> +	p_next = cl_qmap_head(p_tbl);
> +	while (p_next != cl_qmap_end(p_tbl)) {
> +		p_sw = (osm_switch_t *) p_next;
> +		p_next = cl_qmap_next(p_next);
> +
> +		if (ib_switch_info_get_opt_sl2vlmapping(&p_sw->switch_info) &&
> +		    p_osm->subn.opt.use_optimized_slvl) {
> +			p_physp = osm_node_get_physp_ptr(p_sw->p_node, 1);
> +			num_physp = osm_node_get_num_physp(p_sw->p_node);
> +			force_update = p_osm->subn.need_update;
> +			for (i = 1; i < num_physp; i++) {
> +				p_physp = osm_node_get_physp_ptr(p_sw->p_node, i);
> +				if (!p_physp)
> +					continue;
> +				if (vlarb_physp_setup(&p_osm->sm, p_physp, i,
> +						      p_physp->need_update ||
> +						      p_osm->subn.need_update,
> +						      &swe_config))
> +					ret = -1;
> +				force_update |= p_physp->need_update;
> +			}
> +			if (sl2vl_update(&p_osm->sm,
> +					 osm_node_get_physp_ptr(p_sw->p_node, 0),
> +					 p_physp, i, 1, force_update,

At this point i = num_physp, which is an invalid switch port number,
right?

Sasha


> +					 &swe_config)) {
> +				OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 6204: "
> +					"failed to update optimized SL2VLMapping"
> +					" tables for port %" PRIx64 " #%d\n",
> +					cl_ntoh64(p_physp->port_guid), i);
> +				ret = -1;
> +			}
> +		}
> +	}
> +
> +	/* now, loop on ports skipping the external ports of switches
> +	   that support optimized SL2VL programming */
>  	p_tbl = &p_osm->subn.port_guid_tbl;
>  	p_next = cl_qmap_head(p_tbl);
>  	while (p_next != cl_qmap_end(p_tbl)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
