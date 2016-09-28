From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] ccan: Add CCAN min and max functionality
Date: Wed, 28 Sep 2016 10:18:25 -0600
Message-ID: <20160928161825.GA22668@obsidianresearch.com>
References: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
 <1475076789-14359-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475076789-14359-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 06:33:06PM +0300, Yishai Hadas wrote:

> +publish_internal_headers(ccan
> +  minmax.h
> +  build_assert.h
> +  config.h
> +  )

Please keep these lists in cmakefiles sorted everywhere, in every
patch.

> diff --git a/ccan/config.h b/ccan/config.h
> new file mode 100644
> index 0000000..b89ac94
> +++ b/ccan/config.h
> @@ -0,0 +1,2 @@
> +#define HAVE_STATEMENT_EXPR 1
> +#define HAVE_TYPEOF 1

This is going to get confusing, ditch this and just put those lines in
buildlib/config.h.in

I think you'll need to add a header sentinal to config.h.in to guard
against multiple inclusion, I forgot apparently.

> +#if HAVE_BUILTIN_TYPES_COMPATIBLE_P

Add to config.h.in

> +++ b/ccan/build_assert.h
> @@ -0,0 +1,40 @@
> +/* CC0 (Public domain) - see LICENSE file for details */

Each patch also needs to add the appropriate COPYING/LICENSE files to ccan/

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
