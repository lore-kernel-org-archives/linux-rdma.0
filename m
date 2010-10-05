From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 15:02:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010051500330.8786@router.home>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com> <alpine.DEB.2.00.1010051410370.7065@router.home> <20101005195428.GB24268@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005195428.GB24268-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Oct 2010, Jason Gunthorpe wrote:

> > I agree. We had similar ideas. However, the kernel does send igmp
> > reports to the MC address not to 244.0.0.2. We would have to redirect at
> > the IB layer until multicast via MLID becomes functional. We cannot tell
> > when that will be the case.
>
> Sure, but Aleksey's patch is aimed at the case when the SM has not yet
> replied, not for your problem with IGMPv2. If their is no MLID then
> sending to the broadcast MLID is a better choice than hanging onto the
> packets. I wonder if you could even send unicasts to the broadcast?

The problem that the SM has not yet replied is no different between the
IGMP versions. If you get a confirmation but the MC group is not
functional then packets go nowhere.

> I still think the problem you have with IGMPv2 is best solved by
> leaning on the gateway vendors to support IGMPv3 - which *does* send
> all reports to 244.0.0.22

s/22/2

Certainly a solution for the igmp messages themselves but not for
initial traffic or traffic send via sendonly join.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
