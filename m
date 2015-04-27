From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Mon, 27 Apr 2015 15:22:42 -0400
Message-ID: <20150427192241.GB5347@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <55375C10.8070901@profitbricks.com> <DB4PR05MB0863B84F5AF4F8203CFDAC36B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com> <5538A034.4030904@profitbricks.com> <DB4PR05MB08635737AF7A40F3F82B7628B1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB4PR05MB08635737AF7A40F3F82B7628B1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 24, 2015 at 02:44:29PM +0000, Liran Liss wrote:
> > From: Michael Wang [mailto:yun.wang@profitbricks.com]
> 
> 
> > [snip]
> > >
> > > Depends on who is "we".
> > > For ULPs, you are probably right.
> > >
> > > However, core services (e.g., mad management, CM, SA) do care about
> > various details.
> > > In some cases, where it doesn't matter, this code will use management
> > helpers.
> > > In other cases, this code will inspect link, transport, and node attributes of
> > rdma devices.
> > >
> > > For example, the CM code has specific code paths for IB, RoCE, and iWARP.
> > > There is no other CM code; there is no reason to abstract 'CM'. This
> > > code will have code paths that depend on various specific details.
> > 
> > That's exactly what we want to stop, we have classified the CM to IB and
> > IWARP now :-)
> >
> 
> We don't want to stop code branches that are not abstractions but rather depend
> on the specific technology!
> There is no generic "iWARP CM" - only one.
> There is no generic "ROCE CM" - only one.
> There is no generic "IB CM" - only one.

How can you say this?  Or perhaps I don't understand what you mean.

While conceptually one could say that each technology has its own "CM" we are
trying to have the same module (and code) implement them all (ie a generic CM
for a node).  Therefore, the CM code _is_ generic.  As is the MAD code.  This
is the reason we have this problem.  We are trying to reuse those modules for
multiple technologies.

> 
> At the CM high-level (i.e., whether an ib_dev port registers an IB client), you could consider
> an rdma_has_cm() call, but this the only place in the code that this check will be called!
> Hence, no need for a generic check.
> 
> You want to stop abstract code that uses IB core infrastructure.

Not sure what you mean here?

Ira
