From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Date: Mon, 29 Apr 2019 18:41:19 +0000
Message-ID: <20190429184116.GB6705@mtr-leonro.mtl.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190429181326.6262-10-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <8BDDE47243465F42B6415193B86D22C1@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 06:14:16PM +0000, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
>
> When in switchdev mode, we would like to treat loopback RoCE
> traffic (on eswitch manager) as RDMA and not as regular
> Ethernet traffic
> In order to enable it we add flow steering rule that forward RoCE
> loopback traffic to the HW RoCE filter (by adding allow rule).
> In addition we add RoCE address in GID index 0, which will be
> set in the RoCE loopback packet.
>
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
>  .../net/ethernet/mellanox/mlx5/core/rdma.c    | 182 ++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/rdma.h    |  20 ++
>  include/linux/mlx5/driver.h                   |   7 +
>  5 files changed, 214 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.h
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
