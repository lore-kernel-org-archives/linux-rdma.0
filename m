From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 16:34:07 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010051632191.10603@router.home>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com> <alpine.DEB.2.00.1010051410370.7065@router.home> <20101005195428.GB24268@obsidianresearch.com> <alpine.DEB.2.00.1010051500330.8786@router.home> <20101005202121.GC24268@obsidianresearch.com>
 <alpine.DEB.2.00.1010051535480.10603@router.home> <20101005205545.GF24268@obsidianresearch.com> <alpine.DEB.2.00.1010051600190.10603@router.home> <20101005212826.GG24268@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005212826.GG24268-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Oct 2010, Jason Gunthorpe wrote:

> > The problem is that the client join on 224.0.0.22 will be delayed due to
> > fabric reconfig. The group is joined on demand. It is not automatically
> > joined.
>
> I was trying to explain that it is possible for the SM to provide a
> MLID that is fully functional for .22 - there is no behind the scenes
> network reconfiguring delay. This is doable with IGMPv3 because the
> client join is send-only and all the listeners have been joined for a
> long time.

Ahh.. Good idea.

> There is virtually no cost with preconfiguring switches for send only
> traffic.

True.

> > Sure this sounds to be a much better approach (we have thought through
> > such approaches here repeatedly) but I do not know of any IB gateway that
> > supports IGMPv3.
>
> Lean on the vendors :( Seems crazy to not implement v3 when v2 is so
> unworkable on IB.

Oh we will.... Do obsidian routers support IGMPv3 for IB?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
