From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting
	IB path
Date: Tue, 6 Oct 2009 10:01:56 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA8168EFD82BA@MNEXMB2.qlogic.org>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
 <20091005175656.GK5191@obsidianresearch.com>
 <F7D418716F3A4A0DACE42CC449624298@amr.corp.intel.com>
 <20091005181525.GL5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091005181525.GL5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Monday, October 05, 2009 2:15 PM
> To: Sean Hefty
> Cc: linux-rdma; Roland Dreier
> Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually
> setting IB path
> 
> On Mon, Oct 05, 2009 at 11:08:51AM -0700, Sean Hefty wrote:
> > >On Mon, Oct 05, 2009 at 10:43:44AM -0700, Sean Hefty wrote:
> > >> Export rdma_set_ib_paths to user space to allow applications to
> > >> manually set the IB path used for connections.  This allows
> > >> alternative ways for a user space application or library to obtain
> > >> path record information, including retrieving path information
> > >> from cached data, avoiding direct interaction with the IB SA.
> > >> The IB SA is a single, centralized entity that can limit scaling
> > >> on large clusters running MPI applications.
> > >
> > >Um, isn't this kind of low level control exactly why we have the IB
> > >CM?
> >
> > There are very few apps that I'm aware of (one to be precise) that
> have coded
> > directly to the libibcm.
> 
> I've done several..
> 
> But that isn't really the point, IB CM already provides this API so,
> why corrupt the RDMA CM abstraction with this?
> 
> Jason


Ideally the best approach would be to have a mux at the ib_mad level.  We could allow a user space application to intercept all outbound MADs for a given class and/or attribute.  Unlike the present "snooping" of mads, this would literally be a interception.  This would provide a number of key advantages:

1. outbound queries from all sources (ib_cm, rdma_cm, kernel ULPs, user space applications, saquery tool, etc) could all be intercepted and processed the same way

2. The "cache" could be in user space and be optional.  If the cache application is not running, the intercept is disabled and MADs flow as they do now.  However when the cache application is running, it can intercept the MADs.  The cache may then choose to directly respond from the cache (without sending a MAD on the wire) or issue the MAD (or a modified version of it) on the wire, get the response, cache it, then answer the original requester.

3. This approach could also provide opportunities for interesting IB packet tracing facilities.  Ib_madeye is quite primitive in its ability to show packets and filter.  As a result ib_madeye is useful for low speed analysis, but is difficult to use for high message rate MAD traffic.  It also doesn't show source/dest address information.  By having a mux there would be the opportunity to capture binary packets into user space for offline analysis, perhaps with tools like WireShark/EtherReal or other hand crafted packet analysis/dump/debug tools.

Todd Rimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
