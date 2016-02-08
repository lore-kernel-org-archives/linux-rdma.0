From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 6/7] Expose device capabilities for Memory Window type two
Date: Mon,  8 Feb 2016 14:43:21 +0200
Message-ID: <1454935402-15192-7-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

At that step Memory Window type two is ready to be used, exposing
its device capabilities.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index b9102a6..8eb1f08 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -119,6 +119,9 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_MEM_WINDOW           = 1 << 17,
 	IBV_DEVICE_UD_IP_CSUM		= 1 << 18,
 	IBV_DEVICE_XRC			= 1 << 20,
+	IBV_DEVICE_MEM_MGT_EXTENSIONS	= 1 << 21,
+	IBV_DEVICE_MEM_WINDOW_TYPE_2A	= 1 << 23,
+	IBV_DEVICE_MEM_WINDOW_TYPE_2B	= 1 << 24,
 	IBV_DEVICE_RC_IP_CSUM		= 1 << 25,
 	IBV_DEVICE_RAW_IP_CSUM		= 1 << 26,
 	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
