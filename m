From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 3/8] svcrdma: Add svc_rdma_get_context() API that is
 allowed to fail
Date: Mon, 23 Nov 2015 22:55:22 -0800
Message-ID: <20151124065522.GC29141@infradead.org>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net>
 <20151123222038.13040.61285.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123222038.13040.61285.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +struct svc_rdma_op_ctxt *svc_rdma_get_context_gfp(struct svcxprt_rdma *xprt,
> +						  gfp_t flags)
> +{
> +	struct svc_rdma_op_ctxt *ctxt;
> +
> +	ctxt = kmem_cache_alloc(svc_rdma_ctxt_cachep, flags);
> +	if (!ctxt)
> +		return NULL;
> +	svc_rdma_init_context(xprt, ctxt);
> +	return ctxt;
> +}
> +
> +struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)
> +{
> +	struct svc_rdma_op_ctxt *ctxt;
> +
> +	ctxt = kmem_cache_alloc(svc_rdma_ctxt_cachep,
> +				GFP_KERNEL | __GFP_NOFAIL);
> +	svc_rdma_init_context(xprt, ctxt);
>  	return ctxt;

Sounds like you should have just added a gfp_t argument to
svc_rdma_get_context.  And if we have any way to avoid the __GFP_NOFAIL
I'd really appreciate if we could give that a try.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
