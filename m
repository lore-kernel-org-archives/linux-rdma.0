From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Thu, 6 Sep 2018 10:04:33 +0300
Message-ID: <20180906070433.GA13034@cello>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
 <20180905135035.GT2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905135035.GT2977@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2018 at 04:50:35PM +0300, Leon Romanovsky wrote:
> On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrote:
> > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infini=
band/ulp/ipoib/ipoib_main.c
> > index 30f840f874b3..7386e5bde3d3 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> >  }
> >
> > +/*
> > + * We erroneously exposed the iface's port number in the dev_id
> > + * sysfs field long after dev_port was introduced for that purpose[1],
> > + * and we need to stop everyone from relying on that.
> > + * Let's overload the shower routine for the dev_id file here
> > + * to gently bring the issue up.
> > + *
> > + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> > + */
> > +static ssize_t dev_id_show(struct device *dev,
> > +			   struct device_attribute *attr, char *buf)
> > +{
> > +	struct net_device *ndev =3D to_net_dev(dev);
> > +	ssize_t ret =3D -EINVAL;
> > +
> > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > +		netdev_info_once(ndev,
> > +			"\"%s\" wants to know my dev_id. "
> > +			"Should it look at dev_port instead?\n",
> > +			current->comm);
> > +		netdev_info_once(ndev,
> > +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> > +	}
> > +
> > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > +
> > +	return ret;
> > +}
> > +static DEVICE_ATTR_RO(dev_id);
> > +
>=20
> I don't see this field among exposed by IPoIB, why should we expose it no=
w?
>=20

To deviate from standard netdev behaviour, which only prints the
field out. Doug wanted this to also print a deprecation message, and
netdev (obviously) does not do that. See below.

> > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > +{
> > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
>=20
> Why isn't enough to rely on netdev code?
>=20

Netdev code relies on macros around a *static* function 'netdev_show',
which is defined in net/core/net-sysfs.c; it is not listed in any header
files, and the macros aren't as well. This all leads me to believe it
was not really meant to be used from outside net/core/net-sysfs.

The only way we could use any netdev code here is to set up our own
handler (again), printk() a message, then call netdev_show =E2=80=94 but we=
 have
no access to it.

Of course, it also may be that I'm terribly missing a clue.

> > +}
> > +
> >  static struct net_device *ipoib_add_port(const char *format,
> >  					 struct ib_device *hca, u8 port)
> >  {
> > @@ -2427,6 +2463,8 @@ static struct net_device *ipoib_add_port(const ch=
ar *format,
> >  	 */
> >  	ndev->priv_destructor =3D ipoib_intf_free;
> >
> > +	if (ipoib_intercept_dev_id_attr(ndev))
> > +		goto sysfs_failed;
> >  	if (ipoib_cm_add_mode_attr(ndev))
> >  		goto sysfs_failed;
> >  	if (ipoib_add_pkey_attr(ndev))
> > --
> > 2.19.0.rc1
> >



--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluQ0XsACgkQ9dQjyAYL
01DTABAAo8JPRLvRrEQGe4m9m2B3ubv/qd2tRXD24ND9+yyOxBT/HcL5ZUIOfnrw
DJUvg6X/eex6ca9wuKBlbPZUhhlelNUFGlPYDllk4LSckkMjvxRV4iNf0chg8Ilb
lC1mXYqfnFeQAjZoAXc4BSNffHB4x/NKlnBD0iMCnSRUoc2ee+Bu36otgO2P4F5k
hyiQ9/eAZI5+TF0HlHtuBIrOP5U++RlXf+WKZnWv98JKMvPC2D4gJwzK3zG0nhKI
mt85gfb1++o8tCX5SzMky+u8sVOWBE1HOS5EnJRIvWssEDUK/FDmCOR7KK9bRBYq
M4r/Bez5b8pvAU4eT/R2bq/Ecg4WmhS6MJz7MQmtLAMGVxjuwNyo8x74zM95b0BZ
LHk3grqBC3K1dJf2/aeihQd8cw4dkx3XLZWdeMAqtpDDxn7y/yRZbhsj12lOY/NH
hr9PWIjkMy/WJLShs0MsdyWWq0aDAjzy77xgC/A1C+Rp1xykw6G8GGg6HTSdzUzP
uDl9GhxqGDw8b4EArSBNv1knu/pyNjFhgVh8fmHNMKZxZTP1YcQJUWWlYdvg2Q6l
PXySDDfM2axJBtqxpSCw4yHEfe/zTx7jvN1+TTPx/JjWmQtzpWnwx2+VZYOjgPrJ
7cfwhucmtpdc/W5C0Fmbv2Nxu8y3a+3by9vGsBP2FYIlmM8A7E0=
=T3/S
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
