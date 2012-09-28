From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 3/7] libibverbs: Add support for XRC SRQs
Date: Thu, 27 Sep 2012 18:42:05 -0600
Message-ID: <20120928004205.GB21759@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A97DCA@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A97DCA-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 28, 2012 at 12:02:34AM +0000, Hefty, Sean wrote:

> +static inline uint32_t ibv_get_srq_num(struct ibv_srq *srq)
> +{
> +	struct verbs_context *vctx = verbs_get_ctx_op(srq->context, get_srq_num);
> +	if (!vctx) {
> +		errno = ENOSYS;
> +		return 0;
> +	}
> +	return vctx->get_srq_num(srq);
> +}

Do you think the function pointer indirection for ibv_get_srq_num is
needed? I had thought something like:

static inline uint32_t ibv_get_srq_num(struct ibv_srq *srq)
{
       /* NOTE: we could assume has_comp_mask always exists and optimize
          out the macro's test on size. */
       struct verbs_context *vctx = verbs_get_ctx_op(srq->context, has_comp_mask);
       if (vctx &&
           (vctx->has_comp_mask | SRQ_COMP_MASK) &&
           ((__verbs_srq *)srq->comp_mask & VERBS_SRQ_NUM))
	      return ((__verbs_srq *)srq)->srq_num;

       errno = ENOSYS;
       return 0;
}

Where has_comp_mask is a bitmask from the provider with each bit
indicating if a provider allocated structure is extended with
comp_mask. The driver is required to allocate all structures of that
type with a comp_mask if the bit is set.

This mechanism would be setup in your patch 1 to support all provider
allocated structures.

__verbs_srq to keep 'verbs_srq' out of the user namespace and
discourage direct use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
