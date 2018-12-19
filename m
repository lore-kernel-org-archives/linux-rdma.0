From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Fix to mlx5 devx interface
Date: Wed, 19 Dec 2018 19:14:38 +0000
Message-ID: <20181219191432.GY30567@mellanox.com>
References: <20181219142811.21301-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181219142811.21301-1-leon@kernel.org>
Content-Language: en-US
Content-ID: <C07C850AB8542040B09B98F0A2501500@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2018 at 04:28:09PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Hi,
>=20
> This small fix to mlx5 devx interface is separated to two, so we can
> apply first patch to mlx5-next.
>=20
> Thanks
>=20
> Yishai Hadas (2):
>   IB/mlx5: Introduce uid as part of alloc/dealloc transport domain
>   IB/mlx5: Use uid as part of alloc/dealloc transport domain
>=20
>  drivers/infiniband/hw/mlx5/cmd.c | 2 ++
>  include/linux/mlx5/mlx5_ifc.h    | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)

These look fine too, please update the shared branch

Thanks,
Jason
