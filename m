From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon, 9 Oct 2017 09:41:04 -0600
Message-ID: <20171009154104.GA3824@obsidianresearch.com>
References: <20171009081717.21478-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009081717.21478-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 09, 2017 at 11:17:17AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The commit 983f80191923 ("verbs: fix compilation error with ICC") fixed
> warning by using UINTPTR_MAX, however such change breaks compilation
> of C++ applications.
> 
> In C++ world, the UINTPTR_MAX is declared in <cstdint> and not stdint.h,
> so in order to avoid messing with various defines to decide which
> header

I don't think this statement is right. In C++ land the 'cXXX' headers
and the 'XXX.h' headers are usually the same. On my system I see
nothing that would cause stdint.h to not define the macros in C++ mode:

$ echo t.cc
#include <stdint.h>

enum {foo = UINTPTR_MAX};

$ g++-5 -c -Wall t.cc

So, what environment fails here? It should be described in the
commit message..

The best fix is something like this:

#ifdef __cplusplus
#include <limits>
#define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
#else
#define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
#endif

The static in a header file also a mistake.

Using <cstdint> is a bit risky since it is a c++11 header and may not
be in some of the older distros we still support.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
