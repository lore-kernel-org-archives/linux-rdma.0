From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 13/33] RDMA/core: Add iterator over ib_devices
Date: Thu, 10 Aug 2017 13:26:20 +0300
Message-ID: <20170810102620.GS1423@mtr-leonro.local>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-14-leon@kernel.org>
 <9ae5be78-67ef-5803-9737-f913dc874861@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dT+85zccSFkyJC53"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ae5be78-67ef-5803-9737-f913dc874861-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--dT+85zccSFkyJC53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 01:09:00PM -0400, Doug Ledford wrote:
> On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The coming nldev needs to iterate over all IB devices in the system
> > and in order to not expose the ib_devices list outside the devices.c,
> > it is necessary to provide function iterator.
> >
> > Current version is written explicitly for nldev callback to avoid
> > over-engineering at this stage, but it can be easily extended for
> > other types.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/core/core_priv.h |  8 ++++++++
> >  drivers/infiniband/core/device.c    | 25 +++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> > index e759c27113cd..0c175590cf92 100644
> > --- a/drivers/infiniband/core/core_priv.h
> > +++ b/drivers/infiniband/core/core_priv.h
> > @@ -102,6 +102,14 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
> >  			      roce_netdev_callback cb,
> >  			      void *cookie);
> >
> > +typedef int (*nldev_callback)(struct ib_device *device,
> > +			      struct sk_buff *skb,
> > +			      struct netlink_callback *cb,
> > +			      unsigned int idx);
> > +
> > +int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
> > +		     struct netlink_callback *cb);
> > +
> >  enum ib_cache_gid_default_mode {
> >  	IB_CACHE_GID_DEFAULT_MODE_SET,
> >  	IB_CACHE_GID_DEFAULT_MODE_DELETE
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index a1d5798fa4d7..54143476a020 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -892,6 +892,31 @@ void ib_enum_all_roce_netdevs(roce_netdev_filter filter,
> >  	up_read(&lists_rwsem);
> >  }
> >
> > +/**
> > + * ib_enum_all_devs - enumerate all ib_devices
> > + * @cb: Callback to call for each found ib_device
> > + *
> > + * Enumerates all ib_devices and calls callback() on each device.
> > + */
> > +int ib_enum_all_devs(nldev_callback nldev_cb, struct sk_buff *skb,
> > +		     struct netlink_callback *cb)
> > +{
> > +	struct ib_device *dev;
> > +	unsigned int idx = 0;
> > +	int ret = 0;
> > +
> > +	down_read(&lists_rwsem);
> > +	list_for_each_entry(dev, &device_list, core_list) {
> > +		ret = nldev_cb(dev, skb, cb, idx);
>
> This clearly enumerates more than just ib devs, should the signature not
> be rdma_enum_all_devs?

It enumerates "struct ib_device"s, so I prefer to leave it as is for now.

>
> > +		if (ret)
> > +			break;
> > +		idx++;
> > +	}
> > +
> > +	up_read(&lists_rwsem);
> > +	return ret;
> > +}
> > +
> >  /**
> >   * ib_query_pkey - Get P_Key table entry
> >   * @device:Device to query
> >
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--dT+85zccSFkyJC53
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmMNMwACgkQ5GN7iDZy
WKdUvhAAkMyT9KJG17aKKYyonTpPLYg+2AjInodvIE1TH0UyB2sYG/QDJwlRI5fA
DffwUvy/+Lz594oFH72DkbR5chYVDybnKxh7BurGd57Y12/x9TCjOH+XOSAPPbD5
66PJWqjzGKcWzCVIjZyDdxI3qA0i1LlQS8pqqz27kfXOxICfOe9/sV+ikFvyx5kZ
oc6B/+le/NXU5vVHlLFdyMkBMI2yFCfbzQ7PVXrllzG0b86IzoadL7DB9s85eM8E
Y9MUT3A0zP8d8X7J4O+QtXCGdiJrvA43ncL4z8raT4UnwkFa7iUW27kFf2Vmd5oR
+R72k4WbQi/NurDQU7TQ7Jho/UMFS4MKU626p1a4vDv55BxYCE2qVQFnHn+/P5nk
4RuFEljqZ9HhV+6QcLmiTtsGsrXaifjqzL/uR8iyqOh72+KypXQKVnp9ijpn9B3G
fnjKhAS3UGOoswRMIdcZrEURlw7XsbOf5qW3f+94LWqYllD6d2zus/6czt1SCQQc
CYHk47aK7DQVtEvbYtpRQeeUm9QglSftDSj5NOQGNn9wj9PToJfuORqE9092X2ij
q/kB6fW498mRki5Ob0NE2BsYov9b//yx/utei+OLRu2RSbqTuWTffzmsIUpDgiY7
xKAxCMMfw9+0VgbaCawo6lYvNKSwAmJ6J2uXUo87b4XBDkeU1JU=
=9IhQ
-----END PGP SIGNATURE-----

--dT+85zccSFkyJC53--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
