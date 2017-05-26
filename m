From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Fri, 26 May 2017 08:50:20 +0200
Message-ID: <20170526065020.GA19681@lst.de>
References: <1495743219-1085-1-git-send-email-maxg@mellanox.com> <1495743219-1085-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495743219-1085-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 25, 2017 at 11:13:39PM +0300, Max Gurtovoy wrote:
> Cache the needed umr_fence and set the wqe ctrl segmennt
> accordingly.
> 
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c    |   14 ++++++++++++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
>  drivers/infiniband/hw/mlx5/qp.c      |   15 +++++++--------
>  3 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index d45772d..83d1f9b 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -2979,6 +2979,18 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
>  	return ret;
>  }
>  
> +static u8 mlx5_get_umr_fence(u8 umr_fence_cap)
> +{
> +	switch (umr_fence_cap) {
> +	case MLX5_CAP_UMR_FENCE_STRONG:
> +		return MLX5_FENCE_MODE_STRONG_ORDERING;
> +	case MLX5_CAP_UMR_FENCE_SMALL:
> +		return MLX5_FENCE_MODE_INITIATOR_SMALL;
> +	default:
> +		return MLX5_FENCE_MODE_NONE;

Of course I don't really understand your firmware interface, but
shouldn't strong ordering be the default, and only certain fw
cap bits would relax it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
