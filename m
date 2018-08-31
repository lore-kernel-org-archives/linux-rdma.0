From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH v2 1/2] IB/ipoib: Use dev_port to expose network
 interface port numbers
Date: Fri, 31 Aug 2018 11:57:40 +0300
Message-ID: <20180831085740.GA22172@cello.Dlink>
References: <20180830182238.16361-1-ar@cs.msu.ru>
 <20180830182238.16361-2-ar@cs.msu.ru>
 <075a5d0f9fb9dfc868e82073f930a98bea15e578.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <075a5d0f9fb9dfc868e82073f930a98bea15e578.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 30, 2018 at 04:17:58PM -0400, Doug Ledford wrote:
> On Thu, 2018-08-30 at 21:22 +0300, Arseny Maslennikov wrote:
> > Some InfiniBand network devices have multiple ports on the same PCI
> > function. This initializes the `dev_port' sysfs field of those
> > network interfaces with their port number.
> >=20
> > Prior to this the kernel erroneously used the `dev_id' sysfs
> > field of those network interfaces to convey the port number to userspac=
e.
> >=20
> > The use of `dev_id' was considered correct until Linux 3.15,
> > when another field, `dev_port', was defined for this particular
> > purpose and `dev_id' was reserved for distinguishing stacked ifaces
> > (e.g: VLANs) with the same hardware address as their parent device.
> >=20
> > Similar fixes to net/mlx4_en and many other drivers, which started
> > exporting this information through `dev_id' before 3.15, were accepted
> > into the kernel 4 years ago.
> > See 76a066f2a2a0 (`net/mlx4_en: Expose port number through sysfs').
> >=20
> > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infini=
band/ulp/ipoib/ipoib_main.c
> > index e3d28f9ad9c0..ba16a63ee303 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1880,7 +1880,7 @@ static int ipoib_parent_init(struct net_device *n=
dev)
> >  	       sizeof(union ib_gid));
> > =20
> >  	SET_NETDEV_DEV(priv->dev, priv->ca->dev.parent);
> > -	priv->dev->dev_id =3D priv->port - 1;
> > +	priv->dev->dev_port =3D priv->port - 1;
>=20
> I don't know that we can't do this.  At least not yet.  Expose the new
> item to make us compliant with the new docs, and deprecate the old sysfs
> item, but we can't just yank the old item.  Existing tools/scripts might
> (probably) rely on it (existing tools already special case IPoIB
> interfaces and we'll need to make sure they don't special case this
> element too).

I'm good with keeping both items for a (probably long) while to not break
things. But how exactly should we notify users of the deprecation, so they
don't special case this again? A comment in the code seems too little =E2=
=80=94
everyone's obviously too busy to look there and stumble upon that.
A distinct notice in the doc seems too much. I can't think of another place
for the deprecation notice where people would take note of it, however.

Anyway: would it be OK to just restore both items and put a small note in
dev_id's doc entry? If yes, I'll then send a v3.

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluJAv4ACgkQ9dQjyAYL
01A6ExAAspuelHPM1Q0PQn1oEzQWEpcHo6BKdMfOXPVXXWKRZulcNr7eKlbQobi8
mbDOBxZUbeM13tzkq4+WelUNhcSsaYxVPs4IwDv7ozcFRyHLRrnWr7P3YCA1Y42y
yPgQ2iz69dETFiAvUYhfvlq7gLgL2ypplqouuIsfhBCtpFuWx+21wsz+M+NMl+pN
Rn85CusCEKYzzekjoDLFnZasN9lEvbrP42Y4G8O6B5GDRoV4/LgzuhEYwHZEIlAR
sm3CaGUV7DoruBWKPs2n6yYqiI9QhcdQ6T3RYUvFiTyHYqfyQ1sQa3vu/6F54pM9
XWLL4oj1EVf5XewHynzMMFXlGrqsUEwXMnUDslTTirdWIsbQxJSvgHeFqnkidYb5
SV0Q6bchCeY7Tw/YIWBCotXSfPlOMvUnM0ttI7Ull3lkG7TzSENT+DelACAdaEDA
K3tZ2AHV2OVl+8wOUq7+XLiJ9XbsO84e/WVEWAXt9Wioby96UowwvNTovT+SDPCg
kv0KFm/b/1cQpgyX595qoWBji+t4JVtFyLRU3B4fyVEO+unEiIZsUDg14VS1h/M4
lhKAxhmX5V7U2icirDqS7kmOPTGsaz+Kxrva3TvQN6pK+iS/zQBtMpohkvnDHkGA
XKJLflnFrqH9q6QpBHtPHHmMmBAgTBJ5XapahkjL+6PNSlaPA3U=
=L90b
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
