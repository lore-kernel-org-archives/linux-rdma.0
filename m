From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
	calls
Date: Wed, 7 Jul 2010 14:47:12 -0600
Message-ID: <20100707204712.GK4630@obsidianresearch.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com> <20100707185257.GJ4630@obsidianresearch.com> <4C34D208.1000705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C34D208.1000705-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 07, 2010 at 12:14:16PM -0700, Steven Dake wrote:

>> But, you surely could not have seen a bug on Linux that was caused by
>> this - so why was this patch prepared?

> We redefine all the non-thread-safe posix calls in our package (such as  
> readdir) to assert(0).  This prevents their usage in our app.  The  
> reason we do this is to prevent plugin developers from writing plugins  
> that use non-thread-safe posix APIs.  Our app is portable, where the  
> glibc semantics you describe above are not present.  POSIX is blank on  
> this issue, and was addressed in readdir_r.

Well, if you are already creating wrappers, wouldn't it be better to
provide wrappers that provide the glibc functionality on platforms you
port to that don't already do that, rather than forbid a perfectly
functional, and thread safe, call?

FWIW, I've always considered readdir_r to be broken, you pass in a
buffer without passing in a size and hope everything works out. Your
proposed patch to libibverbs is also not-portable because it uses
NAME_MAX, not pathconf.. Sigh POSIX.

I guess, as a general question, do you know of any libc
implementations that actually use a static buffer for readdir and
would require readdir_r to function properly?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
