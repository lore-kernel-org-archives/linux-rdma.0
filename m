From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V8 libibverbs 1/7] Infrastructure to support verbs
 extensions
Date: Wed, 31 Jul 2013 10:52:05 -0600
Message-ID: <20130731165205.GC27845@obsidianresearch.com>
References: <1374741488-30895-1-git-send-email-yishaih@mellanox.com>
 <1374741488-30895-2-git-send-email-yishaih@mellanox.com>
 <20130725171408.GA17616@obsidianresearch.com>
 <51F268B1.9040003@dev.mellanox.co.il>
 <20130729233056.GB4439@obsidianresearch.com>
 <51F821A3.1010507@dev.mellanox.co.il>
 <20130730221548.GA14439@obsidianresearch.com>
 <51F8BC4A.5010102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F8BC4A.5010102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 31, 2013 at 10:27:06AM +0300, Yishai Hadas wrote:

>     Looking around ibv_context usage, it's used as non const input,
> in that case we can have only one version which takes non-const
> input and return non-const one, preventing any silent casting as
> below, can we agree on ?

Fair enough.

Why are you so against the inline version?

>     Are you fine with below definition ? any other () needed ?
> 
>   #define verbs_set_ctx_op(_vctx, op, ptr) ({ \
>        struct verbs_context *vctx = _vctx; \
>        if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
>                vctx->op = ptr; })

This looks fine

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
