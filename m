From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Versioning scheme for rdma-plumbing
Date: Thu, 15 Sep 2016 07:05:42 +0200
Message-ID: <1473915942.3545.126.camel@oracle.com>
References: <20160914044745.GB7975@obsidianresearch.com>
         <20160914122820.GA32048@infradead.org>
         <20160914173327.GJ16014@obsidianresearch.com>
         <20160914195335.GC8644@redhat.com>
         <20160914203204.GA14548@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914203204.GA14548-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-09-14 at 14:32 -0600, Jason Gunthorpe wrote:
> On Wed, Sep 14, 2016 at 03:53:35PM -0400, Jarod Wilson wrote:
> 
> > It's actually useful. We tend to backport "up to kernel v4.x", so the
> > kernelspace drivers would match up well enough with the libibverbs with a
> > version number matching that. We actually have one userspace glue thing
> > that Doug mentioned earlier, which uses exactly that scheme for it's
> > versioning.
> 
> Humm to be clear, it would be more like '4.9 works with at least
> kernel 4.9, but may not enable all features'. So you might still end
> up using the 4.10 release to go with your backported 4.9 patches, for
> example.
> 
> Perhaps that is the strongest argument not to use this versioning
> scheme as it encourages artificial rushing to hit an arbitary version
> number.. (as Greg KH complains about with the stable kernels)
> 
> Then again, perhaps we shouldn't be accepting the kernel side of
> something if the user side isn't ready??

I think it is important to realize that the version numbering itself 
affects how people not intimately involved perceive stability and compatibility
of the versioned component.

I think if we go for a tie to the kernel version, people will expect versions 
to match kernel version, with pressure to update the (major) versions
even when content or API has not changed significantly. 

If on the other hand a separate versioning scheme is kept, the version numbering
will end up closer reflecting the intrusiveness of the actual changes made. 

Based on this reasoning, I'd definitely vote for the separate versioning.

Thanks,
Knut

> 
> Unclear..
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
