From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/17] ocrdma: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:09 +0200
Message-ID: <1476388576-22863-11-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/ocrdma/ocrdma_main.c  | 2 +-
 providers/ocrdma/ocrdma_verbs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index f3830d9..39da8f0 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -59,7 +59,7 @@
 	{ .vendor = PCI_VENDOR_ID_##v,        \
 	  .device = PCI_DEVICE_ID_EMULEX_##d }
 
-struct {
+static struct {
 	unsigned vendor;
 	unsigned device;
 } ucna_table[] = {
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 163bf23..c5dd74b 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -608,7 +608,7 @@ mbx_err:
 	return NULL;
 }
 
-enum ocrdma_qp_state get_ocrdma_qp_state(enum ibv_qp_state qps)
+static enum ocrdma_qp_state get_ocrdma_qp_state(enum ibv_qp_state qps)
 {
 	switch (qps) {
 	case IBV_QPS_RESET:
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
