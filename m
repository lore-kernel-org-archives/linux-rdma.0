From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 13:45:55 -0600
Message-ID: <20100823194555.GN26549@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231427130.12815@router.home> <7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F8013249-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 23, 2010 at 10:34:38PM +0300, Yossi Etigin wrote:
> Hello Christoph,
> 
> I think you'll first want to check the wc_flags field in the work
> completion to see whether GRH is present (and it must be present in
> multicast packets, normally not present in unicast). Then, extract the
> destination gid from grh, and compare the first 6 bytes of it to the
> dev->broadcast address bytes 4...9 (once with dev->broadcast which is
> IPv4, second time with dev->broadcast with the IP version nibble changed
> to 6). The first 4 bytes of dev->broadcast are QPN.
> Of course, you'll be doing this before pulling any other headers from
> the skb because GRH comes first.

> The QPN you get in the completion is the QP from which it was sent -
> src_qp. You don't get the QPN which was put in the UD header by the
> sender, which is 0xFFFFFF for multicast. In userspace (aka struct
> ibv_wc), you get the qp number from which the receive buffer was taken,
> and in kernel space (aka struct ib_wc, no 'v') you get the pointer to
> the QP.

Ah, so that clears things up. Sorry to have confused things with this
suggestion.

Simplest then is to check if byte 24 of the packet is 0xff.
(ie IN6_IS_ADDR_MULTICAST)

No need to worry about if it is properly formed or anything, if it is
a multicast DGID then it is a multicast packet at the link level.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
