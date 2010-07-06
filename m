From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Tue, 6 Jul 2010 13:52:32 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904928D9C9B@azsmsx506.amr.corp.intel.com>
References: <ada6319ttnj.fsf@roland-alpha.cisco.com>
 <OFE69DF7DF.E7AB1B1F-ONC125774D.0035CCED-C125774D.005C2F46@ch.ibm.com>
 <2EFBCAEF10980645BBCFB605689E08E904926FF2A4@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E904926FF2A4-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve,

Do you see any issues with Bernard's proposal?  Is this something we can agree on?

Chien

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tung,
> Chien Tin
> Sent: Friday, June 25, 2010 3:15 PM
> To: Bernard Metzler; Roland Dreier
> Cc: Jason Gunthorpe; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Waskiewicz Jr,
> Peter P; Steve Wise
> Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
> 
> > To my understanding, our discussion touches two topics. One is
> > to solve the TCP port space issue, the other is more general, its about
> > proper integration of offloaded TCP within Linux. So, the second
> > topic is a generalization of the first.
> >
> > Regarding the first topic, what I was about to propose is that the
> > iWARP kernel driver (software iWARP or RNIC) itself should take care of
> > port space allocations. Port space maintenance functionality should
> > be minimized at iWARP CM level. It looks straightforward to me if
> > during the rdma_connect() call the driver picks a free port using
> > a socket/bind sequence for its local interface. The same would be possible
> > for
> > the passive connection setup, which always involves an rdma_bind_addr()
> > - we would have to pass the rdma_bind_addr() call down to the driver
> > and EADDRINUSE would be a reasonable return value.
> > Here things are getting a little more complicated, if it comes to
> > INADDR_ANY and port 0 bindings. In private email, Bob Sharp already
> > suggested it -  the iWARP CM would have to pick a port and
> > try it on all interfaces....maybe by starting with port 0 binding
> > on one interface and trying to extend with the returned port on
> > all remaining interfaces. That introduces an unbind() call if things
> > fail, too. In any case, the rdma_bind_addr() call would create additional
> > state
> > at driver level.
> 
> I am okay with adding rdma_bind_addr and rdma_unbind_addr calls.  I won't
> speak for Sean and the work that needs to go into the CM.  But this will allow
> all known iWARP implementations to work together.
> 
> > For softiwarp, during bind() or connect(), a TCP socket would be created
> > and bound, for an RNIC driver (currently) the same would happen. While with
> > softiwarp this socket would be used for communication later, the RNIC
> > driver
> > would simply have to keep it around until the connection endpoint gets
> > destroyed
> > or the port gets unbound.
> 
> We want to be careful and make sure there is only one iWARP provider per IP address.
> If softiWARP binds and surfaces another verbs interface on an existing one,
> this scheme will not work.
> 
> Chien
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
