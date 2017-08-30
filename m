From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Convert explicitly to signed char
Date: Wed, 30 Aug 2017 10:49:52 -0600
Message-ID: <20170830164952.GA9310@obsidianresearch.com>
References: <1504102764-21638-1-git-send-email-yishaih@mellanox.com>
 <1504102764-21638-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504102764-21638-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 30, 2017 at 05:19:24PM +0300, Yishai Hadas wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The 0x80 value is a canonical way to mark as not-used in intrinsics
> function calls.

This commit message is not good, try:

_mm_shuffle_epi8 requires 0x80 to set the output byte to zero, but
_mm_set_epi8() accepts char. If gcc is compiling in a configuration
with a signed char then it can produce a -Werror=overflow warning.

And this fix is wrong, since it just moves the warning to
configurations that have an unsigned char. (eg -funsigned-char)

It is really broken that the _mm_set_epi uses a char as input :|

I think you need to do this instead:

#include <limits.h>
#if CHAR_MIN < 0
#define SHUFFLE_IGNORE  -128
#else
#define SHUFFLE_IGNORE  0x80
#endif

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
