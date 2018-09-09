From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH v4 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Sun, 9 Sep 2018 21:11:46 +0300
Message-ID: <20180909181146.GA29632@cello.Dlink>
References: <20180906145112.29245-1-ar@cs.msu.ru>
 <20180906145112.29245-4-ar@cs.msu.ru>
 <20180907154359.GA14627@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180907154359.GA14627@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 09:43:59AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 06, 2018 at 05:51:12PM +0300, Arseny Maslennikov wrote:
> > Some tools may currently be using only the deprecated attribute;
> > let's print an elaborate and clear deprecation notice to kmsg.
> >=20
> > To do that, we have to replace the whole sysfs file, since we inherit
> > the original one from netdev.
> >=20
> > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 31 +++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infini=
band/ulp/ipoib/ipoib_main.c
> > index 30f840f874b3..74732726ec6f 100644
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -2386,6 +2386,35 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> >  }
> > =20
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
> > +
> > +	if (ndev->dev_id =3D=3D ndev->dev_port)
> > +		netdev_info_once(ndev,
> > +			"\"%s\" wants to know my dev_id. Should it look at dev_port instead=
? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
> > +			current->comm);
> > +
> > +	return sprintf(buf, "%#x\n", ndev->dev_id);
> > +}
> > +static DEVICE_ATTR_RO(dev_id);
> > +
> > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > +{
> > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > +}
>=20
> Isn't this racey with userspace? Ie what happens if udev is querying
> the dev_id right here?

udev in particular does not use dev_id at all since 2014, because "why
would we keep using dev_id if it is not the right thing to use?".

>=20
> Do we know there is no userspace doing this?
>=20

Not for sure.

If we move all the sysfs handling stuff we introduce in _add_port():
 - pkey
 - umcast
 - {create,delete}_child
 - connected/datagram mode
to _ndo_init(), which is called by register_netdev before it sends
the netlink message, would that suffice to eliminate the race?
(Sysfs files for {create,delete}_child go to _parent_init() then).

> >  static struct net_device *ipoib_add_port(const char *format,
> >  					 struct ib_device *hca, u8 port)
> >  {
> > @@ -2427,6 +2456,8 @@ static struct net_device *ipoib_add_port(const ch=
ar *format,
> >  	 */
> >  	ndev->priv_destructor =3D ipoib_intf_free;
> > =20
> > +	if (ipoib_intercept_dev_id_attr(ndev))
> > +		goto sysfs_failed;
>=20
> No device_remove_file needed?
>=20

As far as I understand, unregister_netdevice takes care of it
while destroying the related kobject.

> Jason

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluVYlwACgkQ9dQjyAYL
01D0zhAA0xZoVCKGTnvmFlzEJfFMosQzZU2hxLYWp3vZnmpkpyfV4IAGt5qFa8ev
U6jww1LMNsNGi1ljUQvy0o6crW6ZKIQKudYrD4rzxfEWDN8w5+uM3Z5Nu311DiP1
4yZNBrEysWeKV5FB7P85kvYBeikKtw7Zxsz4e9rQubfhUP2FAkj703zVhTd0VXVs
vMmKdzj7I8jGreBvkCIl5mBIElbkwz1fb2qiHce1DcaKby52p4C5MqQK+15s1Mwd
fuhiFK/ZDY0YE8AiOGuJ8htb+qbWf3wpKIZ7wiHrkBrlxgl1vK4KTb1RBIGBbt/f
l7Es9Jdazak1sDdKc9WG936P7LtZQq+1/2OuwId6Z9vtLr4gW57pYvbbiiV40TNG
SEsKVC+lCxPBtcBvRc4wVY6VzWMr3DzLp3EmS9utw01+9sngXa9kK6rVUk7Diw89
QVXrarXT/LN19fauP+I8B/Yq2904j2z6uwY13PvNdfdfZDozoi2DKSS52og8dDWY
k6j5ay4YAxqIhrMmTe/yET2IKiKhXDv6kamUEGarIFFqg3hf84ZphQyv84mtHaCu
p+MhdakWj7rAMgtmeO5Ez+NxP+jZmd3I9Mt4hchSmXDEPCscBT6oVXppIeAQaXOX
i8MmKVR1Uyg88MzsAR1i2T5a//KnYDD+k8hkNtZMkzMLKpL7lUw=
=tMMJ
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
