From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Versioning scheme for rdma-plumbing
Date: Thu, 15 Sep 2016 10:02:23 -0600
Message-ID: <20160915160223.GB18154@obsidianresearch.com>
References: <20160914044745.GB7975@obsidianresearch.com>
 <20160914122820.GA32048@infradead.org>
 <20160914173327.GJ16014@obsidianresearch.com>
 <20160915061509.GB4869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915061509.GB4869-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 11:15:09PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 14, 2016 at 11:33:27AM -0600, Jason Gunthorpe wrote:
> > >  - it allows for much smoother minor updates.  I hope this will be
> > >    rare, but my experience from various projects tells me that they
> > >    will occasionally be needed.
> > 
> > Can you explain this some more?
> > 
> > If we use a single integer ala udev, I'd see minor updates, LTS
> > branch, etc being released with a suffix eg: 123.2
> 
> Well, that's not a monotonically increasing version number anymore.
> And at least in the past systemd folks argued against even doing these
> releases.  If you're fine with doing minor releases off these single
> component versions this argument goes away of course.

Yah, I wouldn't as strict as what you are describing.

The 'single integer' is really semantic versioning with the 'MAJOR'
stripped off, since a project goal is to not make incompatable
changes.

Most upstream releases should be of the 'add functionality in a
backwards-compatible manner' and should just increment the
integer. Upstream can always increment the integer

If upstream botches a release then it might make a quick 123.1, but
generally upstream would not be in the buisness of backporting fixes
from N to N-1.

*However* I think we should make room for the people to collaborate
on a LTS branch that would use the .X nomenclature. Much like in the
kernel Linus doesn't maintain the -stable, but makes space for the
people who do.

eg perhaps the OFED team would be willing to direct their energies
upstream and maintain a public stable branch for the duration of their
release cylce ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
