From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Fri, 7 Sep 2018 20:28:21 +0300
Message-ID: <20180907172821.GS3142@mtr-leonro.mtl.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
 <20180905135035.GT2977@mtr-leonro.mtl.com>
 <20180906070433.GA13034@cello>
 <20180906130358.GJ3142@mtr-leonro.mtl.com>
 <adc47601cbf388f7909bc01dd3b122d6558cc74e.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6iqOn7HZPWKXx18"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <adc47601cbf388f7909bc01dd3b122d6558cc74e.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Arseny Maslennikov <ar@cs.msu.ru>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--d6iqOn7HZPWKXx18
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 01:14:37PM -0400, Doug Ledford wrote:
> On Thu, 2018-09-06 at 16:03 +0300, Leon Romanovsky wrote:
> > On Thu, Sep 06, 2018 at 10:04:33AM +0300, Arseny Maslennikov wrote:
> > > On Wed, Sep 05, 2018 at 04:50:35PM +0300, Leon Romanovsky wrote:
> > > > On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrote:
> > > > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > > > ---
> > > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++=
++++++
> > > > >  1 file changed, 38 insertions(+)
> > > > >
> > > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/=
infiniband/ulp/ipoib/ipoib_main.c
> > > > > index 30f840f874b3..7386e5bde3d3 100644
> > > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > > @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device =
*dev)
> > > > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + * We erroneously exposed the iface's port number in the dev_id
> > > > > + * sysfs field long after dev_port was introduced for that purpo=
se[1],
> > > > > + * and we need to stop everyone from relying on that.
> > > > > + * Let's overload the shower routine for the dev_id file here
> > > > > + * to gently bring the issue up.
> > > > > + *
> > > > > + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> > > > > + */
> > > > > +static ssize_t dev_id_show(struct device *dev,
> > > > > +			   struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	struct net_device *ndev =3D to_net_dev(dev);
> > > > > +	ssize_t ret =3D -EINVAL;
> > > > > +
> > > > > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > > > > +		netdev_info_once(ndev,
> > > > > +			"\"%s\" wants to know my dev_id. "
> > > > > +			"Should it look at dev_port instead?\n",
> > > > > +			current->comm);
> > > > > +		netdev_info_once(ndev,
> > > > > +			"See Documentation/ABI/testing/sysfs-class-net for more info.=
\n");
> > > > > +	}
> > > > > +
> > > > > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > > > > +
> > > > > +	return ret;
> > > > > +}
> > > > > +static DEVICE_ATTR_RO(dev_id);
> > > > > +
> > > >
> > > > I don't see this field among exposed by IPoIB, why should we expose=
 it now?
> > > >
> > >
> > > To deviate from standard netdev behaviour, which only prints the
> > > field out. Doug wanted this to also print a deprecation message, and
> > > netdev (obviously) does not do that. See below.
> > >
> > > > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > > > +{
> > > > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > > >
> > > > Why isn't enough to rely on netdev code?
> > > >
> > >
> > > Netdev code relies on macros around a *static* function 'netdev_show',
> > > which is defined in net/core/net-sysfs.c; it is not listed in any hea=
der
> > > files, and the macros aren't as well. This all leads me to believe it
> > > was not really meant to be used from outside net/core/net-sysfs.
> > >
> > > The only way we could use any netdev code here is to set up our own
> > > handler (again), printk() a message, then call netdev_show =E2=80=94 =
but we have
> > > no access to it.
> > >
> > > Of course, it also may be that I'm terribly missing a clue.
> >
> > Thanks,
> >
> > IMHO, the end result of adequate Doug's request is a little bit too muc=
h.
> > I don't think that it justifies such remove->create construction.
> >
> > Personal opinion.
>
> I agree with you that the end result is kinda bulky, *but*, we will need
> to know if there are things using the old dev_id before we can remove
> it.  In particular, I'm concerned the IPoIB handling code of
> NetworkManager uses it.  It's worth the cost I think.

I did my checks now and saw that ibdev2netdev uses the value provided
=66rom this dev_id, so every invocation of that script will generate the
warning.

See this line in Parav's repo
https://github.com/Mellanox/container_scripts/blob/master/ibdev2netdev#L112

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--d6iqOn7HZPWKXx18
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkrU1AAoJEORje4g2clin7RAP/3zMXXy4bASkyRm3mBz9tsxl
VOSbUHZJ8vp3DVXDFwokrz/D5rGVSvJsS8v0RhQjdGi0wIr2zQuRTbVIFjsoxU41
oi7gybwaQbNb6cT4GKdquKPOf09kLJNDCvSX90dS81LxxNGKi4mugjo1YYTb5qvU
HcAt3bFV5emFBCke9Fb33lo3yOWOaUsq26ObVKvsCcGAHjpxf/4B+BKgxkUH/47A
EBuqSWEayE4ScHF1TduPtmmvuxpeGC0qPS8MLaJa99t0rIWSd+Cnh+kn2+NruGxv
YITJTN1wUX8DRlBjyXfn9SEN7DPZlgY8EX0oSmUJlFj4J+R1P22s8GAeZUMp8Vji
4s2kphCKlOwHCwsNvyHAt/DRl+qOM+hVUVcZoOPCMFLfKSEOjaHBUuDxWe0yVFe3
tnxcFqWBoDdvpfnO2L/dDSIYxVVHBGxkytxjuXgWARx5ZWS9Fc1CK59r4KlJuCwX
AgZFD9rT4oIkiQ0IYyoRGclBCSvJs9mysEFoRpYerlJ3tSW1dTSaPr2jcqqeHs+8
yp+LEX8wHkjnfIRubcDPvt1JSB5V7zO01OXVeJ/F4wGeYXfBuQaL4MoMczpNeMAj
lWwvFuXgqlnHJcq0xNbrW+JKiZFZ/ukp9+B06lWip08bYiR2apGaabMlLhFhDrfB
iUIRge4lIFu98sw799ln
=YFZf
-----END PGP SIGNATURE-----

--d6iqOn7HZPWKXx18--
