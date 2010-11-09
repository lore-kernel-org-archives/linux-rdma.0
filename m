From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: TCP CUBIC and IPoIB
Date: Mon, 8 Nov 2010 17:58:13 -0700
Message-ID: <20101109005813.GD909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I wonder if anyone has ever looked at this? It looks like there is
something wrong here.

I was just looking at some results from a stock 2.6.35 kernel doing
TCP over IPoIB (2k MTU) and CUBIC looks like it is going nutz, you can
see in a bandwidth plot a fairly characteristic saw tooth pattern, and
diminished bandwidth. The effect compounds rather dramatically as the
RTT goes up.

This isn't really my area of expertise, so I wonder if someone else
has looked into this? Errant congestion events will sap bandwidth
even on low latency links..

Cheers,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
