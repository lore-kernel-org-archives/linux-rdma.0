From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: use dst parameter in import_ep().
Date: Fri, 27 Apr 2012 10:24:33 -0500
Message-ID: <20120427152433.27398.80383.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Function import_ep() is incorrectly using ep->dst instead of the dst
ptr passed in.  This causes a crash when accepting new rdma connections
becase ep->dst is not initialized yet.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3d0e40a..2a71dd5 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1596,7 +1596,7 @@ static int import_ep(struct c4iw_ep *ep, __be32 peer_ip, struct dst_entry *dst,
 					n, n->dev, 0);
 		if (!ep->l2t)
 			goto out;
-		ep->mtu = dst_mtu(ep->dst);
+		ep->mtu = dst_mtu(dst);
 		ep->tx_chan = cxgb4_port_chan(n->dev);
 		ep->smac_idx = (cxgb4_port_viid(n->dev) & 0x7F) << 1;
 		step = cdev->rdev.lldi.ntxq /

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
