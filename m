From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 14:55:45 -0600
Message-ID: <20101005205545.GF24268@obsidianresearch.com>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com> <alpine.DEB.2.00.1010051410370.7065@router.home> <20101005195428.GB24268@obsidianresearch.com> <alpine.DEB.2.00.1010051500330.8786@router.home> <20101005202121.GC24268@obsidianresearch.com> <alpine.DEB.2.00.1010051535480.10603@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010051535480.10603-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 05, 2010 at 03:43:47PM -0500, Christoph Lameter wrote:

> > Using .22 will generally solve the problems with sychronizing the
> > IPoIB gateway to the state of the IGMPv3 clients. Yes, there will
> > still be some unknown lag in building the IB side of the network and
> > for the router(s) to get ready to handle the group - but at least it
> > is no longer dependent on any timeouts.
> 
> How do you propose to handle the IB level join to 224.0.0.22 to avoid
> packet loss there? IGMP messages will still get lost because of that.

First, the routers all join the group at startup and stay joined
forever. This avoids the race in the route joining a new MGID after
the client creates it, but before the IGMPv2 report is sent. I expect
this is a major source of delay and uncertainty

Second, since all clients join this group as send-only it becomes
possible for the SM to do reasonable things - for instance the MLID
can be pre-provisioned as send-only from any end-port and thus after
the SM replies with a MLID the MLID is guaranteed good for send-only
use immediately.

Third, once the client etners IGMPv3 mode and joins the group (maybe
at system boot?) it stays joined forever.

Finally, by sending multicast packets to the broadcast during the time
the MLID is unknown we can pretty much guarantee that the first IGMPv3
packet that is sent to .22 will reach all routers in a timely fashion.
(Hence my objection to Aleksey's approach)

Basically, this completely solves the IGMP client to IPoIB router
communication problem. Yes, there will still be an unknown time until
the IB network, router, and whatever is beyond the router is ready to
actually process packets on a new group - BUT that is normal for IP
multicast! The main point is that without lost IGMP packets things can
proceed without relying on timeouts.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
