From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cma: Set default gid type to RoCEv2
Date: Tue, 30 May 2017 09:47:34 +0300
Message-ID: <20170530064734.4731-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RoCEv2 is the preferred RDMA protocol for Ethernet link layer because
of its advantages over RoCEv1. For better user experience make it the
default choice for RDMA_CM connections if device/port support it.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 91b7a2fe5a55..5ce3c9e1657e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -72,6 +72,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
+#define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP

 static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_ADDR_RESOLVED]	 = "address resolved",
@@ -4305,8 +4306,12 @@ static void cma_add_one(struct ib_device *device)
 	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
 		supported_gids = roce_gid_type_mask_support(device, i);
 		WARN_ON(!supported_gids);
-		cma_dev->default_gid_type[i - rdma_start_port(device)] =
-			find_first_bit(&supported_gids, BITS_PER_LONG);
+		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE)
+			cma_dev->default_gid_type[i - rdma_start_port(device)] =
+				CMA_PREFERRED_ROCE_GID_TYPE;
+		else
+			cma_dev->default_gid_type[i - rdma_start_port(device)] =
+				find_first_bit(&supported_gids, BITS_PER_LONG);
 		cma_dev->default_roce_tos[i - rdma_start_port(device)] = 0;
 	}

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
