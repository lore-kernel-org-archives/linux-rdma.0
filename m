From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 7 Dec 2010 22:53:23 +0200
Message-ID: <7E95F01E94AB484F83061FCFA35B39F8794E3B@exil.voltaire.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com><1291047399-430-6-git-send-email-nirm@voltaire.com><20101129191136.GC16788@obsidianresearch.com><1291126171.3155.250.camel@nirm-desktop><20101130181944.GI16788@obsidianresearch.com><1291219134.3155.471.camel@nirm-desktop><20101201183538.GQ16788@obsidianresearch.com><1291736427.32170.36.camel@nirm-desktop> <20101207185453.GD16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Jason Gunthorpe wrote:
>  
> On Tue, Dec 07, 2010 at 05:40:27PM +0200, Nir Muchtar wrote:
> 
> > I understand. still, I prefer staying focused on the primary goal and
> > complete the patches before looking into this, So the solution for now
> > is to just skip on device name and obtain them from userspace using the
> > net devices and /sys/class. I might return to this once the first
> > patches are accepted.
> 
> This doesn't really work if the IB netdevice is part of a bond, and it
> won't work at all once Sean is done adding AF_GID.
> 
> Churning the userspace ABI is a really bad idea, if something is hard
> to do, then fine. But this isn't..

I'm just not convinced this can be easily completed/accepted and not divert
us from the primary goal, so I prefer picking this up later after those
patches are accepted. If I discover there's no good way to obtain this 
through userspace then I won't.

> 
> > What I mean is that I will supply the maximum flexibility by supporting
> > arbitrary netlink messages and attributes. This will support your
> > suggested schema as well as any changes we'll agree upon. My current
> > plans are for RDMA CM exports and not QP table exports but this should
> > be next in line.
> 
> Do you have an idea what this will look like?

I'm submitting an RDMA CM extension and not a QP table extension, so I
don't have a complete design, but the infrastructure will support a
more module collaborative design like you suggested as well as a more
per-module design like in the case of RDMA CM. The exact specification
can be agreed upon later.

> > The thing is, there's no easy and clean way to retrieve the export when
> > using dump_start.
> 
> I don't follow this comment, can you elaborate?
> 
> This really needs to use the dump api, and I can't see any reason why
> it can't.
> 
> Jason

As I said, there's just no way (I know of) to use dump_start, divide data
into several packets, and receive a consistent snapshot of the data, and
this is an issue. We can achieve all that by doing something a little 
different so why shouldn't we? 

dump_start is used by some subsystems and not used by others. It's a
convenience function and it doesn't necessarily fit in every case,
so we shouldn't force it.

Nir








--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
