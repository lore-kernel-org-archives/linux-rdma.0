From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 14:27:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008231427130.12815@router.home>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com> <alpine.DEB.2.00.1008231254300.10719@router.home> <20100823182859.GL26549@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100823182859.GL26549-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Aug 2010, Jason Gunthorpe wrote:

> src_qp is just the send QPN, you need to look at qp_num (aka dest qp).
> I'm not entirely sure what it will be, I didn't find anything too clear
> in the spec. If it is 0xFFFFFF then the HCA is copying the dest QP
> directly into the WC and this can work, if it is something else then
> the HCA is setting it to the QPN of the RQ that recieved the packet,
> which is not useful for this.

AFAICT the spec has a QP for RC and one for UD packets. How do these
relate to multicast?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
