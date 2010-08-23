From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 12:30:44 -0600
Message-ID: <20100823183044.GM26549@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com> <alpine.DEB.2.00.1008231317150.10719@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231317150.10719-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 23, 2010 at 01:19:20PM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Jason Gunthorpe wrote:
> 
> > Hmmm... What are you trying to access here? I'm guessing it is the
> > DGID of the GRH?
> >
> >         ipoib_ud_skb_put_frags(priv, skb, wc->byte_len);
> >         skb_pull(skb, IB_GRH_BYTES);  <-- These are the bytes you want
> >         skb_reset_mac_header(skb);  <-- Sets skb_mac_header to skb->head+40
> >         skb_pull(skb, IPOIB_ENCAP_LEN);
> >
> > So, I think you are accessing byte 42, which doesn't seem right? The
> > DGID starts in byte 24 from skb->head.
> >
> > Also, you need to check for IBV_WC_GRH, the 40 bytes are garbage if it
> > is not set.
> 
> Trying to get the MGID information:
> 
> From http://tools.ietf.org/html/draft-ietf-ipoib-link-multicast-00

The MGID is stuffed into the DGID field of the GRH by the sender, so
you want to start at byte 24 of the wc data. The structure is 40 bytes
of GRH, 4 bytes of IPOIB_ENCAP with the protocol number, and then the
datagram. It looks to me like the MAC header pointer is set to the
IPOIB_ENCAP header.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
