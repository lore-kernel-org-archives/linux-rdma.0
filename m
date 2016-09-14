From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Versioning scheme for rdma-plumbing
Date: Wed, 14 Sep 2016 15:53:35 -0400
Message-ID: <20160914195335.GC8644@redhat.com>
References: <20160914044745.GB7975@obsidianresearch.com>
 <20160914122820.GA32048@infradead.org>
 <20160914173327.GJ16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914173327.GJ16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 11:33:27AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 14, 2016 at 05:28:20AM -0700, Christoph Hellwig wrote:
> > Hi Jason,
> > 
> > thanks for the writeup.  Versioning is always a bit of a bikeshedding
> > exercise, but I'd still vote for following the kernel versioning (while
> > fully agreeing with your thiughts on shared library versioning).
> 
> I'm having a hard time preferring one choice over the other.
> 
> If we use the kernel version then the shlibs will progress like:
> 
>  libibverbs1 1.2.4.8-1
>  libibverbs1 1.3.4.9-1
> 
> I don't see a problem with that, even if it does look a bit strange.
> 
> > Two reasons for that:
> > 
> >  - it's a good marker of what version of the userspace code you need
> >    to take advtantage of new kernel features
> 
> Most users are running EL distros and their kernels are full of
> backports. So the number doesn't help them. Perhaps it could help the
> distros?

It's actually useful. We tend to backport "up to kernel v4.x", so the
kernelspace drivers would match up well enough with the libibverbs with a
version number matching that. We actually have one userspace glue thing
that Doug mentioned earlier, which uses exactly that scheme for it's
versioning.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
