From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] ipoib: remove unnecessary returned value check
Date: Tue, 3 Jan 2017 08:46:56 +0200
Message-ID: <20170103064655.GA6001@yuval-lap.uk.oracle.com>
References: <1482151756-8802-1-git-send-email-yanjun.zhu@oracle.com>
 <586B0DB8.3060301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <586B0DB8.3060301-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, emilbart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 03, 2017 at 10:34:32AM +0800, Yanjun Zhu wrote:
> Any comment ?

You will have to make change also to __ipoib_vlan_add

> 
> 
> On 2016/12/19 20:49, Zhu Yanjun wrote:
> >In the function ipoib_set_dev_features, the returned value is always 0.
> >As such, it is not necessary to check the returned value.
> >This is not a bug. When I read the source code, I think it is not
> >necessary to check it.

Please rephrase - omit the words "I think".

> >
> >Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >---
> >  drivers/infiniband/ulp/ipoib/ipoib.h      | 2 +-
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++------
> >  2 files changed, 3 insertions(+), 7 deletions(-)
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
