From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Date: Mon, 29 Apr 2019 18:45:59 +0000
Message-ID: <VI1PR0501MB22712A3E3743FE283308771ED1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
 <20190429184116.GB6705@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190429184116.GB6705@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Leon Romanovsky
> Sent: Monday, April 29, 2019 1:41 PM
> To: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>
> Subject: Re: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
> loopback traffic
>=20
> On Mon, Apr 29, 2019 at 06:14:16PM +0000, Saeed Mahameed wrote:
> > From: Maor Gottlieb <maorg@mellanox.com>
> >
> > When in switchdev mode, we would like to treat loopback RoCE traffic
> > (on eswitch manager) as RDMA and not as regular Ethernet traffic In
> > order to enable it we add flow steering rule that forward RoCE
> > loopback traffic to the HW RoCE filter (by adding allow rule).
> > In addition we add RoCE address in GID index 0, which will be set in
> > the RoCE loopback packet.
> >
I likely don't understand nor I reviewed the patches.
Part that I don't understand is GID index 0 for RoCE.
RoCE traffic runs over all the GID entries and for all practical purposes f=
rom non_zero index.
How will it work?
It is better if you explain it in the commit log, why its done this way, 'w=
hat' part is already present the patch.


> > Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
> >  .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
> >  .../net/ethernet/mellanox/mlx5/core/rdma.c    | 182 ++++++++++++++++++
> >  .../net/ethernet/mellanox/mlx5/core/rdma.h    |  20 ++
> >  include/linux/mlx5/driver.h                   |   7 +
> >  5 files changed, 214 insertions(+), 1 deletion(-)  create mode 100644
> > drivers/net/ethernet/mellanox/mlx5/core/rdma.c
> >  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.h
> >
>=20
> Thanks,
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
