From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs extensions
Date: Thu, 01 Aug 2013 19:01:34 +0300
Message-ID: <51FA865E.1000907@dev.mellanox.co.il>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com> <1374741488-30895-2-git-send-email-yishaih@mellanox.com> <20130725171408.GA17616@obsidianresearch.com> <51F268B1.9040003@dev.mellanox.co.il> <20130729233056.GB4439@obsidianresearch.com> <51F821A3.1010507@dev.mellanox.co.il> <20130730221548.GA14439@obsidianresearch.com> <51F8BC4A.5010102@dev.mellanox.co.il> <20130731165205.GC27845@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731165205.GC27845-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2013 7:52 PM, Jason Gunthorpe wrote:
> On Wed, Jul 31, 2013 at 10:27:06AM +0300, Yishai Hadas wrote:
>
>>      Looking around ibv_context usage, it's used as non const input,
>> in that case we can have only one version which takes non-const
>> input and return non-const one, preventing any silent casting as
>> below, can we agree on ?
> Fair enough.
     Thanks, will use as part of V9.
> Why are you so against the inline version?
     In V9 don't add them, macros are 2/3 lines code, seem to me 
redundant here.
     In addition verbs_get_ctx is inline so we partially have it.
>
>>      Are you fine with below definition ? any other () needed ?
>>
>>    #define verbs_set_ctx_op(_vctx, op, ptr) ({ \
>>         struct verbs_context *vctx = _vctx; \
>>         if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
>>                 vctx->op = ptr; })
> This looks fine
     Thanks, will use as part of V9.
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
