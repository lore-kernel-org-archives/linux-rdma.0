From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mad: Reduce MAD scope to mlx5_ib only
Date: Mon, 14 Jan 2019 19:56:23 +0000
Message-ID: <20190114195615.GV22875@mellanox.com>
References: <20190113135704.10032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190113135704.10032-1-leon@kernel.org>
Content-Language: en-US
Content-ID: <2F27D62D99F11241A651F5BFE9D49DFA@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 13, 2019 at 03:57:04PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Management Datagram Interface (MAD) is applicable
> only when physical port is Infiniband. It makes MAD
> command logic to be completely unrelated to eth/core
> parts of mlx5.
=20
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/cmd.c              | 37 +++++++++
>  drivers/infiniband/hw/mlx5/cmd.h              |  2 +
>  drivers/infiniband/hw/mlx5/mad.c              | 11 ++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 -
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/mad.c | 75 -------------------
>  include/linux/mlx5/driver.h                   |  2 -
>  7 files changed, 47 insertions(+), 85 deletions(-)
>  delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mad.c

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
