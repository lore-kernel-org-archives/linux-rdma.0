From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 03/12] ib_core: IBoE UD packet packing support
Date: Thu, 14 Oct 2010 13:12:52 -0700
Message-ID: <adazkugildn.fsf@cisco.com>
References: <20100826141756.GD8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141756.GD8795@mtldesk30> (Eli Cohen's message of "Thu,
	26 Aug 2010 17:17:56 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > +	if (lrh_present) {
 > +		header->lrh.link_version     = 0;
 > +		header->lrh.link_next_header =
 > +			grh_present ? IB_LNH_IBA_GLOBAL : IB_LNH_IBA_LOCAL;
 > +		packet_length = IB_LRH_BYTES;
 > +	}
 > +
 > +	if (eth_present)
 > +		packet_length += IB_ETH_BYTES;

How does this code in ib_ud_header_init() work if lrh_present == 0 and
eth_present == 1?  It seems packet_length is never initialized in that
case, or am I missing something?

Anyway I changed the patch in my tree to do

	packet_length = IB_ETH_BYTES

if eth_present is set.

I'm assuming lrh_present and eth_present are exclusive; in fact it might
be a better interface to ib_ud_header_init() if we passed in a link
layer type instead of requiring the caller to do it... that would save
from everyone having to do

+	ib_ud_header_init(send_size, !is_eth, is_eth, is_grh, 0, &sqp->ud_header);

as ends up later in the patch series.

This could be a future cleanup if we care.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
