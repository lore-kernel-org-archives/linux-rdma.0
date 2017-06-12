From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/3] IB/core: Fix the validations of a
 multicast LID in attach or detach operations
Date: Mon, 12 Jun 2017 16:15:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB142896@ORSMSX109.amr.corp.intel.com>
References: <20170612081404.17553-1-leon@kernel.org>
 <20170612081404.17553-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612081404.17553-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
> +{
> +	struct ib_qp_init_attr init_attr = {};
> +	struct ib_qp_attr attr = {};
> +	int num_eth_ports = 0;
> +	int port;
> +
> +	/* If QP state >= init, it is assigned to a port and we can
> check this
> +	 * port only.
> +	 */
> +	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT,
> &init_attr)) {
> +		if (attr.qp_state >= IB_QPS_INIT) {
> +			if (qp->device->get_link_layer(qp->device,
> attr.port_num) !=
> +			    IB_LINK_LAYER_INFINIBAND)
> +				return true;
> +			goto lid_check;
> +		}
> +	}
> +
> +	/* Can't get a quick answer, iterate over all ports */
> +	for (port = 0; port < qp->device->phys_port_cnt; port++)
> +		if (qp->device->get_link_layer(qp->device, port) !=
> +		    IB_LINK_LAYER_INFINIBAND)
> +			num_eth_ports++;
> +
> +	/* If we have at lease one Ethernet port, RoCE annex declares
> that
> +	 * multicast LID should be ignored. We can't tell at this step
> if the
> +	 * QP belongs to an IB or Ethernet port.
> +	 */
> +	if (num_eth_ports)
> +		return true;

Reporting that a lid *might* be valid is a really weak check.  Can we require that RoCE QPs be in the INIT state prior to joining, or use the mgid, or something to make the validation check work?  Do we even know if the qp is a roce qp?


> +
> +	/* If all the ports are IB, we can check according to IB spec.
> */
> +lid_check:
> +	return !(lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
> +		 lid == be16_to_cpu(IB_LID_PERMISSIVE));
> +}
> +
>  int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
>  {
>  	int ret;
> @@ -1526,8 +1564,7 @@ int ib_attach_mcast(struct ib_qp *qp, union
> ib_gid *gid, u16 lid)
>  	if (!qp->device->attach_mcast)
>  		return -ENOSYS;
>  	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
> -	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
> -	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
> +	    !is_valid_mcast_lid(qp, lid))
>  		return -EINVAL;
> 
>  	ret = qp->device->attach_mcast(qp, gid, lid);
> @@ -1544,8 +1581,7 @@ int ib_detach_mcast(struct ib_qp *qp, union
> ib_gid *gid, u16 lid)
>  	if (!qp->device->detach_mcast)
>  		return -ENOSYS;
>  	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD ||
> -	    lid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
> -	    lid == be16_to_cpu(IB_LID_PERMISSIVE))
> +	    !is_valid_mcast_lid(qp, lid))
>  		return -EINVAL;
> 
>  	ret = qp->device->detach_mcast(qp, gid, lid);
> --
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
