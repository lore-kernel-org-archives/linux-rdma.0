From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] RDMA/bnxt_re: Fix return value check for ib_get_eth_speed()
Date: Thu, 17 Aug 2017 04:48:24 -0700
Message-ID: <1502970504-30010-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_get_eth_speed() return 0 on success. Fixing the condition checking
and prevent reporting failure for query_port verb.

Fixes: d41861942fc5 (Add generic function to extract IB speed from netdev)
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
