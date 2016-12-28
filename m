From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1 v2] IB/srp: fix mr allocation when the device
 supports sg gaps
Date: Wed, 28 Dec 2016 13:25:30 +0200
Message-ID: <20161228112529.GA6237@yuval-lap>
References: <1482922108-3243-1-git-send-email-maxg@mellanox.com>
 <1482922108-3243-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482922108-3243-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Dec 28, 2016 at 12:48:28PM +0200, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> If the device support arbitrary sg list mapping (device cap
> IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
> IB_MR_TYPE_SG_GAPS.
> 
> Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>        [4.7+]
> Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 8ddc071..0f67cf9 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -371,6 +371,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
>  	struct srp_fr_desc *d;
>  	struct ib_mr *mr;
>  	int i, ret = -EINVAL;
> +	enum ib_mr_type mr_type;
>  
>  	if (pool_size <= 0)
>  		goto err;
> @@ -384,9 +385,13 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
>  	spin_lock_init(&pool->lock);
>  	INIT_LIST_HEAD(&pool->free_list);
>  
> +	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
> +		mr_type = IB_MR_TYPE_SG_GAPS;
> +	else
> +		mr_type = IB_MR_TYPE_MEM_REG;
> +
>  	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
> -		mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
> -				 max_page_list_len);
> +		mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
>  		if (IS_ERR(mr)) {
>  			ret = PTR_ERR(mr);
>  			if (ret == -ENOMEM)
> -- 
> 1.8.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
