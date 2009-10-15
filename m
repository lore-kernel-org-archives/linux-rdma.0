From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by multicast routing
 tables (MFTs)
Date: Thu, 15 Oct 2009 22:42:33 +0200
Message-ID: <20091015204233.GG20210@me>
References: <20091014213546.GA32163@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091014213546.GA32163-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17:35 Wed 14 Oct     , Hal Rosenstock wrote:
> 
> Heap memory consumption by the unicast and multicast routing tables can be
> reduced.
> 
> This patch is analagous to the previous patch doing this for the unicast
> routing tables (LFTs).
> 
> Using valgrind --tool=massif (for heap profiling), there are couple of place
> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:96)
> 
> osm_mcast_tbl_init (osm_mcast_tbl.c:96):
>         p_tbl->p_mask_tbl = malloc(p_tbl->num_entries *
>                                    (IB_MCAST_POSITION_MAX +
>                                     1) * IB_MCAST_MASK_SIZE / 8);
> 
> num_entries above is set based on the switch's MulticastFDBCap
> (indicated in it's SM class SwitchInfo attribute).
> 
> MFTs are only be increased in size and are never reduced in size. If a realloc
> for MFT fails, it is treated as a fatal error and OpenSM is exited.
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v2:
> MFT allocation during routing preparation rather than on table access
> Changes since v1:
> MFT allocation based on actual MLID requests
> 
> diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
> index 710d199..85730e6 100644
> --- a/opensm/include/opensm/osm_mcast_tbl.h
> +++ b/opensm/include/opensm/osm_mcast_tbl.h
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -46,6 +46,7 @@
>  #include <iba/ib_types.h>
>  #include <complib/cl_qmap.h>
>  #include <opensm/osm_base.h>
> +#include <opensm/osm_subnet.h>
>  
>  #ifdef __cplusplus
>  #  define BEGIN_C_DECLS extern "C" {
> @@ -74,6 +75,7 @@ typedef struct osm_mcast_fwdbl {
>  	int16_t max_block_in_use;
>  	uint16_t num_entries;
>  	uint16_t max_mlid_ho;
> +	uint16_t mft_size;

Description for this newly introduced field would be helpful - I had to
spend some time realizing about which units are used here.

>  	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>  } osm_mcast_tbl_t;
>  /*
> @@ -97,7 +99,7 @@ typedef struct osm_mcast_fwdbl {
>  *	max_mlid_ho
>  *		Maximum MLID value (host order).
>  *
> -*	pp_mask_tbl
> +*	p_mask_tbl
>  *		Pointer to a two dimensional array of port_masks for this switch.
>  *		The first dimension is MLID, the second dimension is mask position.
>  *		This pointer is null for switches that do not support multicast.
> @@ -114,8 +116,8 @@ typedef struct osm_mcast_fwdbl {
>  *
>  * SYNOPSIS
>  */
> -ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
> -				   IN uint8_t num_ports, IN uint16_t capacity);
> +void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
> +			IN uint16_t capacity);
>  /*
>  * PARAMETERS
>  *	num_ports
> @@ -126,7 +128,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
>  *		by this switch.
>  *
>  * RETURN VALUE
> -*	IB_SUCCESS on success.
> +*	None.
>  *
>  * NOTES
>  *
> @@ -158,6 +160,38 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t ** pp_tbl);
>  * SEE ALSO
>  *********/
>  
> +/****f* OpenSM: Forwarding Table/osm_mcast_tbl_realloc_mask_tbl
> +* NAME
> +*	osm_mcast_tbl_realloc_mask_tbl
> +*
> +* DESCRIPTION
> +*	This function reallocates the port mask table if necessary.
> +*
> +* SYNOPSIS
> +*/
> +void
> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
> +			       IN osm_subn_t * p_subn, IN uintn_t mlid_offset);
> +/*
> +* PARAMETERS
> +*
> +*	p_tbl
> +*		[in] Pointer to the Multicast Forwarding Table object.
> +*
> +*	p_subn
> +*		[in] Pointer to the subnet object.
> +*
> +*	mlid_offset
> +*		[in] Offset of MLID being accessed.
> +*
> +* RETURN VALUE
> +*	None
> +*
> +* NOTES
> +*
> +* SEE ALSO
> +*/
> +
>  /****f* OpenSM: Forwarding Table/osm_mcast_tbl_destroy
>  * NAME
>  *	osm_mcast_tbl_destroy
> diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
> index 08b3156..c004b6c 100644
> --- a/opensm/opensm/osm_dump.c
> +++ b/opensm/opensm/osm_dump.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
>   * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -232,6 +232,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
>  static void dump_mcast_routes(cl_map_item_t * item, FILE * file, void *cxt)
>  {
>  	osm_switch_t *p_sw = (osm_switch_t *) item;
> +	osm_opensm_t *p_osm = cxt;
>  	osm_mcast_tbl_t *p_tbl;
>  	int16_t mlid_ho = 0;
>  	int16_t mlid_start_ho;
> @@ -261,6 +262,9 @@ static void dump_mcast_routes(cl_map_item_t * item, FILE * file, void *cxt)
>  			sprintf(mlid_hdr, "0x%04X :",
>  				mlid_ho + IB_LID_MCAST_START_HO);
>  			while (position <= p_tbl->max_position) {
> +				osm_mcast_tbl_realloc_mask_tbl(p_tbl,
> +							       &p_osm->subn,
> +							       mlid_ho);

Hmm, why to realloc here?

>  				mask_entry =
>  				    cl_ntoh16((*p_tbl->
>  					       p_mask_tbl)[mlid_ho][position]);
> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
> index 0ee689c..e6da7f6 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -1043,6 +1043,34 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm)
>  	return ret;
>  }
>  
> +static void alloc_mfts(osm_sm_t * sm)
> +{
> +	int i;
> +	cl_map_item_t *item;
> +	osm_switch_t *p_sw;
> +	int max_mlid = 0;
> +
> +	for (i = sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO; i >= 0;
> +	     i--) {
> +		if (!sm->p_subn->mgroups[i])
> +			continue;
> +		max_mlid = i + IB_LID_MCAST_START_HO;
> +		break;

Something simpler like:

		if (sm->p_subn->mgroups[i]) {
			max_mlid = i + IB_LID_MCAST_START_HO;
			break;
		}

would make more sense.

> +	}
> +
> +	if (max_mlid == 0)
> +		return;
> +
> +	/* Now, walk switches and (re)allocate multicast tables */
> +	for (item = cl_qmap_head(&sm->p_subn->sw_guid_tbl);
> +	     item != cl_qmap_end(&sm->p_subn->sw_guid_tbl);
> +	     item = cl_qmap_next(item)) {
> +		p_sw = (osm_switch_t *)item;
> +		osm_mcast_tbl_realloc_mask_tbl(&p_sw->mcast_tbl, sm->p_subn,
> +					       max_mlid - IB_LID_MCAST_START_HO);

I would suggest to have a return value here and...

> +	}
> +}
> +
>  /**********************************************************************
>   **********************************************************************/
>  int osm_mcast_mgr_process(osm_sm_t * sm)
> @@ -1063,6 +1091,8 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
>  		goto exit;
>  	}
>  
> +	alloc_mfts(sm);

to verify allocation status and break multicast routing calculation
when there is no room for MFTs.

> +
>  	for (i = 0; i <= sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
>  	     i++)
>  		if (sm->p_subn->mgroups[i] || sm->mlids_req[i])
> @@ -1101,6 +1131,8 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * sm)
>  		goto exit;
>  	}
>  
> +	alloc_mfts(sm);
> +
>  	for (i = 0; i <= sm->mlids_req_max; i++) {
>  		if (!sm->mlids_req[i])
>  			continue;
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
> index d7c9529..11070b1 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (c) 2004-2006 Voltaire, Inc. All rights reserved.
> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>   * Copyright (c) 2009 HNR Consulting. All rights reserved.
>   *
> @@ -50,11 +50,13 @@
>  #include <complib/cl_math.h>
>  #include <iba/ib_types.h>
>  #include <opensm/osm_mcast_tbl.h>
> +#include <opensm/osm_log.h>
> +#include <opensm/osm_opensm.h>
>  
>  /**********************************************************************
>   **********************************************************************/
> -ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
> -				   IN uint8_t num_ports, IN uint16_t capacity)
> +void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
> +			IN uint16_t capacity)
>  {
>  	CL_ASSERT(p_tbl);
>  	CL_ASSERT(num_ports);
> @@ -68,7 +70,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
>  		   This switch apparently doesn't support multicast.
>  		   Everything is initialized to zero already, so return.
>  		 */
> -		return IB_SUCCESS;
> +		return;
>  	}
>  
>  	p_tbl->num_entries = capacity;
> @@ -82,25 +84,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
>  					IB_MCAST_BLOCK_SIZE) - 1);
>  
>  	p_tbl->max_mlid_ho = (uint16_t) (IB_LID_MCAST_START_HO + capacity - 1);
> -
> -	/*
> -	   The number of bytes needed in the mask table is:
> -	   The (maximum bit mask 'position' + 1) times the
> -	   number of bytes in each bit mask times the
> -	   number of MLIDs supported by the table.
> -
> -	   We must always allocate the array with the maximum position
> -	   since it is (and must be) defined that way the table structure
> -	   in order to create a pointer to a two dimensional array.
> -	 */
> -	p_tbl->p_mask_tbl = calloc(p_tbl->num_entries,
> -				   (IB_MCAST_POSITION_MAX +
> -				    1) * IB_MCAST_MASK_SIZE / 8);
> -
> -	if (p_tbl->p_mask_tbl == NULL)
> -		return IB_INSUFFICIENT_MEMORY;
> -
> -	return IB_SUCCESS;
>  }
>  
>  /**********************************************************************
> @@ -123,6 +106,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
>  	CL_ASSERT(p_tbl);
>  	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
>  	CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
> +	CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_tbl->mft_size);
>  	CL_ASSERT(p_tbl->p_mask_tbl);
>  
>  	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> @@ -138,6 +122,51 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
>  
>  /**********************************************************************
>   **********************************************************************/
> +void
> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
> +			       IN osm_subn_t * p_subn, IN uintn_t mlid_offset)

I would suggest to simplify the function name to something like
'osm_mcast_tbl_realloc()' - osm_mcast_tbl API doesn't have any
information about a buffer internal structure.


> +{
> +	size_t mft_size, size;
> +	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
> +
> +	if (mlid_offset < p_tbl->mft_size)
> +		return;
> +
> +	/*
> +	   The number of bytes needed in the mask table is:
> +	   The (maximum bit mask 'position' + 1) times the
> +	   number of bytes in each bit mask times the
> +	   number of MLIDs supported by the table.
> +
> +	   We must always allocate the array with the maximum position
> +	   since it is (and must be) defined that way the table structure
> +	   in order to create a pointer to a two dimensional array.
> +	 */
> +	mft_size = (mlid_offset + IB_MCAST_BLOCK_SIZE) /
> +		    IB_MCAST_BLOCK_SIZE * IB_MCAST_BLOCK_SIZE;
> +	if (mft_size > (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE)
> +		mft_size = (p_tbl->max_block + 1) * IB_MCAST_BLOCK_SIZE;

Hmm, wouldn't this:

	mft_size = (mlid_offset / IB_MCAST_BLOCK_SIZE + 1) * IB_MCAST_BLOCK_SIZE;

do the same as lines above?

> +	size = mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8;
> +	p_mask_tbl = realloc(p_tbl->p_mask_tbl, size);
> +	if (!p_mask_tbl)
> +		goto error;
> +	memset((uint8_t *)p_mask_tbl + p_tbl->mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
> +	       0,
> +	       size - p_tbl->mft_size * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
> +	p_tbl->p_mask_tbl = p_mask_tbl;
> +	p_tbl->mft_size = mft_size;
> +	return;
> +
> +error:
> +	OSM_LOG(&p_subn->p_osm->log, OSM_LOG_SYS,
> +		"Reallocation of multicast mask table failed - exiting\n");
> +	OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, " ERR 6401: "
> +		"Reallocation of multicast mask table failed - exiting\n");
> +	exit(1);

Why to break whole OpenSM execution (print syslog errors, etc.)? Just
return -1 to the caller.

> +}
> +
> +/**********************************************************************
> + **********************************************************************/
>  boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
>  				IN uint16_t mlid_ho, IN uint8_t port_num)
>  {
> @@ -154,6 +183,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
>  		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
>  
>  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> +		if (mlid_offset >= p_tbl->mft_size)
> +			return FALSE;

If you are introducing new field mft_size, I would also suggest to change
the meaning of max_mlid_ho field to be max configured mlid for this
table and not max capability mlid (which is almost duplicated by
num_entries field). I suppose that this can be done as separate patch.

Then all such and similar (many below) checks should be performed against
this actually configured max mlid and not against table size. As we
discussed already this prevents some bugs for 'max_mlid < table_size - 1'
case.

Sasha

>  		mask_offset = port_num / IB_MCAST_MASK_SIZE;
>  		bit_mask = cl_ntoh16((uint16_t)
>  				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
> @@ -181,6 +212,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
>  		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
>  
>  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> +		if (mlid_offset >= p_tbl->mft_size)
> +			return FALSE;
>  
>  		for (position = 0; position <= p_tbl->max_position; position++)
>  			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
> @@ -210,7 +243,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
>  
>  	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
>  
> -	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
> +	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->mft_size)
>  		return IB_INVALID_PARAMETER;
>  
>  	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
> @@ -234,6 +267,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
>  
>  	if (p_tbl->p_mask_tbl && (mlid_ho <= p_tbl->max_mlid_ho)) {
>  		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
> +		if (mlid_offset >= p_tbl->mft_size)
> +			return;
>  		for (i = 0; i <= p_tbl->max_position; i++)
>  			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
>  	}
> @@ -250,6 +285,7 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
>  
>  	CL_ASSERT(p_tbl);
>  	CL_ASSERT(p_block);
> +	CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <= p_tbl->mft_size);
>  
>  	if (block_num > p_tbl->max_block_in_use)
>  		return FALSE;
> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
> index ed0bc66..223791c 100644
> --- a/opensm/opensm/osm_switch.c
> +++ b/opensm/opensm/osm_switch.c
> @@ -136,9 +136,8 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_node,
>  
>  	memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) * num_ports);
>  
> -	if (osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
> -			       cl_ntoh16(p_si->mcast_cap)))
> -		goto err;
> +	osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_num_physp(p_node),
> +			   cl_ntoh16(p_si->mcast_cap));
>  
>  	for (port_num = 0; port_num < num_ports; port_num++)
>  		osm_port_prof_construct(&p_sw->p_prof[port_num]);
> @@ -508,7 +507,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
>  		p_sw->lft = new_lft;
>  		p_sw->lft_size = lft_size;
>  	}
> -
>  	return 0;
>  }
>  
> @@ -549,7 +547,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids
>  		p_sw->num_hops = max_lids + 1;
>  	}
>  	p_sw->max_lid_ho = max_lids;
> -
>  	return 0;
>  }
>  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
