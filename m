From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/9] RDMA CM: Fix AF_INET6 support in multicast joining
Date: Mon, 16 Nov 2009 15:57:54 -0800
Message-ID: <42E34BCA3C1A4A5A8D05055ED243BBEE@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <[jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]>

If joining to an AF_INET6 address we need to map the address to a MGID
in the same way as the IP stack. The old code would just fall through to
the IPv4 case and generate garbage.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8bb2cf4..052b4c0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2691,6 +2691,11 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
