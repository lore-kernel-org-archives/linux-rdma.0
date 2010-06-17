From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Thu, 17 Jun 2010 16:14:44 +0200
Message-ID: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com>
References: <4C13A526.3040500@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C13A526.3040500-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I agree that the issue must get solved and its good that it has
been brought up again. I agree with Chien that the
solution should respect and interface to a single in kernel instance
maintaining host global TCP port space. iWARP is just another
protocol on top of TCP - like iSCSI. There is no good reason to
invent another TCP port maintainer per TCP user type trying to
synchonize with the kernel if the resource is host global and
already maintained by the kernel.

Since we are developing and already open sourced a full software
implementation (SoftiWARP) of RDMA, our view on the optimal solution
must be different. Like kernel iSCSI, we are running on top of regular
kernel sockets. With that, there is no point having a connection manager
blocking just the port we wanted to use for communication - SoftiWARP
uses kernel sockets for data communication.

Therefore, I propose pushing back responsibility to the RDMA device driver,
where the actual connection setup is initiated (RNIC) or takes place
(software RMDA stack). I think, it is not the job of the RDMA connection
manager to maintain TCP port space at all. It should be up to the driver
to do the appropriate steps. Due to the lack of another interface, an
RNIC driver would create and bind a kernel socket to get hold of
the TCP port it is intending to use for offloaded communication,
while a software RDMA stack just goes forward doing communication on
that socket. For the future it might be a good idea to approach the
netdev folks kindly asking for a neat interface for just TCP port
maintainance without the need to create and bind an otherwise
useless socket.

Of course, the RNIC driver must restrict its activities to local
IP adresses on its cards (or, for SoftiWARP, to IP adresses of interfaces
it is bound to). For example, a wildcard listen must get translated
into a listen restricted to the interface(s) under local control.

With that, the RDMA connection manager should simply be aware of
the possibility that a listen or connect call may fail for one
more reason. From using SoftiWARP in that environment I know,
that's already the case (-EADDRINUSE is always an acceptable
return value).

Thanks,
Bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 06/12/2010 05:17:58 PM:

> Roland Dreier wrote:
> >  > Other protocols are also running over networking today, such as
iSCSI
> >  > and FCoE.  These happily co-exist with other L2->L4 protocols in the
> >  > stack. This iWARP patch allows iWARP to happily co-exist on a TCP
> >  > connection, and does *not* negatively affect the networking stack at
> >  > all.
> >
> > How do iSCSI offload HBAs coexist?  As I understand it, they typically
> > just choose a separate IP address.
> >
> > In any case I'm not going to slip in a patch that another maintainer
has
> > explicitly NAKed.  Maybe one way to force things forward would be to
> > write up an exhaustive explanation of the underlying problem and the
> > impact on end users, include this patch, explain that it touches only
> > RDMA code, and point out that most end users are already using this
> > patch since it's shipped in OFED.  Then send the whole thing to Linus
> > and Andrew Morton, making sure to cc Dave Miller, netdev, and
> > linux-rdma.
> >
> >  - R.
> >
>
> My 2007 thread does this basically, but posted it to lkml and David
> Miller.  But the rationale for why we need it as well as other possible
> solutions is included in that thread.  We could re-package it and send
> it on as you suggest.  It might carry more weight coming from the linux
> rdma maintainer though. :)
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
