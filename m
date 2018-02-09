From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 18:55:31 +0200
Message-ID: <20180209165531.GR2197@mtr-leonro.local>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com>
 <20180209161030.GA7584@mellanox.com>
 <HE1PR0502MB3004BB45FC9ADB9B49CAF283D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
 <20180209161325.GD7570@ziepe.ca>
 <20180209164200.GO2197@mtr-leonro.local>
 <20180209165138.GA11850@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tT3UgwmDxwvOMqfu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180209165138.GA11850-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tT3UgwmDxwvOMqfu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2018 at 09:51:38AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 09, 2018 at 06:42:00PM +0200, Leon Romanovsky wrote:
> > On Fri, Feb 09, 2018 at 09:13:25AM -0700, Jason Gunthorpe wrote:
> > > On Fri, Feb 09, 2018 at 04:12:24PM +0000, Parav Pandit wrote:
> > >
> > > > > I did a patch that will make our public headers mostly strictly c=
onforming to C11
> > > > > with -Wpedantic set, which I've been wondering if it is worth sen=
ding..
> > >
> > > > Any reason to use open code instead of using BIT() macro from
> > > > include/linux/bitops.h which does the same thing?
> > >
> > > BIT only works in the kernel. This is a publich header from rdma-core
> > > userspace.
> >
> > =E2=9E=9C  rdma-core git:(master) git grep "define BIT" providers/mlx5/=
cq.c
> > providers/mlx5/cq.c:#define BIT(i) (1UL << (i))
>
> Still can't use it in a public header.

Thanks, I missed that we are talking about mlx4dv.h

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--tT3UgwmDxwvOMqfu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp90oMACgkQ5GN7iDZy
WKcQig/7Bvu898SEEp/WuATPLyaV9MassquHM2Y899YxDmjSitvaPIGRZ3Tugx8Z
LMPQInhdJr40zYYVUxYhKuaLEkWnhadEfMkT4ys/yReKqjDhNP6/Ka2H+4/KwD52
bGbYR8sV2rtCtLDwaaZKztI8tEU0wkEB3zarl70BHvm7sazeJ+I+F7dcnxTALewi
5m1Ofv1oTJluT294t13T62bxyVZd5uhwym6/lclNAuGcecvgwBPYrXWy9x5dO5JH
DlHUdj2vD6tvdjC8Z3xgxQ0qUyJ5hZC0APfTbfV9V19qNj+p57J4v/TT1qHKvjnU
cBQCYqnNqaVP1qC4MD4+Yq7blJLQcdBQzgSS6GvY2HW5HSlzknkTKVLJZwfMZh/f
GKpAFV642azn8bhovbPl6in0rI2q34O0xghxWUVXhZZT2aAyME9bLkm5YFH1+R36
do8nldJHQ956CiHwmBUxIyyGGEnK318DDKECuunac1DiByFy65rKfpFK7E+cMHLU
N6Y6UaGEzjqrjkVqiA/TdbzJDuOF95L/MaqRkmxtkEqwbrqV6wq9gfUCosmvaHeT
cq22C0Qv+VKHS+BSrFzDfQHot42Sx9ZOw4uJbVFy/IAM9wyEXn/Lu0Rh64Ze5W/a
sq9Jo94RuQL6XCT02KVsreGeEgtfhxuBRIt01rczFo4TztK1Iag=
=3P0O
-----END PGP SIGNATURE-----

--tT3UgwmDxwvOMqfu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
