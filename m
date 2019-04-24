From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 4/8] IB/mlx5: Add steering SW ICM device memory
 type
Date: Wed, 24 Apr 2019 10:04:40 -0300
Message-ID: <20190424130440.GA5196@ziepe.ca>
References: <20190331164450.23618-1-leon@kernel.org>
 <20190331164450.23618-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190331164450.23618-5-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 31, 2019 at 07:44:46PM +0300, Leon Romanovsky wrote:
> From: Ariel Levkovich <lariel@mellanox.com>
> 
> This patch adds support for allocating, deallocating and registering
> a new device memory type, STEERING_SW_ICM.
> This memory can be allocated and used by a privileged user for direct
> rule insertion and management of the device's steering tables.
> 
> The type is provided by the user via the dedicated attribute in
> the alloc_dm ioctl command.
> 
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Eli Cohen <eli@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/Kconfig        |   2 +-
>  drivers/infiniband/hw/mlx5/cmd.c          | 127 +++++++++++++++++++-
>  drivers/infiniband/hw/mlx5/cmd.h          |   6 +-
>  drivers/infiniband/hw/mlx5/main.c         | 136 +++++++++++++++++++++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h      |  17 +++
>  drivers/infiniband/hw/mlx5/mr.c           |   7 ++
>  include/uapi/rdma/mlx5_user_ioctl_verbs.h |   2 +
>  7 files changed, 291 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
> index 8d651c05de62..347d457fcb2f 100644
> +++ b/drivers/infiniband/hw/mlx5/Kconfig
> @@ -1,6 +1,6 @@
>  config MLX5_INFINIBAND
>  	tristate "Mellanox 5th generation network adapters (ConnectX series) support"
> -	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
> +	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE && PHYS_ADDR_T_64BIT

Why do we need this?

Jason
