From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by unicast routing
 tables (LFTs)
Date: Mon, 12 Oct 2009 17:46:29 +0200
Message-ID: <20091012154629.GD31778@me>
References: <20091004160541.GA28310@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091004160541.GA28310-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 12:05 Sun 04 Oct     , Hal Rosenstock wrote:
> 
> Heap memory consumption by the unicast and multicast routing tables can be
> reduced.
> 
> Using valgrind --tool=massif (for heap profiling), there are couple of places that consume most of the heap memory:
> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:96)
> 
> osm_switch_new (osm_switch.c:108):
>        p_sw->lft = malloc(IB_LID_UCAST_END_HO + 1);
> 
> From ib_types.h
>  #define IB_LID_UCAST_END_HO 0xBFFF
> 
> The LFT can be allocated after LID assignment, once the number of LIDs
> assigned is known.
> 
> So it looks like for cluster of 2-4K with an LMC of 0 about 40% (!!!) of the
> heap memory can be saved:
> 
>  - 39% used by LFTs, each with 48K entries - SM can allocate 4K entries instead.
> 
> A similar subsequent change will do this for MFTs.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v2:
> Fixed alloc_lft handling of an existing lft
> Moved alloc_lft into osm_switch_prepare_path_rebuild 
> 
> Changes since v1:
> Basic approach changed to not do in chunks but rather allocate
> LFT once LID assignment is completed
> 
> diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
> index 502e5a7..d881576 100644
> --- a/opensm/include/opensm/osm_switch.h
> +++ b/opensm/include/opensm/osm_switch.h
> @@ -102,6 +102,7 @@ typedef struct osm_switch {
>  	osm_port_profile_t *p_prof;
>  	uint8_t *lft;
>  	uint8_t *new_lft;
> +	uint16_t lft_size;
>  	osm_mcast_tbl_t mcast_tbl;
>  	int32_t mft_block_num;
>  	uint32_t mft_position;
> @@ -253,7 +254,7 @@ static inline uint8_t osm_switch_get_hop_count(IN const osm_switch_t * p_sw,
>  					       IN uint16_t lid_ho,
>  					       IN uint8_t port_num)
>  {
> -	return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
> +	return (lid_ho >= p_sw->lft_size || !p_sw->hops[lid_ho]) ?
>  	    OSM_NO_PATH : p_sw->hops[lid_ho][port_num];
>  }
>  /*
> @@ -341,7 +342,7 @@ void osm_switch_clear_hops(IN osm_switch_t * p_sw);
>  static inline uint8_t osm_switch_get_least_hops(IN const osm_switch_t * p_sw,
>  						IN uint16_t lid_ho)
>  {
> -	return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid_ho]) ?
> +	return (lid_ho >= p_sw->lft_size || !p_sw->hops[lid_ho]) ?

Now LFT buffer is only increased in size, so in cases then actual number
of lids was decreased (and p_sw->max_lid_ho + 1 < p_sw->lft_size) such
changed check may return garbage data from previous cycles. I think the
check:

	lid_ho > p_sw->max_lid_ho

should be preserved rather than:

	lid_ho >= p_sw->lft_size

>  	    OSM_NO_PATH : p_sw->hops[lid_ho][0];
>  }
>  /*
> @@ -405,7 +406,7 @@ uint8_t osm_switch_get_port_least_hops(IN const osm_switch_t * p_sw,
>  static inline uint8_t osm_switch_get_port_by_lid(IN const osm_switch_t * p_sw,
>  						 IN uint16_t lid_ho)
>  {
> -	if (lid_ho == 0 || lid_ho > IB_LID_UCAST_END_HO)
> +	if (lid_ho == 0 || lid_ho >= p_sw->lft_size)

Similar story? Shouldn't this be checked against p_sw->max_lid_ho? 

>  		return OSM_NO_PATH;
>  	return p_sw->lft[lid_ho];
>  }
> @@ -711,7 +712,7 @@ osm_switch_set_lft_block(IN osm_switch_t * p_sw, IN const uint8_t * p_block,
>  		(uint16_t) (block_num * IB_SMP_DATA_SIZE);
>  	CL_ASSERT(p_sw);
>  
> -	if (lid_start + IB_SMP_DATA_SIZE > IB_LID_UCAST_END_HO)
> +	if (lid_start + IB_SMP_DATA_SIZE > p_sw->lft_size)
>  		return IB_INVALID_PARAMETER;
>  
>  	memcpy(&p_sw->lft[lid_start], p_block, IB_SMP_DATA_SIZE);
> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
> index 185c700..c40c9d3 100644
> --- a/opensm/opensm/osm_state_mgr.c
> +++ b/opensm/opensm/osm_state_mgr.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
> @@ -1011,9 +1011,9 @@ static void cleanup_switch(cl_map_item_t * item, void *log)
>  	if (!sw->new_lft)
>  		return;
>  
> -	if (memcmp(sw->lft, sw->new_lft, IB_LID_UCAST_END_HO + 1))
> +	if (memcmp(sw->lft, sw->new_lft, sw->lft_size))
>  		osm_log(log, OSM_LOG_ERROR, "ERR 331D: "
> -			"LFT of switch 0x%016" PRIx64 " is not up to date.\n",
> +			"LFT of switch 0x%016" PRIx64 " is not up to date\n",
>  			cl_ntoh64(sw->p_node->node_info.node_guid));
>  	else {
>  		free(sw->new_lft);
> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
> index ad1018f..7d51c05 100644
> --- a/opensm/opensm/osm_switch.c
> +++ b/opensm/opensm/osm_switch.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
> @@ -130,12 +130,6 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
>  	p_sw->num_ports = num_ports;
>  	p_sw->need_update = 2;
>  
> -	p_sw->lft = malloc(IB_LID_UCAST_END_HO + 1);
> -	if (!p_sw->lft)
> -		goto err;
> -
> -	memset(p_sw->lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> -
>  	p_sw->p_prof = malloc(sizeof(*p_sw->p_prof) * num_ports);
>  	if (!p_sw->p_prof)
>  		goto err;
> @@ -166,7 +160,7 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
>  	CL_ASSERT(p_sw);
>  	CL_ASSERT(p_block);
>  
> -	if (base_lid_ho > p_sw->max_lid_ho)
> +	if (base_lid_ho >= p_sw->lft_size)

Ditto.

>  		return FALSE;
>  
>  	CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <= IB_LID_UCAST_END_HO);
> @@ -498,21 +492,54 @@ void osm_switch_clear_hops(IN osm_switch_t * p_sw)
>  
>  /**********************************************************************
>   **********************************************************************/
> +static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
> +{
> +	uint16_t lft_size;
> +	uint8_t *new_lft;
> +
> +	lft_size = lids;
> +	/* Ensure LFT is in units of LFT block size */
> +	if (lids % IB_SMP_DATA_SIZE)
> +		lft_size = (lids + IB_SMP_DATA_SIZE) / IB_SMP_DATA_SIZE * IB_SMP_DATA_SIZE;

Could be slightly faster:

	lft_size = (lids + IB_SMP_DATA_SIZE - 1) / IB_SMP_DATA_SIZE * IB_SMP_DATA_SIZE;

> +
> +	if (!p_sw->lft) {
> +		new_lft = malloc(lft_size);
> +		if (!new_lft)
> +			return -1;
> +		memset(new_lft, OSM_NO_PATH, lft_size);
> +		p_sw->lft = new_lft;
> +		p_sw->lft_size = lft_size;
> +	} else if (lft_size > p_sw->lft_size) {
> +		new_lft = realloc(p_sw->lft, lft_size);
> +		if (!new_lft)
> +			return -1;
> +		memset(new_lft + p_sw->lft_size, OSM_NO_PATH,
> +		       lft_size - p_sw->lft_size);
> +		p_sw->lft = new_lft;
> +		p_sw->lft_size = lft_size;
> +	}

I think that this if/else if can be merged since initially p_sw->lft_size
is zero.

Sasha

> +	return 0;
> +}
> +
> +/**********************************************************************
> + **********************************************************************/
>  int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids)
>  {
>  	uint8_t **hops;
>  	unsigned i;
>  
> +	if (alloc_lft(p_sw, max_lids))
> +		return -1;
> +
>  	for (i = 0; i < p_sw->num_ports; i++)
>  		osm_port_prof_construct(&p_sw->p_prof[i]);
>  
>  	osm_switch_clear_hops(p_sw);
>  
> -	if (!p_sw->new_lft &&
> -	    !(p_sw->new_lft = malloc(IB_LID_UCAST_END_HO + 1)))
> -		return IB_INSUFFICIENT_MEMORY;
> +	if (!(p_sw->new_lft = realloc(p_sw->new_lft, p_sw->lft_size)))
> +		return -1;
>  
> -	memset(p_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> +	memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
>  
>  	if (!p_sw->hops) {
>  		hops = malloc((max_lids + 1) * sizeof(hops[0]));
> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_ucast_cache.c
> index 6d3c53e..31a5333 100644
> --- a/opensm/opensm/osm_ucast_cache.c
> +++ b/opensm/opensm/osm_ucast_cache.c
> @@ -1079,10 +1079,10 @@ int osm_ucast_cache_process(osm_ucast_mgr_t * p_mgr)
>  			/* no new routing was recently calculated for this
>  			   switch, but the LFT needs to be updated anyway */
>  			p_sw->new_lft = p_sw->lft;
> -			p_sw->lft = malloc(IB_LID_UCAST_END_HO + 1);
> +			p_sw->lft = malloc(p_sw->lft_size);
>  			if (!p_sw->lft)
>  				return IB_INSUFFICIENT_MEMORY;
> -			memset(p_sw->lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> +			memset(p_sw->lft, OSM_NO_PATH, p_sw->lft_size);
>  		}
>  
>  	}
> diff --git a/opensm/opensm/osm_ucast_file.c b/opensm/opensm/osm_ucast_file.c
> index 5b73ca5..7c1b5ba 100644
> --- a/opensm/opensm/osm_ucast_file.c
> +++ b/opensm/opensm/osm_ucast_file.c
> @@ -193,8 +193,7 @@ static int do_ucast_file_load(void *context)
>  					cl_ntoh64(sw_guid));
>  				continue;
>  			}
> -			memset(p_sw->new_lft, OSM_NO_PATH,
> -			       IB_LID_UCAST_END_HO + 1);
> +			memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
>  		} else if (p_sw && !strncmp(p, "0x", 2)) {
>  			p += 2;
>  			lid = (uint16_t) strtoul(p, &q, 16);
> diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
> index 1defd95..885c834 100644
> --- a/opensm/opensm/osm_ucast_ftree.c
> +++ b/opensm/opensm/osm_ucast_ftree.c
> @@ -566,7 +566,7 @@ static ftree_sw_t *sw_create(IN ftree_fabric_t * p_ftree,
>  		return NULL;
>  
>  	/* initialize lft buffer */
> -	memset(p_osm_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> +	memset(p_osm_sw->new_lft, OSM_NO_PATH, p_osm_sw->lft_size);
>  	p_sw->hops = malloc((p_osm_sw->max_lid_ho + 1) * sizeof(*(p_sw->hops)));
>  	if (p_sw->hops == NULL)
>  		return NULL;
> diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
> index 8b0a190..8015226 100644
> --- a/opensm/opensm/osm_ucast_lash.c
> +++ b/opensm/opensm/osm_ucast_lash.c
> @@ -994,7 +994,7 @@ static void populate_fwd_tbls(lash_t * p_lash)
>  
>  	p_next_sw = (osm_switch_t *) cl_qmap_head(&p_subn->sw_guid_tbl);
>  
> -	/* Go through each swtich individually */
> +	/* Go through each switch individually */
>  	while (p_next_sw != (osm_switch_t *) cl_qmap_end(&p_subn->sw_guid_tbl)) {
>  		uint64_t current_guid;
>  		switch_t *sw;
> @@ -1005,7 +1005,7 @@ static void populate_fwd_tbls(lash_t * p_lash)
>  		current_guid = p_sw->p_node->node_info.port_guid;
>  		sw = p_sw->priv;
>  
> -		memset(p_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> +		memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
>  
>  		for (lid = 1; lid <= max_lid_ho; lid++) {
>  			port = cl_ptr_vector_get(&p_subn->port_lid_tbl, lid);
> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> index be37df9..d0e85b1 100644
> --- a/opensm/opensm/osm_ucast_mgr.c
> +++ b/opensm/opensm/osm_ucast_mgr.c
> @@ -372,7 +372,7 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
>  		cl_ntoh64(osm_node_get_node_guid(p_sw->p_node)));
>  
>  	/* Initialize LIDs in buffer to invalid port number. */
> -	memset(p_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
> +	memset(p_sw->new_lft, OSM_NO_PATH, p_sw->max_lid_ho + 1);
>  
>  	if (p_mgr->p_subn->opt.lmc)
>  		alloc_ports_priv(p_mgr);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
