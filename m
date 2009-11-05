From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
 for RDMA CM
Date: Thu, 05 Nov 2009 14:21:53 +0200
Message-ID: <4AF2C361.1080307@voltaire.com>
References: <20091028054253.GA22882@obsidianresearch.com>	<4E89386C612E46C9A33501CEC2521BAF@amr.corp.intel.com>	<20091028165043.GD1966@obsidianresearch.com>	<E27512B9FE294380956C074D2C35D235@amr.corp.intel.com> <20091028185847.GK14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028185847.GK14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Well, looking at this, I see that ADDR_CHANGE is only generated on netdev events NETDEV_BONDING_FAILOVER - so what are the semantics WRT to UCM here? As I said before, defeating the ND process seriously affects how bonding works.
Again, much of the rdma-cm essence is to link/bridge/glue the netdev and 
rdma stacks. I don't see what it has to do with UCM which you keep 
mentioning/repeating over this email/thread and elsewhere.

Sean, I don't see why ACM can't be implemented without introducing 
AF_IB/PS_IB, is it really a must or more of something you see as making 
the implementation somehow easier? Now, even if you are fine with AF_IB, 
I don't think that UCM should take over the rdma-ucm and fill the kernel 
rdma-cm code with tons of IB specifics code. If people need UCM, lets 
them use libibcm.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
