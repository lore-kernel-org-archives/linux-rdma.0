From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] DAPL v2.0: common: increase default IB ack timer from
 16 to 20
Date: Wed, 2 Nov 2011 20:28:22 -0600
Message-ID: <20111103022822.GA6674@obsidianresearch.com>
References: <54347E5A035A054EAE9D05927FB467F916E93128@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237316E8CBCB@ORSMSX101.amr.corp.intel.com>
 <54347E5A035A054EAE9D05927FB467F916E931C5@ORSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237316E8CC00@ORSMSX101.amr.corp.intel.com>
 <54347E5A035A054EAE9D05927FB467F916E931E8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54347E5A035A054EAE9D05927FB467F916E931E8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 02, 2011 at 11:31:38PM +0000, Davis, Arlin R wrote:
> > > Yes, a user can modify path lifetime via rdma_create_ep() but there
> > > is no way for the user to know how much that will be manipulated and
> > > increased in the IB CM driver.
> > 
> > Sure there is.  It's an open source driver.  :)
> > 
> > The ib_cm calculates the "correct" timeout based on the packet lifetime
> > provided by the SA and the CA ack timeout.  If user modifications to
> > this value are necessary, then there is a bug in either the SA or HCA
> > driver.
> 
> or there could be congestion on the fabric that the SA or HCA driver
> is unaware of.

That is what packet life time is supposed to model, and the policy
knob for it belongs in the SA, not every app..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
