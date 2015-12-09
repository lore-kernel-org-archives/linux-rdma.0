From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Tue, 8 Dec 2015 19:52:03 -0500
Message-ID: <20151209005203.GD16976@phlsvsds.ph.intel.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com> <566753E3.9060301@redhat.com> <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com> <20151208225940.GB27609@obsidianresearch.com> <20151208230244.GA10701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208230244.GA10701-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 03:02:44PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 08, 2015 at 03:59:40PM -0700, Jason Gunthorpe wrote:
> > Or, can we please stop this bikeshedding. Christoph's patch is done,
> > well tested and does a lot more clean up that this hacky three liner.
> > 
> > It is a good patch, and although patchworks doesn't have my remarks
> > from an earlier revision I still think it should go forward. 
> 
> While I'd prefer the version Or points to over not having anything
> at all I'd much prefer sorting it properly and make the RDMA code
> behave like all other Linux subsystems.
> 
> Jason, can you give me a formal ACK'ed by and I'll rebase it on top
> of the current 4.4 queue so we could start the 4.5 window with it.

Searching patchworks...

I'm a bit worried about the size of the patch and I would like to see it split
up for review.  But I agree Christophs method is better long term.

Christoph do you have this on github somewhere?  Perhaps it is split but I'm
not finding in on patchworks?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
