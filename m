From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/opensm] Decode the SAPKeyTableRecord block number
 properly, and don't segv
Date: Wed, 23 Feb 2011 19:20:19 +0200
Message-ID: <20110223172019.GA8537@calypso.voltaire.com>
References: <20110211221206.GA8532@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110211221206.GA8532-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On 15:12 Fri 11 Feb     , Jason Gunthorpe wrote:
> * Properly byteswap block_num before using it
> * Properly check bounds of the block number before de-referencing it.
> 
> This fixes a remotely triggered null pointer dereference.
> ---
>  opensm/include/iba/ib_types.h      |    2 +-
>  opensm/opensm/osm_sa_pkey_record.c |   16 ++++++++++++----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
> index e1bc102..24f5662 100644
> --- a/opensm/include/iba/ib_types.h
> +++ b/opensm/include/iba/ib_types.h
> @@ -6724,7 +6724,7 @@ typedef struct _ib_pkey_table {
>  #include <complib/cl_packon.h>
>  typedef struct _ib_pkey_table_record {
>  	ib_net16_t lid;		// for CA: lid of port, for switch lid of port 0
> -	uint16_t block_num;
> +	ib_net16_t block_num;
>  	uint8_t port_num;	// for switch: port number, for CA: reserved
>  	uint8_t reserved1;
>  	uint16_t reserved2;

I guess reserved2 could also be changed to ib_net16_t, right?

> diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_sa_pkey_record.c
> index e4930d0..cf50430 100644
> --- a/opensm/opensm/osm_sa_pkey_record.c
> +++ b/opensm/opensm/osm_sa_pkey_record.c
> @@ -71,6 +71,7 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
>  	osm_pkey_item_t *p_rec_item;
>  	uint16_t lid;
>  	ib_api_status_t status = IB_SUCCESS;
> +	ib_pkey_table_t *tbl;
>  
>  	OSM_LOG_ENTER(sa->p_log);
>  
> @@ -98,8 +99,15 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
>  	p_rec_item->rec.lid = lid;
>  	p_rec_item->rec.block_num = block;
>  	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
> -	p_rec_item->rec.pkey_tbl =
> -	    *(osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp), block));
> +	/* FIXME: There are ninf.PartitionCap or swinf.PartitionEnforcementCap
> +	   pkey entries so everything in that range is a valid block number
> +	   even if opensm is not using it. Return 0. However things outside
> +	   that range should return no entries.. Not sure how to figure that
> +	   here? The range of pkey_tbl can be less than the cap, so
> +	   this falsely triggers. */
> +	tbl = osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp), block);
> +	if (tbl)
> +		p_rec_item->rec.pkey_tbl = *tbl;
>  
>  	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);

What is the expected behaviour when IB PKey table block is empty?
rec.pkey_tbl might be uninitialized here. 
Shouldn't SubnAdmGetResp contain ERR_NO_RECORDS in such case?

>  
> @@ -269,14 +277,14 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
>  	context.p_list = &rec_list;
>  	context.comp_mask = p_rcvd_mad->comp_mask;
>  	context.sa = sa;
> -	context.block_num = p_rcvd_rec->block_num;
> +	context.block_num = cl_ntoh16(p_rcvd_rec->block_num);
>  	context.p_req_physp = p_req_physp;
>  
>  	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
>  		"Got Query Lid:%u(%02X), Block:0x%02X(%02X), Port:0x%02X(%02X)\n",
>  		cl_ntoh16(p_rcvd_rec->lid),
>  		(comp_mask & IB_PKEY_COMPMASK_LID) != 0, p_rcvd_rec->port_num,
> -		(comp_mask & IB_PKEY_COMPMASK_PORT) != 0, p_rcvd_rec->block_num,
> +		(comp_mask & IB_PKEY_COMPMASK_PORT) != 0, context.block_num,
>  		(comp_mask & IB_PKEY_COMPMASK_BLOCK) != 0);
>  
>  	cl_plock_acquire(sa->p_lock);
> -- 
> 1.7.1
> 

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
