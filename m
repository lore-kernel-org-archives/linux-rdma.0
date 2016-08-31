From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Wed, 31 Aug 2016 12:32:34 +0300
Message-ID: <bb2a15be-8a22-d889-5eb6-c0f315465507@mellanox.com>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
 <1472464943-29450-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

> +		idb_rkey = cpu_to_be32(pd->unsafe_global_rkey);
>  	}
>
>  	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
> @@ -3269,7 +3270,6 @@ static ssize_t srp_create_target(struct device *dev,
>  	target->scsi_host	= target_host;
>  	target->srp_host	= host;
>  	target->lkey		= host->srp_dev->pd->local_dma_lkey;
> -	target->global_mr	= host->srp_dev->global_mr;
>  	target->cmd_sg_cnt	= cmd_sg_entries;
>  	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
>  	target->allow_ext_sg	= allow_ext_sg;
> @@ -3524,6 +3524,7 @@ static void srp_add_one(struct ib_device *device)
>  	struct srp_host *host;
>  	int mr_page_shift, p;
>  	u64 max_pages_per_mr;
> +	unsigned int flags = 0;
>
>  	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
>  	if (!srp_dev)
> @@ -3558,6 +3559,10 @@ static void srp_add_one(struct ib_device *device)
>  		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
>  	}
>
> +	if (never_register || !register_always ||
> +	    (!srp_dev->has_fmr && !srp_dev->has_fr))
> +		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
> +

I don't see the pd allocation with the flags, am I missing something ?
previous commit does it with flags=0.

>  	if (srp_dev->use_fast_reg) {
>  		srp_dev->max_pages_per_mr =
>  			min_t(u32, srp_dev->max_pages_per_mr,
> @@ -3577,15 +3582,6 @@ static void srp_add_one(struct ib_device *device)
>  	if (IS_ERR(srp_dev->pd))
>  		goto free_dev;
>
> -	if (never_register || !register_always ||
> -	    (!srp_dev->has_fmr && !srp_dev->has_fr)) {
> -		srp_dev->global_mr = ib_get_dma_mr(srp_dev->pd,
> -						   IB_ACCESS_LOCAL_WRITE |
> -						   IB_ACCESS_REMOTE_READ |
> -						   IB_ACCESS_REMOTE_WRITE);
> -		if (IS_ERR(srp_dev->global_mr))
> -			goto err_pd;
> -	}
>
>  	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
>  		host = srp_add_port(srp_dev, p);
> @@ -3596,9 +3592,6 @@ static void srp_add_one(struct ib_device *device)
>  	ib_set_client_data(device, &srp_client, srp_dev);
>  	return;
>
> -err_pd:
> -	ib_dealloc_pd(srp_dev->pd);
> -
>  free_dev:
>  	kfree(srp_dev);
>  }
> @@ -3638,8 +3631,6 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
>  		kfree(host);
>  	}
>
> -	if (srp_dev->global_mr)
> -		ib_dereg_mr(srp_dev->global_mr);
>  	ib_dealloc_pd(srp_dev->pd);


thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
