From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 3/5] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Wed, 21 May 2014 14:31:07 -0600
Message-ID: <20140521203107.GD26909@obsidianresearch.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405929-14313-4-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400405929-14313-4-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 18, 2014 at 12:38:47PM +0300, Or Gerlitz wrote:
>  struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
>  {
> -	struct ibv_ah *ah = pd->context->ops.create_ah(pd, attr);
> +	int err;
> +	struct ibv_ah *ah = NULL;
> +#ifndef NRESOLVE_NEIGH
> +	struct ibv_port_attr port_attr;
> +	int dst_family;
> +	int src_family;
> +	int oif;
> +	struct get_neigh_handler neigh_handler;
> +	union ibv_gid sgid;
> +	struct ibv_ah_attr_ex attr_ex;
> +	int ether_len;
> +	struct verbs_context *vctx = verbs_get_ctx_op(pd->context,
> +						      create_ah_ex);
> +	struct peer_address src;
> +	struct peer_address dst;
> +
> +	if (!vctx) {
> +#endif
> +		ah = pd->context->ops.create_ah(pd, attr);
> +#ifndef NRESOLVE_NEIGH
> +		goto return_ah;
> +	}
> +
> +	err = ibv_query_port(pd->context, attr->port_num, &port_attr);

It feels like a regression to force this overhead. Many HCAs have no
possibility to support anything but IB, or Ethernet and don't need
this.

This whole arrangement seems strange. create_ah_ex should be a full
fledged user callable function, not a buried driver entry point.
It is also very unusual for verbs to have all this generic code in
a driver wrapper.

I suspect the answer here is to have the driver call into helper
functions from verbs to do this addressing
work. 'get_ethernet_l2_from_ah' or something.

If you do that then we don't even need create_ah_ex and query_port_ex
- those function seem to only be required to support this wrapper
technique.

So please rethink how this flows.. Maybe wrapping is not the best
choice??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
