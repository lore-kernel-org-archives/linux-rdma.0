From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 14/27] IB/Verbs: Reform cma_acquire_dev()
Date: Thu, 16 Apr 2015 09:19:06 -0400
Message-ID: <552FB6CA.1040106@dev.mellanox.co.il>
References: <552F6CF2.4000606@profitbricks.com> <552F6E43.2070700@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552F6E43.2070700-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 4:09 AM, Michael Wang wrote:
> 
> Reform cma_acquire_dev() with management helpers, introduce
> cma_validate_port() to make the code more clean.
> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 69 +++++++++++++++++++++++++------------------
>  1 file changed, 41 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index b520882..902cc1a 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -370,18 +370,36 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
>  	return ret;
>  }
>  
> +static inline int cma_validate_port(struct ib_device *device, u8 port,
> +				      union ib_gid *gid, int dev_type)
> +{
> +	u8 found_port;
> +	int ret = -ENODEV;
> +
> +	if ((dev_type == ARPHRD_INFINIBAND) && !rdma_tech_ib(device, port))
> +		return ret;
> +
> +	if ((dev_type != ARPHRD_INFINIBAND) && rdma_tech_ib(device, port))
> +		return ret;
> +
> +	ret = ib_find_cached_gid(device, gid, &found_port, NULL);
> +
> +	if (!ret && (port == found_port))
> +		return 0;
> +
> +	return ret;

Should the case where ret = 0 and port != found_port need to be handled
the same as currently ? It looks different to me since in this case the
port will be saved into id_priv->id.port_num whereas currently it isn't.

-- Hal

> +}
> +
>  static int cma_acquire_dev(struct rdma_id_private *id_priv,
>  			   struct rdma_id_private *listen_id_priv)
>  {
>  	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
>  	struct cma_device *cma_dev;
> -	union ib_gid gid, iboe_gid;
> +	union ib_gid gid, iboe_gid, *gidp;
>  	int ret = -ENODEV;
> -	u8 port, found_port;
> -	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
> -		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
> +	u8 port;
>  
> -	if (dev_ll != IB_LINK_LAYER_INFINIBAND &&
> +	if (dev_addr->dev_type != ARPHRD_INFINIBAND &&
>  	    id_priv->id.ps == RDMA_PS_IPOIB)
>  		return -EINVAL;
>  
> @@ -391,41 +409,36 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
>  
>  	memcpy(&gid, dev_addr->src_dev_addr +
>  	       rdma_addr_gid_offset(dev_addr), sizeof gid);
> -	if (listen_id_priv &&
> -	    rdma_port_get_link_layer(listen_id_priv->id.device,
> -				     listen_id_priv->id.port_num) == dev_ll) {
> +
> +	if (listen_id_priv) {
>  		cma_dev = listen_id_priv->cma_dev;
>  		port = listen_id_priv->id.port_num;
> -		if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
> -		    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
> -			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
> -						 &found_port, NULL);
> -		else
> -			ret = ib_find_cached_gid(cma_dev->device, &gid,
> -						 &found_port, NULL);
> +		gidp = rdma_tech_iboe(cma_dev->device, port) ?
> +		       &iboe_gid : &gid;
>  
> -		if (!ret && (port  == found_port)) {
> -			id_priv->id.port_num = found_port;
> +		ret = cma_validate_port(cma_dev->device, port, gidp,
> +					dev_addr->dev_type);
> +		if (!ret) {
> +			id_priv->id.port_num = port;
>  			goto out;
>  		}
>  	}
> +
>  	list_for_each_entry(cma_dev, &dev_list, list) {
>  		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port) {
>  			if (listen_id_priv &&
>  			    listen_id_priv->cma_dev == cma_dev &&
>  			    listen_id_priv->id.port_num == port)
>  				continue;
> -			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
> -				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
> -				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
> -					ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
> -				else
> -					ret = ib_find_cached_gid(cma_dev->device, &gid, &found_port, NULL);
> -
> -				if (!ret && (port == found_port)) {
> -					id_priv->id.port_num = found_port;
> -					goto out;
> -				}
> +
> +			gidp = rdma_tech_iboe(cma_dev->device, port) ?
> +			       &iboe_gid : &gid;
> +
> +			ret = cma_validate_port(cma_dev->device, port, gidp,
> +						dev_addr->dev_type);
> +			if (!ret) {
> +				id_priv->id.port_num = port;
> +				goto out;
>  			}
>  		}
>  	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
