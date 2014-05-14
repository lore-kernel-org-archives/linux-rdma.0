From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs] Align Flow Steering API to the extension
 verbs scheme
Date: Wed, 14 May 2014 10:08:04 -0600
Message-ID: <20140514160804.GC6253@obsidianresearch.com>
References: <1400075090-14296-1-git-send-email-ogerlitz@mellanox.com>
 <1400075090-14296-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400075090-14296-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 14, 2014 at 04:44:50PM +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The receive flow steering API didn't conform with the extension
> verbs:
> 1. It introduced VERBS_CONTEXT_CREATE_FLOW and
>    VERBS_CONTEXT_DESTROY_FLOW, even though the structures
>    aren't allocated by the provider.

"even though the structures aren't allocated by the provider"
is not the reason..

1. VERBS_CONTEXT_CREATE_FLOW/VERBS_CONTEXT_DESTROY_FLOW mis
   uses 'has_comp_mask' which is supposed to indicate if a legacy
   structure is extended or not. It does not indicate the presence
   of a function call

BTW, I see now that libmlx4 was never updated to set these values
(???)  so I think we can actually just drop them instead of adding
RESERVED, since they were never written or read.

>  	struct verbs_context *vctx = verbs_get_ctx_op(qp->context,
> -						      lib_ibv_create_flow);
> -	if (!vctx || !vctx->lib_ibv_create_flow)
> +						      create_flow);
> +	if (!vctx)
>  		return NULL;


Right, that 2nd test for lib_ibv_create flow was redundant.

Should errno be set here? I've forgotton what we settled on :|

No matter what, errno will be set by the kernel and leak out of the
provider call.

It feels broken that there are multiple failure modes to the call and
now way for the user to tell them apart.

.. and the man page should talk about errno if it is actually part of
the API.

>  /**
> diff --git a/man/ibv_create_flow.3 b/man/ibv_create_flow.3
> new file mode 100644
> index 0000000..f7c767e
> +++ b/man/ibv_create_flow.3
> @@ -0,0 +1,86 @@
> +.TH IBV_CREATE_FLOW 3 2013-08-21 libibverbs "Libibverbs
> Programmer's Manual"

Christoph: can you, as a user of this API, give the man page a quick
read to check that it captures everything?

Otherwise, this looks good to me.

Reviewd-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks for taking care of this Or

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
