From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Date: Wed, 19 Jun 2019 06:51:28 +0000
Message-ID: <20190619065125.GF11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190619063941.GA5176@mellanox.com>
Content-Language: en-US
Content-ID: <70D3FC83AAAA164B970C3964AEF7EEDF@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Jianbo Liu <jianbol@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 19, 2019 at 06:40:16AM +0000, Jianbo Liu wrote:
> The 06/19/2019 13:04, Leon Romanovsky wrote:
> > On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> > > The 06/18/2019 18:19, Leon Romanovsky wrote:
> > > > On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> > > > > From: Jianbo Liu <jianbol@mellanox.com>
> > > > >
> > > > > If vport metadata matching is enabled in eswitch, the rule create=
d
> > > > > must be changed to match on the metadata, instead of source port.
> > > > >
> > > > > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > > > > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > > > > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > > ---
> > > > >  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> > > > >  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> > > > >  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++=
------
> > > > >  3 files changed, 63 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infini=
band/hw/mlx5/ib_rep.c
> > > > > index 22e651cb5534..d4ed611de35d 100644
> > > > > --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> > > > > +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> > > > > @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(s=
truct mlx5_eswitch *esw, int vport)
> > > > >  	return mlx5_eswitch_vport_rep(esw, vport);
> > > > >  }
> > > > >
> > > > > +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_esw=
itch *esw)
> > > > > +{
> > > > > +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> > > > > +}
> > > > > +
> > > > > +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_esw=
itch *esw,
> > > > > +						 u16 vport)
> > > > > +{
> > > > > +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> > > > > +}
> > > >
> > > > 1. There is no need to introduce one line functions, call to that c=
ode directly.
> > >
> > > No. They are in IB, and we don't want them be mixed up by the origina=
l
> > > functions in eswitch. Please ask Mark more about it.
> >
> > Please enlighten me.
>
> It was suggested by Mark in prevouis review.
> I think it's because there are in different modules, and better to with
> different names, so introduce there extra one line functions.
> Please correct me if I'm wrong, Mark...

mlx5_ib is full of direct function calls to mlx5_core and it is done on
purpose for at least two reasons. First is to control in one place
all compilation options and expose proper API interface with and without
specific kernel config is on. Second is to emphasize that this is core
function and save us time in refactoring and reviewing.

>
> >
> > >
> > > > 2. It should be bool and not u32.
> > > >
> > > > Thanks
> > >
> > > --
>
> --
