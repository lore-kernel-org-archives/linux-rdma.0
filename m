From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs
 extensions
Date: Tue, 30 Jul 2013 16:15:48 -0600
Message-ID: <20130730221548.GA14439@obsidianresearch.com>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com>
 <1374741488-30895-2-git-send-email-yishaih@mellanox.com>
 <20130725171408.GA17616@obsidianresearch.com>
 <51F268B1.9040003@dev.mellanox.co.il>
 <20130729233056.GB4439@obsidianresearch.com>
 <51F821A3.1010507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F821A3.1010507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 30, 2013 at 11:27:15PM +0300, Yishai Hadas wrote:

> Can accept it, however as it's a const pointer may need some casting later
> which is not fully clean.

Drop the const from the definition then.

>     Your suggestion for verbs_set_ctx_op can't not work as it calls internally
> to verbs_get_ctx_op and will may fail as
>     at that step function pointer was not set and *(void **)((uint8_t *)vctx +
> off) will be NULL.

Yes, that is too bad in that case, but the old macro is still flawed:

+#define verbs_set_ctx_op(vctx, op, ptr) ({ \
+       if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
+               vctx->op = ptr; })

- Missing () on all vctx usages
- Missing type enforcement on vctx

Something like this:

#define verbs_set_ctx_op(_vctx, op, ptr) ({ \
       struct verbs_context *vctx = _vctx; \
       if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
               vctx->op = ptr; })

>     In addition changing to use const as part of returning from
> __verbs_get_ctx_op causes some necessary casting to non const in some places
> which
>     is not fully clean. (e.g. free((void *)context_ex); as part of
> __ibv_close_device, verbs_ctx->has_comp_mask = VERBS_CONTEXT_XRCD |
> VERBS_CONTEXT_SRQ |
>                     VERBS_CONTEXT_QP; as part of mlx4_init_context)

It is virtually impossible to do const-correctness fully and
transparently in C, since the language has no feature to silently
propogate the const.

If you want to be 100% clean then provide a non-const version --
verbs_get_ctx_nc that takes non-const input.

Functions that silently discard const are bad since it silently
defeats static analysis around const.

>     I recommend staying with V8 suggestion for both macros, in case
> you think there is any problem with missing () for the set operation
> please point on and may handle.

Using the inline to help the -Os case is definitely desirable, and the
fix to the () at least.
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
