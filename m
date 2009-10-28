From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
 for	RDMA CM
Date: Wed, 28 Oct 2009 16:49:28 +0200
Message-ID: <4AE859F8.2030708@Voltaire.com>
References: <20091028054253.GA22882@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028054253.GA22882-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> **COMPILE TESTED ONLY**

any reason why other people have to test for you?

> Convert the address resolution process for outgoing connections
> to be very similar to the way the TCP stack does the same operations.
> This fixes many corner case bugs that can crop up.

rdma_join_multicast(3) states that "before  joining  a  multicast  group,  the  rdma_cm_id  must  be  bound to an RDMA device by calling rdma_bind_addr or rdma_resolve_addr", please make sure that this flow isn't broken by your patch.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
