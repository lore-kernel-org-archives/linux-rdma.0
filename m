From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/cma: Fix gid type setting for RoCE
Date: Fri, 11 Aug 2017 02:09:45 -0700
Message-ID: <1502442585-22391-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCE gid_type should be 0 or 1 based on RoCE v1 or
RoCE V2. Since bit mask is used now, cma_dev->default_gid_type
is set to 2 (1 << IB_GID_TYPE_ROCE_UDP_ENCAP).
Use the bit mask to check the prefered gid_type and
assign the gid_type value to IB_GID_TYPE_ROCE(0) or
IB_GID_TYPE_ROCE_UDP_ENCAP(1).

Fixes: 3c7f67d1880d (IB/cma: Fix default RoCE type setting)
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ca4135c..eb420da 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -72,7 +72,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
-#define CMA_PREFERRED_ROCE_GID_TYPE (1 << IB_GID_TYPE_ROCE_UDP_ENCAP)
+#define CMA_PREFERRED_ROCE_GID_TYPE_MASK (1 << IB_GID_TYPE_ROCE_UDP_ENCAP)
+#define CMA_PREFERRED_ROCE_GID_TYPE __ffs(CMA_PREFERRED_ROCE_GID_TYPE_MASK)
 
 static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_ADDR_RESOLVED]	 = "address resolved",
@@ -4282,7 +4283,7 @@ static void cma_add_one(struct ib_device *device)
 	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
 		supported_gids = roce_gid_type_mask_support(device, i);
 		WARN_ON(!supported_gids);
-		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE)
+		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE_MASK)
 			cma_dev->default_gid_type[i - rdma_start_port(device)] =
 				CMA_PREFERRED_ROCE_GID_TYPE;
 		else
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
