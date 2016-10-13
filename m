From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 14/32] cxgb4: mark symbols static where possible
Date: Thu, 13 Oct 2016 19:51:17 +0200
Message-ID: <1476381095-20041-15-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/cxgb4/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index e1486ec..69b04ac 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -49,7 +49,7 @@
  * Macros needed to support the PCI Device ID Table ...
  */
 #define CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN \
-	struct { \
+	static struct { \
 		unsigned vendor; \
 		unsigned device; \
 	} hca_table[] = {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
