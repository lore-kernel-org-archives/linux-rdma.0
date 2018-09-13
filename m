From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Thu, 13 Sep 2018 11:45:57 -0400
Message-ID: <4dbef82e363766ab81cd7371df1e1f3b1e0a6af5.camel@redhat.com>
References: <20180906145112.29245-1-ar@cs.msu.ru>
         <20180906145112.29245-4-ar@cs.msu.ru> <20180907154359.GA14627@ziepe.ca>
         <20180909181146.GA29632@cello.Dlink> <20180909205512.GA5918@cello.Dlink>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZmWOHySb6uUXy/iMU7W7"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180909205512.GA5918@cello.Dlink>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-ZmWOHySb6uUXy/iMU7W7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-09-09 at 23:55 +0300, Arseny Maslennikov wrote:
> On Sun, Sep 09, 2018 at 09:11:46PM +0300, Arseny Maslennikov wrote:
> > On Fri, Sep 07, 2018 at 09:43:59AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Sep 06, 2018 at 05:51:12PM +0300, Arseny Maslennikov wrote:
> > > > Some tools may currently be using only the deprecated attribute;
> > > > let's print an elaborate and clear deprecation notice to kmsg.
> > > >=20
> > > > To do that, we have to replace the whole sysfs file, since we inher=
it
> > > > the original one from netdev.
> > > >=20
> > > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 31 +++++++++++++++++++=
++++
> > > >  1 file changed, 31 insertions(+)
> > > >=20
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/in=
finiband/ulp/ipoib/ipoib_main.c
> > > > index 30f840f874b3..74732726ec6f 100644
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > @@ -2386,6 +2386,35 @@ int ipoib_add_pkey_attr(struct net_device *d=
ev)
> > > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > > >  }
> > > > =20
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
> > > > +
> > > > +	if (ndev->dev_id =3D=3D ndev->dev_port)
> > > > +		netdev_info_once(ndev,
> > > > +			"\"%s\" wants to know my dev_id. Should it look at dev_port ins=
tead? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
> > > > +			current->comm);
> > > > +
> > > > +	return sprintf(buf, "%#x\n", ndev->dev_id);
> > > > +}
> > > > +static DEVICE_ATTR_RO(dev_id);
> > > > +
> > > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > > +{
> > > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > > > +}
> > >=20
> > > Isn't this racey with userspace? Ie what happens if udev is querying
> > > the dev_id right here?
> >=20
> > udev in particular does not use dev_id at all since 2014, because "why
> > would we keep using dev_id if it is not the right thing to use?".
> >=20
> > >=20
> > > Do we know there is no userspace doing this?
> > >=20
> >=20
> > Not for sure.
> >=20
> > If we move all the sysfs handling stuff we introduce in _add_port():
> >  - pkey
> >  - umcast
> >  - {create,delete}_child
> >  - connected/datagram mode
> > to _ndo_init(), which is called by register_netdev before it sends
> > the netlink message, would that suffice to eliminate the race?
> > (Sysfs files for {create,delete}_child go to _parent_init() then).
> >=20
>=20
> No, we can't, sorry for the noise. ndo_init() runs before the kobject
> becomes available.
>=20
> Anyway, our sysfs attributes being racy is unrelated to the patch series
> subject, and I can't come up with any other ideas what to do with them
> that do not involve adjustments to register_netdev.

Agreed (that fixing the race issues is a different patch series).

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-ZmWOHySb6uUXy/iMU7W7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluahjUACgkQuCajMw5X
L93kRg/+Pfx5vh8m4vPdkyFYVSSKV2Ejz1iSuodhKneFUlE61weDXprAjr9kcBcQ
zWsMWuq7uqQxVMV2q+D1018VAotxXDK94NDh4TfnBpq2SqFf5IznOobRrn0aec/F
/GrtRB3hbHjhYnK2TDKEO031RlU0+0eBpm+UIMKfoXbnDODetmUS+4bhejsvytvt
Nggcc1PurOo5NkMUYLBvMfoxuqYT21QwR/Xn/T40dQBuVyA3a8WAvV5ywD/yuhcY
Y44+I6Cd3JsfOUoTwkCY8c4zGJUpuq/zSK4FQZEzG3lI6Aztfn1yYXttagzkX9cK
fw7U0aw1mXTcpvN5+DabHh8BTIXW8lgRUSkZJ/+r5CN8ALqTsYikj9ihe0ufi7r9
elDdwuD184UPuPPRJC6NNEZZvUt4yfsUklU0yPktTlcTjjwOkg0k/u3N5SsWrUGt
qwKB3qcFCYYB376CeIy5c1RD22dEaTrRWsio69LeWEy+QefgQH2E6HjIspyRUB8+
uBkTqJESSdLXLcSwfYP4UzvWX4b8zIte+vkntVboWwHW/tUCjqf/W465Hxl4UlaM
P7dmWLVvst71cguvua7ADUPXZgo+9F1/+82FJlhXorLtZEyU+71lIcnwxczWvISY
7QzpryYNfggOajtvDHtt6xRenS99RZmsW1lchIvSv9ZAAa2LXnk=
=b3y0
-----END PGP SIGNATURE-----

--=-ZmWOHySb6uUXy/iMU7W7--
