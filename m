From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 7 Jul 2010 17:37:38 +0200
Message-ID: <OF9B577A15.49E0F3EB-ONC1257759.005129F2-C1257759.0055D7D7@ch.ibm.com>
References: <4C339A13.3030802@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C339A13.3030802-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve,

merging the port space of different transports is very particular
and it would be good if we could avoid it w/o losing on transport
independence. Could we prove a strong need for that short-cut?
If its really needed, one global RDMA_CM instance should be able
to achive that requirement. But wouldn't that go together with a waste
of unused transports resources (i.e., IB binds would create
and bind also TCP sockets..?).
Many thanks for clarification!


Thanks,
Bernard.

Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote on 07/06/2010 11:03:15 PM:

> I haven't thought through all the details, but in principal this should
> work.  But this isn't just and iWARP issue.  Currently all RDMA-CM users
> share the same port space.   I think we need to maintain this, so a
> transport-independent RDMA app can run over both IB and IW.  This goes
> for server side wrt listen/accept as well.
>
> Steve.
>
>
> Tung, Chien Tin wrote:
> > Steve,
> >
> > Do you see any issues with Bernard's proposal?  Is this something
> we can agree on?
> >
> > Chien
> >
> >
> >> -----Original Message-----
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tung,
> >> Chien Tin
> >> Sent: Friday, June 25, 2010 3:15 PM
> >> To: Bernard Metzler; Roland Dreier
> >> Cc: Jason Gunthorpe; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Waskiewicz Jr,
> >> Peter P; Steve Wise
> >> Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space
usage
> >>
> >>
> >>> To my understanding, our discussion touches two topics. One is
> >>> to solve the TCP port space issue, the other is more general, its
about
> >>> proper integration of offloaded TCP within Linux. So, the second
> >>> topic is a generalization of the first.
> >>>
> >>> Regarding the first topic, what I was about to propose is that the
> >>> iWARP kernel driver (software iWARP or RNIC) itself should take care
of
> >>> port space allocations. Port space maintenance functionality should
> >>> be minimized at iWARP CM level. It looks straightforward to me if
> >>> during the rdma_connect() call the driver picks a free port using
> >>> a socket/bind sequence for its local interface. The same would be
possible
> >>> for
> >>> the passive connection setup, which always involves an rdma_bind_addr
()
> >>> - we would have to pass the rdma_bind_addr() call down to the driver
> >>> and EADDRINUSE would be a reasonable return value.
> >>> Here things are getting a little more complicated, if it comes to
> >>> INADDR_ANY and port 0 bindings. In private email, Bob Sharp already
> >>> suggested it -  the iWARP CM would have to pick a port and
> >>> try it on all interfaces....maybe by starting with port 0 binding
> >>> on one interface and trying to extend with the returned port on
> >>> all remaining interfaces. That introduces an unbind() call if things
> >>> fail, too. In any case, the rdma_bind_addr() call would create
additional
> >>> state
> >>> at driver level.
> >>>
> >> I am okay with adding rdma_bind_addr and rdma_unbind_addr calls.  I
won't
> >> speak for Sean and the work that needs to go into the CM.  But
> this will allow
> >> all known iWARP implementations to work together.
> >>
> >>
> >>> For softiwarp, during bind() or connect(), a TCP socket would be
created
> >>> and bound, for an RNIC driver (currently) the same would happen.While
with
> >>> softiwarp this socket would be used for communication later, the RNIC
> >>> driver
> >>> would simply have to keep it around until the connection endpoint
gets
> >>> destroyed
> >>> or the port gets unbound.
> >>>
> >> We want to be careful and make sure there is only one iWARP
> provider per IP address.
> >> If softiWARP binds and surfaces another verbs interface on an existing
one,
> >> this scheme will not work.
> >>
> >> Chien
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
