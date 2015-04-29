From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix unaligned accesses
Date: Wed, 29 Apr 2015 15:51:23 -0600
Message-ID: <20150429215123.GA29809@obsidianresearch.com>
References: <1430340983-12538-1-git-send-email-david.ahern@oracle.com>
 <20150429211822.GA25951@obsidianresearch.com>
 <55414C03.40902@oracle.com>
 <20150429213042.GA28812@obsidianresearch.com>
 <55414F4E.5020209@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55414F4E.5020209-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 29, 2015 at 03:38:22PM -0600, David Ahern wrote:

> >And dealing with the fairly few resulting changes..
> 
> Confused. That does not deal with the alignment problem. Internal to
> cm_mask_copy unsigned longs are used (8-bytes), so why change the
> signature to u32?

You'd change the loop stride to by u32 as well.

This whole thing is just an attempted optimization, but doing copy and
mask 8 bytes at a time on unaligned data is not very efficient, even
on x86.

So either drop the optimization and use u8 as the stride.

Or keep the optimization and guarentee alignment, the best we can do
is u32.

Since this is an optimization, get_unaligned should be avoided,
looping over u8 would be faster.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
