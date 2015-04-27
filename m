From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Mon, 27 Apr 2015 16:58:33 -0400
Message-ID: <20150427205832.GC5347@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <1429714792.45956.110.camel@redhat.com> <20150422171051.GE1494@phlsvsds.ph.intel.com> <DB4PR05MB08630282DEFFFB181A525B67B1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB4PR05MB08630282DEFFFB181A525B67B1EC0-xsq7jzH2t6llkovD9u25SNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 24, 2015 at 02:53:37PM +0000, Liran Liss wrote:
> > From: ira.weiny [mailto:ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> > [snip]
> > 
> > > >
> > > > 2)The name rdma_tech_* is lame.
> > > > rdma_transport_*(), adhering to the above (*) remark, is much better.
> > > > For example, both IB and ROCE *do* use the same transport.
> > >
> > > I especially want to second this.  I haven't really been happy with
> > > the
> > > rdma_tech_* names at all.
> > >
> > 
> > I am sure Michael is open to alternative names.  I know I am.  The problem is
> > that we can't figure out what "IBoE" is.  It is not a transport, even though
> > query_transport is now returning it as one.  :-P
> 
> IBOE is used in part of the kernel symbols that refer to RoCE. That's it.
> ROCE HCA links have the following characteristics:
> - Ethernet link layer
> - IB transport
> - CA node type
> 
> And, if needed in the future:
> - ROCEv1 and ROCEv2 protocol stacks

Let me rephrase that[*].

We don't know what to "call" "IBoE" vs "IBoIB" vs "iWarp Verbs over iWarp" vs
"IBoOPA", etc.

The problem with your argument (no matter what name we use, "Transport",
"tech", "protocol") etc is that support for various features are implied rather
than explicit.

Your argument that RoCE is just "IB transport" over Ethernet (while technically
correct) is not relevant for the problem we are trying to solve.

The ib_mad, ib_cm, rdma_cm, and ib_sa modules are attempting to support many
different device type (on a port basis).  The functionality they provide is
dependent on so much more that the notion of "transport" and "link layer".

The purpose of this patch series was to create the specific helper functions
based on the support the core modules need to explicitly determine what they
should do for a port.  Furthermore, the implementation of those features was to
be based on the current implementation (which happens to use the transport and
link layer) to ensure we don't break everything.

Once we could agree on items like the feature set and the names of the helper
calls we could then alter the implementation to remove the implied nature of
this support.

> 
> > 
> > I think the idea behind the "tech" name was that it is a technology "family".
> > I can't think of a better name.

I see "protocol" and "specification" being discussed.  Those are probably
decent.

Ira

[*] We all know what RoCE (IBoE) _is_...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
