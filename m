From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: report correct port state if interface is down
Date: Mon, 23 Aug 2010 09:32:36 -0500
Message-ID: <20100823143236.GA6592@CTUNG-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


With commit cd6860eb03 we no longer remove nes interface on
ifdown.  On nes_query_port add additional check to net queue
and report IB_PORT_DOWN if the queue is not running.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index b89972c..2374efb 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -584,7 +584,9 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->lmc = 0;
 	props->sm_lid = 0;
 	props->sm_sl = 0;
-	if (nesvnic->linkup)
+	if (netif_queue_stopped(netdev))
+		props->state = IB_PORT_DOWN;
+	else if (nesvnic->linkup)
 		props->state = IB_PORT_ACTIVE;
 	else
 		props->state = IB_PORT_DOWN;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
