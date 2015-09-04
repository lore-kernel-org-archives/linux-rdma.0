From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs] Fix create/destroy flow API
Date: Fri, 4 Sep 2015 15:32:26 -0600
Message-ID: <20150904213226.GB20758@obsidianresearch.com>
References: <9665e46a71940f2721b30fdb4aaa0853161babc9.1441401379.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9665e46a71940f2721b30fdb4aaa0853161babc9.1441401379.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 04, 2015 at 05:17:38PM -0400, Doug Ledford wrote:
> +		/*
> +		 * In order to maintain backward/forward binary compatibility
> +		 * with libmlx4-1.0.6, which has the original version of the
> +		 * flow steering patches, we need to set the two
> +		 * ABI_compat_placeholder entries to match the driver
> +		 * set flow entries.  This is because, in the specific instance
> +		 * of using libmlx4-1.0.6 with the fixed version of
> +		 * libibvberbs, the ibv_create_flow inline function already
> +		 * compiled into libmlx4-1.0.6 will be loooking in the
> +		 * ABI_placeholder spots for the function pointer to the
> +		 * create and destroy flow verbs.
>  		 */

This isn't quite the right comment, it has very little to do with mlx,
ibv_create_flow is the user entry point, the above applies to
everything linked to ibverbs.

My suggestion was to not change the ibverbs->user ABI at all and just
mangle the driver side, ie move the ABI_placeholder to what was drv_
instead of lib_.

Can't see anything wrong with it this way, off hand, other than the
comment.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
