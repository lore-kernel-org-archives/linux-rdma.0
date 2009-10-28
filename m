From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
	for RDMA CM
Date: Wed, 28 Oct 2009 12:58:47 -0600
Message-ID: <20091028185847.GK14520@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com> <20091028165043.GD1966@obsidianresearch.com> <E27512B9FE294380956C074D2C35D235@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E27512B9FE294380956C074D2C35D235-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 10:58:58AM -0700, Sean Hefty wrote:

> >I guess I was hoping you'd be able to do the private data in userspace
> >and avoid those kind of special cases..
> 
> The private data would still be done in user space.  This allows
> apps that make use of ADDR_CHANGE events to continue working as
> normal, while still allowing for address resolution to be done in
> user space.  This should meet Or's request.  User space may not know
> if they can resolve a particular address before binding.

Well, looking at this, I see that ADDR_CHANGE is only generated on
netdev events NETDEV_BONDING_FAILOVER - so what are the semantics
WRT to UCM here? As I said before, defeating the ND process seriously
affects how bonding works.

I think if UCM is going to have bonding-like HA it has to do the work
itself. It has to record the bonding IP is bound to multiple GID/LIDs
and it has to attempt connecting to multiple addrs.

So, I don't see ADDR_CHANGE fitting into this. An IB centric IB
connection lost event to trigger reconnect would be more
appropriate. This would be desirable anyhow for AF_IB only apps, so
multi-protocol apps can handle both cases - the same recovery
action is probably required anyhow...

FWIW, I think HA + UCM is very doable, if UCM can construct multiple
PRs based on bonding data it collects it should pass them into the
kernel using the mechanism we talked about for APM. The kernel does
not have to implement APM but it certainly can run through the
combinations and use the first to reply to the GMP as the path to
establish a connection. For typical 2 port bonding there would be 4
combinations, 2 of which the kernel could eliminate immediately by
detecting the local port is downed.

Then again, is bonding + ucm going to be a common usage model? Without
the faster address failover provided by the unsolicted ND packet the
recovery time will be worse. On the other hand, if all the above is
done UCM would actually have enough information to setup multi-port
APM...

Anyhow, I don't suggest you try to implement HA + UCM out of the gate,
but as a direction for work in that area to take I think AF_IB only
plus IB_LINK_LOST event, plus 'APM-lite' kernel PR round robin is a
viable approach.

Keeping AF_IB uniformly as AF_IB seems like it would make things
simpler to implement and describe WTF it is doing.

> At this point, I'm guessing that the only thing that would prevent
> this from working is if an explicit check is added.

Some kinds of checks are needed, passing  AF_INET and AF_INET6 into
rdma_resolve_ip will mis-function. dst=AF_IB will have to
branch off before this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
