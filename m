From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for	RDMA CM
Date: Wed, 28 Oct 2009 10:58:58 -0700
Message-ID: <E27512B9FE294380956C074D2C35D235@amr.corp.intel.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com> <20091028165043.GD1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028165043.GD1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Hum.. Not sure how that would work? src = AF_INET, dst = AF_IB?

yes - conceptually, these both map to PF_IB, which I think is really the
limiting factor

I'm guessing that you could make the reverse work as well, but it requires more
work and probably wouldn't be used by apps anyway.

>I guess I was hoping you'd be able to do the private data in userspace
>and avoid those kind of special cases..

The private data would still be done in user space.  This allows apps that make
use of ADDR_CHANGE events to continue working as normal, while still allowing
for address resolution to be done in user space.  This should meet Or's request.
User space may not know if they can resolve a particular address before binding.

I need to write the kernel patches to see if supporting this causes undo grief.
At this point, I'm guessing that the only thing that would prevent this from
working is if an explicit check is added.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
