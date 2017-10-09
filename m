From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon, 9 Oct 2017 13:11:01 -0600
Message-ID: <20171009191101.GC15336@obsidianresearch.com>
References: <20171009081717.21478-1-leon@kernel.org>
 <20171009154104.GA3824@obsidianresearch.com>
 <20171009190519.GD1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009190519.GD1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 09, 2017 at 10:05:19PM +0300, Leon Romanovsky wrote:

> It means that your glibc is new enough.
> On some systems, the stdint.h contains the following ifdef to protect UINTPTR_MAX
> "#if !defined __cplusplus || defined __STDC_LIMIT_MACROS"

Ah, that old thing. __STDC_LIMIT_MACROS is removed from the latest
standards, and IIRC, including cstdint isn't even enough to reliably
get the macros under the old standards.

The commit comment should describe the problem in these terms..

So this is the best fix:

> > #ifdef __cplusplus
> > #include <limits>
> > #define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
> > #else
> > #define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
> > #endif

Because numeric_limits is never subject to __STDC_LIMIT_MACROS

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
