From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 14:59:45 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008231454230.12815@router.home>
References: <alpine.DEB.2.00.1008231427130.12815@router.home> <7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com> <20100823194555.GN26549@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100823194555.GN26549-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Aug 2010, Jason Gunthorpe wrote:

> Simplest then is to check if byte 24 of the packet is 0xff.
> (ie IN6_IS_ADDR_MULTICAST)

Dont see that function defined anywhere in the kernel.

> No need to worry about if it is properly formed or anything, if it is
> a multicast DGID then it is a multicast packet at the link level.

ok so skb->head[24] = 0xff ?

Looks raw and not kernel style. There need to be some skb_xxx function
that get to it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
