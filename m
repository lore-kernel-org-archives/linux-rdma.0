From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Tue, 16 Nov 2010 17:57:59 +0200
Message-ID: <1289923079.2258.1149.camel@nirm-desktop>
References: <4CE00A72.30001@voltaire.com>
	 <20101115031904.GA3566@obsidianresearch.com>
	 <1289836604.2258.1091.camel@nirm-desktop>
	 <20101116062602.GA488@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116062602.GA488-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-11-15 at 23:26 -0700, Jason Gunthorpe wrote:
> > Code separation is just a bonus. I like the idea of having the runtime
> > option to use this interface (or not).
> 
> Well, I do not like that option at all. This means you can't rely on
> netlink being available so people won't use it. If you have to rely on
> an admin to add a bunch of module names to /etc/modules then you have
> already lost. IMHO. Modules are best used when auto-detection is
> possible, other cases are troublesome. I've already seen that (for
> instance) using ib_ucm's interface is virtually impossible because
> most sites don't load the module, and the end-users that want to use
> the software that relies on it can't get an admin to install it.
> 
> More non-automatic modules == bad.
I was under the impression that a different module is appropriate here
based on the structure of the IB modules and similar modules like
netfilter_netlink, and other architectures in the kernel. However, I'm
naturally open to other views. If the other way around is the consensus
nowadays, and I'm in minority here, then certainly, things can be done
the other way. I'd be happy to hear other views to concur/reject my
view.
> 
> > What I wanted to achieve is an IB independent infrastructure that can be
> > used in parts. 
> 
> That doesn't seem useful, what is really needed here is an RDMA
> *dependent* netlink interface. Ie I think your plug-in point is at the
> wrong place, ib_verbs should be enumerating all QPs and calling back
> to the code that owns them to fill in additional information for that
> QP. Ie SRP can annotate what the host ID is, RDMA-CM can include the
> IP address, IB-CM can include the PRs/etc/etc

What do you mean by RDMA dependent? RDMA CM? All QP's that are related
to RDMA CM?
Also, why should we limit ourselves to QP related information only? What
if we need access to other data? (Even HW specific)

> > Yes I have actually. Some ideas are from NETLINK_INET_DIAG which is the
> > back-end for ss.
> > There are a few differences here that made the result different. 
> > I'd say this is a mix between NETLINK_INET_DIAG and NETLINK_NETFILTER.
> 
> Well, I don't see it, your code should have calls to
> netlink_dump_start, and lots of calls to 
> RTA_DATA(__RTA_PUT(skb, attrtype, attrlen))
> 
> ie the NETLINK_INET_DIAG reply is returend as a series of netlink
> messages for inet_diag_msg structures with sub structures of things
> like INET_DIAG_INFO/INET_DIAG_VEGASINFO/etc terminated by NLMSG_DONE.
> 
> What you have done is just concatenate rdma_cm_id_stats structures,
> which is not extensible, doesn't have natural netlink message
> boundaries to let userspace re-call recv, and introduces a 32/64 bit
> issue (which is an big no-go).

I can change the message transport itself to behave like inet_diag if
that is acceptable. It will add some complexity to the infrastructure
and callbacks and make plugins harder to add, but I agree that it will
present a cleaner API to the userspace. 

Thanks for your input,
Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
