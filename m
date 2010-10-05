From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 5 Oct 2010 14:12:57 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010051410370.7065@router.home>
References: <4CAB4D49.9090107@voltaire.com> <20101005162833.GC5967@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005162833.GC5967-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Oct 2010, Jason Gunthorpe wrote:

> On Tue, Oct 05, 2010 at 06:07:37PM +0200, Aleksey Senin wrote:
> > When using slow SM allow more packets to be buffered before answer
> > comming back. This patch based on idea of Christoph Lameter.
> >
> > http://lists.openfabrics.org/pipermail/general/2009-June/059853.html
>
> IMHO, I think it is better to send multicasts to the broadcast MLID than to
> queue them.. More like ethernet that way.

I agree. We had similar ideas. However, the kernel does send igmp
reports to the MC address not to 244.0.0.2. We would have to redirect at
the IB layer until multicast via MLID becomes functional. We cannot tell
when that will be the case.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
