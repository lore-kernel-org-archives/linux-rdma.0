From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/mlx5; Remove redundant allocation warning
 print
Date: Thu, 18 Jan 2018 22:02:12 +0200
Message-ID: <20180118200211.GA17561@yuvallap>
References: <20180118123424.21062-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180118123424.21062-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 18, 2018 at 02:34:24PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The kmalloc() failure to allocate memory generates enough information
> and doesn't need to be accompanied by another driver print.
> 
> Fixes: d69a24e03659 ("IB/mlx5: Move IB event processing onto a workqueue")

Didn't found it in:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/leon/linux-rdma/
branch rdma-next and didn't find it.
Where should i look?

> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index f282e281eff2..91688352b5d7 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3345,19 +3345,17 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
>  	struct mlx5_ib_event_work *work;
> 
>  	work = kmalloc(sizeof(*work), GFP_ATOMIC);
> -	if (work) {
> -		INIT_WORK(&work->work, mlx5_ib_handle_event);
> -		work->dev = dev;
> -		work->param = param;
> -		work->context = context;
> -		work->event = event;
> -
> -		queue_work(mlx5_ib_event_wq, &work->work);
> +	if (!work)
>  		return;
> -	}
> 
> -	dev_warn(&dev->pdev->dev, "%s: mlx5_dev_event: %d, with param: %lu dropped, couldn't allocate memory.\n",
> -		 __func__, event, param);
> +	INIT_WORK(&work->work, mlx5_ib_handle_event);
> +	work->dev = dev;
> +	work->param = param;
> +	work->context = context;
> +	work->event = event;
> +
> +	queue_work(mlx5_ib_event_wq, &work->work);
> +	return;

We don't really need this last "return", right?

>  }
> 
>  static int set_has_smi_cap(struct mlx5_ib_dev *dev)
> --
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
