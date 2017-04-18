From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mthca: Check validity of output parameter
 pointer
Date: Tue, 18 Apr 2017 16:48:56 +0300
Message-ID: <20170418134855.GA3490@yuval-lap>
References: <20170415154725.17559-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170415154725.17559-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 15, 2017 at 06:47:25PM +0300, Leon Romanovsky wrote:
> The mthca driver didn't check supplied pointer to functions
> mthca_cmd_poll() and mthca_cmd_wait(). This caused to the following
> smatch errors:
> 
> drivers/infiniband/hw/mthca/mthca_cmd.c:371 mthca_cmd_poll() error: we previously assumed 'out_param' could be null (see line 353)
> drivers/infiniband/hw/mthca/mthca_cmd.c:454 mthca_cmd_wait() error: we previously assumed 'out_param' could be null (see line 432)
> 
> In reality all callers of these functions are setting out_is_imm
> flag are providing pointer too. However it is better to check
> again to remove smatch errors to achieve warning free subsystem.
> 
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  Based on k.o/for-4.12 branch.
> ---
>  drivers/infiniband/hw/mthca/mthca_cmd.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
> index c7f49bbb0c72..9d83a53c0c67 100644
> --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> @@ -367,12 +367,16 @@ static int mthca_cmd_poll(struct mthca_dev *dev,
>  		goto out;
>  	}
> 
> -	if (out_is_imm)
> +	if (out_is_imm && out_param) {
>  		*out_param =
>  			(u64) be32_to_cpu((__force __be32)
>  					  __raw_readl(dev->hcr + HCR_OUT_PARAM_OFFSET)) << 32 |
>  			(u64) be32_to_cpu((__force __be32)
>  					  __raw_readl(dev->hcr + HCR_OUT_PARAM_OFFSET + 4));
> +	} else if (out_is_imm) {
> +		err = -EINVAL;
> +		goto out;

So if this is a good reason to fail the function - how about doing this
validation before triggering HW operation (mthca_cmd_post)?

> +	}
> 
>  	status = be32_to_cpu((__force __be32) __raw_readl(dev->hcr + HCR_STATUS_OFFSET)) >> 24;
>  	if (status) {
> @@ -450,8 +454,12 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
>  		err = mthca_status_to_errno(context->status);
>  	}
> 
> -	if (out_is_imm)
> +	if (out_is_imm && out_param) {
>  		*out_param = context->out_param;
> +	} else if (out_is_imm) {
> +		err = -EINVAL;

Ditto

> +		goto out;
> +	}
> 
>  out:
>  	spin_lock(&dev->cmd.context_lock);
> --
> 2.12.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
