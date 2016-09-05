From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon, 5 Sep 2016 14:39:01 +0300
Message-ID: <7cf3a27d-b66b-5b41-80e5-799b68bad599@mellanox.com>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
 <1473072981-2035-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473072981-2035-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>
>  	indirect_hdr->table_desc.va = cpu_to_be64(req->indirect_dma_addr);
> @@ -3268,8 +3271,8 @@ static ssize_t srp_create_target(struct device *dev,
>  	target->io_class	= SRP_REV16A_IB_IO_CLASS;
>  	target->scsi_host	= target_host;
>  	target->srp_host	= host;
> +	target->pd		= host->srp_dev->pd;
>  	target->lkey		= host->srp_dev->pd->local_dma_lkey;
> -	target->global_mr	= host->srp_dev->global_mr;
>  	target->cmd_sg_cnt	= cmd_sg_entries;
>  	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
>  	target->allow_ext_sg	= allow_ext_sg;
> @@ -3524,6 +3527,7 @@ static void srp_add_one(struct ib_device *device)
>  	struct srp_host *host;
>  	int mr_page_shift, p;
>  	u64 max_pages_per_mr;
> +	unsigned int flags = 0;
>
>  	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
>  	if (!srp_dev)
> @@ -3558,6 +3562,10 @@ static void srp_add_one(struct ib_device *device)
>  		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
>  	}
>
> +	if (never_register || !register_always ||
> +	    (!srp_dev->has_fmr && !srp_dev->has_fr))
> +		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
> +
>  	if (srp_dev->use_fast_reg) {
>  		srp_dev->max_pages_per_mr =
>  			min_t(u32, srp_dev->max_pages_per_mr,
> @@ -3573,19 +3581,10 @@ static void srp_add_one(struct ib_device *device)
>  	INIT_LIST_HEAD(&srp_dev->dev_list);
>
>  	srp_dev->dev = device;
> -	srp_dev->pd  = ib_alloc_pd(device, 0);
> +	srp_dev->pd  = ib_alloc_pd(device, flags);
>  	if (IS_ERR(srp_dev->pd))
>  		goto free_dev;


Looks good,

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
