From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: Remove unnecessary returned value check
Date: Thu, 5 Jan 2017 08:12:36 +0200
Message-ID: <20170105061236.GV12077@mtr-leonro.local>
References: <1483522018-4669-1-git-send-email-yanjun.zhu@oracle.com>
 <586DB06C.5020600@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e8/wErwm0bqugfcz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <586DB06C.5020600-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--e8/wErwm0bqugfcz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2017 at 10:33:16AM +0800, Yanjun Zhu wrote:
> Hi, Yuval Shaia && Leon Romanovsky && Maintainers
>
> Follow your advice, a new patch is made. Please check it.

How are you sending it? I missed this patch and first version too.
Are you sending it with git send-email?

Was your patch catched in patchworks [1]? and linux-rdma mailing list?

Please post it properly, so we will be able to review it and Doug will
be able to apply it.

[1] https://patchwork.kernel.org/project/linux-rdma/list/

Thanks

>
> Thanks a lot.
> Zhu Yanjun
>
> On 2017/1/4 17:26, Zhu Yanjun wrote:
> > In the function ipoib_set_dev_features, the returned value is always 0.
> > As such, it is not necessary to check the returned value.
> > This is not a bug. It is a trivial problem.
> >
> > Reviewed-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > Change from v1 to v2:
> >   make change to __ipoib_vlan_add.
> >   change the commit header.
> >
> >   drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
> >   drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++------
> >   drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 4 +---
> >   3 files changed, 4 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> > index da12717..f568064 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> > @@ -593,7 +593,7 @@ void ipoib_pkey_open(struct ipoib_dev_priv *priv);
> >   void ipoib_drain_cq(struct net_device *dev);
> >   void ipoib_set_ethtool_ops(struct net_device *dev);
> > -int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
> > +void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
> >   #define IPOIB_FLAGS_RC		0x80
> >   #define IPOIB_FLAGS_UC		0x40
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index 3ce0765..4e8e11e 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1984,7 +1984,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> >   	return device_create_file(&dev->dev, &dev_attr_pkey);
> >   }
> > -int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> > +void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >   {
> >   	priv->hca_caps = hca->attrs.device_cap_flags;
> > @@ -1996,8 +1996,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >   		priv->dev->features |= priv->dev->hw_features;
> >   	}
> > -
> > -	return 0;
> >   }
> >   static struct net_device *ipoib_add_port(const char *format,
> > @@ -2037,9 +2035,7 @@ static struct net_device *ipoib_add_port(const char *format,
> >   		goto device_init_failed;
> >   	}
> > -	result = ipoib_set_dev_features(priv, hca);
> > -	if (result)
> > -		goto device_init_failed;
> > +	ipoib_set_dev_features(priv, hca);
> >   	/*
> >   	 * Set the full membership bit, so that we join the right
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > index a2f9f29..0c2988d 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > @@ -61,9 +61,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
> >   	priv->parent = ppriv->dev;
> >   	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
> > -	result = ipoib_set_dev_features(priv, ppriv->ca);
> > -	if (result)
> > -		goto err;
> > +	ipoib_set_dev_features(priv, ppriv->ca);
> >   	priv->pkey = pkey;
>

--e8/wErwm0bqugfcz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlht49QACgkQ5GN7iDZy
WKdtiQ//TdJMt8ujhU1EVfAmYS6RYYkFFm2HDwGlinVTV1JFkvCqFL62AMGlQSHI
xghgojqYV3/dWXLkGTnULNak5dhB479S8TAKRTgl7KOpFHCqCLxcNg6W0MwMDbNg
XPaFPkddGs9l2534W2JZ8pKfn9IRtHrrjn2b7/6Dd94SarbNlPn69NS4zRSxKhpD
jWlvvJKoV83EcKDAUKy2J7nC423IOY+wnr8wCCDmOS8J2vdC9uXxZgHZZOjbxbMW
quchgRlHJ0ihL4K+EYKAl4TFuI9ruhpL4BnMLxk368KIJGmH9tNrn0TIpwwFMOkX
KjJKJgTPG+nAlBTQZ41iFgBe8lB+g0pB+qjCllfIICya9Fx7FE2sQcFSNRYkvpcM
BKWCq/H9YgyorjMXf6FCcKkdVgXSD4O2V+2s7mq3SKBMOi67A+Op1U5RG3yfG+aE
C4dwpcoU3Lyxgbbj+robHySEzNIU8Sfs723IcpnknoTcaNgCCADa7uIl4KalaDQM
W3+zSGnMj2SmmskJCQR4jSnu8FDo/cjPUMQ6I1Ltq8hBQVOr/Y/GhNK252muoRtr
wHecaG5+71SF4zL5e9G6k4tALRfB9m5i9Q5ZpVTTsAlIYIlax9n6mdUDIbeBd+YU
2BJQKrTYYAaGwXEP3QsTmq8B2EMazhwohf/sq8/LyQU+xPU3hF4=
=mTIL
-----END PGP SIGNATURE-----

--e8/wErwm0bqugfcz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
