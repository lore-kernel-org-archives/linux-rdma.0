From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/ipoib: Limit call to free rdma_netdev for
 capable devices
Date: Wed, 28 Jun 2017 10:13:15 +0300
Message-ID: <20170628071315.GZ1248@mtr-leonro.local>
References: <20170614065909.23650-1-leon@kernel.org>
 <20170614065909.23650-3-leon@kernel.org>
 <20170627173407.GA55945@knc-06.sc.intel.com>
 <20170627174156.GA5340@obsidianresearch.com>
 <20170627190838.GA55990@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pwp4JDU+MaGmJm70"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170627190838.GA55990-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pwp4JDU+MaGmJm70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 27, 2017 at 12:08:38PM -0700, Vishwanathapura, Niranjana wrote:
> On Tue, Jun 27, 2017 at 11:41:56AM -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 27, 2017 at 10:34:07AM -0700, Vishwanathapura, Niranjana wrote:
> > > >diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > >index 0ddd9709e1df..91fae34bdd4f 100644
> > > >+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > >@@ -2301,7 +2301,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
> > > >		flush_workqueue(priv->wq);
> > > >
> > > >		unregister_netdev(priv->dev);
> > > >-		free_netdev(priv->dev);
> > > >+		if (device->free_rdma_netdev)
> > > >+			device->free_rdma_netdev(priv->dev);
> > > >+		else
> > > >+			free_netdev(priv->dev);
> > >
> > > This is causing an crash in hfi1 driver.
> > > If the call to alloc_rdma_netdev() has returned -EOPNOTSUPP, we shouldn't be
> > > calling free_rdma_netdev() here (as device driver doesn't own that netdev).
> > > I will send out a patch to hfi1 driver to guard check for the type in its
> > > free_rdma_netdev() call to handle such issues.
> >
> > I think instead you should move free_rdma_netdev from struct ib_device
> > to struct rdma_netdev to prevent this mistake in general.
> >
>
> Thanks, that is another option. With that, we will be freeing the
> rdma_netdev from a function pointer call that belongs to that rdma_netdev.
> Is that ok?  (Though I think it should work fine).

The downside of this that the code will be non-symmetrical, for
alloc_rdma_netdev vs. free_rdma_netdev.

2198         /**
2199          * rdma netdev operations
2200          *
2201          * Driver implementing alloc_rdma_netdev must return -EOPNOTSUPP if it
2202          * doesn't support the specified rdma netdev type.
2203          */
2204         struct net_device *(*alloc_rdma_netdev)(
2205                                         struct ib_device *device,
2206                                         u8 port_num,
2207                                         enum rdma_netdev_t type,
2208                                         const char *name,
2209                                         unsigned char name_assign_type,
2210                                         void (*setup)(struct net_device *));
2211         void (*free_rdma_netdev)(struct net_device *netdev);

>
> Also, I think this needs updating ib_verbs.h, hfi1, ipoib and mlx5 (under
> drivers/net) together. I can make the change, if this is the direction we
> are taking.
>
> Another option is to add a new type RDMA_NETDEV_IPOIB_DEF and use only
> within ipoib driver to differentiate default case.

It is less optimal option, I would prefer to see IPoIB the same for all flows.

Thanks

>
> Thanks,
> Niranjana
>

--pwp4JDU+MaGmJm70
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTVwsACgkQ5GN7iDZy
WKdPExAAtM5ofs8p4qo/pigVmijKeKjdq+esJxSx07UI1CSKm2G/qbT92UyXkoUf
EEjms6fGPOCdXS5FW+M/X1AcXr7AK+2txprWxyHdgX/CuSNyI/pDTdh4jKDKDmI1
8Lap+odtTgzCZuqwKLglKs8q8j6XD2kfpxdBWAVbLnFRFFvYQ0Ev9AzYY5NJ35GS
mvxmWrs39KgJd8l1Xm0fDESh66X4I3r0wlyb9UUdXT0pXF9TMfOF4Ra13utGAqS/
ksyMIdsMiqHJt6ipfrCFhn0iSJFlPJgCPhVSnHCk+Wrt0iHDm79S4aWUL/yUmuGj
0euPjZVd5+Fid/gLKNvgnuK7ehjaFfmCbT1yYlLhKb1nq3O0AzK11w9pOcilKTqW
oYO8s+fvOMwMuzQZBQHv405UHXr9tS6qpNVc7P8Oj5kxtGLwGVuvNaNYPARs+ACb
2UWOBwKIg7Ty6IoYvWPKofdp2Ny4XFQz0T0rZueWGpDltFWpUbhB2AxHarPDPImD
SOOoibtvcstQ+8bHcTn26PGf8FQHFcOiQBMVhdb4LUydTZ4mW3RQEAYJyhuSwQws
CExm4grORVwdyqAKd8IynzjnhNj0b6J95reHenkfVjYoo3iHxQAASCG/OBPzWoR5
SVcdwTxdy0GmdQUBKOnBrexPBVcOTE+zKCO7hha74Z554i561cI=
=t83l
-----END PGP SIGNATURE-----

--pwp4JDU+MaGmJm70--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
