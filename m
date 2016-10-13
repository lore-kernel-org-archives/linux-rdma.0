From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/17] cxgb3: handle global variables properly
Date: Thu, 13 Oct 2016 21:56:00 +0200
Message-ID: <1476388576-22863-2-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We'll need to define them in one compilation unit and use an extern
declaration in the headers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/cxgb3/cxio_wr.h | 6 +++---
 providers/cxgb3/iwch.c    | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/providers/cxgb3/cxio_wr.h b/providers/cxgb3/cxio_wr.h
index e154795..d56c529 100644
--- a/providers/cxgb3/cxio_wr.h
+++ b/providers/cxgb3/cxio_wr.h
@@ -633,9 +633,9 @@ static inline unsigned t3_cq_depth(struct t3_cq *cq)
 	return (1UL<<cq->size_log2);
 }
 
-unsigned long iwch_page_size;
-unsigned long iwch_page_shift;
-unsigned long iwch_page_mask;
+extern unsigned long iwch_page_size;
+extern unsigned long iwch_page_shift;
+extern unsigned long iwch_page_mask;
 
 #define PAGE_ALIGN(x) (((x) + iwch_page_mask) & ~iwch_page_mask)
 
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index aa9b108..804726c 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -105,6 +105,10 @@ static struct ibv_context_ops iwch_ctx_ops = {
 	.req_notify_cq = iwch_arm_cq,
 };
 
+unsigned long iwch_page_size;
+unsigned long iwch_page_shift;
+unsigned long iwch_page_mask;
+
 static struct ibv_context *iwch_alloc_context(struct ibv_device *ibdev,
 					      int cmd_fd)
 {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
