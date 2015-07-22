From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Wed, 22 Jul 2015 10:04:13 -0700
Message-ID: <20150722170413.GE6443@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437548143-24893-39-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -2585,11 +2517,9 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
>  	struct isert_device *device = isert_conn->device;
>  	struct ib_device *ib_dev = device->ib_device;
>  	struct ib_mr *mr;
>  	struct ib_send_wr fr_wr, inv_wr;
>  	struct ib_send_wr *bad_wr, *wr = NULL;
> +	int ret;
>  
>  	if (mem->dma_nents == 1) {
>  		sge->lkey = device->mr->lkey;
> @@ -2600,40 +2530,32 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
>  		return 0;
>  	}
>  
> +	if (ind == ISERT_DATA_KEY_VALID)
>  		/* Registering data buffer */
>  		mr = fr_desc->data_mr;
> +	else
>  		/* Registering protection buffer */
>  		mr = fr_desc->pi_ctx->prot_mr;
>  
>  	if (!(fr_desc->ind & ind)) {
>  		isert_inv_rkey(&inv_wr, mr);
>  		wr = &inv_wr;
>  	}
>  
> +	ret = ib_map_mr_sg(mr, mem->sg, mem->nents, IB_ACCESS_LOCAL_WRITE);
> +	if (ret) {
> +		isert_err("failed to map sg %p with %d entries\n",
> +			 mem->sg, mem->dma_nents);
> +		return ret;
> +	}
> +
> +	isert_dbg("Use fr_desc %p sg_nents %d offset %u\n",
> +		  fr_desc, mem->nents, mem->offset);
> +
>  	/* Prepare FASTREG WR */
>  	memset(&fr_wr, 0, sizeof(fr_wr));
> +	ib_set_fastreg_wr(mr, mr->lkey, ISER_FASTREG_LI_WRID,
> +			  false, &fr_wr);

Shouldn't ib_set_fastreg_wr take care of this memset?  Also it seems
instead of the singalled flag to it we might just set that or
other flags later if we really want to.

>  struct pi_context {
>  	struct ib_mr		       *prot_mr;
> -	struct ib_fast_reg_page_list   *prot_frpl;
>  	struct ib_mr		       *sig_mr;
>  };
>  
>  struct fast_reg_descriptor {
>  	struct list_head		list;
>  	struct ib_mr		       *data_mr;
> -	struct ib_fast_reg_page_list   *data_frpl;
>  	u8				ind;
>  	struct pi_context	       *pi_ctx;

As a follow on it might be worth to just kill off the separate
pi_context structure here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
