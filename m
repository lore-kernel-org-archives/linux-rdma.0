From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: sparse fixes, part2
Date: Fri, 14 Oct 2016 07:31:59 +0200
Message-ID: <20161014053159.GA8255@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de> <20161014040602.GA5726@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014040602.GA5726-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 10:06:02PM -0600, Jason Gunthorpe wrote:
> Though, I had to use '#pragma GCC diagnostic ignored
> "-Wmissing-prototypes"' to deal with the symver stuff.. Couldn't find
> a better way..

I was planning on adding a header to define them just to shut up
sparse.  This is one of the bigger sets or remaining warnings, the
other beeing pthread macros abusing 0 as NULL (probably unfixable by us),
direct use of __sync_* builting (we should move over to C99 atomics or
something similar) nad various misc issues.  But as non of them are trivial
I didn't want to send that with the patch bomb.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
