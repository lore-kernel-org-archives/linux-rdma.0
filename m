From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Factor out HCA capabilities
 functions
Date: Mon, 11 Feb 2019 20:32:02 +0000
Message-ID: <20190211203154.GM24706@mellanox.com>
References: <20190211115608.22677-1-leon@kernel.org>
 <20190211115608.22677-3-leon@kernel.org>
 <20190211195050.GL24706@mellanox.com>
 <20190211200207.GD21447@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211200207.GD21447@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <DE6330C19A27E547A71044F8BD42F521@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 10:02:07PM +0200, Leon Romanovsky wrote:
> On Mon, Feb 11, 2019 at 07:50:55PM +0000, Jason Gunthorpe wrote:
> > On Mon, Feb 11, 2019 at 01:56:08PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Combine all HCA capabilities setters under one function
> > > and compile out the ODP related function in case kernel
> > > was compiled without ODP support.
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  .../net/ethernet/mellanox/mlx5/core/main.c    | 47 +++++++++++++----=
--
> > >  1 file changed, 33 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers=
/net/ethernet/mellanox/mlx5/core/main.c
> > > index 6d45518edbdc..d7145ab6105d 100644
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > @@ -459,6 +459,7 @@ static int handle_hca_cap_atomic(struct mlx5_core=
_dev *dev)
> > >  	return err;
> > >  }
> > >
> > > +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > >  static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> > >  {
> > >  	void *set_hca_cap;
> > > @@ -502,6 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_de=
v *dev)
> > >  	kfree(set_ctx);
> > >  	return err;
> > >  }
> > > +#endif
> > >
> > >  static int handle_hca_cap(struct mlx5_core_dev *dev)
> > >  {
> > > @@ -576,6 +578,35 @@ static int handle_hca_cap(struct mlx5_core_dev *=
dev)
> > >  	return err;
> > >  }
> > >
> > > +static int set_hca_cap(struct mlx5_core_dev *dev)
> > > +{
> > > +	struct pci_dev *pdev =3D dev->pdev;
> > > +	int err;
> > > +
> > > +	err =3D handle_hca_cap(dev);
> > > +	if (err) {
> > > +		dev_err(&pdev->dev, "handle_hca_cap failed\n");
> > > +		goto out;
> > > +	}
> > > +
> > > +	err =3D handle_hca_cap_atomic(dev);
> > > +	if (err) {
> > > +		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
> > > +		goto out;
> > > +	}
> > > +
> > > +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > > +	err =3D handle_hca_cap_odp(dev);
> > > +	if (err) {
> > > +		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
> > > +		goto out;
> > > +	}
> > > +#endif
> >
> > Adding
> >   if (IS_ENABLED..)
> >     return 0;
> >
> > To the top of handle_hca_cap_odp is alot better.
>=20
> Saeed gave comment that he prefers code to be compiled-out in case
> config is not set. In you suggestion, the code will exist and only
> with some optimizations enabled it will be thrown.

the kernel always compiles with optimizations that will throw away
this code, it is a widely used pattern.

#ifdef creates a compilation test matrix that is very undesired.

Jason
