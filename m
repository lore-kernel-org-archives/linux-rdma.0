From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/8] IB/core: Convert ah_attr from OPA to IB
 when copying to user
Date: Tue, 16 May 2017 18:08:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB11E128@ORSMSX109.amr.corp.intel.com>
References: <1494458576-6816-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458576-6816-2-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494458576-6816-2-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
> -			     struct rdma_ah_attr *src)
> +static int rdma_ah_conv_opa_to_ib(struct ib_device *dev,
> +				  struct rdma_ah_attr *ib,
> +				  struct rdma_ah_attr *opa)
>  {
> +	struct ib_port_attr port_attr;
> +
> +	if (ib_query_port(dev, opa->port_num, &port_attr))
> +		return -EINVAL;
> +
> +	/* Do structure copy and the over-write fields */
> +	*ib = *opa;
> +
> +	ib->type = RDMA_AH_ATTR_TYPE_IB;
> +	rdma_ah_set_grh(ib, NULL, 0, 0, 1, 0);
> +	rdma_ah_set_subnet_prefix(ib,
> cpu_to_be64(port_attr.subnet_prefix));
> +	rdma_ah_set_interface_id(ib,
> OPA_MAKE_ID(rdma_ah_get_dlid(opa)));
> +	return 0;
> +}
> +
> +void ib_copy_ah_attr_to_user(struct ib_device *device,
> +			     struct ib_uverbs_ah_attr *dst,
> +			     struct rdma_ah_attr *ah_attr)
> +{
> +	struct rdma_ah_attr *src = ah_attr;
> +	struct rdma_ah_attr conv_ah;
> +
>  	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
> +
> +	if ((ah_attr->type == RDMA_AH_ATTR_TYPE_OPA) &&
> +	    (rdma_ah_get_dlid(ah_attr) >=
> +	     be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
> +	    (!rdma_ah_conv_opa_to_ib(device, &conv_ah, ah_attr)))

Doesn't a failure result in copying the wrong data to user space?  Can rdma_ah_conv_opa_to_ib() use some sort of default subnet prefix if query_port fails?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
