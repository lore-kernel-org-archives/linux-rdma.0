From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] ib/ipoib: allow disabling/enabling TSO through
 ethtool
Date: Thu, 4 Mar 2010 15:40:18 +0200
Message-ID: <20100304134018.GA17107@mtldesk030.lab.mtl.com>
References: <Pine.LNX.4.64.1003041516300.2755@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003041516300.2755-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 04, 2010 at 03:16:52PM +0200, Or Gerlitz wrote:
> 
> +static int ipoib_set_tso(struct net_device *dev, u32 data)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +
> +	if (data) {
> +		if (!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> +			(dev->features & NETIF_F_SG) &&
> +				(priv->hca_caps & IB_DEVICE_UD_TSO))
> +			dev->features |= NETIF_F_TSO;
> +		else {
> +			ipoib_warn(priv, "can't set TSO on\n");
> +			return -EOPNOTSUPP;
> +		}
> +	} else
> +		dev->features &= ~NETIF_F_TSO;
> +	return 0;
> +}
> +

I believe dev->features should be protected by rtnl lock.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
