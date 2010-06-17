From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Thu, 17 Jun 2010 18:13:48 +0200
Message-ID: <OF0EE1C395.3DC5B442-ONC1257745.00531E16-C1257745.005927CB@ch.ibm.com>
References: <4C1A378B.9030509@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1A378B.9030509-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Hi Steve,

> Bernard Metzler wrote:
> > I agree that the issue must get solved and its good that it has
> > been brought up again. I agree with Chien that the
> > solution should respect and interface to a single in kernel instance
> > maintaining host global TCP port space. iWARP is just another
> > protocol on top of TCP - like iSCSI. There is no good reason to
> > invent another TCP port maintainer per TCP user type trying to
> > synchonize with the kernel if the resource is host global and
> > already maintained by the kernel.
> >
> > Since we are developing and already open sourced a full software
> > implementation (SoftiWARP) of RDMA, our view on the optimal solution
> > must be different. Like kernel iSCSI, we are running on top of regular
> > kernel sockets. With that, there is no point having a connection
manager
> > blocking just the port we wanted to use for communication - SoftiWARP
> > uses kernel sockets for data communication.
> >
> >
>
>
> Hey Bernard,
>
> Has SoftiWARP been submitted upstream yet?

It's at gitorious.org/softiwarp, but not pushed upstream.
After doing some performance measurements and further stability
testing, we decided to improve things (carefully reading Rolands recent
email on code quality confirmed me ;). After an update of the sources
in the next days, we will try harder getting recognized by netdev.

>
>
> > Therefore, I propose pushing back responsibility to the RDMA device
driver,
> > where the actual connection setup is initiated (RNIC) or takes place
> > (software RMDA stack). I think, it is not the job of the RDMA
connection
> > manager to maintain TCP port space at all. It should be up to the
driver
> > to do the appropriate steps. Due to the lack of another interface, an
> > RNIC driver would create and bind a kernel socket to get hold of
> > the TCP port it is intending to use for offloaded communication,
> > while a software RDMA stack just goes forward doing communication on
> > that socket. For the future it might be a good idea to approach the
> > netdev folks kindly asking for a neat interface for just TCP port
> > maintainance without the need to create and bind an otherwise
> > useless socket.
> >
>
>
> I proposed this design in 2007. It was NAK'd. Read the tail end of this
> email where I describe such a solution and indicate that Miller already
> NAK'd it. Now we could try again with this solution, but unless we have
> end users backing us and showing how much demand there is for this, it
> won't fly IMO.
>
>
> http://lkml.org/lkml/2007/8/15/174
>
>
>
> > Of course, the RNIC driver must restrict its activities to local
> > IP adresses on its cards (or, for SoftiWARP, to IP adresses of
interfaces
> > it is bound to). For example, a wildcard listen must get translated
> > into a listen restricted to the interface(s) under local control.
> >
> >
>
>
> I implemented and submitted this type of solution for cxgb3 in 2007 as
> well.
>
>
> http://lkml.org/lkml/2007/9/13/268
>
>
> Roland didn't like it, I think, because it used well known tokens in the
> interface name to designate iwarp ip addresses via ifconfig. Like
> "eth0:iw1". So the solution really required the admin to setup these
> iwarp-only subnets/interfaces. There was nothing that prevented non
> iwarp traffic to arrive on these ip addresses other than admin policy. I
> think that was another reason Roland didn't like this solution. Anyway,
> you can peruse that thread and maybe its a starting point for some
> "separate iwarp ipaddresses" solution....
>
>

I don't find it the appropriate solution to establish 'iwarp-only'
interfaces
and subnets. iWARP is just a TCP application as iSCSI is one. There is no
technical need to establish 'iSCSI-only' subnets to run iSCSI. Having
separate subnets and interfaces is InfiniBand. iWARP does not need
that, it even does not need dedicated hardware to run the protocol.
As Peter already pointed out - its trying to converge
traffic on a single link. I hope. (Yes, any RNIC should also be an
Ethernet device at the same time, for all the ports not used for RDMA
communication, and the vendor of that RNIC should maintain correct
behaviour.)

So, Steve, I would go for something like your early driver patch...

Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
