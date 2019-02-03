From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 12/12] net/mlx5: Set ODP SRQ support in firmware
Date: Sun, 3 Feb 2019 11:03:11 +0200
Message-ID: <20190203090311.GD3634@mtr-leonro.mtl.com>
References: <20190122064851.6032-1-leon@kernel.org>
 <20190122064851.6032-13-leon@kernel.org>
 <20190131232843.GA15062@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="11Y7aswkeuHtSBEs"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131232843.GA15062@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2019 at 04:28:44PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 22, 2019 at 08:48:51AM +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis@mellanox.com>
> >
> > To avoid compatibility issue with older kernels the firmware doesn't
> > allow SRQ to work with ODP unless kernel asks for it.
> >
> > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 53 +++++++++++++++++++
> >  include/linux/mlx5/device.h                   |  3 ++
> >  include/linux/mlx5/mlx5_ifc.h                 |  1 +
> >  3 files changed, 57 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index be81b319b0dc..b3a76df0cf6c 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -459,6 +459,53 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
> >  	return err;
> >  }
> >
> > +static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> > +{
> > +	void *set_ctx;
> > +	void *set_hca_cap;
> > +	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> > +	int err;
> > +
> > +	if (!MLX5_CAP_GEN(dev, pg))
> > +		return 0;
>
> Should a
>
>     if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
>              return 0;
>
> Be here?

We had similar discussion in mlx5_ib main.c, but here we are talking
about mlx5_core code, which from my point of view should represent the
real HW capabilities without relation to kernel compilation mode.

Thanks

>
> Jason

--11Y7aswkeuHtSBEs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcVq5PAAoJEORje4g2clinqgMP/j+yFs8h/HxtiXSp4e2EV7Op
yW2N76UKOi2dkSl3UVCxbiHJpq4nauG/V8RhLL+Ed/kJ5cOUg6Smbr4EaLgF7Yip
CLAPtjka6ig+hD16h/G4BICWfs8/rExiwmWNs9cUe3Twfhhm6q53cZ9IHuPOXkll
o4sfuL0BJ9FyyZ2UpkQVBqVGk66fpkq5nOhICvBgCfaMf5R7kXDzpCQ0XlycTT4x
6bGOp8Xvv7Z99GJgqwb8ktmZ3yGl/I0wcx1c6yAYgnwBoL6r6fuuhXWLojWAXwZY
TOMOKInlsoioMcyNTabh74FOlDBPHiAwbr3q5+/vzHgI2n1sfxJujH1Txchga8D3
WCBR9uKd01aAM0tno58YCkP6xAV4adt2aa1mWZU04S+RjG0dCa4eOY2DzgL6Z98U
faakuc0Urzo48i3EP/ZDym9iDRxfsJKmMJ2wtnMeh+Ed5OHFE2gHev4H1QFpsbZT
pZUshlO83+BeZ7HviB7hkxfmnlIugv+5TFniFs/KrdG/H2anKKGM8XZ4Sxhz5cQZ
KsMacZ3aXHIV00+E8Lr83uitD/lem9GRoJypz8wWoQ3EkEaSFrxUtLMdoj0vf7e0
V99HHtOZt82UEIxW4dtJgfxvgJlHDPIpjjMpvvTxDZaXK7ssEAZZs3Le83An4gEZ
IlFRcl9+E+kCfhe2y0cT
=9+1L
-----END PGP SIGNATURE-----

--11Y7aswkeuHtSBEs--
