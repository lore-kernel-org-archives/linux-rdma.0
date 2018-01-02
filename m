From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] net/mlx5: Add DCT command interface
Date: Tue, 2 Jan 2018 12:07:26 +0200
Message-ID: <20180102100726.GA10145@mtr-leonro.local>
References: <20171226091634.2352-1-leon@kernel.org>
 <20171226091634.2352-2-leon@kernel.org>
 <20180102094327.GA3302@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102094327.GA3302@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 11:43:27AM +0200, Yuval Shaia wrote:
> On Tue, Dec 26, 2017 at 11:16:29AM +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add a missing command interface to work with a DCT. It includes: creating,
> > destroying and get events for.
> >
> > Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/eq.c |   9 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 128 ++++++++++++++++++++++++---
> >  include/linux/mlx5/device.h                  |   9 ++
> >  include/linux/mlx5/driver.h                  |   8 ++
> >  include/linux/mlx5/qp.h                      |  12 +++
> >  5 files changed, 153 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> > index 60771865c99c..7d3d503fa675 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> >
> > +static u64 dct_allowed_event_types(void)
> > +{
> > +	u64 mask;
> > +
> > +	mask = BIT(MLX5_EVENT_TYPE_DCT_DRAINED);
> > +
> > +	return mask;
>
> We don't really need this "mask" variable, right?

I removed it in v1 and it won't be in v2 too.

Thanks

>
> > +}
> > +

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpLWd4ACgkQ5GN7iDZy
WKefVg//f3YiDyM/t0FVZKTFXw+9Zn1s/cF7CvbzVBSAW/Qd/uJOr97kj4jHPHx6
hEpdyy+IAYfPzCRAzSPcyiuaXAQbDConwI+sN2NhBAeHYZ63xt/Klnk/NqwyJUaa
JVAP2a21i1ZTXKx6mwkcY1G9nV+J4jiDGSW2LGC1155m0F4FP5AmV2d8z4O3mBvz
9CZdtUHqqn/fuVfKATugyBjCrimlvtxPG5wQU9juQZuRe9s00Uwt1UFy9w1aZdZ4
YEjZgXqbWm72wJ6HUmJ9UiOaQYYH25QytL/W366wnuRPEVD6dG6xIM9wNh7tU8pv
x+qHeECnYv4DDcGIMMIbQWuHo74HA756AAabCY5dKNJ+FsFBLaqjSA/0HNKYj/UT
Ye4DLD9gcjIYFInn6FSZk4b5SPDDgbEDD0sm7mv/4+d52YRa/Y5vN6mgfsg3bR3l
2WZJs6FO1E6UnFWjUG3YJsjfRzVIqI2pVMAIzaSxoobN7X3JJx8UZrEta4WyM7Ff
iyZH5Y03YU8xqNOH5VwF9i4j9m+NPKeJiu66w7C9TKyN/KVPryJ/dpzyHK9wK3uV
0B+DWhOdmbg9vpuH5KYlsWZX1bdRd68ztXVNv39+A5ws/VxP4myZTbwzTBkWf5kJ
QzS0xX4SXopk9ZrsHHMlaKmTDuxxkbD78aiqfwd5B2b2294D2bA=
=UHEZ
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
