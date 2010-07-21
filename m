From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Wed, 21 Jul 2010 17:40:25 +0300
Message-ID: <4C4706D9.2030100@Voltaire.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com>	<20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com>	<4C45E701.7030501@opengridcomputing.com>	<20100720184620.GJ7920@obsidianresearch.com>	<4C45F6F5.6050008@opengridcomputing.com>	<20100720203044.GK7920@obsidianresearch.com>	<4C460BFD.5010707@opengridcomputing.com> <20100720205746.GL7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720205746.GL7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> I'm thinking something like this..
> - The RDMA CM gets the dst from its route lookup locks it and stores it.
> - Instead of doing a route lookup cxgb gets the dst from RDMA CM,
>   locks it and stores it
> - RDMA CM traps all notifications/etc and generates callback to cxgb
>   to say the dst has changed.
> - cxgb releases the old dst and grabs the new one, updates the HW, etc.


Jason,

I'm up for extending the rdma-cm event of address change, on which an app can decide if
to re-act or not. For example, the in-tree iser and rds code treat this event the same as a disconnection request arriving, which means higher layer (e.g the user space iscsi daemon in the iser case) would try to re-connect. This has the advantage of simplifying the ULP state-machine, so there's no need for special handing for address-change, just treat it as a hint that re-connection is needed.

the cxgb* code take this deeper as they handle L2 changes in the driver level and not as event delivered to the ULP which can optionally address or ignore it.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
