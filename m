From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Thu, 9 Dec 2010 10:47:18 +0200
Message-ID: <1291884438.4715.152.camel@nirm-desktop>
References: <20101129191136.GC16788@obsidianresearch.com>
	 <1291126171.3155.250.camel@nirm-desktop>
	 <20101130181944.GI16788@obsidianresearch.com>
	 <1291219134.3155.471.camel@nirm-desktop>
	 <20101201183538.GQ16788@obsidianresearch.com>
	 <1291736427.32170.36.camel@nirm-desktop>
	 <20101207185453.GD16788@obsidianresearch.com>
	 <7E95F01E94AB484F83061FCFA35B39F8794E3B@exil.voltaire.com>
	 <20101207212924.GG16788@obsidianresearch.com>
	 <1291820122.4715.96.camel@nirm-desktop>
	 <20101208182356.GK16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101208182356.GK16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-12-08 at 11:23 -0700, Jason Gunthorpe wrote:

> > Sorry, I still need some clarifications...
> > When you say deadlocks, do you mean when calling malloc with a lock or
> > when overflowing a socket receive buffer?
> > For the second case, when we use netlink_unicast, the skbuff is sent and
> > freed. It is transferred to the userspace's socket using netlink_sendskb
> > and accumulated in its recv buff.
> > 
> > Are you referring to a deadlock there? I still fail to see the issue.
> > Why would the kernel socket recv buff reach a limit? Could you please
> > elaborate?
> 
> Netlink is all driven from user space syscalls.. so it looks like
> 
> sendmsg()
> [..]
> ibnl_rcv_msg
> cma_get_stats
> [..]
> ibnl_unicast
> [..]
> netlink_attachskb
> (now we block on the socket recv queue once it fills)
> 
> The deadlock is that userspace is sitting in sendmsg() while the
> kernel is sleeping in netlink_attachskb waiting for the recvbuf to
> empty.
> 
> User space cannot call recvmsg() while it is in blocked in sendmsg()
> so it all goes boom.
> 

Oh, now I see what you mean. I thought you meant the recv buffer in the
netlink socket... 

But I'm using MSG_DONTWAIT when calling netlink_unicast, so attachskb
shouldn't block. I also tested that.
I do agree that freeing the skb and simply giving up is not the best we
can do, so we can try and send as much as we can instead, but either
way, a deadlock shouldn't occur.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
