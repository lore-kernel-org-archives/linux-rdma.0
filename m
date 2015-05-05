From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IPoIB/CM: Fix indentation level
Date: Tue, 5 May 2015 13:01:39 +0200
Message-ID: <5548A313.3080908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

See also patch "IPoIB/cm: Add connected mode support for devices
without SRQs" (commit ID 68e995a29572). Detected by smatch.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 56959ad..cf32a778 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -386,8 +386,8 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 					   rx->rx_ring[i].mapping,
 					   GFP_KERNEL)) {
 			ipoib_warn(priv, "failed to allocate receive buffer %d\n", i);
-				ret = -ENOMEM;
-				goto err_count;
+			ret = -ENOMEM;
+			goto err_count;
 		}
 		ret = ipoib_cm_post_receive_nonsrq(dev, rx, &t->wr, t->sge, i);
 		if (ret) {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
