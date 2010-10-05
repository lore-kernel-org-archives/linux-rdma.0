From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 16:12:59 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010051600190.10603@router.home>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com> <alpine.DEB.2.00.1010051410370.7065@router.home> <20101005195428.GB24268@obsidianresearch.com> <alpine.DEB.2.00.1010051500330.8786@router.home> <20101005202121.GC24268@obsidianresearch.com>
 <alpine.DEB.2.00.1010051535480.10603@router.home> <20101005205545.GF24268@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005205545.GF24268-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Oct 2010, Jason Gunthorpe wrote:

> > How do you propose to handle the IB level join to 224.0.0.22 to avoid
> > packet loss there? IGMP messages will still get lost because of that.
>
> First, the routers all join the group at startup and stay joined
> forever. This avoids the race in the route joining a new MGID after
> the client creates it, but before the IGMPv2 report is sent. I expect
> this is a major source of delay and uncertainty

I think the current routers join 224.0.0.2 already. Adding another MC
group should come with IGMPv3 support.

> Second, since all clients join this group as send-only it becomes
> possible for the SM to do reasonable things - for instance the MLID
> can be pre-provisioned as send-only from any end-port and thus after
> the SM replies with a MLID the MLID is guaranteed good for send-only
> use immediately.

The problem is that the client join on 224.0.0.22 will be delayed due to
fabric reconfig. The group is joined on demand. It is not automatically
joined.

> Third, once the client etners IGMPv3 mode and joins the group (maybe
> at system boot?) it stays joined forever.

IGMP does not explicitly join 224.0.0.X groups. Looks like messages to
224.0.0.X will not be send unless there is no other responder on the
subnet. So the initial messages for the first join getting lost
may still be a problem.

> Finally, by sending multicast packets to the broadcast during the time
> the MLID is unknown we can pretty much guarantee that the first IGMPv3
> packet that is sent to .22 will reach all routers in a timely fashion.
> (Hence my objection to Aleksey's approach)

Right. So the multicast traffic will flow to the broadcast address until
the SM sends the response. The multicast traffic will then get lost until
the fabric reconfig is complete.

> Basically, this completely solves the IGMP client to IPoIB router
> communication problem. Yes, there will still be an unknown time until
> the IB network, router, and whatever is beyond the router is ready to
> actually process packets on a new group - BUT that is normal for IP
> multicast! The main point is that without lost IGMP packets things can
> proceed without relying on timeouts.

Sure this sounds to be a much better approach (we have thought through
such approaches here repeatedly) but I do not know of any IB gateway that
supports IGMPv3.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
