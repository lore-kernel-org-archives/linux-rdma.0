From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 14:21:21 -0600
Message-ID: <20101005202121.GC24268@obsidianresearch.com>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com> <alpine.DEB.2.00.1010051410370.7065@router.home> <20101005195428.GB24268@obsidianresearch.com> <alpine.DEB.2.00.1010051500330.8786@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010051500330.8786-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 05, 2010 at 03:02:21PM -0500, Christoph Lameter wrote:
> On Tue, 5 Oct 2010, Jason Gunthorpe wrote:
> 
> > > I agree. We had similar ideas. However, the kernel does send igmp
> > > reports to the MC address not to 244.0.0.2. We would have to redirect at
> > > the IB layer until multicast via MLID becomes functional. We cannot tell
> > > when that will be the case.
> >
> > Sure, but Aleksey's patch is aimed at the case when the SM has not yet
> > replied, not for your problem with IGMPv2. If their is no MLID then
> > sending to the broadcast MLID is a better choice than hanging onto the
> > packets. I wonder if you could even send unicasts to the broadcast?
> 
> The problem that the SM has not yet replied is no different between the
> IGMP versions. If you get a confirmation but the MC group is not
> functional then packets go nowhere.

Getting a MLID that is not 'functional' is a different problem. Aleksey
is looking at the case when there is no MLID at all, and I think
queuing is the wrong approach.

> > I still think the problem you have with IGMPv2 is best solved by
> > leaning on the gateway vendors to support IGMPv3 - which *does* send
> > all reports to 244.0.0.22
> 
> s/22/2

No, 22. RFC 3376:

4.2.14. IP Destination Addresses for Reports

   Version 3 Reports are sent with an IP destination address of
   224.0.0.22, to which all IGMPv3-capable multicast routers listen.  A
   system that is operating in version 1 or version 2 compatibility
   modes sends version 1 or version 2 Reports to the multicast group
   specified in the Group Address field of the Report.  In addition, a
   system MUST accept and process any version 1 or version 2 Report
   whose IP Destination Address field contains *any* of the addresses
   (unicast or multicast) assigned to the interface on which the Report
   arrives.

> Certainly a solution for the igmp messages themselves but not for
> initial traffic or traffic send via sendonly join.

Using .22 will generally solve the problems with sychronizing the
IPoIB gateway to the state of the IGMPv3 clients. Yes, there will
still be some unknown lag in building the IB side of the network and
for the router(s) to get ready to handle the group - but at least it
is no longer dependent on any timeouts.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
