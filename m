From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Tue, 18 Jan 2011 11:01:29 -0700
Message-ID: <20110118180129.GH995@obsidianresearch.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
 <4D342510.80701@voltaire.com>
 <1295318783.3051.81.camel@obelisk.thedillows.org>
 <4D353E5E.2020500@voltaire.com>
 <1295353524.3051.121.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1295353524.3051.121.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 18, 2011 at 07:25:24AM -0500, David Dillow wrote:

> > Also when working with direct I/O from user space and/or under file-system,
> > did you really see many BIOs that can be merged? I was under the impression,
> > that (specifically after some time the system is active) for the most case, 
> > I get totally scattered SGs, whose pages can't be coalesced at all.
> 
> I would expect that to be a common case, but there are systems out there
> that this is not an issue. They typically allocate buffers early on when
> they can be contiguous, and just keep reusing those.

It has become really easy to use hugetlb now, you can just mmap
anonymous memory with MAP_HUGETLB and you get 2M pages. If an app is
using O_DIRECT it seem worth making an attempt to use huge pages..

IIRC databases are already doing this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
