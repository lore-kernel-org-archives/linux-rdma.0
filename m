From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] librdmacm/mckey: enforce local binding for unmapped
	multicast addresses
Date: Mon, 2 Nov 2009 11:42:27 -0700
Message-ID: <20091102184227.GD7768@obsidianresearch.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911011130140.6591-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 01, 2009 at 11:31:22AM +0200, Or Gerlitz wrote:

> Sean, using unmapped multicast addresses I see that a different broacast group is
> created by the SM such that mckey doesn't manage to join the ipv4 broadcast group
> 
> $ ./mckey -M ff12:401b:ffff:0:0:0:ffff:ffff -b 10.10.5.62 -p 0x2
> 
> mckey: joined dgid: ff12:401b:ffff:: mlid c00b sl 0

Erm, I'm not sure what is going on by the time things get to the SA,
but the above output shows this kernel bug. The joined DGID for that
AF_INET6 address should be FF12:601b::FFFF:FFFF

The AF_INET6 -M argument to mckey is not treated as a MGID unless it is
prefixed with FF10:A01B:: (so ugly..)

If you want to join the IPv4 all hosts group I think you need to use
-M 255.255.255.255

Your result does show that something else is wrong too, the group with
MLID 0xC00B should have been MGID ff12:401b:ffff:: like mckey reported
..

>From 9f3a76deb5bfda0f8243eadfa024eb547c03f583 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Mon, 2 Nov 2009 11:23:38 -0700
Subject: [PATCH] RDMA CM: Fix AF_INET6 support in multicast joining

If joining to an AF_INET6 address we need to map the address to a MGID
in the same way as the IP stack. The old code would just fall through to
the IPv4 case and generate garbage.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

compile tested only.

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a0fa241..1e9a78a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2724,6 +2724,11 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 								 0xFF10A01B)) {
 		/* IPv6 address is an SA assigned MGID. */
 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
+	} else if ((addr->sa_family == AF_INET6)) {
+		ipv6_ib_mc_map(&sin6->sin6_addr, dev_addr->broadcast, mc_map);
+		if (id_priv->id.ps == RDMA_PS_UDP)
+			mc_map[7] = 0x01;	/* Use RDMA CM signature */
+		*mgid = *(union ib_gid *) (mc_map + 4);
 	} else {
 		ip_ib_mc_map(sin->sin_addr.s_addr, dev_addr->broadcast, mc_map);
 		if (id_priv->id.ps == RDMA_PS_UDP)
-- 
1.5.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
