From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Wed, 1 Dec 2010 11:35:38 -0700
Message-ID: <20101201183538.GQ16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <20101129191136.GC16788@obsidianresearch.com>
 <1291126171.3155.250.camel@nirm-desktop>
 <20101130181944.GI16788@obsidianresearch.com>
 <1291219134.3155.471.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291219134.3155.471.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 01, 2010 at 05:58:54PM +0200, Nir Muchtar wrote:
> On Tue, 2010-11-30 at 11:19 -0700, Jason Gunthorpe wrote:
> 
> > > I don't know of an IB device index mapping like the one in netdevice.
> > > Am I missing one? Do you mean we should create one?
> > 
> > Yes, definately. It is very easy to do and goes hand-in-hand with the
> > typical netlink protocol design.
> 
> I agree, but this is a bit out of scope for the current patches and I
> think this kind of change should be given some thought. 

I'd view it as a pre-condition, actually.

> It needs to supply userspace with mapping functions and I don't
> think it will be that easy to complete. The patch in its current
> state uses names but it doesn't perpetuate their use because the
> rdma cm export is separate from the infrastructure. Once we have
> such an ability, it will be very easy to use here.

I think you are overthinking things. For now, just including the
ifindex attribute in sysfs in quite enough. As the netlink interface
is completed a by index lookup will naturally fall out.

> So we are in agreement that more then one export type is required here.
> I do agree that your suggestion will make sense once we try to export QP
> related data, so maybe we can agree that I will fully support such a
> scheme, so it will be easy to implement later. By that I mean that the
> infrastructure will allow adding arbitrary attributes to messages (in
> type and in size). What do you think?

I'm happy to see things done later, if we can agree on what everything
should look like later so the pieces we have now fit. Maybe you can
outline the sort of schema you are thinking of as I did?

Having a framework where ib_core generates the QP message and calls
out to RDMA_CM, IB_CM, driver, uverbs, etc to fill in attributes seems
best to me for the QP table.

A table for listening objects would be kind of similar with
information provided by rdma_cm and ib_cm, or just ib_cm

> >  6. Kernel copies the data from #3 into userspace
> >  7. netlink_dump calls callback which returns non-zero
> >  8. recv() returns in userspace
 
> Yes that's correct, but inet_diag takes care of the last two steps by
> updating its cb index, and not dump_start. If we use it that way we can
> have problems with changes in data structure on subsequent recv calls,
> so if we want to keep it the same we would still need to employ locking.
> I don't see a way to keep the same data without locking and without a
> session mechanism of some sort.

That is what the netlink_callback structure is for, you can stick
your current position info into args[].

You shouldn't be attempting to dump the structure in one go while
holding a lock, you need to try best-efforts to dump it by keeping
some kind of current position value.

inet_diag seems to use a pretty simple scheme where it just records
the hash bucket and count into the chain. Not sure what happens if
things are erased - looks like you'll get duplicates/misses? You could
do the same by keeping track of the offset into the linked list.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
