From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 7 Dec 2010 11:54:53 -0700
Message-ID: <20101207185453.GD16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <20101129191136.GC16788@obsidianresearch.com>
 <1291126171.3155.250.camel@nirm-desktop>
 <20101130181944.GI16788@obsidianresearch.com>
 <1291219134.3155.471.camel@nirm-desktop>
 <20101201183538.GQ16788@obsidianresearch.com>
 <1291736427.32170.36.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291736427.32170.36.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 07, 2010 at 05:40:27PM +0200, Nir Muchtar wrote:

> I understand. still, I prefer staying focused on the primary goal and
> complete the patches before looking into this, So the solution for now
> is to just skip on device name and obtain them from userspace using the
> net devices and /sys/class. I might return to this once the first
> patches are accepted.

This doesn't really work if the IB netdevice is part of a bond, and it
won't work at all once Sean is done adding AF_GID.

Churning the userspace ABI is a really bad idea, if something is hard
to do, then fine. But this isn't..

> What I mean is that I will supply the maximum flexibility by supporting
> arbitrary netlink messages and attributes. This will support your
> suggested schema as well as any changes we'll agree upon. My current
> plans are for RDMA CM exports and not QP table exports but this should
> be next in line.

Do you have an idea what this will look like?

> > You shouldn't be attempting to dump the structure in one go while
> > holding a lock, you need to try best-efforts to dump it by keeping
> > some kind of current position value.
> > 
> > inet_diag seems to use a pretty simple scheme where it just records
> > the hash bucket and count into the chain. Not sure what happens if
> > things are erased - looks like you'll get duplicates/misses? You could
> > do the same by keeping track of the offset into the linked list.
> 
> The thing is, there's no easy and clean way to retrieve the export when
> using dump_start.

I don't follow this comment, can you elaborate?

This really needs to use the dump api, and I can't see any reason why
it can't.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
