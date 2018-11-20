From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 11/12] {net,IB}/mlx5: Move Page fault EQ and
 ODP logic to RDMA
Date: Tue, 20 Nov 2018 17:30:38 +0000
Message-ID: <20181120173031.GI22009@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
 <20181119185242.21961-12-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-12-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <8AA3C9BBC83FB94D96276803CF940E66@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2018 at 10:52:41AM -0800, Saeed Mahameed wrote:
> Use the new generic EQ API to move all ODP RDMA data structures and logic
> form mlx5 core driver into mlx5_ib driver.
>=20
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c             |  10 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  15 +-
>  drivers/infiniband/hw/mlx5/odp.c              | 281 +++++++++++++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c |  34 ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 252 ----------------
>  .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   8 -
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 -
>  include/linux/mlx5/driver.h                   |  49 ---
>  include/linux/mlx5/eq.h                       |  21 ++
>  10 files changed, 308 insertions(+), 381 deletions(-)

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Can you let me know when these land in the shared branch please?

Thanks,
Jason
