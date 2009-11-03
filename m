From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] RDMA CM: Fix AF_INET6 support in multicast joining
Date: Tue, 3 Nov 2009 11:30:33 -0700
Message-ID: <20091103183033.GR7768@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If joining to an AF_INET6 address we need to map the address to a MGID
in the same way as the IP stack. The old code would just fall through to
the IPv4 case and generate garbage.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

Sean: Sounded like you approve?

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
