From: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Wed, 06 Oct 2010 17:57:56 +0200
Message-ID: <1286380676.31487.1.camel@alst60.voltaire.com>
References: <4CAB4D49.9090107@voltaire.com>
	 <alpine.DEB.2.00.1010051415100.7065@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1010051415100.7065-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-10-05 at 14:18 -0500, Christoph Lameter wrote: 
> On Tue, 5 Oct 2010, Aleksey Senin wrote:
> 
> > When using slow SM allow more packets to be buffered before answer
> > comming back. This patch based on idea of Christoph Lameter.
> 
> I agree, I think we need to have those things configurable.
> 
> Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> 
> How do you handle the situation of the SM responding before the fabric has
> been reconfigured? I do not see any delay on join. So they will be dropped
> if the fabric was not reconfigured fast enough? Or does the SM somehow
> delay the response?

I think this issue, that should solve the problem of sending or delaying
packets after obtaining MLID should be solved in another patch. Proposed
code improve today situation, when you can't change it at all.
Relating to broadcast, I don't think that this is a good solution it
will bring unwarranted load, specially in the case if no MLID received.
The way of adding delay before we start to send packages, seems to me
better.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
