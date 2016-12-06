From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] mlx5: Use NULL instead of 0 to represent a pointer
Date: Tue, 6 Dec 2016 15:59:17 +0200
Message-ID: <20161206135917.GC2437@mtr-leonro.local>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <16dc2a07-86f7-ce47-7b0c-1da03e58d99f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <16dc2a07-86f7-ce47-7b0c-1da03e58d99f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 05, 2016 at 05:18:08PM -0800, Bart Van Assche wrote:
> Detected by sparse.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 32b09f059c84..abd200e3e299 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -127,7 +127,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
>  
>  		if ((upper == ndev || (!upper && ndev == ibdev->roce.netdev))
>  		    && ibdev->ib_active) {
> -			struct ib_event ibev = {0};
> +			struct ib_event ibev = { NULL };

I afraid that it is sparse anomality and because NULL==0, the ibev.event
will be initialized to zero, but it is a matter of time when the sparse
will complain about wrong initialization again.

>  
>  			ibev.device = &ibdev->ib_dev;
>  			ibev.event = (event == NETDEV_UP) ?
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
