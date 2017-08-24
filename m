From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/3] IB/mlx5: Always return success for RoCE
 modify port
Date: Thu, 24 Aug 2017 17:39:01 +0300
Message-ID: <20170824143900.GC5128@yuvallap>
References: <20170823053542.17754-1-leon@kernel.org>
 <20170823053542.17754-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170823053542.17754-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 23, 2017 at 08:35:42AM +0300, Leon Romanovsky wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> CM layer calls ib_modify_port() regardless of the link layer.
> 
> For the Ethernet ports, qkey violation and Port capabilities
> are meaningless. Therefore, always return success for ib_modify_port
> calls on the Ethernet ports.
> 
> Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index a7f2e60085c4..f7fcde1ff0aa 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1085,6 +1085,12 @@ static int mlx5_ib_modify_port(struct ib_device *ibdev, u8 port, int mask,
>  	bool is_ib = (mlx5_ib_port_link_layer(ibdev, port) ==
>  		      IB_LINK_LAYER_INFINIBAND);
> 
> +	/* CM layer calls ib_modify_port() regardless of the link layer. For
> +	 * Ethernet ports, qkey violation and Port capabilities are meaningless.
> +	 */
> +	if (!is_ib)
> +		return 0;
> +

Alternatively you better stick to the convention used in mlx5_ib_add and do
the check there before installing the hook, like it is done for
mlx5_ib_get_netdev.

>  	if (MLX5_CAP_GEN(dev->mdev, ib_virt) && is_ib) {
>  		change_mask = props->clr_port_cap_mask | props->set_port_cap_mask;
>  		value = ~props->clr_port_cap_mask | props->set_port_cap_mask;
> --
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
