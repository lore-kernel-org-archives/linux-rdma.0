From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [IPoIB] Identify Multicast packets and fix IGMP breakage
Date: Thu, 26 Aug 2010 14:32:09 -0700
Message-ID: <ada39u13vs6.fsf@cisco.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home>
	<20100823174110.GK26549@obsidianresearch.com>
	<alpine.DEB.2.00.1008231317150.10719@router.home>
	<20100823183044.GM26549@obsidianresearch.com>
	<alpine.DEB.2.00.1008261453510.21466@router.home>
	<adapqx5rtez.fsf@cisco.com>
	<alpine.DEB.2.00.1008261613160.24174@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1008261613160.24174-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org> (Christoph
	Lameter's message of "Thu, 26 Aug 2010 16:17:08 -0500 (CDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > also it's not clear to me why it's OK to do this test of the DGID if the
 > > packet didn't have a GRH -- presumably we are just looking at random
 > > uninitialized memory so we might incorrectly say some packets are
 > > multicast if that byte happens to be 0xff.  (or does that not matter?
 > > if so why can't we just always make everything PACKET_MULTICAST?)

 > We will do an skb_pull to skip over the GRH next? The IP layer checks
 > PACKET_HOST etc in various places so we may risk breakage in odd places
 > like what already occurred here. It would be good to also have support
 > for PACKET_BROADCAST but that would require a full MGID comparison.

I'm not sure I follow what you're saying.  An IB UD packet may or may
not include a GRH on the wire.  If it does, when it's received, the
adapter writes the GRH and then the packet data into the receive
buffer.  If there is no GRH on the wire, then the adapter skips 40 bytes
(size of a GRH/ipv6 header) and then writes the packet data into the
receive buffer.

So in all cases, the real packet data starts 40 bytes into the receive
buffer and we have to do an skb_pull, but if there was no GRH on the
wire, then the 40 bytes we skipped is just uninitialized memory.  The
wc_flags bit IB_WC_GRH tells you if there was a GRH on the wire or not.

It sounds like we want to get this right without random false positives,
so I think we need to test IB_WC_GRH.  (And doing a full compare against
the broadcast MGID for multicast packets wouldn't be *too* bad -- it's
not much worse than what ethernet does)

 > > It seems the check should be something like
 > >
 > > 	if ((wc->wc_flags & IB_WC_GRH) &&
 > > 	    IN6_IS_ADDR_MULTICAST(((struct ipv6hdr *) skb->data)->daddr))
 > 
 > Hmmm... More IPV6 stuff slipping in.

I guess it would be at least as correct to cast to struct ib_grh and
check that the dgid is a multicast GID (we can add an inline function to
check this and as a cleanup we could then get rid of the open-coded
tests in ib_attach_mcast etc)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
