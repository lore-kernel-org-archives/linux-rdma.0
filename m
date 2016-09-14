From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Versioning scheme for rdma-plumbing
Date: Wed, 14 Sep 2016 11:33:27 -0600
Message-ID: <20160914173327.GJ16014@obsidianresearch.com>
References: <20160914044745.GB7975@obsidianresearch.com>
 <20160914122820.GA32048@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914122820.GA32048-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 05:28:20AM -0700, Christoph Hellwig wrote:
> Hi Jason,
> 
> thanks for the writeup.  Versioning is always a bit of a bikeshedding
> exercise, but I'd still vote for following the kernel versioning (while
> fully agreeing with your thiughts on shared library versioning).

I'm having a hard time preferring one choice over the other.

If we use the kernel version then the shlibs will progress like:

 libibverbs1 1.2.4.8-1
 libibverbs1 1.3.4.9-1

I don't see a problem with that, even if it does look a bit strange.

> Two reasons for that:
> 
>  - it's a good marker of what version of the userspace code you need
>    to take advtantage of new kernel features

Most users are running EL distros and their kernels are full of
backports. So the number doesn't help them. Perhaps it could help the
distros?

>  - it allows for much smoother minor updates.  I hope this will be
>    rare, but my experience from various projects tells me that they
>    will occasionally be needed.

Can you explain this some more?

If we use a single integer ala udev, I'd see minor updates, LTS
branch, etc being released with a suffix eg: 123.2

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
