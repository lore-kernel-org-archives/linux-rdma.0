From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V7 libmlx4 2/2] Add support for XRC QPs
Date: Thu, 11 Jul 2013 11:25:35 -0600
Message-ID: <20130711172535.GC27357@obsidianresearch.com>
References: <1373555264-1787-1-git-send-email-yishaih@mellanox.com>
 <1373555264-1787-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1373555264-1787-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 11, 2013 at 06:07:44PM +0300, Yishai Hadas wrote:

> +	if (sizeof(*verbs_ctx) -
> +	    offsetof(struct verbs_context,
> +		     close_xrcd) <= verbs_ctx->sz)
> +		verbs_ctx->close_xrcd = mlx4_close_xrcd;

please put a macro in libibverbs headers for this, all drivers will
require this tricky test. Eg:

  verbs_set_ctx_op(verbs_ctx, close_xrcd, mlx4_close_xrcd);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
