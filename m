From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 13/16] IB/iser: Micro-optimize iser logging
Date: Sun,  7 Dec 2014 16:10:04 +0200
Message-ID: <1417961407-10139-14-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

And fix a checkpatch warning.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 4234a9c..cf704da 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -73,30 +73,27 @@
 
 #define iser_dbg(fmt, arg...)				 \
 	do {						 \
-		if (iser_debug_level > 2)		 \
+		if (unlikely(iser_debug_level > 2))	 \
 			printk(KERN_DEBUG PFX "%s: " fmt,\
 				__func__ , ## arg);	 \
 	} while (0)
 
 #define iser_warn(fmt, arg...)				\
 	do {						\
-		if (iser_debug_level > 0)		\
+		if (unlikely(iser_debug_level > 0))	\
 			pr_warn(PFX "%s: " fmt,		\
 				__func__ , ## arg);	\
 	} while (0)
 
 #define iser_info(fmt, arg...)				\
 	do {						\
-		if (iser_debug_level > 1)		\
+		if (unlikely(iser_debug_level > 1))	\
 			pr_info(PFX "%s: " fmt,		\
 				__func__ , ## arg);	\
 	} while (0)
 
-#define iser_err(fmt, arg...)				\
-	do {						\
-		printk(KERN_ERR PFX "%s: " fmt,		\
-		       __func__ , ## arg);		\
-	} while (0)
+#define iser_err(fmt, arg...) \
+	pr_err(PFX "%s: " fmt, __func__ , ## arg)
 
 #define SHIFT_4K	12
 #define SIZE_4K	(1ULL << SHIFT_4K)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
