From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Fri, 07 Sep 2018 13:14:37 -0400
Message-ID: <adc47601cbf388f7909bc01dd3b122d6558cc74e.camel@redhat.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
         <20180903161316.25121-4-ar@cs.msu.ru>
         <20180905135035.GT2977@mtr-leonro.mtl.com> <20180906070433.GA13034@cello>
         <20180906130358.GJ3142@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-y6OJqvcUuG7NIyNJ1dEl"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180906130358.GJ3142@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-y6OJqvcUuG7NIyNJ1dEl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-09-06 at 16:03 +0300, Leon Romanovsky wrote:
> On Thu, Sep 06, 2018 at 10:04:33AM +0300, Arseny Maslennikov wrote:
> > On Wed, Sep 05, 2018 at 04:50:35PM +0300, Leon Romanovsky wrote:
> > > On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrote:
> > > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > > ---
> > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++++=
++++
> > > >  1 file changed, 38 insertions(+)
> > > >=20
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/in=
finiband/ulp/ipoib/ipoib_main.c
> > > > index 30f840f874b3..7386e5bde3d3 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device *d=
ev)
> > > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > > >  }
> > > >=20
> > > > +/*
> > > > + * We erroneously exposed the iface's port number in the dev_id
> > > > + * sysfs field long after dev_port was introduced for that purpose=
[1],
> > > > + * and we need to stop everyone from relying on that.
> > > > + * Let's overload the shower routine for the dev_id file here
> > > > + * to gently bring the issue up.
> > > > + *
> > > > + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> > > > + */
> > > > +static ssize_t dev_id_show(struct device *dev,
> > > > +			   struct device_attribute *attr, char *buf)
> > > > +{
> > > > +	struct net_device *ndev =3D to_net_dev(dev);
> > > > +	ssize_t ret =3D -EINVAL;
> > > > +
> > > > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > > > +		netdev_info_once(ndev,
> > > > +			"\"%s\" wants to know my dev_id. "
> > > > +			"Should it look at dev_port instead?\n",
> > > > +			current->comm);
> > > > +		netdev_info_once(ndev,
> > > > +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n=
");
> > > > +	}
> > > > +
> > > > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +static DEVICE_ATTR_RO(dev_id);
> > > > +
> > >=20
> > > I don't see this field among exposed by IPoIB, why should we expose i=
t now?
> > >=20
> >=20
> > To deviate from standard netdev behaviour, which only prints the
> > field out. Doug wanted this to also print a deprecation message, and
> > netdev (obviously) does not do that. See below.
> >=20
> > > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > > +{
> > > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > >=20
> > > Why isn't enough to rely on netdev code?
> > >=20
> >=20
> > Netdev code relies on macros around a *static* function 'netdev_show',
> > which is defined in net/core/net-sysfs.c; it is not listed in any heade=
r
> > files, and the macros aren't as well. This all leads me to believe it
> > was not really meant to be used from outside net/core/net-sysfs.
> >=20
> > The only way we could use any netdev code here is to set up our own
> > handler (again), printk() a message, then call netdev_show =E2=80=94 bu=
t we have
> > no access to it.
> >=20
> > Of course, it also may be that I'm terribly missing a clue.
>=20
> Thanks,
>=20
> IMHO, the end result of adequate Doug's request is a little bit too much.
> I don't think that it justifies such remove->create construction.
>=20
> Personal opinion.

I agree with you that the end result is kinda bulky, *but*, we will need
to know if there are things using the old dev_id before we can remove
it.  In particular, I'm concerned the IPoIB handling code of
NetworkManager uses it.  It's worth the cost I think.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-y6OJqvcUuG7NIyNJ1dEl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluSsf0ACgkQuCajMw5X
L90Sfw/9GoyRCCCCuhDVX4jb/V+tZzSPKpGJrfbTTTaQliLfmbY2JjYwLr15Ok9H
aOoXEPmV7+FIX5ifeSWTn6Nxn9p//71J/Vfc1fxgQwCIlstCET/AfgmDOmsdmcIm
iI6EuRi7+EmBh6WJwHWo2cogPCEIcP85XtGOIj2JujIcVJd88P+5+k0hR1FVb/ef
m7tCr2uHspUM6Xcd9Z9KCE+fHZP3W2pBYV+6N06XSrAAUebn1wnTPx21wgyemKRW
9cVwMPcvkSyhYUHfj46WE0pTMKEK+JR03QOqZBMqgz1D4FGecU0JU7vKrhvm2fi+
VwBCFVnHTV4uwNWBW4bMhP/9prEkvAyRVEbTyN0YjJLu+rEvXx04aBxR7IwRBqsa
IML//2/KI1r880H9wSiaBOnhRbnoHqbQUHmUfyV8zy0LUOuQxyBaz68LT94PaxPd
83BKywrnUCeNCbYWFYnLatNcbxQ0GbaXaE9shewK5Lsk3LnJNv0OtqgdFkW/30sj
FYUo1MAuawLdd7WTHQob8EXuCdkS5ZNycJe49Bnm49gjunp6RlurlTiiOeKUpziO
bYK27Yb1g9QmZMY5iJQPQc592fPcp6lF0jffKzCXOfDhzzofPJk2mgNjb35HTG7I
W3IwlDutVo+M6fO1+Wd/tcaagbb+eDdGcOpFJTkqG8cx5LjLUOs=
=4+m2
-----END PGP SIGNATURE-----

--=-y6OJqvcUuG7NIyNJ1dEl--
