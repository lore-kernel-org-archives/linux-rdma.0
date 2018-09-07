From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Fri, 07 Sep 2018 16:02:17 -0400
Message-ID: <98743a2d9e724d2728a52cfd702b6ad196e6f81f.camel@redhat.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
         <20180903161316.25121-4-ar@cs.msu.ru>
         <20180905135035.GT2977@mtr-leonro.mtl.com> <20180906070433.GA13034@cello>
         <20180906130358.GJ3142@mtr-leonro.mtl.com>
         <adc47601cbf388f7909bc01dd3b122d6558cc74e.camel@redhat.com>
         <20180907172821.GS3142@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zPprLVMmKqMozHoPIKdr"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180907172821.GS3142@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Arseny Maslennikov <ar@cs.msu.ru>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-zPprLVMmKqMozHoPIKdr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-09-07 at 20:28 +0300, Leon Romanovsky wrote:
> On Fri, Sep 07, 2018 at 01:14:37PM -0400, Doug Ledford wrote:
> > On Thu, 2018-09-06 at 16:03 +0300, Leon Romanovsky wrote:
> > > On Thu, Sep 06, 2018 at 10:04:33AM +0300, Arseny Maslennikov wrote:
> > > > On Wed, Sep 05, 2018 at 04:50:35PM +0300, Leon Romanovsky wrote:
> > > > > On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrot=
e:
> > > > > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > > > > ---
> > > > > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++=
++++++++
> > > > > >  1 file changed, 38 insertions(+)
> > > > > >=20
> > > > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/driver=
s/infiniband/ulp/ipoib/ipoib_main.c
> > > > > > index 30f840f874b3..7386e5bde3d3 100644
> > > > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > > > @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_devic=
e *dev)
> > > > > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > > > > >  }
> > > > > >=20
> > > > > > +/*
> > > > > > + * We erroneously exposed the iface's port number in the dev_i=
d
> > > > > > + * sysfs field long after dev_port was introduced for that pur=
pose[1],
> > > > > > + * and we need to stop everyone from relying on that.
> > > > > > + * Let's overload the shower routine for the dev_id file here
> > > > > > + * to gently bring the issue up.
> > > > > > + *
> > > > > > + * [1] https://www.spinics.net/lists/netdev/msg272123.html
> > > > > > + */
> > > > > > +static ssize_t dev_id_show(struct device *dev,
> > > > > > +			   struct device_attribute *attr, char *buf)
> > > > > > +{
> > > > > > +	struct net_device *ndev =3D to_net_dev(dev);
> > > > > > +	ssize_t ret =3D -EINVAL;
> > > > > > +
> > > > > > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > > > > > +		netdev_info_once(ndev,
> > > > > > +			"\"%s\" wants to know my dev_id. "
> > > > > > +			"Should it look at dev_port instead?\n",
> > > > > > +			current->comm);
> > > > > > +		netdev_info_once(ndev,
> > > > > > +			"See Documentation/ABI/testing/sysfs-class-net for more inf=
o.\n");
> > > > > > +	}
> > > > > > +
> > > > > > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > > > > > +
> > > > > > +	return ret;
> > > > > > +}
> > > > > > +static DEVICE_ATTR_RO(dev_id);
> > > > > > +
> > > > >=20
> > > > > I don't see this field among exposed by IPoIB, why should we expo=
se it now?
> > > > >=20
> > > >=20
> > > > To deviate from standard netdev behaviour, which only prints the
> > > > field out. Doug wanted this to also print a deprecation message, an=
d
> > > > netdev (obviously) does not do that. See below.
> > > >=20
> > > > > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > > > > +{
> > > > > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > > > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> > > > >=20
> > > > > Why isn't enough to rely on netdev code?
> > > > >=20
> > > >=20
> > > > Netdev code relies on macros around a *static* function 'netdev_sho=
w',
> > > > which is defined in net/core/net-sysfs.c; it is not listed in any h=
eader
> > > > files, and the macros aren't as well. This all leads me to believe =
it
> > > > was not really meant to be used from outside net/core/net-sysfs.
> > > >=20
> > > > The only way we could use any netdev code here is to set up our own
> > > > handler (again), printk() a message, then call netdev_show =E2=80=
=94 but we have
> > > > no access to it.
> > > >=20
> > > > Of course, it also may be that I'm terribly missing a clue.
> > >=20
> > > Thanks,
> > >=20
> > > IMHO, the end result of adequate Doug's request is a little bit too m=
uch.
> > > I don't think that it justifies such remove->create construction.
> > >=20
> > > Personal opinion.
> >=20
> > I agree with you that the end result is kinda bulky, *but*, we will nee=
d
> > to know if there are things using the old dev_id before we can remove
> > it.  In particular, I'm concerned the IPoIB handling code of
> > NetworkManager uses it.  It's worth the cost I think.
>=20
> I did my checks now and saw that ibdev2netdev uses the value provided
> from this dev_id, so every invocation of that script will generate the
> warning.
>=20
> See this line in Parav's repo
> https://github.com/Mellanox/container_scripts/blob/master/ibdev2netdev#L1=
12

I'm pretty sure libvirt + qemu will trigger it too.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-zPprLVMmKqMozHoPIKdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAluS2UkACgkQuCajMw5X
L91/5Q//VZG4+Da2obmwvSpLIyOnG1VvF6YisKTvhC0BrK7RpY4PtECXTGu98DL8
j8HnNZkd8G7TaA5zaqHgIPDk4NkN4gda8qsozp75CNl9XV8rbRNwdZwAKqdFv0Fe
2AHtGL8MSW/S5hoedwM/1I8XQNIZ/LhDSZ8XAOpF7rqS2Lh1zkO/nxFMeTTnjPak
t5pIlmTdKqu8erJ16iv1lxUqeM1RTRENl93aqySvy+PKadfKYOSKV/2ln/vR2U/7
KdA5vSbD3uB6WD3kA8IWw0hJf84FfQ43ukB7u8yFiTG5sQwpEY7yoDPGilQNUb3l
mLM5OKPc8d634dVbVy1rBYjPQSmioLL2S9Sq9+OUVUlaQlzau6ua6SwV1b3AGc8L
0H/u/+OycVQ7SB91+1nz+/Cex4x7GOyN89CvgnQewokqg6/8h000PiQOcRUJQBK/
6j4ldhzCpsR2GKn5WqDjfme9bM8b6WuMdydmI78QfPWxfdVZC+jg+xoYN99i7lpb
CdQB8Rd89NpBkcFifpKTc57yZhLHir9Rd282G/rRmFAd3Zw5cDu+o6mNUyTG7OBP
jKv8Prgk5Uu3hvMXeIp9555y/yD5sDviStvxIkKtoM8FDdib/k7hfNhLc/l6cUht
xj3tIeU8VLqXjf3eQUIMR7Wn39dPy9lsbEW7yWIXdDEx1oiWo/I=
=4w1X
-----END PGP SIGNATURE-----

--=-zPprLVMmKqMozHoPIKdr--
