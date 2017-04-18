From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 5/9] IB/IPoIB: Combine substrings for three messages
Date: Tue, 18 Apr 2017 14:33:41 +0300
Message-ID: <20170418113340.GE4045@yuval-lap>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
 <8267b19e-d6a6-ac77-6b0e-e184e690db9b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8267b19e-d6a6-ac77-6b0e-e184e690db9b@users.sourceforge.net>
Sender: target-devel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 07, 2017 at 11:05:23PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 7 Apr 2017 21:06:08 +0200
> 
> The script "checkpatch.pl" pointed information out like the following.
> 
> WARNING: quoted string split across lines
> 
> Thus fix affected source code places.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 55581417eb43..43aef0ca53ad 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -226,8 +226,9 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
>  	priv->admin_mtu = new_mtu;
>  
>  	if (priv->mcast_mtu < priv->admin_mtu)
> -		ipoib_dbg(priv, "MTU must be smaller than the underlying "
> -				"link layer MTU - 4 (%u)\n", priv->mcast_mtu);
> +		ipoib_dbg(priv,
> +			  "MTU must be smaller than the underlying link layer MTU - 4 (%u)\n",
> +			  priv->mcast_mtu);
>  
>  	dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
>  
> @@ -480,8 +481,8 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
>  	/* flush paths if we switch modes so that connections are restarted */
>  	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
>  		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
> -		ipoib_warn(priv, "enabling connected mode "
> -			   "will cause multicast packet drops\n");
> +		ipoib_warn(priv,
> +			   "enabling connected mode will cause multicast packet drops\n");
>  		netdev_update_features(dev);
>  		dev_set_mtu(dev, ipoib_cm_max_mtu(dev));
>  		rtnl_unlock();
> @@ -1855,8 +1856,8 @@ void ipoib_set_umcast(struct net_device *ndev, int umcast_val)
>  
>  	if (umcast_val > 0) {
>  		set_bit(IPOIB_FLAG_UMCAST, &priv->flags);
> -		ipoib_warn(priv, "ignoring multicast groups joined directly "
> -				"by userspace\n");
> +		ipoib_warn(priv,
> +			   "ignoring multicast groups joined directly by userspace\n");
>  	} else
>  		clear_bit(IPOIB_FLAG_UMCAST, &priv->flags);
>  }
> -- 
> 2.12.2
> 
