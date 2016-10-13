From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/17] cxgb3: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:01 +0200
Message-ID: <1476388576-22863-3-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/cxgb3/cq.c   | 2 +-
 providers/cxgb3/iwch.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/cxgb3/cq.c b/providers/cxgb3/cq.c
index 1510d1e..a6158ce 100644
--- a/providers/cxgb3/cq.c
+++ b/providers/cxgb3/cq.c
@@ -255,7 +255,7 @@ skip_cqe:
  *	-EAGAIN 		caller must try again
  * 	any other -errno	fatal error
  */
-int iwch_poll_cq_one(struct iwch_device *rhp, struct iwch_cq *chp,
+static int iwch_poll_cq_one(struct iwch_device *rhp, struct iwch_cq *chp,
 		     struct ibv_wc *wc)
 {
 	struct iwch_qp *qhp = NULL;
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 804726c..a03bced 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -61,7 +61,7 @@
 	  .device = PCI_DEVICE_ID_CHELSIO_##d,		\
 	  .type = CHELSIO_##t }
 
-struct {
+static struct {
 	unsigned vendor;
 	unsigned device;
 	enum iwch_hca_type type;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
