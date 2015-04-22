From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 10/27] IB/Verbs: Reform cm related part in IB-core cma/ucm
Date: Tue, 21 Apr 2015 20:07:05 -0400
Message-ID: <20150422000704.GJ15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BA94.8010502@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BA94.8010502@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:36:36AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform cm related part in IB-core cma/ucm.
> 
> Few checks focus on the device cm type rather than the port capability,
> directly pass port 1 works currently, but can't support mixing cm type
> device in future.
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
>  drivers/infiniband/core/cma.c | 81 +++++++++++++------------------------------
>  drivers/infiniband/core/ucm.c |  3 +-
>  2 files changed, 26 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index d570030..815e41b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -735,8 +735,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
>  	int ret = 0;
>  
>  	id_priv = container_of(id, struct rdma_id_private, id);
> -	switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> +	if (rdma_ib_or_iboe(id->device, id->port_num)) {
>  		if (!id_priv->cm_id.ib || (id_priv->id.qp_type == IB_QPT_UD))
>  			ret = cma_ib_init_qp_attr(id_priv, qp_attr, qp_attr_mask);
>  		else
> @@ -745,19 +744,15 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
>  
>  		if (qp_attr->qp_state == IB_QPS_RTR)
>  			qp_attr->rq_psn = id_priv->seq_num;
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	} else if (rdma_tech_iwarp(id->device, id->port_num)) {
>  		if (!id_priv->cm_id.iw) {
>  			qp_attr->qp_access_flags = 0;
>  			*qp_attr_mask = IB_QP_STATE | IB_QP_ACCESS_FLAGS;
>  		} else
>  			ret = iw_cm_init_qp_attr(id_priv->cm_id.iw, qp_attr,
>  						 qp_attr_mask);
> -		break;
> -	default:
> +	} else
>  		ret = -ENOSYS;
> -		break;
> -	}
>  
>  	return ret;
>  }
> @@ -1037,17 +1032,12 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  	mutex_unlock(&id_priv->handler_mutex);
>  
>  	if (id_priv->cma_dev) {
> -		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
> -		case RDMA_TRANSPORT_IB:
> +		if (rdma_ib_or_iboe(id_priv->id.device, 1)) {
>  			if (id_priv->cm_id.ib)
>  				ib_destroy_cm_id(id_priv->cm_id.ib);
> -			break;
> -		case RDMA_TRANSPORT_IWARP:
> +		} else if (rdma_tech_iwarp(id_priv->id.device, 1)) {
>  			if (id_priv->cm_id.iw)
>  				iw_destroy_cm_id(id_priv->cm_id.iw);
> -			break;
> -		default:
> -			break;
>  		}
>  		cma_leave_mc_groups(id_priv);
>  		cma_release_dev(id_priv);
> @@ -1626,7 +1616,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
>  	int ret;
>  
>  	if (cma_family(id_priv) == AF_IB &&
> -	    rdma_node_get_transport(cma_dev->device->node_type) != RDMA_TRANSPORT_IB)
> +	    !rdma_ib_or_iboe(cma_dev->device, 1))
>  		return;
>  
>  	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
> @@ -2028,7 +2018,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
>  	mutex_lock(&lock);
>  	list_for_each_entry(cur_dev, &dev_list, list) {
>  		if (cma_family(id_priv) == AF_IB &&
> -		    rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
> +		    !rdma_ib_or_iboe(cur_dev->device, 1))
>  			continue;
>  
>  		if (!cma_dev)
> @@ -2060,7 +2050,7 @@ port_found:
>  		goto out;
>  
>  	id_priv->id.route.addr.dev_addr.dev_type =
> -		(rdma_port_get_link_layer(cma_dev->device, p) == IB_LINK_LAYER_INFINIBAND) ?
> +		(rdma_tech_ib(cma_dev->device, p)) ?
>  		ARPHRD_INFINIBAND : ARPHRD_ETHER;
>  
>  	rdma_addr_set_sgid(&id_priv->id.route.addr.dev_addr, &gid);
> @@ -2537,18 +2527,15 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
>  
>  	id_priv->backlog = backlog;
>  	if (id->device) {
> -		switch (rdma_node_get_transport(id->device->node_type)) {
> -		case RDMA_TRANSPORT_IB:
> +		if (rdma_ib_or_iboe(id->device, 1)) {
>  			ret = cma_ib_listen(id_priv);
>  			if (ret)
>  				goto err;
> -			break;
> -		case RDMA_TRANSPORT_IWARP:
> +		} else if (rdma_tech_iwarp(id->device, 1)) {
>  			ret = cma_iw_listen(id_priv, backlog);
>  			if (ret)
>  				goto err;
> -			break;
> -		default:
> +		} else {
>  			ret = -ENOSYS;
>  			goto err;
>  		}
> @@ -2884,20 +2871,15 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>  		id_priv->srq = conn_param->srq;
>  	}
>  
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> +	if (rdma_ib_or_iboe(id->device, id->port_num)) {
>  		if (id->qp_type == IB_QPT_UD)
>  			ret = cma_resolve_ib_udp(id_priv, conn_param);
>  		else
>  			ret = cma_connect_ib(id_priv, conn_param);
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	} else if (rdma_tech_iwarp(id->device, id->port_num))
>  		ret = cma_connect_iw(id_priv, conn_param);
> -		break;
> -	default:
> +	else
>  		ret = -ENOSYS;
> -		break;
> -	}
>  	if (ret)
>  		goto err;
>  
> @@ -3000,8 +2982,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>  		id_priv->srq = conn_param->srq;
>  	}
>  
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> +	if (rdma_ib_or_iboe(id->device, id->port_num)) {
>  		if (id->qp_type == IB_QPT_UD) {
>  			if (conn_param)
>  				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
> @@ -3017,14 +2998,10 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
>  			else
>  				ret = cma_rep_recv(id_priv);
>  		}
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	} else if (rdma_tech_iwarp(id->device, id->port_num))
>  		ret = cma_accept_iw(id_priv, conn_param);
> -		break;
> -	default:
> +	else
>  		ret = -ENOSYS;
> -		break;
> -	}
>  
>  	if (ret)
>  		goto reject;
> @@ -3068,8 +3045,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
>  	if (!id_priv->cm_id.ib)
>  		return -EINVAL;
>  
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> +	if (rdma_ib_or_iboe(id->device, id->port_num)) {
>  		if (id->qp_type == IB_QPT_UD)
>  			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
>  						private_data, private_data_len);
> @@ -3077,15 +3053,12 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
>  			ret = ib_send_cm_rej(id_priv->cm_id.ib,
>  					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
>  					     0, private_data, private_data_len);
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	} else if (rdma_tech_iwarp(id->device, id->port_num)) {
>  		ret = iw_cm_reject(id_priv->cm_id.iw,
>  				   private_data, private_data_len);
> -		break;
> -	default:
> +	} else
>  		ret = -ENOSYS;
> -		break;
> -	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(rdma_reject);
> @@ -3099,22 +3072,18 @@ int rdma_disconnect(struct rdma_cm_id *id)
>  	if (!id_priv->cm_id.ib)
>  		return -EINVAL;
>  
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> +	if (rdma_ib_or_iboe(id->device, id->port_num)) {
>  		ret = cma_modify_qp_err(id_priv);
>  		if (ret)
>  			goto out;
>  		/* Initiate or respond to a disconnect. */
>  		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0))
>  			ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0);
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	} else if (rdma_tech_iwarp(id->device, id->port_num)) {
>  		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
> -		break;
> -	default:
> +	} else
>  		ret = -EINVAL;
> -		break;
> -	}
> +
>  out:
>  	return ret;
>  }
> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
> index f2f6393..70e0ccb 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -1253,8 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
>  	dev_t base;
>  	struct ib_ucm_device *ucm_dev;
>  
> -	if (!device->alloc_ucontext ||
> -	    rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> +	if (!device->alloc_ucontext || !rdma_ib_or_iboe(device, 1))
>  		return;
>  
>  	ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
> -- 
> 2.1.0
