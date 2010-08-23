From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 12:28:59 -0600
Message-ID: <20100823182859.GL26549@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com> <alpine.DEB.2.00.1008231254300.10719@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231254300.10719-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 23, 2010 at 01:10:45PM -0500, Christoph Lameter wrote:

> +	if (wc->src_qp == multicast_priv->qp->qp_num)
> +
> +		skb->pkt_type = PACKET_MULTICAST;
> +	else
> +		skb->pkt_type = PACKET_HOST;

src_qp is just the send QPN, you need to look at qp_num (aka dest qp).
I'm not entirely sure what it will be, I didn't find anything too clear
in the spec. If it is 0xFFFFFF then the HCA is copying the dest QP
directly into the WC and this can work, if it is something else then
the HCA is setting it to the QPN of the RQ that recieved the packet,
which is not useful for this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
