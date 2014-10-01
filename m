From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 18/21] IB/iser: Nit - add space after __func__ in iser logging
Date: Wed,  1 Oct 2014 14:02:14 +0300
Message-ID: <1412161337-25285-19-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change logging: "iser:XXXX" to "iser: XXXX"

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index f4e9d62..eedcbf2 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -71,30 +71,30 @@
 #define PFX		DRV_NAME ": "
 #define DRV_VER		"1.4.1"
 
-#define iser_dbg(fmt, arg...)				\
-	do {						\
-		if (iser_debug_level > 2)		\
-			printk(KERN_DEBUG PFX "%s:" fmt,\
-				__func__ , ## arg);	\
+#define iser_dbg(fmt, arg...)				 \
+	do {						 \
+		if (iser_debug_level > 2)		 \
+			printk(KERN_DEBUG PFX "%s: " fmt,\
+				__func__ , ## arg);	 \
 	} while (0)
 
 #define iser_warn(fmt, arg...)				\
 	do {						\
 		if (iser_debug_level > 0)		\
-			pr_warn(PFX "%s:" fmt,          \
+			pr_warn(PFX "%s: " fmt,		\
 				__func__ , ## arg);	\
 	} while (0)
 
 #define iser_info(fmt, arg...)				\
 	do {						\
 		if (iser_debug_level > 1)		\
-			pr_info(PFX "%s:" fmt,          \
+			pr_info(PFX "%s: " fmt,		\
 				__func__ , ## arg);	\
 	} while (0)
 
 #define iser_err(fmt, arg...)				\
 	do {						\
-		printk(KERN_ERR PFX "%s:" fmt,          \
+		printk(KERN_ERR PFX "%s: " fmt,		\
 		       __func__ , ## arg);		\
 	} while (0)
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
