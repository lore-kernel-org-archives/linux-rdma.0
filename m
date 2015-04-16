From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH v4 03/27] IB/Verbs: Reform IB-core mad/agent/user_mad
Date: Thu, 16 Apr 2015 08:43:18 -0400
Message-ID: <552FAE66.6020900@dev.mellanox.co.il>
References: <552F6CF2.4000606@profitbricks.com> <552F6D53.70804@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552F6D53.70804@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 4:05 AM, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-core mad/agent/user_mad.
> 
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  drivers/infiniband/core/agent.c    |  2 +-
>  drivers/infiniband/core/mad.c      | 20 ++++++++++----------
>  drivers/infiniband/core/user_mad.c | 26 ++++++++++++++++++++------
>  3 files changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
> index f6d2961..ffdef4d 100644
> --- a/drivers/infiniband/core/agent.c
> +++ b/drivers/infiniband/core/agent.c
> @@ -156,7 +156,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
>  		goto error1;
>  	}
>  
> -	if (rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND) {
> +	if (rdma_tech_ib(device, port_num)) {
>  		/* Obtain send only MAD agent for SMI QP */
>  		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
>  							    IB_QPT_SMI, NULL, 0,
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 74c30f4..d451a47 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *device,
>  	init_mad_qp(port_priv, &port_priv->qp_info[1]);
>  
>  	cq_size = mad_sendq_size + mad_recvq_size;
> -	has_smi = rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND;
> +	has_smi = rdma_tech_ib(device, port_num);
>  	if (has_smi)
>  		cq_size *= 2;
>  
> @@ -3057,9 +3057,6 @@ static void ib_mad_init_device(struct ib_device *device)
>  {
>  	int start, end, i;
>  
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> -
>  	if (device->node_type == RDMA_NODE_IB_SWITCH) {
>  		start = 0;
>  		end   = 0;
> @@ -3069,6 +3066,9 @@ static void ib_mad_init_device(struct ib_device *device)
>  	}
>  
>  	for (i = start; i <= end; i++) {
> +		if (!rdma_ib_or_iboe(device, i))
> +			continue;
> +
>  		if (ib_mad_port_open(device, i)) {
>  			dev_err(&device->dev, "Couldn't open port %d\n", i);
>  			goto error;
> @@ -3086,15 +3086,15 @@ error_agent:
>  		dev_err(&device->dev, "Couldn't close port %d\n", i);
>  
>  error:
> -	i--;
> +	while (--i >= start) {
> +		if (!rdma_ib_or_iboe(device, i))
> +			continue;
>  
> -	while (i >= start) {
>  		if (ib_agent_port_close(device, i))
>  			dev_err(&device->dev,
>  				"Couldn't close port %d for agents\n", i);
>  		if (ib_mad_port_close(device, i))
>  			dev_err(&device->dev, "Couldn't close port %d\n", i);
> -		i--;
>  	}
>  }
>  
> @@ -3102,9 +3102,6 @@ static void ib_mad_remove_device(struct ib_device *device)
>  {
>  	int i, num_ports, cur_port;
>  
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> -
>  	if (device->node_type == RDMA_NODE_IB_SWITCH) {
>  		num_ports = 1;
>  		cur_port = 0;
> @@ -3113,6 +3110,9 @@ static void ib_mad_remove_device(struct ib_device *device)
>  		cur_port = 1;
>  	}
>  	for (i = 0; i < num_ports; i++, cur_port++) {
> +		if (!rdma_ib_or_iboe(device, i))

Shouldn't this be:
		if (!rdma_ib_or_iboe(device, cur_port))
?

-- Hal

> +			continue;
> +
>  		if (ib_agent_port_close(device, cur_port))
>  			dev_err(&device->dev,
>  				"Couldn't close port %d for agents\n",
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
> index 928cdd2..71fc8ba 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -1273,9 +1273,7 @@ static void ib_umad_add_one(struct ib_device *device)
>  {
>  	struct ib_umad_device *umad_dev;
>  	int s, e, i;
> -
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> +	int count = 0;
>  
>  	if (device->node_type == RDMA_NODE_IB_SWITCH)
>  		s = e = 0;
> @@ -1296,11 +1294,21 @@ static void ib_umad_add_one(struct ib_device *device)
>  	umad_dev->end_port   = e;
>  
>  	for (i = s; i <= e; ++i) {
> +		if (!rdma_ib_or_iboe(device, i))
> +			continue;
> +
>  		umad_dev->port[i - s].umad_dev = umad_dev;
>  
>  		if (ib_umad_init_port(device, i, umad_dev,
>  				      &umad_dev->port[i - s]))
>  			goto err;
> +
> +		count++;
> +	}
> +
> +	if (!count) {
> +		kobject_put(&umad_dev->kobj);
> +		return;
>  	}
>  
>  	ib_set_client_data(device, &umad_client, umad_dev);
> @@ -1308,8 +1316,12 @@ static void ib_umad_add_one(struct ib_device *device)
>  	return;
>  
>  err:
> -	while (--i >= s)
> +	while (--i >= s) {
> +		if (!rdma_ib_or_iboe(device, i))
> +			continue;
> +
>  		ib_umad_kill_port(&umad_dev->port[i - s]);
> +	}
>  
>  	kobject_put(&umad_dev->kobj);
>  }
> @@ -1322,8 +1334,10 @@ static void ib_umad_remove_one(struct ib_device *device)
>  	if (!umad_dev)
>  		return;
>  
> -	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
> -		ib_umad_kill_port(&umad_dev->port[i]);
> +	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
> +		if (rdma_ib_or_iboe(device, i))
> +			ib_umad_kill_port(&umad_dev->port[i]);
> +	}
>  
>  	kobject_put(&umad_dev->kobj);
>  }
