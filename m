From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs V1 4/5] Export cross-channel capability flag
Date: Sat, 16 Jan 2016 17:53:43 +0200
Message-ID: <1452959624-29454-5-git-send-email-leon@leon.nu>
References: <1452959624-29454-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452959624-29454-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Export device capability flag IB_DEVICE_CROSS_CHANNEL
for the devices that can perform cross-channel operations.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index d91dd8a1376e..0ad9be3c323f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -121,6 +121,7 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_XRC			= 1 << 20,
 	IBV_DEVICE_RC_IP_CSUM		= 1 << 25,
 	IBV_DEVICE_RAW_IP_CSUM		= 1 << 26,
+	IBV_DEVICE_CROSS_CHANNEL	= 1 << 27,
 	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
 };
 
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
