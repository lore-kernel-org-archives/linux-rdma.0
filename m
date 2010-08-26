From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [IPoIB] Identify Multicast packets and fix IGMP breakage
Date: Thu, 26 Aug 2010 15:29:27 -0600
Message-ID: <20100826212927.GA24971@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231210010.9840@router.home> <20100823174110.GK26549@obsidianresearch.com> <alpine.DEB.2.00.1008231317150.10719@router.home> <20100823183044.GM26549@obsidianresearch.com> <alpine.DEB.2.00.1008261453510.21466@router.home> <adapqx5rtez.fsf@cisco.com> <alpine.DEB.2.00.1008261613160.24174@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008261613160.24174-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 26, 2010 at 04:17:08PM -0500, Christoph Lameter wrote:
> On Thu, 26 Aug 2010, Roland Dreier wrote:
> 
> > also it's not clear to me why it's OK to do this test of the DGID if the
> > packet didn't have a GRH -- presumably we are just looking at random
> > uninitialized memory so we might incorrectly say some packets are
> > multicast if that byte happens to be 0xff.  (or does that not matter?
> > if so why can't we just always make everything PACKET_MULTICAST?)
>
> We will do an skb_pull to skip over the GRH next? 

The GRH bytes are always present, but the HW may not fill them in if 
IB_WC_GRH is not set.

Checking for the broadcast address should be done by comparing the
MGID against dev->broadcast + 4, like Yossi was describing. This can
be done as a sub-case of the multicast check since dev->broadcast+4
will always start with 0xff.

IPv6 does not have a broadcast address, so the additional work
to check the v6 MGID format Yossi was discussing is not required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
