From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 for-next] RDMA: Fix return value check for ib_get_eth_speed()
Date: Thu, 17 Aug 2017 07:58:07 -0700
Message-ID: <1502981887-31953-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_get_eth_speed() return 0 on success. Fixing the condition checking
and prevent reporting failure for query_port verb.

Fixes: d41861942fc5 ("Add generic function to extract IB speed from netdev")
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
v1 -> v2:
	Fixing the commit log. Also, fixes the same issue in usnic driver also
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 4 ++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index d78fedc..3fa20e0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -264,8 +264,8 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 	 * IB stack to avoid race in the NETDEV_UNREG path
 	 */
 	if (test_bit(BNXT_RE_FLAG_IBDEV_REGISTERED, &rdev->flags))
-		if (!ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
-				      &port_attr->active_width))
+		if (ib_get_eth_speed(ibdev, port_num, &port_attr->active_speed,
+				     &port_attr->active_width))
 			return -EINVAL;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index e5f57dd..97dd79e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -309,8 +309,8 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	usnic_dbg("\n");
 
 	mutex_lock(&us_ibdev->usdev_lock);
-	if (!ib_get_eth_speed(ibdev, port, &props->active_speed,
-			      &props->active_width)) {
+	if (ib_get_eth_speed(ibdev, port, &props->active_speed,
+			     &props->active_width)) {
 		mutex_unlock(&us_ibdev->usdev_lock);
 		return -EINVAL;
 	}
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
