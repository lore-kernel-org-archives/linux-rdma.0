From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libibverbs 3/3] libibverbs: Export cross-channel capability flag
Date: Sun, 20 Dec 2015 13:22:44 +0200
Message-ID: <1450610564-17279-4-git-send-email-leon@leon.nu>
References: <1450610564-17279-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610564-17279-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The device implements capability to execute complex
I/O operations across multiple I/O channels - synchronize
execution of I/O operations on one I/O channel with
execution of I/O operations on another channel(s).

Cross-channel operations support is indicated by the HCA_CAP.cd.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 2b9b50c87f45..879f4cca8173 100644
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
