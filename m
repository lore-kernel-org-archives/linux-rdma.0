From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/rxe: Check return value from get_settings
Date: Sun,  4 Jun 2017 20:06:19 +0300
Message-ID: <20170604170619.3697-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The functions get_link_ksettings and get_settings might return bad
status indicating a failure to retrieve interface atttibutes.
Check return value to cover this case.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e..ffd3888 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -81,6 +81,7 @@ static int rxe_query_port(struct ib_device *dev,
 	struct rxe_dev *rxe = to_rdev(dev);
 	struct rxe_port *port;
 	u32 speed;
+	int rc = -EINVAL;
 
 	if (unlikely(port_num != 1)) {
 		pr_warn("invalid port_number %d\n", port_num);
@@ -96,14 +97,15 @@ static int rxe_query_port(struct ib_device *dev,
 	if (rxe->ndev->ethtool_ops->get_link_ksettings) {
 		struct ethtool_link_ksettings ks;
 
-		rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
+		rc = rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
 		speed = ks.base.speed;
 	} else if (rxe->ndev->ethtool_ops->get_settings) {
 		struct ethtool_cmd cmd;
 
-		rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
+		rc = rxe->ndev->ethtool_ops->get_settings(rxe->ndev, &cmd);
 		speed = cmd.speed;
-	} else {
+	}
+	if (rc) {
 		pr_warn("%s speed is unknown, defaulting to 1000\n",
 			rxe->ndev->name);
 		speed = 1000;
-- 
2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
