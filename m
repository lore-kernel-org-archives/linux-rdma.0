From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [IPoIB] Identify Multicast packets and fix IGMP breakage
Date: Thu, 26 Aug 2010 13:49:24 -0700
Message-ID: <adapqx5rtez.fsf@cisco.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home>
	<20100823174110.GK26549@obsidianresearch.com>
	<alpine.DEB.2.00.1008231317150.10719@router.home>
	<20100823183044.GM26549@obsidianresearch.com>
	<alpine.DEB.2.00.1008261453510.21466@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1008261453510.21466-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org> (Christoph
	Lameter's message of "Thu, 26 Aug 2010 14:55:27 -0500 (CDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > +	/* According to Jason Gunthorpe byte 24 in the GRH has the MGID */

I think we could put a better explanation here than "Jason said so."  In
fact since the GRH format matches the IPv6 header format, maybe we do
something like "((struct ipv6hdr *) skb->data)->daddr" to get at the
DGID being used.

 > +	if (IN6_IS_ADDR_MULTICAST(skb->data + 24))
 > +

trivial but this blank line isn't needed here.

 > +		skb->pkt_type = PACKET_MULTICAST;
 > +

or here

 > +	else
 > +		skb->pkt_type = PACKET_HOST;

also it's not clear to me why it's OK to do this test of the DGID if the
packet didn't have a GRH -- presumably we are just looking at random
uninitialized memory so we might incorrectly say some packets are
multicast if that byte happens to be 0xff.  (or does that not matter?
if so why can't we just always make everything PACKET_MULTICAST?)

It seems the check should be something like

	if ((wc->wc_flags & IB_WC_GRH) &&
	    IN6_IS_ADDR_MULTICAST(((struct ipv6hdr *) skb->data)->daddr))

 > --- linux-2.6.orig/include/linux/in6.h	2010-08-26 14:11:39.000000000 -0500
 > +++ linux-2.6/include/linux/in6.h	2010-08-26 14:11:52.000000000 -0500
 > @@ -53,6 +53,9 @@
 >  extern const struct in6_addr in6addr_linklocal_allrouters;
 >  #define IN6ADDR_LINKLOCAL_ALLROUTERS_INIT \
 >  		{ { { 0xff,2,0,0,0,0,0,0,0,0,0,0,0,0,0,2 } } }
 > +
 > +#define IN6_IS_ADDR_MULTICAST(a) (((const __u8 *) (a))[0] == 0xff)

We probably want to run this addition past netdev.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
