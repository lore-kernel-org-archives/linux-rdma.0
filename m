From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/8] IB/{core,ulp} Support above 32 possible
 device capability flags
Date: Sun, 21 Feb 2016 10:00:53 +0200
Message-ID: <20160221080053.GL30450@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
 <1455954465-15141-6-git-send-email-leon@leon.nu>
 <56C969B5.5080802@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56C969B5.5080802-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 21, 2016 at 09:39:33AM +0200, Haggai Eran wrote:
> On 20/02/2016 09:47, Leon Romanovsky wrote:
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1762,7 +1762,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
> >  
> >  int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
> >  {
> > -	priv->hca_caps = hca->attrs.device_cap_flags;
> > +	priv->hca_caps = (int)hca->attrs.device_cap_flags;
> 
> Won't it be better to increase the size of priv->hca_caps? Someone in the 
> future will probably attempt to check one of the new device caps through
> this field and will be surprised to see it is only partial.

My changes were intended to minimize the impact on the existing code base. The future
developer will be expected to check his code when he adds new device
capability above 32 bit limit. In this change, he will update the ipoib
properly expose it.

Current implementation doesn't change ipoib behavior and easy for
review without extra knowledge of ipoib internals, so let's stay this
change as is.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
