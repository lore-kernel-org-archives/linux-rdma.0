From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Fri, 07 Sep 2018 13:14:51 -0400
Message-ID: <2615124df732cc4d8926a708eaf11a47cbac4b3a.camel@redhat.com>
References: <20180906145112.29245-1-ar@cs.msu.ru>
         <20180906145112.29245-4-ar@cs.msu.ru> <20180907154359.GA14627@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QTT2J/wVdUZl5T0ar9ap"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180907154359.GA14627@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-QTT2J/wVdUZl5T0ar9ap
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-09-07 at 09:43 -0600, Jason Gunthorpe wrote:
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
>=20
> Do we know there is no userspace doing this?

I don't think that it can race (or reasonably can).  The intercept
function is done as part of ipoib_add_port() so the port itself isn't
live yet.  Things like udev shouldn't be scanning it until after we've
finished bringing it up and added it to the system, so any race here is
unimportant IMO.

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
> Jason

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-QTT2J/wVdUZl5T0ar9ap
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluSsgsACgkQuCajMw5X
L90/KQ/7Bam3chnmX9BK2/assxEIbz8LiggfplhA/9Z5EdK9B6isLm4uqUquUpC3
Om4zwfhqywAG9ejE47YoT3A9IpjlGicvdvso7ArGXDr8CLG6zW8WD6a1NembGB7Z
lgyJ/Gyx+iX6gnV74HAifa17hiYMq7jeon/ArwoKsfGfU46hoCIBeJ1ohtYQAcVK
WlDF+fschyIDf1AN/lBBvbgiimg8OeVdievwFj53e4S7Z0TNcVONVEYw+44Euo+t
uA9EQ/6jIaEdSKSmAIMIeozydr8o7a9cUidA5KZBt9lmL3Nt+F5ueV0ZmarVZolr
U3lt5QCb+0JDsfsphjlGzQ3aLjhp8XqhR3A0XDuc068Fm2BkCUaoxourUbaSbEnG
/2LFkjQ1Ki5ZWjxycAKvl9kKBLgNGQiVZzIGhJ1V8qLMrSdAltGpLxChffS+quXx
gwUTwEkCL1pigRS5MHCKEK0grISuVwWX+WiGkFhnwNFtB0rzXRVi2bI3xU0gAsuY
4zeuDlDnvObagHk7jW5e4a9dMHzqG6eM910NSHggg5+VR36eYZi12aYRxhxB6TN+
RQqfU6wcCKGsHm63N2iSt/JxTCUAGPxYCyAODXyXK13V5hvSDLl3EwAffymx0WYC
wUnadOm6Zh1l7LcC+ppz8DLjskxswecAJKFzICBoB0zvNoAiAJA=
=Y1uh
-----END PGP SIGNATURE-----

--=-QTT2J/wVdUZl5T0ar9ap--
