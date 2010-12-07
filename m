From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 7 Dec 2010 17:40:27 +0200
Message-ID: <1291736427.32170.36.camel@nirm-desktop>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
	 <1291047399-430-6-git-send-email-nirm@voltaire.com>
	 <20101129191136.GC16788@obsidianresearch.com>
	 <1291126171.3155.250.camel@nirm-desktop>
	 <20101130181944.GI16788@obsidianresearch.com>
	 <1291219134.3155.471.camel@nirm-desktop>
	 <20101201183538.GQ16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101201183538.GQ16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-12-01 at 11:35 -0700, Jason Gunthorpe wrote:
> > I agree, but this is a bit out of scope for the current patches and I
> > think this kind of change should be given some thought. 
> 
> I'd view it as a pre-condition, actually.
> 

I understand. still, I prefer staying focused on the primary goal and
complete the patches before looking into this, So the solution for now
is to just skip on device name and obtain them from userspace using the
net devices and /sys/class. I might return to this once the first
patches are accepted.

> I'm happy to see things done later, if we can agree on what everything
> should look like later so the pieces we have now fit. Maybe you can
> outline the sort of schema you are thinking of as I did?
> 
> Having a framework where ib_core generates the QP message and calls
> out to RDMA_CM, IB_CM, driver, uverbs, etc to fill in attributes seems
> best to me for the QP table.

What I mean is that I will supply the maximum flexibility by supporting
arbitrary netlink messages and attributes. This will support your
suggested schema as well as any changes we'll agree upon. My current
plans are for RDMA CM exports and not QP table exports but this should
be next in line.

> You shouldn't be attempting to dump the structure in one go while
> holding a lock, you need to try best-efforts to dump it by keeping
> some kind of current position value.
> 
> inet_diag seems to use a pretty simple scheme where it just records
> the hash bucket and count into the chain. Not sure what happens if
> things are erased - looks like you'll get duplicates/misses? You could
> do the same by keeping track of the offset into the linked list.
> 
> Jason

The thing is, there's no easy and clean way to retrieve the export when
using dump_start.
The locking problem could be solved using GFP_ATOMIC when using malloc.
This will prevent possible long locking periods.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
