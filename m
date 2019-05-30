From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx5: Limit to 64-bit builds
Date: Thu, 30 May 2019 15:22:51 +0300
Message-ID: <20190530122251.GD6251@mtr-leonro.mtl.com>
References: <1559216144-2085-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1559216144-2085-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 30, 2019 at 04:35:44AM -0700, Guenter Roeck wrote:
> 32-bit builds fail with errors such as
>
> ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!

It is fixed in rdma-rc.
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-rc&id=37eb86c4507abcb14fc346863e83aa8751aa4675

Thanks

>
> Fixes: 25c13324d03d ("IB/mlx5: Add steering SW ICM device memory type")
> Cc: Ariel Levkovich <lariel@mellanox.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/infiniband/hw/mlx5/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
> index ea248def4556..574b97da7a43 100644
> --- a/drivers/infiniband/hw/mlx5/Kconfig
> +++ b/drivers/infiniband/hw/mlx5/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config MLX5_INFINIBAND
>  	tristate "Mellanox 5th generation network adapters (ConnectX series) support"
> -	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
> +	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE && 64BIT
>  	---help---
>  	  This driver provides low-level InfiniBand support for
>  	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
> --
> 2.7.4
>
