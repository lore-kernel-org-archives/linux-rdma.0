From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm/osm_pkey_mgr.c: Handle
 osm_pkey_tbl_new_block_get returning NULL
Date: Wed, 27 Apr 2011 17:57:36 +0300
Message-ID: <20110427145736.GA1903@calypso.voltaire.com>
References: <4DA358FF.3060200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA358FF.3060200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 15:39 Mon 11 Apr     , Hal Rosenstock wrote:
> 
> Fixes seg fault when ib_pkey_is_invalid called in last_used_pkey_index
> 
> Introduced by commit aebd9f9d9cdd1c60c2b3784c0c03cfe8f4014019 
> for better last block handling
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
> index 06d9b1e..a2021e9 100644
> --- a/opensm/osm_pkey_mgr.c
> +++ b/opensm/osm_pkey_mgr.c
> @@ -375,14 +375,19 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
>  	return ret;
>  }
>  
> -static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
> -				     const osm_pkey_tbl_t * p_pkey_tbl)
> +static int last_used_pkey_index(const osm_port_t * const p_port,
> +				const osm_pkey_tbl_t * p_pkey_tbl,
> +				uint16_t * p_last_index)
>  {
>  	ib_pkey_table_t *last_block;
>  	uint16_t index, last_index = 0;
>  
> +	CL_ASSERT(p_last_index);
> +
>  	last_block = osm_pkey_tbl_new_block_get(p_pkey_tbl,
>  						p_pkey_tbl->used_blocks - 1);
> +	if (!last_block)
> +		return 1;
>  
>  	if (p_pkey_tbl->used_blocks == p_pkey_tbl->max_blocks)
>  		last_index = cl_ntoh16(p_port->p_node->node_info.partition_cap) % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
> @@ -395,7 +400,8 @@ static uint16_t last_used_pkey_index(const osm_port_t * const p_port,
>  			break;
>  	} while (index != 0);
>  
> -	return index;
> +	*p_last_index = index;

I think it should be: *p_last_index = index + 1;
You want to return the number of pkeys in the block and not the index in the
array.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
