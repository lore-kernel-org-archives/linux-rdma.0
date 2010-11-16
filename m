From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Mon, 15 Nov 2010 23:26:02 -0700
Message-ID: <20101116062602.GA488@obsidianresearch.com>
References: <4CE00A72.30001@voltaire.com> <20101115031904.GA3566@obsidianresearch.com> <1289836604.2258.1091.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1289836604.2258.1091.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 15, 2010 at 05:56:44PM +0200, Nir Muchtar wrote:

> > I'd really prefer that this not be seperate modules. I think it would
> > be good to stick the core stuff as part of ib_uverbs. Especially since
> > it doesn't look too big. For embedded you can have a
> > CONFIG_RDMA_NETLINK or something. (For embedded I think it would use
> > less memory to be able to forgo sysfs and use netlink entirely, someday.)

> Well, the main reason for the module separation is to allow
> extensibility and independence.

Those are orthogonal issues, you can keep a pluggable API without
having modules around it.

> Code separation is just a bonus. I like the idea of having the runtime
> option to use this interface (or not).

Well, I do not like that option at all. This means you can't rely on
netlink being available so people won't use it. If you have to rely on
an admin to add a bunch of module names to /etc/modules then you have
already lost. IMHO. Modules are best used when auto-detection is
possible, other cases are troublesome. I've already seen that (for
instance) using ib_ucm's interface is virtually impossible because
most sites don't load the module, and the end-users that want to use
the software that relies on it can't get an admin to install it.

More non-automatic modules == bad.

> What I wanted to achieve is an IB independent infrastructure that can be
> used in parts. 

That doesn't seem useful, what is really needed here is an RDMA
*dependent* netlink interface. Ie I think your plug-in point is at the
wrong place, ib_verbs should be enumerating all QPs and calling back
to the code that owns them to fill in additional information for that
QP. Ie SRP can annotate what the host ID is, RDMA-CM can include the
IP address, IB-CM can include the PRs/etc/etc

> This way only the modules of interest are joined to the infrastructure. 
> The necessity of this flexibility can be examined of course.

*shrug* why would anyone care except for embedded?

> I agree. That's one of the main goals.
> For example, I have plans for adding ipoib exports as well as other
> ideas.

I have a patch someplace that exports the IPOIB path as part of the
normal netlink neighbour dump, which, IMHO, is appropriate for most
IPOIB information. I can send it to you if you like. A similar
approach can be done for the multicast paths. The locking was
problematic which is why it never was sent to the list..

> > I'll comment on what you have specifically later, but just a quick
> > glance makes me wonder if you reviewed how the 'ss' program exchanges
> > very similar information over netlink for IP sockets when you designed
> > this??

> Yes I have actually. Some ideas are from NETLINK_INET_DIAG which is the
> back-end for ss.
> There are a few differences here that made the result different. 
> I'd say this is a mix between NETLINK_INET_DIAG and NETLINK_NETFILTER.

Well, I don't see it, your code should have calls to
netlink_dump_start, and lots of calls to 
RTA_DATA(__RTA_PUT(skb, attrtype, attrlen))

ie the NETLINK_INET_DIAG reply is returend as a series of netlink
messages for inet_diag_msg structures with sub structures of things
like INET_DIAG_INFO/INET_DIAG_VEGASINFO/etc terminated by NLMSG_DONE.

What you have done is just concatenate rdma_cm_id_stats structures,
which is not extensible, doesn't have natural netlink message
boundaries to let userspace re-call recv, and introduces a 32/64 bit
issue (which is an big no-go).

So for QP's I'd imagine similar, a netlink message for each QP. Basic
information like QPN and RDMA device ID, then sub-structures like
QP_RDMA_CM (port numbers and IP addresses), QP_IB_CM (path records),
etc that include additional information provided by that service.

And like I said, maybe today you only dump the RDMACM table, but
the userspace API should be built to dump the entire QP table and
support QPs created without CM, with UCM, and with RDMACM, which is a
trivial API to build if you use netlink the way it was ment to be used.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
