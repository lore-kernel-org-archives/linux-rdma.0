From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/17] mthca: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:07 +0200
Message-ID: <1476388576-22863-9-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/mthca/mthca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index d5660ce..4103a3a 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -77,7 +77,7 @@
 	  .device = PCI_DEVICE_ID_MELLANOX_##d,		\
 	  .type = MTHCA_##t }
 
-struct {
+static struct {
 	unsigned		vendor;
 	unsigned		device;
 	enum mthca_hca_type	type;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
