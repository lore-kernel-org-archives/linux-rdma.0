From: Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net/mlx5: fix spelling mistake: "alloated" -> "allocated"
Date: Tue, 27 Jun 2017 14:39:45 +0300
Message-ID: <69e20861-df9b-fd47-4e75-6ee978f572f7@mellanox.com>
References: <20170627074059.11774-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170627074059.11774-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 27/06/2017 10:40 AM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> Trivial fix to spelling mistake in mlx5_ib_dbg message
> 
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx5/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c

This is IB, while in patch subject you wrote 'net'.

> index 9f7e18612322..db67a61085f7 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1151,7 +1151,7 @@ static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
>   	if (req->num_low_latency_bfregs > req->total_num_bfregs - 1)
>   		return -EINVAL;
>   
> -	mlx5_ib_dbg(dev, "uar_4k: fw support %s, lib support %s, user requested %d bfregs, alloated %d, using %d sys pages\n",
> +	mlx5_ib_dbg(dev, "uar_4k: fw support %s, lib support %s, user requested %d bfregs, allocated %d, using %d sys pages\n",
>   		    MLX5_CAP_GEN(dev->mdev, uar_4k) ? "yes" : "no",
>   		    lib_uar_4k ? "yes" : "no", ref_bfregs,
>   		    req->total_num_bfregs, *num_sys_pages);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
