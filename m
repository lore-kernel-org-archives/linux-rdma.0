From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: fix VFs callback function prototypes
Date: Wed, 30 Mar 2016 21:26:12 +0300
Message-ID: <20160330182611.GC95906@x-vnc01.mtx.labs.mlnx>
References: <1458729502-3155671-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458729502-3155671-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

are you going to take this fix.

Thanks,
Eli

On Wed, Mar 23, 2016 at 11:37:45AM +0100, Arnd Bergmann wrote:
> The previous patch that added a couple of callback functions put
> the declarations inside of an #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING,
> which causes the build to fail if that option is disabled:
> 
> drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_add':
> drivers/infiniband/hw/mlx5/main.c:2358:31: error: 'mlx5_ib_get_vf_config' undeclared (first use in this function)
> 
> This moves the four declarations below the #ifdef section so they
> are always available.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Fixes: eff901d30e6c ("IB/mlx5: Implement callbacks for manipulating VFs")
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index f16c818ad2e6..b46c25542a7c 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -776,15 +776,6 @@ void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp);
>  void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
>  void mlx5_ib_invalidate_range(struct ib_umem *umem, unsigned long start,
>  			      unsigned long end);
> -int mlx5_ib_get_vf_config(struct ib_device *device, int vf,
> -			  u8 port, struct ifla_vf_info *info);
> -int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
> -			      u8 port, int state);
> -int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
> -			 u8 port, struct ifla_vf_stats *stats);
> -int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
> -			u64 guid, int type);
> -
>  #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
>  static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
>  {
> @@ -801,6 +792,15 @@ static inline void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp)  {}
>  
>  #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
>  
> +int mlx5_ib_get_vf_config(struct ib_device *device, int vf,
> +			  u8 port, struct ifla_vf_info *info);
> +int mlx5_ib_set_vf_link_state(struct ib_device *device, int vf,
> +			      u8 port, int state);
> +int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
> +			 u8 port, struct ifla_vf_stats *stats);
> +int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
> +			u64 guid, int type);
> +
>  __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
>  			       int index);
>  
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
