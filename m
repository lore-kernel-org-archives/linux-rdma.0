From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Wed, 8 Dec 2010 11:23:56 -0700
Message-ID: <20101208182356.GK16788@obsidianresearch.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291820122.4715.96.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 08, 2010 at 04:55:22PM +0200, Nir Muchtar wrote:
> On Tue, 2010-12-07 at 14:29 -0700, Jason Gunthorpe wrote:
> 
> > What you've done in your v2 patch won't work if the table you are
> > dumping is too large, once you pass sk_rmem_alloc for the netlink
> > socket it will deadlock. The purpose of dump_start is to avoid that
> > deadlock. (review my past messages on the subject)
> > 
> > Your v1 patch wouldn't deadlock, but it would fail to dump with
> > ENOMEM, and provides an avenue to build an unprivileged kernel OOM
> > DOS.
> > 
> > The places in the kernel that don't use dump_start have to stay under
> > sk_rmem_alloc.
> > 
> > Jason
> 
> Sorry, I still need some clarifications...
> When you say deadlocks, do you mean when calling malloc with a lock or
> when overflowing a socket receive buffer?
> For the second case, when we use netlink_unicast, the skbuff is sent and
> freed. It is transferred to the userspace's socket using netlink_sendskb
> and accumulated in its recv buff.
> 
> Are you referring to a deadlock there? I still fail to see the issue.
> Why would the kernel socket recv buff reach a limit? Could you please
> elaborate?

Netlink is all driven from user space syscalls.. so it looks like

sendmsg()
[..]
ibnl_rcv_msg
cma_get_stats
[..]
ibnl_unicast
[..]
netlink_attachskb
(now we block on the socket recv queue once it fills)

The deadlock is that userspace is sitting in sendmsg() while the
kernel is sleeping in netlink_attachskb waiting for the recvbuf to
empty.

User space cannot call recvmsg() while it is in blocked in sendmsg()
so it all goes boom.

Even if cma_get_stats was executed from a kernel thread and
ibnl_rcv_msg returned back to userspace you still hold the dev_list
mutex while calling ibnl_unicast, which can sleep waiting on
userspace, which creates an easy DOS against the RDMA CM (I can write
a program that causes the kernel the hold the mutx indefinitely).

You can't hold the mutex while sleeping for userspace, so you have to
unlock it. If you unlock it you have to fixup your position when you
re-lock it. If you can fixup your position then you can use
dump_start.

I don't see malloc being a concern anywhere in what you've done...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
