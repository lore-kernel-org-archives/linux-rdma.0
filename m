From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 12/12] net/mlx5: Set ODP SRQ support in firmware
Date: Tue, 5 Feb 2019 08:27:53 +0200
Message-ID: <20190205062753.GQ3634@mtr-leonro.mtl.com>
References: <20190122064851.6032-1-leon@kernel.org>
 <20190122064851.6032-13-leon@kernel.org>
 <19e67f214aca4424e0e373d782c4c7e6bc25dcef.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Rzq/nSLlHy1djmXS"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19e67f214aca4424e0e373d782c4c7e6bc25dcef.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Rzq/nSLlHy1djmXS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 04, 2019 at 11:47:23PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-01-22 at 08:48 +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis@mellanox.com>
> >
> > To avoid compatibility issue with older kernels the firmware doesn't
> > allow SRQ to work with ODP unless kernel asks for it.
> >
> > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 53
> > +++++++++++++++++++
> >  include/linux/mlx5/device.h                   |  3 ++
> >  include/linux/mlx5/mlx5_ifc.h                 |  1 +
> >  3 files changed, 57 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index be81b319b0dc..b3a76df0cf6c 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -459,6 +459,53 @@ static int handle_hca_cap_atomic(struct
> > mlx5_core_dev *dev)
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
>
> reversed xmas tree.

I'll send followup to address your comments.

Thanks

--Rzq/nSLlHy1djmXS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcWSzpAAoJEORje4g2clinNAgQAJ1t2u2V+wZ+6I0f3pZObofi
pUZX/Pk3ErDs8oPiMp1h0UZC5zrjWoHXxXD15faHKXVOwOyv6zLAeMvmGW/YKyVM
pk+FLfG9lDVQSikGWdnsXI3+gaW1rQPJ/wmISt/KVxRyWdvdrhO1iJy4DpBfqFod
aivrHrNUA1vybwxH0qfBTfEryuYT2bgZUyBK3X/fnanyLGQ59nGQXKNrIsRd215G
3xqiSLoy/3RVt6CPN6+NHRzGVPZoS4RXSukIEelTWdME7ZR3uZo5SYqk+ibLAuDG
7k92ccAl76bDhtOQvfDMv9PWUKiQDpwwmjbfRhlOqtF9VEnhaWc1eXFhR5KdJ0y3
S5jqOVSyr+m9W/YGc811UNigx2g2HLh4pJa/Xg0ws7Fdo0Y7QJpUa6DRqhJO8arj
NHx4Zy4Xn4xlxBJkvqkiChuvCQpJZUonHu0yRnAgFg9QUq5DbNy/T8IkSTetR8IC
iMgqTwTEgxXGUxod1HMPsIvlYLonO7aTfLnrcE4BmxmVocJiKOPpC32sH1xEXG8Z
2BO5r6duLcbHrrGutHHM66diUv1tI+36vzemmP10MbH3POF7Zna9dNUzj+thHTwb
lEi8AZQFes3kUuSCwfzKjaEiWYixz+lr380BcxAK2WUflR5YiSmNLiuEz1XEU1nY
SqqmNyWEbZbpo3kNsR8y
=CIo0
-----END PGP SIGNATURE-----

--Rzq/nSLlHy1djmXS--
