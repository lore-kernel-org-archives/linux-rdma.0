From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Thu, 6 Sep 2018 16:03:58 +0300
Message-ID: <20180906130358.GJ3142@mtr-leonro.mtl.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
 <20180905135035.GT2977@mtr-leonro.mtl.com>
 <20180906070433.GA13034@cello>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906070433.GA13034@cello>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2018 at 10:04:33AM +0300, Arseny Maslennikov wrote:
> On Wed, Sep 05, 2018 at 04:50:35PM +0300, Leon Romanovsky wrote:
> > On Mon, Sep 03, 2018 at 07:13:16PM +0300, Arseny Maslennikov wrote:
> > > Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> > > ---
> > >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++++++=
++
> > >  1 file changed, 38 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infi=
niband/ulp/ipoib/ipoib_main.c
> > > index 30f840f874b3..7386e5bde3d3 100644
> > > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > @@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> > >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> > >  }
> > >
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
> > > +	ssize_t ret =3D -EINVAL;
> > > +
> > > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > > +		netdev_info_once(ndev,
> > > +			"\"%s\" wants to know my dev_id. "
> > > +			"Should it look at dev_port instead?\n",
> > > +			current->comm);
> > > +		netdev_info_once(ndev,
> > > +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> > > +	}
> > > +
> > > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > > +
> > > +	return ret;
> > > +}
> > > +static DEVICE_ATTR_RO(dev_id);
> > > +
> >
> > I don't see this field among exposed by IPoIB, why should we expose it =
now?
> >
>
> To deviate from standard netdev behaviour, which only prints the
> field out. Doug wanted this to also print a deprecation message, and
> netdev (obviously) does not do that. See below.
>
> > > +int ipoib_intercept_dev_id_attr(struct net_device *dev)
> > > +{
> > > +	device_remove_file(&dev->dev, &dev_attr_dev_id);
> > > +	return device_create_file(&dev->dev, &dev_attr_dev_id);
> >
> > Why isn't enough to rely on netdev code?
> >
>
> Netdev code relies on macros around a *static* function 'netdev_show',
> which is defined in net/core/net-sysfs.c; it is not listed in any header
> files, and the macros aren't as well. This all leads me to believe it
> was not really meant to be used from outside net/core/net-sysfs.
>
> The only way we could use any netdev code here is to set up our own
> handler (again), printk() a message, then call netdev_show =E2=80=94 but =
we have
> no access to it.
>
> Of course, it also may be that I'm terribly missing a clue.

Thanks,

IMHO, the end result of adequate Doug's request is a little bit too much.
I don't think that it justifies such remove->create construction.

Personal opinion.

>
> > > +}
> > > +
> > >  static struct net_device *ipoib_add_port(const char *format,
> > >  					 struct ib_device *hca, u8 port)
> > >  {
> > > @@ -2427,6 +2463,8 @@ static struct net_device *ipoib_add_port(const =
char *format,
> > >  	 */
> > >  	ndev->priv_destructor =3D ipoib_intf_free;
> > >
> > > +	if (ipoib_intercept_dev_id_attr(ndev))
> > > +		goto sysfs_failed;
> > >  	if (ipoib_cm_add_mode_attr(ndev))
> > >  		goto sysfs_failed;
> > >  	if (ipoib_add_pkey_attr(ndev))
> > > --
> > > 2.19.0.rc1
> > >
>
>



--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkSW+AAoJEORje4g2clinOM0P/jW2EUmWZmH5AOJhZDUJ2LNg
MYE7BXv5DluFMLnW4j5g4ehkc89pVOsW8LiX8HQ6Idg/u1BZ1ritc1pc8kAsQ3ua
HKcv/6Da74hP9vgwEVtKE5DRff2vUEGS3eSOfKvQjBIlBuJNiASUt9RvKy9pke/N
me4OjJo135uV2sQ2YZyZD8OKKyemhnP3aiLMJ19w20xabmT1T2Zp2LqQm+u5/xKV
zb9RRV3SzX1Yqpcu47mnNlKAxSl/TUzdnzfyXoxJp0PBncf/LULoGbae6tUDkaeG
BVkqa5Rje5P76XgMdhT4G+DAfxnKYP5ZujXD9dtFEZe6665R850WUZLDktLJUrL7
VSfARpo9LPOVpAun9vzjR/sO5F34TfiQSvLq0NtiwrRFa69SXEb3R0ZAxwzcCkTZ
N9zghEiCNWGupogFj2U1NkAWon7NmoUeC/SjqqeBP9fvLYBoPY/a5Vfin8+AwNSd
hEZo00LifPQm28UIyRzapl+c3MrMLX+atX6Jp0lz9FD8ih7HPpApJpjToOuru13o
INwmB8LUTx62GEhRDtcU7q4m+GPQvVoihpWgph52RCZP1D+jhe2BbCS9BfYq9Up+
jbUVQHxBDksY3T1Jy5N0sUAseWRFwOEPYzVPG7fgB/QDleuiyFH8rEneXmVEIsWW
T0rRUHh65Uk4zt1lNA+E
=HYCE
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
