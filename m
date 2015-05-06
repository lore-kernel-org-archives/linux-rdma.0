From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Wed, 6 May 2015 14:25:09 +0000
Message-ID: <HE1PR05MB141813E9F1048F12C22C7705B1D00@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCAEFD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCAEFD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, May 05, 2015 11:29 PM

> > > In other words, I think that 'protocol' should uniquely distinguish
> > interoperable
> > > peers at the Verbs API level. We are *not* trying to describe a
> > > certain
> > header,
> > > but rather a stack of protocols.
> >
> > Any non-UDP "protocol" that might currently be in use over usNIC is an
> > entirely application-level protocol outside of the view of the Verbs
> > API level.
> 

Fine. Then we can add a 'udp/ip' protocol for usNIC.
Similarly, 'raw Ethernet' can designate the ability to inject of all headers starting from L2.

> I agree with this for usNIC.  For other technologies, the definition isn't even
> this simple.  UD QPs and RC QPs cannot interoperate, yet are treated as the
> same 'protocol'.  Just defining protocol as a 'stack of protocols' shows how
> broken the approach is.  And we haven't even tried to incorporate other
> 'protocols' needed to make this work, such as the CM or management
> protocols.

The interoperability between different transport objects depends on the technology.
I don't think that we should even attempt to describe these dependencies in any
abstract way. RTFM...

However, users should have a way of knowing what transports and what wire
protocol stacks a certain rdma device supports.

No one using IB or RoCE would think that UD and RC interoperate.
(If someone tries it, he would be disappointed 'gracefully'...)
But people that use RoCE would like to know which devices they can use to send
RoCE packets (or select a device that supports a certain RoCE version).

--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
