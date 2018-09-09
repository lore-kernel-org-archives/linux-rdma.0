From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH v4 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Sun, 9 Sep 2018 23:55:12 +0300
Message-ID: <20180909205512.GA5918@cello.Dlink>
References: <20180906145112.29245-1-ar@cs.msu.ru>
 <20180906145112.29245-4-ar@cs.msu.ru>
 <20180907154359.GA14627@ziepe.ca>
 <20180909181146.GA29632@cello.Dlink>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180909181146.GA29632@cello.Dlink>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 09, 2018 at 09:11:46PM +0300, Arseny Maslennikov wrote:
> On Fri, Sep 07, 2018 at 09:43:59AM -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 06, 2018 at 05:51:12PM +0300, Arseny Maslennikov wrote:
> > > Some tools may currently be using only the deprecated attribute;
> > > let's print an elaborate and clear deprecation notice to kmsg.
> > >=20
> > > To do that, we have to replace the whole sysfs file, since we inherit
> > > the original one from netdev.
> > >=20
> > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 31 +++++++++++++++++++++=
++
> > >  1 file changed, 31 insertions(+)
> > >=20
> > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infi=
niband/ulp/ipoib/ipoib_main.c
> > > index 30f840f874b3..74732726ec6f 100644
> > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > @@ -2386,6 +2386,35 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > >  }
> > > =20
> > > +/*
> > > + * We erroneously exposed the iface's port number in the dev_id
> > > + * sysfs field long after dev_port was introduced for that purpose[1=
],
> > > + * and we need to stop everyone from relying on that.
> > > + * Let's overload the shower routine for the dev_id file here
> > > + * to gently bring the issue up.
> > > + *
> > > + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> > > + */
> > > +static ssize_t dev_id_show(struct device *dev,
> > > +			   struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct net_device *ndev =3D to_net_dev(dev);
> > > +
> > > +	if (ndev->dev_id =3D=3D ndev->dev_port)
> > > +		netdev_info_once(ndev,
> > > +			"\"%s\" wants to know my dev_id. Should it look at dev_port inste=
ad? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
> > > +			current->comm);
> > > +
> > > +	return sprintf(buf, "%#x\n", ndev->dev_id);
> > > +}
> > > +static DEVICE_ATTR_RO(dev_id);
> > > +
> > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > +{
> > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > > +}
> >=20
> > Isn't this racey with userspace? Ie what happens if udev is querying
> > the dev_id right here?
>=20
> udev in particular does not use dev_id at all since 2014, because "why
> would we keep using dev_id if it is not the right thing to use?".
>=20
> >=20
> > Do we know there is no userspace doing this?
> >=20
>=20
> Not for sure.
>=20
> If we move all the sysfs handling stuff we introduce in _add_port():
>  - pkey
>  - umcast
>  - {create,delete}_child
>  - connected/datagram mode
> to _ndo_init(), which is called by register_netdev before it sends
> the netlink message, would that suffice to eliminate the race?
> (Sysfs files for {create,delete}_child go to _parent_init() then).
>=20

No, we can't, sorry for the noise. ndo_init() runs before the kobject
becomes available.

Anyway, our sysfs attributes being racy is unrelated to the patch series
subject, and I can't come up with any other ideas what to do with them
that do not involve adjustments to register_netdev.

> > >  static struct net_device *ipoib_add_port(const char *format,
> > >  					 struct ib_device *hca, u8 port)
> > >  {
> > > @@ -2427,6 +2456,8 @@ static struct net_device *ipoib_add_port(const =
char *format,
> > >  	 */
> > >  	ndev->priv_destructor =3D ipoib_intf_free;
> > > =20
> > > +	if (ipoib_intercept_dev_id_attr(ndev))
> > > +		goto sysfs_failed;
> >=20
> > No device_remove_file needed?
> >=20
>=20
> As far as I understand, unregister_netdevice takes care of it
> while destroying the related kobject.
>=20
> > Jason



--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluViKUACgkQ9dQjyAYL
01BR8g/8COFCC+d+4XgjoZh750y6iUfnNc7A9U2xOiTJprzgmuloOkzjCNa6nvYw
2Rr/dARydaURZ8D+ZKM4LGn6TOFMHnj+Y2h5uhVzHH0nw9thQtPzyG8WkgKh6qd2
3oqzRBQfq9bJkHDlj0fPZv6WiKuoCWKjHpc/x3NKC2Z39qHUDR1FgsXzUKP8ZAbD
SSxe21d5JTuQ9r26vhBB5seHnPIBNbNnRbNj9yhQuG2bJ2FcVfP8A2q4/RTAbXCg
Rr4NofWGH4mmVkHQzQmgkulbvrCbLHYBIH9KA+eI4HS4KHnCvSJOt2JOINCAlZcD
kZn+61Ke/in5UjYTkpssMj4zVTyjrQMijB45kqnv4dNxEl31Rt/qaJtMJ9fCDb2M
Neo0KBPLQaIQsAmFyKzxwA7oJhdvIm3X9Ojj4bh230oP1DYIrwwW7V37PnhmW9Jc
6EBG0AG7p6U5D4qpabf7N/6EdLzTghFeab3RemBVi9TMaGf41Ga7bo5VIqc/l5Lo
uojkvw5F0F9pIq/diKuu00V83QKixzBqkaj6petB5RzsQzAMVoWF+DbXEaU1rnbT
hLx45lav6VFd6x90MjmGy7vYEnwUw0Vv5+6Qw0gTyFS+QvJn6uzpY7IdqCckARvE
E/Ezc+CDTjmnkkZw0y/6jnOHdeCqT3lkyp7JCWm0cjbPksWDfI8=
=S0hN
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
