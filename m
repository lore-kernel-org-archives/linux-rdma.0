From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libibverbs v5 3/7] livibverbs: Add support for XRC SRQs
Date: Mon, 03 Jun 2013 16:05:44 -0500
Message-ID: <51AD0528.6000900@opengridcomputing.com>
References: <1364332466-22786-1-git-send-email-sean.hefty@intel.com> <1364332466-22786-4-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364332466-22786-4-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/26/2013 4:14 PM, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> XRC support requires the use of a new type of SRQ.
>
> XRC shared receive queues: xrc srq's are similar to normal
> srq's, except that they are bound to an xrcd, rather
> than to a protection domain.  Based on the current spec
> and implementation, they are only usable with xrc qps.  To
> support xrc srq's, we define a new srq_init_attr structure
> to include an srq type and other needed information.
>
> The kernel ABI is also updated to allow creating extended
> SRQs.

<snip>

> @@ -746,11 +770,15 @@ struct ibv_context {
>   
>   enum verbs_context_mask {
>   	VERBS_CONTEXT_XRCD	= 1 << 0,
> -	VERBS_CONTEXT_RESERVED	= 1 << 1
> +	VERBS_CONTEXT_SRQ	= 1 << 1,
> +	VERBS_CONTEXT_RESERVED	= 1 << 2
>   };

Would VERBS_CONTEXT_XSRQ or VERBS_CONTEXT_SRQ_EX be more clear?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
