From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_lft_record.c: In lftr_rcv_new_lftr,
 handle osm_switch_get_lft_block failure
Date: Sun, 4 Oct 2009 03:16:54 +0200
Message-ID: <20091004011654.GO17846@me>
References: <20090930154341.GA31709@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090930154341.GA31709-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:43 Wed 30 Sep     , Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/opensm/osm_sa_lft_record.c b/opensm/opensm/osm_sa_lft_record.c
> index d092129..828b277 100644
> --- a/opensm/opensm/osm_sa_lft_record.c
> +++ b/opensm/opensm/osm_sa_lft_record.c
> @@ -99,8 +99,12 @@ static ib_api_status_t lftr_rcv_new_lftr(IN osm_sa_t * sa,
>  	p_rec_item->rec.block_num = cl_hton16(block);
>  
>  	/* copy the lft block */
> -	osm_switch_get_lft_block(p_sw, block, p_rec_item->rec.lft);
> -
> +	if (!osm_switch_get_lft_block(p_sw, block, p_rec_item->rec.lft)) {
> +		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4403: "
> +			"osm_switch_get_lft_block failed\n");
> +		status = IB_INSUFFICIENT_RESOURCES;
> +		goto Exit;
> +	}

'block' value is limited here (look at lftr_rcv_by_comp_mask()) by:

	max_block = osm_switch_get_max_block_id_in_use(p_sw);
	if (comp_mask & IB_LFTR_COMPMASK_BLOCK) {
		min_block = cl_ntoh16(p_rcvd_rec->block_num);
		if (min_block > max_block)
			return;
		max_block = min_block;
	}

, so as far as I can understand osm_switch_get_lft_block() cannot fail
here.

Sasha

>  	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
>  
>  Exit:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
