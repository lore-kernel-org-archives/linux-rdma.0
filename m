From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC ABI V2 5/8] RDMA/core: Add new ioctl interface
Date: Wed, 27 Jul 2016 13:58:53 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607271356510.8816@east.gentwo.org>
References: <20160720172143.GG21460@obsidianresearch.com> <alpine.DEB.2.20.1607201950160.24804@east.gentwo.org> <20160721015613.GB8279@obsidianresearch.com> <alpine.DEB.2.20.1607202132080.26260@east.gentwo.org> <20160721032803.GA12093@obsidianresearch.com>
 <alpine.DEB.2.20.1607202340280.26638@east.gentwo.org> <20160721054439.GA19329@obsidianresearch.com> <alpine.DEB.2.20.1607210202400.29415@east.gentwo.org> <20160721164133.GD19849@obsidianresearch.com> <alpine.DEB.2.20.1607251104370.23039@east.gentwo.org>
 <20160725180119.GB18773@obsidianresearch.com> <alpine.DEB.2.20.1607270954150.25436@east.gentwo.org> <CAG53R5XZ9RVg-2yGFbr-7To1SMbRoGG3xiZHf-vNnGM4K+R4pw@mail.gmail.com> <alpine.DEB.2.20.1607271300150.27032@east.gentwo.org>
 <CAG53R5V07Q-O8cmm3Ad23qsH3oDQiw9nL87yG2=ki=Rgg9LQAA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5V07Q-O8cmm3Ad23qsH3oDQiw9nL87yG2=ki=Rgg9LQAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Jul 2016, Parav Pandit wrote:

> > It does not need to be zcopy if the functionality is only there for
> > administrative purposes and for other things where we are just too lazy to
> > get the whole QP stuff fully operational from user space and just fall
> > back to the old sockets paradigm where the QP stuff is done by th kernel
> > for us to give us a standard socket API.
> Agree. Would rsockets socket emulation be sufficient/good enough or
> socket has to come from kernel?

The implementation has to fully integrate with the kernel to take
advantage of all the diagnostics etc etc. User space wont help.

> changes which can still benefit from transport offload acceleration,
> with cost of zcopy and syscall.

Sure we could add ioctls etc to do QP setup etc etc. That then also has
the character of a general QP facility that could also be used by other
protocols in the future. Would make RDMA universally available if the
ioctls are also supported by other protocols. Which would be great.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
