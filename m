From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for	RDMA CM
Date: Wed, 28 Oct 2009 10:46:15 -0600
Message-ID: <20091028164615.GC1966@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4AE859F8.2030708@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE859F8.2030708-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 04:49:28PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> > **COMPILE TESTED ONLY**
> 
> any reason why other people have to test for you?

Just a preliminary proposal - other people can do whatever they
want. Look at the list of things it fixes and decide your self if you
want to help or not <shrug>

> > Convert the address resolution process for outgoing connections
> > to be very similar to the way the TCP stack does the same operations.
> > This fixes many corner case bugs that can crop up.
> 
> rdma_join_multicast(3) states that "before joining a multicast
> group, the rdma_cm_id must be bound to an RDMA device by calling
> rdma_bind_addr or rdma_resolve_addr", please make sure that this
> flow isn't broken by your patch.

Can you explain how rdma_resolve_addr is used in conjunction with
multicast? I do not understand what the dest would be. Is it just a man
page typo?

I belive the rdma_bind_addr path is unaffected.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
