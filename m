From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/srp: Introduce srp_alloc_fmr_pool()
Date: Wed, 07 May 2014 13:38:15 +0300
Message-ID: <536A0D17.1030001@dev.mellanox.co.il>
References: <5368DA5B.80609@acm.org> <5368DB05.4070600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DB05.4070600-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/6/2014 3:52 PM, Bart Van Assche wrote:
> Introduce the srp_alloc_fmr_pool() function. Only set
> srp_dev->fmr_max_size if FMR pool creation succeeded. This change is
> safe since that variable is only used if FMR pool creation succeeded.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 56 ++++++++++++++++++++++---------------
>   1 file changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 8c03371..f41cc8c 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2792,13 +2792,43 @@ free_host:
>   	return NULL;
>   }
>   
> +static void srp_alloc_fmr_pool(struct srp_device *srp_dev)
> +{
> +	int max_pages_per_mr;
> +	struct ib_fmr_pool_param fmr_param;
> +	struct ib_fmr_pool *pool;
> +
> +	srp_dev->fmr_pool = NULL;
> +
> +	for (max_pages_per_mr = SRP_FMR_SIZE;
> +	     max_pages_per_mr >= SRP_FMR_MIN_SIZE;
> +	     max_pages_per_mr /= 2) {
> +		memset(&fmr_param, 0, sizeof(fmr_param));
> +		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
> +		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
> +		fmr_param.cache		    = 1;
> +		fmr_param.max_pages_per_fmr = max_pages_per_mr;
> +		fmr_param.page_shift	    = ilog2(srp_dev->fmr_page_size);
> +		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
> +					       IB_ACCESS_REMOTE_WRITE |
> +					       IB_ACCESS_REMOTE_READ);
> +
> +		pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
> +		if (!IS_ERR(pool)) {
> +			srp_dev->fmr_pool = pool;
> +			srp_dev->fmr_max_size =
> +				srp_dev->fmr_page_size * max_pages_per_mr;
> +			break;
> +		}
> +	}
> +}
> +
>   static void srp_add_one(struct ib_device *device)
>   {
>   	struct srp_device *srp_dev;
>   	struct ib_device_attr *dev_attr;
> -	struct ib_fmr_pool_param fmr_param;
>   	struct srp_host *host;
> -	int max_pages_per_fmr, fmr_page_shift, s, e, p;
> +	int fmr_page_shift, s, e, p;
>   
>   	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
>   	if (!dev_attr)
> @@ -2821,7 +2851,6 @@ static void srp_add_one(struct ib_device *device)
>   	fmr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
>   	srp_dev->fmr_page_size	= 1 << fmr_page_shift;
>   	srp_dev->fmr_page_mask	= ~((u64) srp_dev->fmr_page_size - 1);
> -	srp_dev->fmr_max_size	= srp_dev->fmr_page_size * SRP_FMR_SIZE;
>   
>   	INIT_LIST_HEAD(&srp_dev->dev_list);
>   
> @@ -2837,26 +2866,7 @@ static void srp_add_one(struct ib_device *device)
>   	if (IS_ERR(srp_dev->mr))
>   		goto err_pd;
>   
> -	for (max_pages_per_fmr = SRP_FMR_SIZE;
> -			max_pages_per_fmr >= SRP_FMR_MIN_SIZE;
> -			max_pages_per_fmr /= 2, srp_dev->fmr_max_size /= 2) {
> -		memset(&fmr_param, 0, sizeof fmr_param);
> -		fmr_param.pool_size	    = SRP_FMR_POOL_SIZE;
> -		fmr_param.dirty_watermark   = SRP_FMR_DIRTY_SIZE;
> -		fmr_param.cache		    = 1;
> -		fmr_param.max_pages_per_fmr = max_pages_per_fmr;
> -		fmr_param.page_shift	    = fmr_page_shift;
> -		fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
> -					       IB_ACCESS_REMOTE_WRITE |
> -					       IB_ACCESS_REMOTE_READ);
> -
> -		srp_dev->fmr_pool = ib_create_fmr_pool(srp_dev->pd, &fmr_param);
> -		if (!IS_ERR(srp_dev->fmr_pool))
> -			break;
> -	}
> -
> -	if (IS_ERR(srp_dev->fmr_pool))
> -		srp_dev->fmr_pool = NULL;
> +	srp_alloc_fmr_pool(srp_dev);
>   
>   	if (device->node_type == RDMA_NODE_IB_SWITCH) {
>   		s = 0;

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
