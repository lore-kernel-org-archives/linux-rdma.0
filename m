From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Wed, 6 Oct 2010 11:34:49 -0600
Message-ID: <20101006173449.GJ24268@obsidianresearch.com>
References: <4CAB4D49.9090107@voltaire.com> <alpine.DEB.2.00.1010051415100.7065@router.home> <1286380676.31487.1.camel@alst60.voltaire.com> <alpine.DEB.2.00.1010061114590.31538@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010061114590.31538-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 06, 2010 at 11:16:59AM -0500, Christoph Lameter wrote:

> > Relating to broadcast, I don't think that this is a good solution it
> > will bring unwarranted load, specially in the case if no MLID received.
> > The way of adding delay before we start to send packages, seems to me
> > better.
> 
> Broadcast is a temporary solution and it only occurs with in an IB
> partition. It would be a problem if one host suddenly starts sending
> at full line speed. Maybe have that configurable?

Right, and keep in mind that sending a packet with the broadcast MLID
and group-specific MGID will still result in the HCA's filtering based
on MGID. Personally, I'm not concerned about flooding - this is how
things work in ethernet - any sane app will need some way to cope with
that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
