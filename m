From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as
 some general object
Date: Wed, 19 Dec 2018 19:14:12 +0000
Message-ID: <20181219191406.GX30567@mellanox.com>
References: <20181219142815.21480-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181219142815.21480-1-leon@kernel.org>
Content-Language: en-US
Content-ID: <0FE3F27486DB5E489C4AC8222849B635@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Achiad Shochat <achiad@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2018 at 04:28:15PM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> The driver needs to prevent a user space application to create a
> UMEM and UCTX via the general object command.
>=20
> The UMEM must go through the kernel UMEM_REG method to prevent the user
> from setting physical addresses by himself.  The UCTX is some internal
> kernel object and shouldn't be exposed.
>=20
> As of not being any more part of the general object the caps bits were
> moved to be some log_xxx indication in the general HCA caps, 0 means not
> supported.
>=20
> The firmware code was adapted as well to match the above.

This commit message is a bit wonky.. how about

IB/mlx5: Use the correct commands for UMEM and UCTX allocation

During testing the command format was changed to close a security
hole. Revise the driver to use the command format that will actually
be supported in GA firmware.

Both the UMEM and UCTX are intended only for use by the kernel and
cannot be executed using a general command.

Since the UMEM and CTX are not part of the general object the caps
bits were moved to be some log_xxx location in the general HCA caps.

> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Achiad Shochat <achiad@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Also add a fixes line please, any kernel with the devx needs this
patch to work with GA firmware.

>  drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++---------
>  drivers/infiniband/hw/mlx5/main.c |  3 +-
>  include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++----------
>  3 files changed, 58 insertions(+), 41 deletions(-)

Otherwise the patch looks fine, please apply to the shared branch..

Thanks,
Jason
