From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 5/5] providers: Remove unneeded function prototypes
Date: Thu, 14 Dec 2017 15:35:43 -0700
Message-ID: <20171214223544.30117-6-jgg@ziepe.ca>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

These are no longer needed after prior changes to the ops structure
placement.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/i40iw/i40iw_umain.c  | 3 ---
 providers/nes/nes_umain.c      | 3 ---
 providers/ocrdma/ocrdma_main.c | 3 ---
 providers/qedr/qelr_main.c     | 3 ---
 4 files changed, 12 deletions(-)

diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 61c2a92dd6734c..77c1ced812499b 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -91,9 +91,6 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context *i40iw_ualloc_context(struct ibv_device *, int);
-static void i40iw_ufree_context(struct ibv_context *);
-
 static struct ibv_context_ops i40iw_uctx_ops = {
 	.query_device	= i40iw_uquery_device,
 	.query_port	= i40iw_uquery_port,
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index fd3d19def399b2..bd0b6ac68cec40 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -63,9 +63,6 @@ static const struct verbs_match_ent hca_table[] = {
 	{},
 };
 
-static struct ibv_context *nes_ualloc_context(struct ibv_device *, int);
-static void nes_ufree_context(struct ibv_context *);
-
 static struct ibv_context_ops nes_uctx_ops = {
 	.query_device = nes_uquery_device,
 	.query_port = nes_uquery_port,
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 92a5b8a5d1c86c..afd5d79c1884c0 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -64,9 +64,6 @@ static const struct verbs_match_ent ucna_table[] = {
 	{}
 };
 
-static struct ibv_context *ocrdma_alloc_context(struct ibv_device *, int);
-static void ocrdma_free_context(struct ibv_context *);
-
 static struct ibv_context_ops ocrdma_ctx_ops = {
 	.query_device = ocrdma_query_device,
 	.query_port = ocrdma_query_port,
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index fa2be455edc93e..4d62442a58dcb7 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -80,9 +80,6 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context *qelr_alloc_context(struct ibv_device *, int);
-static void qelr_free_context(struct ibv_context *);
-
 static struct ibv_context_ops qelr_ctx_ops = {
 	.query_device = qelr_query_device,
 	.query_port = qelr_query_port,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
