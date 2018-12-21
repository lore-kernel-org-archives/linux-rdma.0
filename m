From: Achiad Shochat <achiad@mellanox.com>
Subject: RE: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as
 some general object
Date: Fri, 21 Dec 2018 09:29:36 +0000
Message-ID: <HE1PR05MB47964508A05F8B74092C01A9A3B80@HE1PR05MB4796.eurprd05.prod.outlook.com>
References: <20181219142815.21480-1-leon@kernel.org>
 <20181220210136.GA10207@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181220210136.GA10207@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Great, thanks


-----Original Message-----
From: Jason Gunthorpe <jgg@ziepe.ca>=20
Sent: Thursday, December 20, 2018 11:02 PM
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>; Yishai Hadas <yishaih@mellanox.com>=
; RDMA mailing list <linux-rdma@vger.kernel.org>; Achiad Shochat <achiad@me=
llanox.com>; Saeed Mahameed <saeedm@mellanox.com>; linux-netdev <netdev@vge=
r.kernel.org>; Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as=
 some general object

On Wed, Dec 19, 2018 at 04:28:15PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> The driver needs to prevent a user space application to create a UMEM=20
> and UCTX via the general object command.
>=20
> The UMEM must go through the kernel UMEM_REG method to prevent the=20
> user from setting physical addresses by himself.  The UCTX is some=20
> internal kernel object and shouldn't be exposed.
>=20
> As of not being any more part of the general object the caps bits were=20
> moved to be some log_xxx indication in the general HCA caps, 0 means=20
> not supported.
>=20
> The firmware code was adapted as well to match the above.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Achiad Shochat <achiad@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++--------- =20
> drivers/infiniband/hw/mlx5/main.c |  3 +-
>  include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++----------
>  3 files changed, 58 insertions(+), 41 deletions(-)

Applied to for-next

Thanks,
Jason
