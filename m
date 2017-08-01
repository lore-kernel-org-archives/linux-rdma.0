From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 12:14:54 -0500
Message-ID: <20170801171454.GA8484@ctung-MOBL3.amr.corp.intel.com>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <1501600807.2475.4.camel@wdc.com>
 <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
 <1501606508.2475.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501606508.2475.12.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 04:55:09PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 11:21 -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 03:20:11PM +0000, Bart Van Assche wrote:
> > > What Leon wrote, namely that calls that send netlink data from kernel to user
> > > space should be non-blocking makes sense to me.
> > 
> > That's been addressed in so many emails I won't rehash.  If _no_one_ should
> > block (it is actually a one shot retry with a timeout) sending Netlink message
> > from kernel to user, why don't Leon or you patch that code out?  All of
> > it, not just ibnl_unicast().
> > 
> > > So please be more constructive than replying with "NAK".
> > 
> > I've sent so many emails (some you were CC'd), so I'm not sure how
> > much more constructive I can be.  BTW, did you see the one with my
> > attempt at world peace (https://www.spinics.net/lists/linux-rdma/msg50591.html)?
> > 
> > Here are the relevant threads for people that are interested in participating
> > in this discussion.
> > 
> > https://patchwork.kernel.org/patch/9814367/
> > 
> > https://patchwork.kernel.org/patch/9752855/
> 
> Hello Chien,
> 
> Yes, I had read these e-mails but I do not agree with all of what was written
> in these e-mails. I'm not sure whether you are aware of the original design
> goal of the netlink mechanism? It was designed on purpose to be unreliable
> such that sending information from the kernel to user space would never block.

Please show me a feference to Netlink design document/email on mailing list
that specifically disallowed this?

> If sending data over a netlink socket can block then analyzing whether or not
> any deadlocks can occur is only possible by examining kernel and user space
> together. If sending data over a netlink socket never blocks then a only the
> kernel has to be considered when analyzing whether or not a deadlock can occur.
> We do not want that userspace can cause the kernel to lock up. So it's very
> strange to me to see that today the kernel has facilities for both blocking
> and non-blocking sends over netlink sockets.

So here we go again.  I will rehash my arguments.

1) There is NO deadlock with ibnl_unicast(). It is single shot retry with timeout.
As I've requested before, people should stop using terms that are NOT applicable
to this situation.  You can make other arguments but not this one.

2) With the patch from Mustafa it will separate out messages, one with the retry
and the other without, as designed in Netlink.  what's wrong with this solution?
Has Leon tried the patch?  Does it not work for his situation?

> My opinion here is that any
> client that needs reliable communication from kernel to user space should use
> another mechanism than netlink sockets. Additionally, since the kernel reports
> netlink socket buffer overflows to user space through the ENOBUFS error code,
> what's so hard about detecting that error code in user space and
> resynchronizing state if recv() fails with ENOBUFS?

Incorrect analysis on how the message is triggered.  The message originates
from kernel to user.  It is not trying to guarantee delivery as it is single
retry with timeout.  Yes, I've stated these facts in previous threads.

> 
> Is your concern perhaps about the code in iwpmd/iwarp_pm_server.c? From what
> I see in process_iwpm_netlink_msg() it seems like all receive errors are
> treated equal and no state resynchronization occurs if the kernel reports
> ENOBUFS?

you need to visit the kernel code flow not user.  I've laid out the code flow
for everyone to see in a previous email, not doing it again.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
