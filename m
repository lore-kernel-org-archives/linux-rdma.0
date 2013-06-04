From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v6 3/7] livibverbs: Add support for XRC SRQs
Date: Tue, 4 Jun 2013 14:48:59 -0600
Message-ID: <20130604204859.GA30182@obsidianresearch.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
 <1370371791-15018-4-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370371791-15018-4-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2013 at 11:49:47AM -0700, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

>  enum verbs_context_mask {
>  	VERBS_CONTEXT_XRCD	= 1 << 0,
> -	VERBS_CONTEXT_RESERVED	= 1 << 1
> +	VERBS_CONTEXT_SRQ	= 1 << 1,
> +	VERBS_CONTEXT_RESERVED	= 1 << 2
>  };

Why is _RESERVED being re-numbered here? That worries me..

For that matter, what is it for?

Frankly, I would ditch mask for verbs_context op members and other
structures that are size based. What does it mean if the size includes
get_srq_num, but VERBS_CONTEXT_SRQ is 0 and *get_srq_num is
null/non-null?

Simpler rule: If the size says the entry is there, then it is
there.

Reserve mask for some other future use.

> +static inline uint32_t ibv_get_srq_num(struct ibv_srq *srq)
> +{
> +	struct verbs_context *vctx = verbs_get_ctx_op(srq->context, get_srq_num);
> +	if (!vctx) {
> +		errno = ENOSYS;
> +		return 0;
> +	}
> +	return vctx->get_srq_num(srq);

Might want to stream line this flow a bit:

static inline struct verbs_context *__verbs_get_ctx_op(struct ibv_context *context,
                                                       size_t op)
{
       struct verbs_context *vctx = verbs_get_ctx(ctx);
       if (vctx && vctx->sz >= sizeof(*vctx) - op &&
           *((void **)vctx + op) != NULL)
         return vctx;
       errno = ENOSYS;
       return NULL;
}
#define verbs_get_ctx_op(ctx, op) __verbs_get_ctx_op(ctx, offsetof(struct verbs_context, op))

static inline uint32_t ibv_get_srq_num(struct ibv_srq *srq)
{
	struct verbs_context *vctx = verbs_get_ctx_op(srq->context,get_srq_num);
	if (!vctx)
	     return 0;
	return vctx->get_srq_num(srq);
}

> diff --git a/src/libibverbs.map b/src/libibverbs.map
> index c190eb9..00f9062 100644
> +++ b/src/libibverbs.map
> @@ -103,4 +103,6 @@ IBVERBS_1.1 {
>  
>  		ibv_cmd_open_xrcd;
>  		ibv_cmd_close_xrcd;
> +		ibv_cmd_create_srq_ex;
> +		
>  } IBVERBS_1.0;

Hum, so drivers that implement XRC will need to be paired with a new
verbs... Bit disappointing, did we want to try and address that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
