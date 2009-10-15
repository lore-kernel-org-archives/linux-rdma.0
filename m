From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_updn.c: Further reduction in
 cas_per_sw memory allocation
Date: Thu, 15 Oct 2009 21:24:06 +0200
Message-ID: <20091015192406.GE20210@me>
References: <20091015133445.GA8041@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091015133445.GA8041-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:34 Thu 15 Oct     , Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
> index ced076a..c46b033 100644
> --- a/opensm/opensm/osm_ucast_updn.c
> +++ b/opensm/opensm/osm_ucast_updn.c
> @@ -424,7 +424,7 @@ static void updn_find_root_nodes_by_min_hop(OUT updn_t * p_updn)
>  	double thd1, thd2;
>  	unsigned i, cas_num = 0;
>  	unsigned *cas_per_sw;
> -	uint16_t lid_ho;
> +	uint16_t lid_ho = 0;
>  
>  	OSM_LOG_ENTER(&p_osm->log);
>  
> @@ -432,13 +432,21 @@ static void updn_find_root_nodes_by_min_hop(OUT updn_t * p_updn)
>  		"Current number of ports in the subnet is %d\n",
>  		cl_qmap_count(&p_osm->subn.port_guid_tbl));
>  
> -	cas_per_sw = malloc(p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
> +	for (item = cl_qmap_head(&p_updn->p_osm->subn.sw_guid_tbl);
> +	     item != cl_qmap_end(&p_updn->p_osm->subn.sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		if (p_sw->lft_size > lid_ho)
> +			lid_ho = p_sw->lft_size;
> +	}

It doesn't look very effective to me - lft_size can be larger than
max_lid_ho + 1 and never smaller. Also I don't like looping here. Why to
not just:

	lid_ho = cl_ptr_vector_get_size(&p_subn->port_lid_tbl);

?

Sasha

> +
> +	cas_per_sw = malloc(lid_ho * sizeof(*cas_per_sw));
>  	if (!cas_per_sw) {
>  		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR AA14: "
>  			"cannot alloc mem for CAs per switch counter array\n");
>  		goto _exit;
>  	}
> -	memset(cas_per_sw, 0, p_osm->subn.max_ucast_lid_ho * sizeof(*cas_per_sw));
> +	memset(cas_per_sw, 0, lid_ho * sizeof(*cas_per_sw));
>  
>  	/* Find the Maximum number of CAs (and routers) for histogram normalization */
>  	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
