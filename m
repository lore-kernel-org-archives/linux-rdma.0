From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Date: Sun, 16 Jun 2019 12:44:01 +0000
Message-ID: <20190616124357.GH4694@mtr-leonro.mtl.com>
References: <20190612122014.22359-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612122014.22359-1-leon@kernel.org>
Content-Language: en-US
Content-ID: <37A744EF553FF2438A01E5C4BF8E415C@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2019 at 03:20:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog v0->v1:
>  * Added patch to devlink to use declared enum for encap mode instead of =
u8
>  * Constify input argumetn to encap mode function
>  * fix encap variable type to be boolean
>
> ---------------------------------------------------------------------
> Hi,
>
> This is short series from Maor to expose and use enacap mode inside mlx5_=
ib.
>
> Thanks
>
> Leon Romanovsky (1):
>   net/mlx5: Declare more strictly devlink encap mode
>
> Maor Gottlieb (3):
>   net/mlx5: Expose eswitch encap mode

Those two applied to mlx5-next
82b11f071936 net/mlx5: Expose eswitch encap mode
98fdbea55037 net/mlx5: Declare more strictly devlink encap mode

>   RDMA/mlx5: Consider eswitch encap mode
>   RDMA/mlx5: Enable decap and packet reformat on FDB

Doug, Jason

Can you please take those two patches in addition to latest mlx5-next?

Thanks

>
>  drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++++++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++---
>  .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +++--
>  include/linux/mlx5/eswitch.h                  | 12 +++++++++
>  include/net/devlink.h                         |  6 +++--
>  net/core/devlink.c                            |  6 +++--
>  7 files changed, 59 insertions(+), 15 deletions(-)
>
> --
> 2.20.1
>
