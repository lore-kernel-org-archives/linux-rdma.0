From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
	calls
Date: Wed, 7 Jul 2010 12:52:57 -0600
Message-ID: <20100707185257.GJ4630@obsidianresearch.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1278527821-14804-1-git-send-email-sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 07, 2010 at 11:37:01AM -0700, Steven Dake wrote:
> From: Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
> 
> The readdir POSIX api is not thread safe.  This presents problems in
> multithreaded programs that use the libibverbs APIs.  This patch has been
> tested with a libibverbs application (http://www.corosync.org) on
> Mellanox MT26428 cards.

Well, that isn't true on glibc.

The buffer returned by readdir() is stored in the DIR * and is
allocated during opendir().
 
The only time you hit thread safety issues is if multiple threads
attempt to use the same DIR at once - glibc has internal locking to
protect the DIR, but the buffer would be re-used.

Since libibverbs doesn't pass the DIR * between threads this usage is
safe.

It isn't entirely clear to me if POSIX definition of readdir as
non-rentrant applies to the general case or to the specific case I
discuss above. Certainly, any implementation can do as glibc does and
allocate the buffer in the DIR *.

But, you surely could not have seen a bug on Linux that was caused by
this - so why was this patch prepared?

BTW, POSIX also says that NAME_MAX is optional, so you have traded one
unlikely portability problem for another unlikely portability problem :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
