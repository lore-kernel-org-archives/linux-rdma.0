From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: using same IP subnet on multiple interfaces
Date: Mon, 16 Aug 2010 21:19:45 -0600
Message-ID: <20100817031945.GA5251@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B@orsmsx501.amr.corp.intel.com> <4C679C39.8060709@Voltaire.com> <20100815165946.GA2861@obsidianresearch.com> <4C69597C.2040008@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C69597C.2040008-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 16, 2010 at 06:30:04PM +0300, Or Gerlitz wrote:

> As for the original issue we were discussing here, Sean - the
> conclusion is that with upstream 2.6.35 bits for the rdma connection
> to go from hca1 port1 to hca1 port2 (or from hca1 port1 to hca2
> port1), the rdma-cm needs a neighbour, similarly to a ping -I ib0 to
> ib1 address.
> 
> A neighbour isn't created unless the responding NIC (ib1 in my
> example) has both rp_filter set to 0 and accept_local set to 1,
> Jason, does this makes sense?

This description seemed reasonable to me. It is pretty confusing what
binding means in RDMA CM, it is different then sockets, and is some
combination of SO_BINDTODEVICE and bind to address.

Also, you might find the fixes that were done lately for IPv6 tidied
up some of the general routing and device select stuff that becomes
noticable when you start doing funny routing things like this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
