From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs
 extensions
Date: Thu, 25 Jul 2013 11:14:08 -0600
Message-ID: <20130725171408.GA17616@obsidianresearch.com>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com>
 <1374741488-30895-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1374741488-30895-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 25, 2013 at 11:38:02AM +0300, Yishai Hadas wrote:

> +#ifndef container_of
> +/**
> +  * container_of - cast a member of a structure out to the containing structure
> +  * @ptr:        the pointer to the member.
> +  * @type:       the type of the container struct this is embedded in.
> +  * @member:     the name of the member within the struct.
> +  *
> + */
> +#define container_of(ptr, type, member) \
> +	((type *) ((char *)(ptr) - offsetof(type, member)))
                 ^^^^^^^^^^^^

This should be 'uint8_t'

> +#define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))

This is never used? Should it be? Ditch it?

> +static inline struct verbs_context *verbs_get_ctx(
> +					const struct ibv_context *ctx)
                  ^^^^^^^^^^^^^
const goes in, const goes out. Should be:

static inline const struct verbs_context *verbs_get_ctx(const struct ibv_context *ctx)

> +{
> +	return (ctx->abi_compat != ((uint8_t *)NULL) - 1) ?
                               ^^^^^^^^^^^^^^^^^^^^^^

Should this be a constant? __VERBS_ABI_IS_EXTENDED or something?

> +#define verbs_get_ctx_op(ctx, op) ({ \
> +	struct verbs_context *vctx = verbs_get_ctx(ctx); \
           ^^^^ const
> +	(!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct verbs_context, op)) || \
> +	 !vctx->op) ? NULL : vctx; })

An inline would be nicer, it will let the compiler merge these when
using -Os.

static inline const struct verbs_context *__verbs_get_ctx_op(const struct ibv_context *ctx, size_t off)
{
    const struct verbs_context *vctx = verbs_get_ctx(ctx);
    if (vctx && vctx->sz < sizeof(*vctx) - off && *(void **)((uint8_t *)vctx + off))
        return vctx;
    return null
}
#define verbs_get_ctx_op(ctx, op) __verbs_get_ctx_op(ctx, offsetof(struct verbs_context, op))

This also solves the problems the macro has with missing ()

> +#define verbs_set_ctx_op(vctx, op, ptr) ({ \
> +	if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
> +		vctx->op = ptr; })

Lots of missing (), and no type check on vctx. This is better and
centralizes the tricky check into __verbs_get_ctx_op:

#define verbs_set_ctx_op(vctx, op, ptr) ({ \
   struct verbs_context *__vctx = (struct verbs_context *)verbs_get_ctx_op((vctx)->context, op); \
   if (__vctx) __vctx->op = ptr; })

> +		context_ex->context.abi_compat  = ((uint8_t *)NULL) - 1;
                                                ^^^^^^^^^^^^^^^^^^^^^^
Constant?

Otherwise this appears to be as we discussed and agreed last year, so
you can add my Ack to this patch.

Please confirm you have done testing with extending and shrinking
verbs_context to test that verbs_get_ctx_op truely works properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
