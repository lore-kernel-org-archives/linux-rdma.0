From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH net 2/2] IB/ipoib: Fix netlink support in IPoIB
Date: Mon, 1 Jan 2018 08:38:33 +0200
Message-ID: <20180101063833.GY3494@mtr-leonro.local>
References: <1514718983-466-1-git-send-email-denisd@mellanox.com>
 <1514718983-466-3-git-send-email-denisd@mellanox.com>
 <20171231202308.GA10145@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y5wfsVCgeKAcINk2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171231202308.GA10145-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Y5wfsVCgeKAcINk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 31, 2017 at 01:23:08PM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 31, 2017 at 01:16:23PM +0200, Denis Drozdov wrote:
> > IPoIB netlink support was broken by commit cd565b4b51e5
> > ("IB/IPoIB: Support acceleration options callbacks"),
> > that added flow which allocates netdev rdma structures
> > after netlink object is already created. Such situation leads
> > to crash in __ipoib_device_add, once trying to reuse netlink
> > device.
> > This commit restores the netlink support.
> >
> > Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
> > Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/ulp/ipoib/ipoib.h         |  2 ++
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c    | 23 +++++++++--------
> >  drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 38 +++++++++++++++++++++++++---
> >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 20 ++++-----------
> >  4 files changed, 54 insertions(+), 29 deletions(-)
>
> I assume this is going through DaveM's tree?

Yes, it was our plan because of the first patch in this series.

> In which case for the drivers/infiniband part:
>
> Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> > @@ -131,11 +157,15 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
> >  	 */
> >  	child_pkey |= 0x8000;
> >
> > -	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev),
> > -			       child_pkey, IPOIB_RTNL_CHILD);
> > +	down_write(&ppriv->vlan_rwsem);
> > +
> > +	priv = ipoib_priv(dev);
> > +	err = __ipoib_vlan_add(ppriv, priv, child_pkey, IPOIB_RTNL_CHILD);
> > +	up_write(&ppriv->vlan_rwsem);
>
> This looks like a necessary and correct change, but does it need to be
> a seperate bug fix commit?

It can.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Y5wfsVCgeKAcINk2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpJ12kACgkQ5GN7iDZy
WKcDQRAAuWjoXTQ9HwX7YJk4Vz9P55rbEAlsis6sM7CoTko/CJ8JU2ERrx4LcgMd
JPirHkD5ohGTAJDuIc1ZBzyv5eFblNYq/FobR/bvOGo3YjAEoDWkjq/tmmYeXGPn
uLnGS6on7r7Ddy3ijy4PBcYuhM77WHefMnNTBZdvzfKLgQNSYZfrVjuWvrjCyLQi
0G+T/Viicn/IW/Xb/FlcE4Ex0Qb4rBluHMulTjW9KebRqrmV4dAanukwPSj2/zyh
G9MZ+B71ScUPnGd1+KRyfFW9BCxGI1wtlwKzUg64IMb0aV5OtL5eQZfPXOUrARdM
Y8FiaZOvXTERdbf6CkWEMbLu0Z7tx2POrcKkljzyoGOA0Fva9eohOuJMQonFud+g
afSuUM7bNI8Nhw8Q86TI8tMESqN29SYGHNMi216TYwsWVNtOKSLJ//Fa4JSpFB4c
37mpGFQn3w/kf0Xri926ZJVWCf87I7PPGb8dsX2rrpx/PSY4XGeIoQNp6jTf88dE
JoRcZmBXYsrVl8WHxda+XSWupDFJCZgP91cE7MAyZ7wIMFvDeBhQ5oGkC+3pbdBc
OuiUqIpiAAnPxMfngZmJ2u16t9A3axKA+iD8tnMuBpUHZBZs0f2fYEoUyGyJabvy
d+FCbV68p1uioHBVYMcYeKLTS1ZArprkEXZnYKbVhFs3vH7IFz8=
=PbRv
-----END PGP SIGNATURE-----

--Y5wfsVCgeKAcINk2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
