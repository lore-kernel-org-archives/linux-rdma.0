From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
Date: Thu, 5 Nov 2009 10:04:19 -0700
Message-ID: <20091105170419.GU1966@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com> <20091028165043.GD1966@obsidianresearch.com> <E27512B9FE294380956C074D2C35D235@amr.corp.intel.com> <20091028185847.GK14520@obsidianresearch.com> <4AF2C361.1080307@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF2C361.1080307-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2009 at 02:21:53PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> >Well, looking at this, I see that ADDR_CHANGE is only generated on netdev 
> >events NETDEV_BONDING_FAILOVER - so what are the semantics WRT to UCM 
> >here? As I said before, defeating the ND process seriously affects how 
> >bonding works.

> Again, much of the rdma-cm essence is to link/bridge/glue the netdev and 
> rdma stacks. I don't see what it has to do with UCM which you keep 
> mentioning/repeating over this email/thread and elsewhere.

Oops, brian fart, I ment ACM

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
