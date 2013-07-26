From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs extensions
Date: Fri, 26 Jul 2013 15:16:49 +0300
Message-ID: <51F268B1.9040003@dev.mellanox.co.il>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com> <1374741488-30895-2-git-send-email-yishaih@mellanox.com> <20130725171408.GA17616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130725171408.GA17616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/25/2013 8:14 PM, Jason Gunthorpe wrote:
> On Thu, Jul 25, 2013 at 11:38:02AM +0300, Yishai Hadas wrote:
>
>> +#ifndef container_of
>> +/**
>> +  * container_of - cast a member of a structure out to the containing structure
>> +  * @ptr:        the pointer to the member.
>> +  * @type:       the type of the container struct this is embedded in.
>> +  * @member:     the name of the member within the struct.
>> +  *
>> + */
>> +#define container_of(ptr, type, member) \
>> +	((type *) ((char *)(ptr) - offsetof(type, member)))
>                   ^^^^^^^^^^^^
>
> This should be 'uint8_t'
>
>> +#define vext_field_avail(type, fld, sz) (offsetof(type, fld) < (sz))
> This is never used? Should it be? Ditch it?
     It's used in further patches of libibverbs, please have a look at: 
ibv_cmd_create_qp_ex, ibv_cmd_create_srq_ex, etc.
>
>> +static inline struct verbs_context *verbs_get_ctx(
>> +					const struct ibv_context *ctx)
>                    ^^^^^^^^^^^^^
> const goes in, const goes out. Should be:
>
> static inline const struct verbs_context *verbs_get_ctx(const struct ibv_context *ctx)
>
>> +{
>> +	return (ctx->abi_compat != ((uint8_t *)NULL) - 1) ?
>                                 ^^^^^^^^^^^^^^^^^^^^^^
>
> Should this be a constant? __VERBS_ABI_IS_EXTENDED or something?
     Can you clarify your suggestion here ?
>
>> +#define verbs_get_ctx_op(ctx, op) ({ \
>> +	struct verbs_context *vctx = verbs_get_ctx(ctx); \
>             ^^^^ const
>> +	(!vctx || (vctx->sz < sizeof(*vctx) - offsetof(struct verbs_context, op)) || \
>> +	 !vctx->op) ? NULL : vctx; })
> An inline would be nicer, it will let the compiler merge these when
> using -Os.
>
> static inline const struct verbs_context *__verbs_get_ctx_op(const struct ibv_context *ctx, size_t off)
> {
>      const struct verbs_context *vctx = verbs_get_ctx(ctx);
>      if (vctx && vctx->sz < sizeof(*vctx) - off && *(void **)((uint8_t *)vctx + off))
>          return vctx;
>      return null
> }
> #define verbs_get_ctx_op(ctx, op) __verbs_get_ctx_op(ctx, offsetof(struct verbs_context, op))
>
> This also solves the problems the macro has with missing ()
     Which problems you refer to with missing () ?
>
>> +#define verbs_set_ctx_op(vctx, op, ptr) ({ \
>> +	if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
>> +		vctx->op = ptr; })
> Lots of missing (), and no type check on vctx. This is better and
> centralizes the tricky check into __verbs_get_ctx_op:
>
> #define verbs_set_ctx_op(vctx, op, ptr) ({ \
>     struct verbs_context *__vctx = (struct verbs_context *)verbs_get_ctx_op((vctx)->context, op); \
>     if (__vctx) __vctx->op = ptr; })
>
>> +		context_ex->context.abi_compat  = ((uint8_t *)NULL) - 1;
>                                                  ^^^^^^^^^^^^^^^^^^^^^^
> Constant?
>
> Otherwise this appears to be as we discussed and agreed last year, so
> you can add my Ack to this patch.
     Thanks, any other input on V8 series ?
>
> Please confirm you have done testing with extending and shrinking
> verbs_context to test that verbs_get_ctx_op truely works properly.
     Already did, will do further testing after adapting to your 
suggestions above.
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
