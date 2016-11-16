From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] ccan: Add likely implementation
Date: Wed, 16 Nov 2016 13:13:43 -0700
Message-ID: <20161116201343.GB19593@obsidianresearch.com>
References: <1479318011-26878-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479318011-26878-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 16, 2016 at 07:40:11PM +0200, Leon Romanovsky wrote:

> index b5de515..153426f 100644
> +++ b/ccan/CMakeLists.txt
> @@ -6,11 +6,13 @@ publish_internal_headers(ccan
>    minmax.h
>    str.h
>    str_debug.h
> +  likely.h
>    )
>  
>  set(C_FILES
>    list.c
>    str.c
> +  likely.c
>    )

Keep these lists sorted please

> +++ b/ccan/likely.c
> @@ -0,0 +1,136 @@
> +/* CC0 (Public domain) - see LICENSE file for details. */
> +#ifdef CCAN_LIKELY_DEBUG
> +#include <ccan/likely/likely.h>
> +#include <ccan/hash/hash.h>
> +#include <ccan/htable/htable_type.h>

Hmm, this isn't going to compile if the debug is set, maybe drop the
.c - but this seems really interesting to see if likely is being used
sensibly....

> +#ifndef CCAN_LIKELY_DEBUG
> +#if HAVE_BUILTIN_EXPECT

You need to add '#define HAVE_BUILTIN_EXPECT 1' to
buildlib/config.h.in - or this doesn't work at all.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
