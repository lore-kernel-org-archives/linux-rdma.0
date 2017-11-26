From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 1/4] verbs: Intorduce QP type IBV_QPT_VENDOR
Date: Sun, 26 Nov 2017 19:45:14 +0200
Message-ID: <1511718317-3381-4-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new QP type for vendor QP is added to the reflect the change in the
kernel.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b39dc30..95594dc 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -813,7 +813,8 @@ enum ibv_qp_type {
 	IBV_QPT_UD,
 	IBV_QPT_RAW_PACKET = 8,
 	IBV_QPT_XRC_SEND = 9,
-	IBV_QPT_XRC_RECV
+	IBV_QPT_XRC_RECV,
+	IBV_QPT_VENDOR = 0xfff,
 };
 
 struct ibv_qp_cap {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
