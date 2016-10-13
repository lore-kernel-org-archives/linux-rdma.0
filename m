From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 13/17] nes: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:12 +0200
Message-ID: <1476388576-22863-14-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/nes/nes_umain.c  | 2 +-
 providers/nes/nes_uverbs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index b4e0bc1..4b19dd7 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -60,7 +60,7 @@ long int page_size;
 	  .device = d,    \
 	  .type = NETEFFECT_##t }
 
-struct {
+static struct {
 	unsigned vendor;
 	unsigned device;
 	enum nes_uhca_type type;
diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index 287e773..f404ffd 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -759,7 +759,7 @@ int nes_upoll_cq_no_db_read(struct ibv_cq *cq, int num_entries, struct ibv_wc *e
 /**
  * nes_arm_cq
  */
-void nes_arm_cq(struct nes_ucq *nesucq, struct nes_uvcontext *nesvctx, int sol)
+static void nes_arm_cq(struct nes_ucq *nesucq, struct nes_uvcontext *nesvctx, int sol)
 {
 	uint32_t cq_arm;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
