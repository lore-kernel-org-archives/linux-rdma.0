From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Wed, 9 Dec 2015 20:45:56 -0500
Message-ID: <20151210014556.GA32059@phlsvsds.ph.intel.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com> <566753E3.9060301@redhat.com> <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com> <20151208225940.GB27609@obsidianresearch.com> <20151208230244.GA10701@infradead.org> <20151209005203.GD16976@phlsvsds.ph.intel.com> <20151209184235.GB4522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209184235.GB4522-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 10:42:35AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 08, 2015 at 07:52:03PM -0500, ira.weiny wrote:
> > Searching patchworks...
> > 
> > I'm a bit worried about the size of the patch and I would like to see it split
> > up for review.  But I agree Christophs method is better long term.
> 
> I'd be happy to split it up if I could see a way to split it.  So if
> anyone has an idea you're welcome!

Well this is a ~3300 line patch which is pretty hard to review in total.

> 
> > Christoph do you have this on github somewhere?  Perhaps it is split but I'm
> > not finding in on patchworks?
> 
> No need for github, we have much better (and older) git hosting sites :)
> 
> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/ib_device_attr

Another nice side effect of this patch is to get rid of all the struct
ib_device_attr allocations which are littered all over the ULPs.

For the core, srp, ipoib, qib, hfi1 bits.  Generally the rest looks fine I just
did not have time to really go through it line by line.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Doug this is going to conflict with the rdmavt work.  So if you take this could
you respond on the list.

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
