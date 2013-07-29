From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs
 extensions
Date: Mon, 29 Jul 2013 17:30:56 -0600
Message-ID: <20130729233056.GB4439@obsidianresearch.com>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com>
 <1374741488-30895-2-git-send-email-yishaih@mellanox.com>
 <20130725171408.GA17616@obsidianresearch.com>
 <51F268B1.9040003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F268B1.9040003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 26, 2013 at 03:16:49PM +0300, Yishai Hadas wrote:

> >>+{
> >>+	return (ctx->abi_compat != ((uint8_t *)NULL) - 1) ?
> >                                ^^^^^^^^^^^^^^^^^^^^^^
> >
> >Should this be a constant? __VERBS_ABI_IS_EXTENDED or something?
>     Can you clarify your suggestion here ?

I was thinking:

static const void *__VERBS_ABI_IS_EXTENDED = (uint8_t *)NULL) - 1;

> >>+	struct verbs_context *vctx = verbs_get_ctx(ctx); \
> >            ^^^^ const
> >>+	(!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct verbs_context, op)) || \
> >>+	 !vctx->op) ? NULL : vctx; })
> >An inline would be nicer, it will let the compiler merge these when
> >using -Os.
> >
> >static inline const struct verbs_context *__verbs_get_ctx_op(const struct ibv_context *ctx, size_t off)
> >{
> >     const struct verbs_context *vctx = verbs_get_ctx(ctx);
> >     if (vctx && vctx->sz < sizeof(*vctx) - off && *(void **)((uint8_t *)vctx + off))
> >         return vctx;
> >     return null
> >}
> >#define verbs_get_ctx_op(ctx, op) __verbs_get_ctx_op(ctx, offsetof(struct verbs_context, op))
> >
> >This also solves the problems the macro has with missing ()
>     Which problems you refer to with missing () ?

Looks like only verbs_set_ctx_op had some missing (), verbs_get_ctx is fine.

> >Otherwise this appears to be as we discussed and agreed last year, so
> >you can add my Ack to this patch.
>     Thanks, any other input on V8 series ?

I haven't looked at the XRC elements, I am not too familiar with XRC.

Hopefully Roland will comment on this patch so things can progress.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
