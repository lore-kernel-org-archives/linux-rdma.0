From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_updn.c: Reduce temporary allocation
 of cas_per_sw
Date: Wed, 14 Oct 2009 15:29:11 +0200
Message-ID: <20091014132911.GB13830@me>
References: <20091014131435.GA23890@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091014131435.GA23890-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:14 Wed 14 Oct     , Hal Rosenstock wrote:
> 
> Also, combine malloc/memset into calloc 

Any special reason for malloc/calloc change?

Please don't mix two things in one patch.

Sasha

> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
> index bb9ccda..a2acdbd 100644
> --- a/opensm/opensm/osm_ucast_updn.c
> +++ b/opensm/opensm/osm_ucast_updn.c
> @@ -2,6 +2,7 @@
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>   * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -431,13 +432,12 @@ static void updn_find_root_nodes_by_min_hop(OUT updn_t * p_updn)
>  		"Current number of ports in the subnet is %d\n",
>  		cl_qmap_count(&p_osm->subn.port_guid_tbl));
>  
> -	cas_per_sw = malloc((IB_LID_UCAST_END_HO + 1) * sizeof(*cas_per_sw));
> +	cas_per_sw = calloc(p_osm->subn.max_ucast_lid_ho, sizeof(*cas_per_sw));
>  	if (!cas_per_sw) {
>  		OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR AA14: "
>  			"cannot alloc mem for CAs per switch counter array\n");
>  		goto _exit;
>  	}
> -	memset(cas_per_sw, 0, (IB_LID_UCAST_END_HO + 1) * sizeof(*cas_per_sw));
>  
>  	/* Find the Maximum number of CAs (and routers) for histogram normalization */
>  	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
