From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH 2/3] IB/ipoib: Stop using dev_id to expose port numbers
Date: Mon, 13 Aug 2018 16:57:24 +0300
Message-ID: <20180813135724.GA23033@cello.Dlink>
References: <20180813114224.7065-1-ar@cs.msu.ru>
 <20180813114224.7065-3-ar@cs.msu.ru>
 <20180813124018.GA6122@lap1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180813124018.GA6122@lap1>
Sender: netdev-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 13, 2018 at 03:40:20PM +0300, Yuval Shaia wrote:
> On Mon, Aug 13, 2018 at 02:42:23PM +0300, Arseny Maslennikov wrote:
> > Some InfiniBand network devices have multiple ports on the same PCI
> > function. Prior to this the kernel erroneously used the `dev_id' sysfs
> > field of those network interfaces to convey the port number to userspac=
e.
> >=20
> > `dev_id' is currently reserved for distinguishing stacked ifaces
> > (e.g: VLANs) with the same hardware address as their parent device.
> >=20
> > Similar fixes to net/mlx4_en and many other drivers, which started
> > exporting this information through `dev_id' before 3.15, were accepted
> > into the kernel 4 years ago.
> > See 76a066f2a2a0268b565459c417b59724b5a3197b, commit message:
> > `net/mlx4_en: Expose port number through sysfs'.
> >=20
> > I would be OK with this commit not being backported to stable, since
> > it might break admin-supplied udev rules and the likes.
> >=20
> > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infini=
band/ulp/ipoib/ipoib_main.c
> > index 6eb0594fffec..f64535038147 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -2252,7 +2252,6 @@ static struct net_device *ipoib_add_port(const ch=
ar *format,
> >  	}
> > =20
> >  	SET_NETDEV_DEV(priv->dev, hca->dev.parent);
> > -	priv->dev->dev_id =3D port - 1;
>=20
> Correct me if i'm wrong here but besides some changes in commit message
> looks like patch 1/3 is the same as 2/3, isn't it?
>=20
> Yuval
>=20

1/3 has an extra line, 2/3 removes a different line.

(a) If you apply both 1/3 and 2/3, the port number can be seen at
/sys/class/net/*/dev_port and not at .../dev_id.

(b) If you apply only 1/3, the port number can be seen at _both_
=2E../dev_port and .../dev_id (to preserve backward compatibility with
e.g. existing udev rules that rely on "ATTR{dev_id}")

By splitting those up we have both options (a) and (b) available,
so the maintainers are free to decide which one is wiser.

> >  	priv->dev->dev_port =3D port - 1;
> > =20
> >  	result =3D ib_query_port(hca, port, &attr);
> > --=20
> > 2.18.0
> >=20

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAltxjjwACgkQ9dQjyAYL
01DThQ//R6B50gnb913kHygf6PA2tH9rV5Y0QM+uEt2yh8eXC7jtYazaThh8LoxD
q5/CH4Funt4a9GFFFKjtPcgWpdKO2XQKqJlBGU25lJkeTHs+DZQXs0n4903ZsrMp
AQr8O83l75Lh0zwcP00gZEVNXlniz07cPaoxhquPTsVdJo7u9VeHztAYDutNaF7e
ufM2/eyYh9OMXsOZMkuDKkYd159y7jdUgKQ800c/w/5jN6aiRmT5CtI/iXIyb19s
y16I72XCdiEGhHbJ0h8/VadR1zWL2go4qXEG4Xy/uL3ssjv4TGM3kDNP5JVm31FJ
0lk3sNQcKDd92jOdmK70sLj/gmZJJbz+GoeGvLjxCc+mUsJvI9r1fYsS58L6oPDB
1hokaaFCYXFQbzUHJM4nl2gPbSDN2CviMWieedXcA/htBeh2SbfZt7OiyHQEnAnS
9Y1qUSnrJfPVyjD79udz7tnS/PZJR0GXb1LBOmDjXNfbGWnoBTYSzBMZ5g4CO5T+
2tz2gWPuvw2uaLfhFbXV4qhTZ7pCRIzvZj/JDT4IR/d8624rqzwGXU7vv2y5ZrmL
ovoyCsqv4TJxztfXffn//+ifZlCR6IyaRsgKxsHlcQevwi6PoyaAUhWArIsJI1jw
hLrPosV53To7J4mqGBqlUyuoMWzhKBdLGQEXzOu8cisDwgCZl0s=
=Beg0
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
