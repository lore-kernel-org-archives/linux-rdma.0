From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 01/22] IB/cma: Fix erroneous validation of supported default GID type
Date: Fri, 11 Aug 2017 13:49:42 +0300
Message-ID: <20170811105003.7661-2-leon@kernel.org>
References: <20170811105003.7661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811105003.7661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When rdma_cm is initializing a cma_device it checks if this device
supports the preferred default GID type. This check was done in a wrong way
and therefore sometimes rdma_cm is coming up with default GID type that is
not supported by the device.

Fix that by checking for supported GID type properly.

Fixes: 3c7f67d1880d ("IB/cma: Fix default RoCE type setting")
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d8edd8b11561..f5f88b427328 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -72,7 +72,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
-#define CMA_PREFERRED_ROCE_GID_TYPE (1 << IB_GID_TYPE_ROCE_UDP_ENCAP)
+#define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
 
 static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_ADDR_RESOLVED]	 = "address resolved",
@@ -4282,7 +4282,7 @@ static void cma_add_one(struct ib_device *device)
 	for (i = rdma_start_port(device); i <= rdma_end_port(device); i++) {
 		supported_gids = roce_gid_type_mask_support(device, i);
 		WARN_ON(!supported_gids);
-		if (supported_gids & CMA_PREFERRED_ROCE_GID_TYPE)
+		if (supported_gids & (1 << CMA_PREFERRED_ROCE_GID_TYPE))
 			cma_dev->default_gid_type[i - rdma_start_port(device)] =
 				CMA_PREFERRED_ROCE_GID_TYPE;
 		else
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
