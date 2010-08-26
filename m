From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [IPoIB] Identify Multicast packets and fix IGMP breakage
Date: Thu, 26 Aug 2010 16:17:08 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1008261613160.24174@router.home>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com> <alpine.DEB.2.00.1008231317150.10719@router.home> <20100823183044.GM26549@obsidianresearch.com> <alpine.DEB.2.00.1008261453510.21466@router.home>
 <adapqx5rtez.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqx5rtez.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Aug 2010, Roland Dreier wrote:

> also it's not clear to me why it's OK to do this test of the DGID if the
> packet didn't have a GRH -- presumably we are just looking at random
> uninitialized memory so we might incorrectly say some packets are
> multicast if that byte happens to be 0xff.  (or does that not matter?
> if so why can't we just always make everything PACKET_MULTICAST?)

We will do an skb_pull to skip over the GRH next? The IP layer checks
PACKET_HOST etc in various places so we may risk breakage in odd places
like what already occurred here. It would be good to also have support
for PACKET_BROADCAST but that would require a full MGID comparison.

> It seems the check should be something like
>
> 	if ((wc->wc_flags & IB_WC_GRH) &&
> 	    IN6_IS_ADDR_MULTICAST(((struct ipv6hdr *) skb->data)->daddr))

Hmmm... More IPV6 stuff slipping in.

> We probably want to run this addition past netdev.

Ok.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
