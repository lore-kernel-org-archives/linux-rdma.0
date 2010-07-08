From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r calls
Date: Thu, 08 Jul 2010 11:27:48 -0700
Message-ID: <adalj9lzv4r.fsf@roland-alpha.cisco.com>
References: <1278540873-3857-1-git-send-email-sdake@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278540873-3857-1-git-send-email-sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Steven
	Dake's message of "Wed, 7 Jul 2010 15:14:33 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The readdir POSIX api is not thread safe.  This presents problems in
 > multithreaded programs that use the libibverbs APIs.

So as discussed this is not true ... as far as I can see libibverbs only
calls readdir inside a mutex and so on all platforms where libibverbs
has even a chance of being applicable, the current code works fine.  The
real issue is that corosync defines a new environment where readdir is
not allowed.

I'm really not sure about this patch one way or another.  With alloca,
it ends up looking pretty clean, but we do introduce the tiny
possibility of buffer overrun (since readdir_r uses a user-supplied
buffer of poorly-specified size); the benefit is that we work within
corosync's constraints.  I honestly don't have a good feeling whether
the benefit exceeds the cost.

Jason, any opinion one way or another?

 > +#if HAVE_ALLOCA_H
 > +#include <alloca.h>
 > +#endif

Elsewhere we just include alloca.h unconditionally, and in fact I don't
see anything that would define HAVE_ALLOCA_H in the libibverbs tree.
Does this actually work?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
