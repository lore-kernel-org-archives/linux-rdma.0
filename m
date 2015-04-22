From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 06/27] IB/Verbs: Reform IB-core multicast
Date: Tue, 21 Apr 2015 20:06:11 -0400
Message-ID: <20150422000610.GG15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BA28.8040905@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BA28.8040905@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:34:48AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-core multicast.
> 
> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/multicast.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
> index fa17b55..24d93f5 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -780,8 +780,7 @@ static void mcast_event_handler(struct ib_event_handler *handler,
>  	int index;
>  
>  	dev = container_of(handler, struct mcast_device, event_handler);
> -	if (rdma_port_get_link_layer(dev->device, event->element.port_num) !=
> -	    IB_LINK_LAYER_INFINIBAND)
> +	if (WARN_ON(!rdma_tech_ib(dev->device, event->element.port_num)))
>  		return;
>  
>  	index = event->element.port_num - dev->start_port;
> @@ -808,9 +807,6 @@ static void mcast_add_one(struct ib_device *device)
>  	int i;
>  	int count = 0;
>  
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> -
>  	dev = kmalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
>  		      GFP_KERNEL);
>  	if (!dev)
> @@ -824,8 +820,7 @@ static void mcast_add_one(struct ib_device *device)
>  	}
>  
>  	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
> -		if (rdma_port_get_link_layer(device, dev->start_port + i) !=
> -		    IB_LINK_LAYER_INFINIBAND)
> +		if (!rdma_tech_ib(device, dev->start_port + i))
>  			continue;
>  		port = &dev->port[i];
>  		port->dev = dev;
> @@ -863,8 +858,7 @@ static void mcast_remove_one(struct ib_device *device)
>  	flush_workqueue(mcast_wq);
>  
>  	for (i = 0; i <= dev->end_port - dev->start_port; i++) {
> -		if (rdma_port_get_link_layer(device, dev->start_port + i) ==
> -		    IB_LINK_LAYER_INFINIBAND) {
> +		if (rdma_tech_ib(device, dev->start_port + i)) {
>  			port = &dev->port[i];
>  			deref_port(port);
>  			wait_for_completion(&port->comp);
> -- 
> 2.1.0
