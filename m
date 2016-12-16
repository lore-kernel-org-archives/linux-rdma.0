From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/10] IB/core: Enable to query QP types supported by IB device on a port
Date: Fri, 16 Dec 2016 15:11:59 -0500
Message-ID: <20161216201158.GE12582@phlsvsds.ph.intel.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org> <1480258296-27032-7-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480258296-27032-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 27, 2016 at 04:51:32PM +0200, Leon Romanovsky wrote:
> From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add qp_type_cap port attribute which is a bit field representation
> of the ib_qp_type enum. This will allow applications to query what QP
> types are supported by an IB device instance on a specific port.
> 
> The qp_type_cap port attribute is set by the core according to the
> protocol supported for the device port. This holds for all the
> providers with the exception of two RoCE drivers that don't implement
> UD and UC. To handle that, they (hns and qedr) are patched to remove
> these QPs from what's the core has set for them as supported.
> 
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c          | 28 ++++++++++++++++++++++++++++
>  drivers/infiniband/hw/hns/hns_roce_main.c |  3 +++
>  drivers/infiniband/hw/qedr/verbs.c        |  2 ++
>  include/rdma/ib_verbs.h                   |  1 +
>  4 files changed, 34 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 760ef60..f7abde2 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -646,6 +646,31 @@ void ib_dispatch_event(struct ib_event *event)
>  }
>  EXPORT_SYMBOL(ib_dispatch_event);
>  
> +static void get_port_qp_types(const struct ib_device *device, u8 port_num,
> +			      struct ib_port_attr *port_attr)
> +{
> +	if (rdma_cap_ib_smi(device, port_num))
> +		port_attr->qp_type_cap |= BIT(IB_QPT_SMI);
> +
> +	if (rdma_cap_ib_cm(device, port_num))
> +		port_attr->qp_type_cap |= BIT(IB_QPT_GSI);

This is not accurate.  The IB CM is not the same as having QP1 supported.

Ira

> +
> +	if (rdma_ib_or_roce(device, port_num)) {
> +		port_attr->qp_type_cap |= (BIT(IB_QPT_RC) | BIT(IB_QPT_UD) | BIT(IB_QPT_UC));
> +		if (device->attrs.device_cap_flags & IB_DEVICE_XRC)
> +			port_attr->qp_type_cap |= (BIT(IB_QPT_XRC_INI) | BIT(IB_QPT_XRC_TGT));
> +	}
> +
> +	if (rdma_protocol_iwarp(device, port_num))
> +		port_attr->qp_type_cap |= BIT(IB_QPT_RC);
> +
> +	if (rdma_protocol_raw_packet(device, port_num))
> +		port_attr->qp_type_cap |= BIT(IB_QPT_RAW_PACKET);
> +
> +	if (rdma_protocol_usnic(device, port_num))
> +		port_attr->qp_type_cap |= BIT(IB_QPT_UD);
> +}
> +
>  /**
>   * ib_query_port - Query IB port attributes
>   * @device:Device to query
> @@ -666,6 +691,9 @@ int ib_query_port(struct ib_device *device,
>  		return -EINVAL;
>  
>  	memset(port_attr, 0, sizeof(*port_attr));
> +
> +	get_port_qp_types(device, port_num, port_attr);
> +
>  	err = device->query_port(device, port_num, port_attr);
>  	if (err || port_attr->subnet_prefix)
>  		return err;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index c6b5779..22de534 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -430,6 +430,9 @@ static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
>  			IB_PORT_ACTIVE : IB_PORT_DOWN;
>  	props->phys_state = (props->state == IB_PORT_ACTIVE) ? 5 : 3;
>  
> +	/* mark that UD and UC aren't supported */
> +	props->qp_type_cap &= ~(BIT(IB_QPT_UD) | BIT(IB_QPT_UC));
> +
>  	spin_unlock_irqrestore(&hr_dev->iboe.lock, flags);
>  
>  	return 0;
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index 53207ff..33d0219 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -263,6 +263,8 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
>  	attr->max_msg_sz = rdma_port->max_msg_size;
>  	attr->max_vl_num = 4;
>  
> +	/* mark that UD and UC aren't supported */
> +	attr->qp_type_cap &= ~(BIT(IB_QPT_UD) | BIT(IB_QPT_UC));
>  	return 0;
>  }
>  
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 485b725..0b839e4 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -536,6 +536,7 @@ struct ib_port_attr {
>  	u8			active_speed;
>  	u8                      phys_state;
>  	bool			grh_required;
> +	u16			qp_type_cap;
>  };
>  
>  enum ib_device_modify_flags {
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
