From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-next, 02/31] IB/{core/cm}: Fix dmac query for IPv6 link
 local destination
Date: Mon, 18 Dec 2017 13:38:46 -0700
Message-ID: <20171218203846.GA18377@ziepe.ca>
References: <20171114125218.20477-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:49PM +0200, Leon Romanovsky wrote:

> +static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
> +				       struct rdma_ah_attr *ah_attr)
> +{
> +	struct ib_gid_attr sgid_attr;
> +	struct ib_global_route *grh;
> +	int hop_limit = 0xff;
> +	union ib_gid sgid;
> +	int ret;
> +
> +	grh = rdma_ah_retrieve_grh(ah_attr);
> +
> +	ret = ib_query_gid(device,
> +			   rdma_ah_get_port_num(ah_attr),
> +			   grh->sgid_index,
> +			   &sgid, &sgid_attr);

[..]

> +		ret = get_sgid_index_from_eth(device, port_num,
> +					      vlan_id, &dgid,
> +					      gid_type, &gid_index);
>  		if (ret)
>  			return ret;
> +		flow_class = be32_to_cpu(grh->version_tclass_flow);
> +		rdma_ah_set_grh(ah_attr, &sgid,
> +				flow_class & 0xFFFFF,
> +				(u8)gid_index, hoplimit,
> +				(flow_class >> 20) & 0xFF);
> +		return ib_resolve_unicast_gid_dmac(device, ah_attr);

This patch looks like a major improvement, so I am going to take it.

However, I dislike this flow here, calling get_sgid_index_from_eth to
get an index then converting the index to a ib_gid_attr via
ib_query_gid is silly.

We should have support APIs that go directly from the WC & GRH to a
gid_attr without the racy inbetween step of gid_index.

Can you send a followup to fix it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
