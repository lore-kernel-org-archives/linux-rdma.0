From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs extensions
Date: Wed, 31 Jul 2013 10:27:06 +0300
Message-ID: <51F8BC4A.5010102@dev.mellanox.co.il>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com> <1374741488-30895-2-git-send-email-yishaih@mellanox.com> <20130725171408.GA17616@obsidianresearch.com> <51F268B1.9040003@dev.mellanox.co.il> <20130729233056.GB4439@obsidianresearch.com> <51F821A3.1010507@dev.mellanox.co.il> <20130730221548.GA14439@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130730221548.GA14439-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2013 1:15 AM, Jason Gunthorpe wrote:
> On Tue, Jul 30, 2013 at 11:27:15PM +0300, Yishai Hadas wrote:
>
>> Can accept it, however as it's a const pointer may need some casting later
>> which is not fully clean.
> Drop the const from the definition then.
>
>>      Your suggestion for verbs_set_ctx_op can't not work as it calls internally
>> to verbs_get_ctx_op and will may fail as
>>      at that step function pointer was not set and *(void **)((uint8_t *)vctx +
>> off) will be NULL.
> Yes, that is too bad in that case, but the old macro is still flawed:
>
> +#define verbs_set_ctx_op(vctx, op, ptr) ({ \
> +       if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
> +               vctx->op = ptr; })
>
> - Missing () on all vctx usages
> - Missing type enforcement on vctx
>
> Something like this:
>
> #define verbs_set_ctx_op(_vctx, op, ptr) ({ \
>         struct verbs_context *vctx = _vctx; \
>         if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
>                 vctx->op = ptr; })
>
>>      In addition changing to use const as part of returning from
>> __verbs_get_ctx_op causes some necessary casting to non const in some places
>> which
>>      is not fully clean. (e.g. free((void *)context_ex); as part of
>> __ibv_close_device, verbs_ctx->has_comp_mask = VERBS_CONTEXT_XRCD |
>> VERBS_CONTEXT_SRQ |
>>                      VERBS_CONTEXT_QP; as part of mlx4_init_context)
> It is virtually impossible to do const-correctness fully and
> transparently in C, since the language has no feature to silently
> propogate the const.
>
> If you want to be 100% clean then provide a non-const version --
> verbs_get_ctx_nc that takes non-const input.
     Looking around ibv_context usage, it's used as non const input, in 
that case we can have only one version which takes non-const input and 
return
     non-const one, preventing any silent casting as below, can we agree 
on ?

static inline struct verbs_context *verbs_get_ctx(
                     struct ibv_context *ctx)
     {
     return (!ctx || (ctx->abi_compat != ((uint8_t *)NULL) - 1)) ?
         NULL : container_of(ctx, struct verbs_context, context);
     }

#define verbs_get_ctx_op(ctx, op) ({ \
     struct verbs_context *vctx = verbs_get_ctx(ctx); \
     (!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct 
verbs_context, op)) || \
     !vctx->op) ? NULL : vctx; })
>
> Functions that silently discard const are bad since it silently
> defeats static analysis around const.
>
>>      I recommend staying with V8 suggestion for both macros, in case
>> you think there is any problem with missing () for the set operation
>> please point on and may handle.
> Using the inline to help the -Os case is definitely desirable, and the
> fix to the () at least.
>   
     Will stay with the macro, improved to your suggestion above.
     Are you fine with below definition ? any other () needed ?

   #define verbs_set_ctx_op(_vctx, op, ptr) ({ \
        struct verbs_context *vctx = _vctx; \
        if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
                vctx->op = ptr; })

> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
