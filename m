From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Wed, 6 Oct 2010 11:16:59 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010061114590.31538@router.home>
References: <4CAB4D49.9090107@voltaire.com>  <alpine.DEB.2.00.1010051415100.7065@router.home> <1286380676.31487.1.camel@alst60.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286380676.31487.1.camel-uOVkuFIEnOODI2cvxHXf6UEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 6 Oct 2010, Alekseys Senin wrote:

> > How do you handle the situation of the SM responding before the fabric has
> > been reconfigured? I do not see any delay on join. So they will be dropped
> > if the fabric was not reconfigured fast enough? Or does the SM somehow
> > delay the response?
>
> I think this issue, that should solve the problem of sending or delaying
> packets after obtaining MLID should be solved in another patch. Proposed
> code improve today situation, when you can't change it at all.

I agree with that.

> Relating to broadcast, I don't think that this is a good solution it
> will bring unwarranted load, specially in the case if no MLID received.
> The way of adding delay before we start to send packages, seems to me
> better.

Broadcast is a temporary solution and it only occurs with in an IB
partition. It would be a problem if one host suddenly starts sending
at full line speed. Maybe have that configurable?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
