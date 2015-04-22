From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 04/27] IB/Verbs: Reform IB-core cm
Date: Tue, 21 Apr 2015 20:05:35 -0400
Message-ID: <20150422000535.GE15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534B9E9.1020108@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534B9E9.1020108@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:33:45AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-core cm.
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
>  drivers/infiniband/core/cm.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index e28a494..3c10b75 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -3761,9 +3761,7 @@ static void cm_add_one(struct ib_device *ib_device)
>  	unsigned long flags;
>  	int ret;
>  	u8 i;
> -
> -	if (rdma_node_get_transport(ib_device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> +	int count = 0;
>  
>  	cm_dev = kzalloc(sizeof(*cm_dev) + sizeof(*port) *
>  			 ib_device->phys_port_cnt, GFP_KERNEL);
> @@ -3783,6 +3781,9 @@ static void cm_add_one(struct ib_device *ib_device)
>  
>  	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
>  	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
> +		if (!rdma_ib_or_iboe(ib_device, i))
> +			continue;
> +
>  		port = kzalloc(sizeof *port, GFP_KERNEL);
>  		if (!port)
>  			goto error1;
> @@ -3809,7 +3810,13 @@ static void cm_add_one(struct ib_device *ib_device)
>  		ret = ib_modify_port(ib_device, i, 0, &port_modify);
>  		if (ret)
>  			goto error3;
> +
> +		count++;
>  	}
> +
> +	if (!count)
> +		goto free;
> +
>  	ib_set_client_data(ib_device, &cm_client, cm_dev);
>  
>  	write_lock_irqsave(&cm.device_lock, flags);
> @@ -3825,11 +3832,15 @@ error1:
>  	port_modify.set_port_cap_mask = 0;
>  	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
>  	while (--i) {
> +		if (!rdma_ib_or_iboe(ib_device, i))
> +			continue;
> +
>  		port = cm_dev->port[i-1];
>  		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
>  		ib_unregister_mad_agent(port->mad_agent);
>  		cm_remove_port_fs(port);
>  	}
> +free:
>  	device_unregister(cm_dev->device);
>  	kfree(cm_dev);
>  }
> @@ -3853,6 +3864,9 @@ static void cm_remove_one(struct ib_device *ib_device)
>  	write_unlock_irqrestore(&cm.device_lock, flags);
>  
>  	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
> +		if (!rdma_ib_or_iboe(ib_device, i))
> +			continue;
> +
>  		port = cm_dev->port[i-1];
>  		ib_modify_port(ib_device, port->port_num, 0, &port_modify);
>  		ib_unregister_mad_agent(port->mad_agent);
> -- 
> 2.1.0
