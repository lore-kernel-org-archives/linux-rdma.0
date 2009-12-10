From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdmaoe/libibverbs: handle binary compatibility
Date: Thu, 10 Dec 2009 10:33:53 -0700
Message-ID: <20091210173353.GW1966@obsidianresearch.com>
References: <20091210170536.GA3229@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091210170536.GA3229@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 07:05:36PM +0200, Eli Cohen wrote:

> here is the patch I prepared based on the discussions we had. The patch is based on the last
> rdmaoe/libibverbs patch I sent. libmlx4 was modified too, a trivial
> change that changes name. Both fixes were push to OFED. I will send a
> new patch set in a few days.

Could you prepare this based on Roland's tree? This patch won't apply.

Why are things still going into OFED so quickly? Shouldn't Roland
accept this stuff before it gets to OFED - or at least review it once..

> +static inline int ___ibv_query_port(struct ibv_context *context,
> +				    uint8_t port_num,
> +				    struct ibv_port_attr *port_attr)
> +{
> +	uint8_t *padp;
> +	int padsize;
> +
> +	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
> +	padp = &port_attr->link_layer + sizeof port_attr->link_layer;
> +	padsize = sizeof(int) - ((unsigned long)padp & (sizeof(int) - 1));
> +	memset(padp, 0, padsize);
> +
> +	return context->ops.query_port(context, port_num, port_attr);
> +}

You should explicity declare the padding, like ibv_query_port_resp
does, the above is very fragile.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
