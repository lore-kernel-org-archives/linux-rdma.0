From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 27 Jul 2016 10:03:50 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607270954150.25436@east.gentwo.org>
References: <20160720172143.GG21460@obsidianresearch.com> <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org> <20160721015613.GB8279@obsidianresearch.com> <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org> <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org> <20160721054439.GA19329@obsidianresearch.com> <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org> <20160721164133.GD19849@obsidianresearch.com> <alpine.DEB.2.20.1607251104370.23039@east.gentwo.org>
 <20160725180119.GB18773@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725180119.GB18773-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 25 Jul 2016, Jason Gunthorpe wrote:

> I can't help that IBTA created a different scheme for device
> aggregation, addressing, and basically everything else. 'standard
> convention' in the kernel really just means ethernet, and this isn't
> like ethernet, except superficially.

Well you can create your own non ethernet protocol. Why is there not an IB
ulp that allows basic messaging, listen() and all the other stuff using
standard system calls? There should be a netdev. I already see devices
in /sys/class/infiniband/*! But they are not listed in /proc/net/dev!!!

Why can we not use these with regular syscalls? Could provide this basic
support for native infiniband? And maybe offload some of the need for
esoteric IB ioctl functions that could just be provided by the standard
calls? F.e. statistics and device configuration would be simplified and possible using
the standard tools. IB devices have MACs as well. We could reuse quite a
bit of software there.

I think Christoph H made the point already that the wire format needs to
stay the same and also the user verbs API (to some degree) but below that
we could do pretty much what we want.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
