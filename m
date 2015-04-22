From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 07/27] IB/Verbs: Reform IB-ulp ipoib
Date: Tue, 21 Apr 2015 20:06:27 -0400
Message-ID: <20150422000626.GH15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BA43.6060400@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5534BA43.6060400-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:35:15AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-ulp ipoib.
> 
> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 58b5aa3..60b379d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1654,9 +1654,7 @@ static void ipoib_add_one(struct ib_device *device)
>  	struct net_device *dev;
>  	struct ipoib_dev_priv *priv;
>  	int s, e, p;
> -
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> +	int count = 0;
>  
>  	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
>  	if (!dev_list)
> @@ -1673,15 +1671,21 @@ static void ipoib_add_one(struct ib_device *device)
>  	}
>  
>  	for (p = s; p <= e; ++p) {
> -		if (rdma_port_get_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
> +		if (!rdma_tech_ib(device, p))
>  			continue;
>  		dev = ipoib_add_port("ib%d", device, p);
>  		if (!IS_ERR(dev)) {
>  			priv = netdev_priv(dev);
>  			list_add_tail(&priv->list, dev_list);
> +			count++;
>  		}
>  	}
>  
> +	if (!count) {
> +		kfree(dev_list);
> +		return;
> +	}
> +
>  	ib_set_client_data(device, &ipoib_client, dev_list);
>  }
>  
> @@ -1690,9 +1694,6 @@ static void ipoib_remove_one(struct ib_device *device)
>  	struct ipoib_dev_priv *priv, *tmp;
>  	struct list_head *dev_list;
>  
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> -
>  	dev_list = ib_get_client_data(device, &ipoib_client);
>  	if (!dev_list)
>  		return;
> -- 
> 2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
