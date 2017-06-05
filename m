From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 05 Jun 2017 10:55:41 -0400
Message-ID: <1496674541.7171.168.camel@redhat.com>
References: <20170529082423.1180-1-leon@kernel.org>
         <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531174245.GA16304-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> On Wed, May 31, 2017 at 07:04:37AM +0300, Leon Romanovsky wrote:
> > 
> > 2. The commit cea05eadde broke NETLINK semantics for whole RDMA.
> 
> How did it break? What's the issue?

As I understand it, and I'll let Leon correct me if I'm wrong, the rest
of the linux kernel's NETLINK interfaces all have a standard they
follow:

When you open a netlink socket, it is by default asynchronous and non-
blocking.  In order to have it any other way, you must issue the
standard libnl commands to switch the socket to the other behavior.
 Leon's argument is that because of the problem iw_portmapper was
having, instead of adding the 3 or 4 lines to iw_portmapper so that it
would issue the necessary and typical calls to libnl to change the
socket semantics, this patch changed the default symantics for the RDMA
subsystems netlink sockets.

The point, then, is that this is not normal accepted practice for
solving a problem.  Normally, you would fix the user space application.
 If someone is used to programming network side netlink interfaces, and
they then get a new job and end up programming rdma side netlink
interfaces, they are going to find this difference confusing, to say
the least.  We will have broken the normal netlink API for the RDMA
subsystem in the name of not fixing a broken user space application.

Does that summarize your argument Leon?

FWIW, I would take this issue very seriously.  Having a default netlink
socket that behaves one way if it happens to belong to the network
subsystem and a default netlink socket that behaves another way if it
belongs to the RDMA subsystem is just flat wrong.  We should never
create an ambiguous API like that.  And if we broke it and made it
ambiguous, then it absolutely needs fixed.

> > 
> > 3. The commit cea05eadde made libnl library (basic block of user-
> > space part of netlink)
> > to work incorrectly and not according to _blocking/_nonblocking
> > semantics.
> 
> How? Is libnl calling ibnl_unicast? As far we can understand
> ibnl_unicast is only called
> by portmapper kernel code.

Let's not forget that Leon is working on a new tool, similar to the ip
command from iproute2, for configuring the rdma subsystem.  Feedback
has already established that it needs to be done all via netlink.  So,
the RDMA subsystem's current use of netlink is but a drop in a bucket
compared to what it will be and where it's going.  It is highly likely
that Leon stumbled across this issue as he was working on this tool and
started needing to deal with the RDMA subsystem's netlink support.

> > 4. Reverting is a common practice in Linux kernel. Patches are not
> > carved in stones.
> 
> Reverting a patch that's introduced during RC cycle is fine,
> introducing
> regression is NOT and that is what you are doing by simply proposing
> to revert
> this patch.  Reverting this patch will introduce a REGRESSION error
> with respect to
> port mapping functionality for all iWARP vendors.

Reverting buggy patches, however, is not considered a regression, but a
bug fix.  This is a bit of a special case in that, if Leon's arguments
are right, this is both a bug fix and a regression.  It means that
there might need to be a flag day to push out a new, fixed
iw_portmapper to people, followed by the revert.  But just because
buggy code is in use does not mean it gets to stay in use.

> > 
> > 5. I proposed a solution -> go and fix your user space program.
> This is a kernel patch you are trying to revert, you are breaking
> existing
> kernel functionality.  Nothing to do with user space.

It absolutely has to do with user space.  If this is an issue that
should have never been fixed via kernel space in the first place and
should have been resolved in user space all along by making
iw_portmapper treat the RDMA netlink socket just like any network
netlink socket would need to be treated, then Leon is right,
iw_portmapper needs fixed and this needs reverted.

> Bottom line, come up with a solution that will address both port
> mapper
> functionality and your issue.

No.  If he's right (and I plan to investigate whether he is) that the
normal netlink socket semantic is asynchronous and non-blocking by
default, and you normally use libnl commands to migrate the socket to
blocking/synchronous once the socket is opened, then this patch will
eventually be reverted and you absolutely need to fix iw_portmapper.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
