From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 15:29:56 -0800
Message-ID: <20151210232956.GA26009@infradead.org>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <20151209184448.GC4522@infradead.org>
 <5669BA8E.30200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5669BA8E.30200-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 12:46:54PM -0500, Doug Ledford wrote:
> Organization.  Let's be fair, the totally flat namespace you are
> preferring is the equivalent of a teenager that is completely incapable
> of picking thier dirty laundry up off the floor.  It is sloppy,
> disorganized, often full of old cruft that you don't know if you can get
> rid of or not, often so disorganized you might have three similarly
> named items that you can't figure out which one should be used in which
> circumstances, etc.

The most cruft I've found in major subsystems in years has been
in the RDMA code, so I'm not sure where that argument comes from.
We're pretty good at garbage collecting cruft in Linux, and the
typical counter examples are arbitrarily split structures where it's
easy to hide things.

> >  And looking at the existing members of
> > struct ib_device what determines if it goes straight into the device
> > or the attribute?
> 
> Organization.  What goes where depends on what makes sense according to
> the organization you are doing.

So what makes num_comp_vectors or phys_port_cnt fit into ib_device,
while max_qp or max_cq are in struct ib_device_attr?

I really like clean data structures, but keeping structures that
have 1:1 relationships and sit in the same module separate never
has been a good idea.

> >  There is a reason why we don't do this weird
> > attr split in other Linux subsystems, and making IB follow this pattern
> > makes everyone feel right at home instead of wondering about the
> > weird attribute.
> 
> Being organized is not "weird".  Let's not wax poetic about sloppy,
> disorganized structures.  Let's be honest about what they are so we
> don't feel like we need to take a shower every time we talk about them
> to purge us of the sins of our lies.

I call that utter BS.  Being organized is exactly not having multiple
structures that have the same scope or life time, it's actually what
I call disorganzied.  There is a lot to be said about grouping the
fields in the structure, and that's how sensible subsystems handle it:

stuct foo_bar {
	/* read/write in the hot path, keep together and tightly packed: */
	...

	/* read-only in the hot path */
	...

	/* random members: */
	...

	/* properties here, immutable after setup: */
	...
};

but that's completely inverse to what we're having with ib_device
currently.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
