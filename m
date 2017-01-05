From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/ipoib: Remove unnecessary returned value check
Date: Thu, 5 Jan 2017 08:05:28 +0200
Message-ID: <20170105060527.GA5285@yuval-lap>
References: <1483522018-4669-1-git-send-email-yanjun.zhu@oracle.com>
 <586DB06C.5020600@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <586DB06C.5020600-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Zhu Yanjun,
Patch looks fine.

However, the way it is posted makes it hard (maybe impossible) to apply.
Suggesting to repost using git send-email.

Yuval

On Thu, Jan 05, 2017 at 10:33:16AM +0800, Yanjun Zhu wrote:
> Hi, Yuval Shaia && Leon Romanovsky && Maintainers
> 
> Follow your advice, a new patch is made. Please check it.
> 
> Thanks a lot.
> Zhu Yanjun
> 
> On 2017/1/4 17:26, Zhu Yanjun wrote:
> >In the function ipoib_set_dev_features, the returned value is always 0.
> >As such, it is not necessary to check the returned value.
> >This is not a bug. It is a trivial problem.
> >
> >Reviewed-by: Guanglei Li <guanglei.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >---
> >Change from v1 to v2:
> >  make change to __ipoib_vlan_add.
> >  change the commit header.
> >
> >  drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++------
> >  drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 4 +---
> >  3 files changed, 4 insertions(+), 10 deletions(-)
> >
> >diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> >index da12717..f568064 100644
> >--- a/drivers/infiniband/ulp/ipoib/ipoib.h
> >+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> >@@ -593,7 +593,7 @@ void ipoib_pkey_open(struct ipoib_dev_priv *priv);
> >  void ipoib_drain_cq(struct net_device *dev);
> >  void ipoib_set_ethtool_ops(struct net_device *dev);
> >-int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
> >+void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
> >  #define IPOIB_FLAGS_RC		0x80
> >  #define IPOIB_FLAGS_UC		0x40
> >diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> >index 3ce0765..4e8e11e 100644
> >--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> >+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> >@@ -1984,7 +1984,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> >  	return device_create_file(&dev->dev, &dev_attr_pkey);
> >  }
> >-int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >+void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >  {
> >  	priv->hca_caps = hca->attrs.device_cap_flags;
> >@@ -1996,8 +1996,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >  		priv->dev->features |= priv->dev->hw_features;
> >  	}
> >-
> >-	return 0;
> >  }
> >  static struct net_device *ipoib_add_port(const char *format,
> >@@ -2037,9 +2035,7 @@ static struct net_device *ipoib_add_port(const char *format,
> >  		goto device_init_failed;
> >  	}
> >-	result = ipoib_set_dev_features(priv, hca);
> >-	if (result)
> >-		goto device_init_failed;
> >+	ipoib_set_dev_features(priv, hca);
> >  	/*
> >  	 * Set the full membership bit, so that we join the right
> >diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> >index a2f9f29..0c2988d 100644
> >--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> >+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> >@@ -61,9 +61,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
> >  	priv->parent = ppriv->dev;
> >  	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
> >-	result = ipoib_set_dev_features(priv, ppriv->ca);
> >-	if (result)
> >-		goto err;
> >+	ipoib_set_dev_features(priv, ppriv->ca);
> >  	priv->pkey = pkey;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
