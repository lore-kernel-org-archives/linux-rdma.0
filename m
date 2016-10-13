From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 15/17] mlx5: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:14 +0200
Message-ID: <1476388576-22863-16-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/mlx5/mlx5.c  | 2 +-
 providers/mlx5/verbs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index f24e504..4b05dc4 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -62,7 +62,7 @@
 	{ .vendor = PCI_VENDOR_ID_##v,			\
 	  .device = d }
 
-struct {
+static struct {
 	unsigned		vendor;
 	unsigned		device;
 } hca_table[] = {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index ef85a63..e288ebf 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1184,7 +1184,7 @@ enum {
 					IBV_QP_INIT_ATTR_RX_HASH),
 };
 
-struct ibv_qp *create_qp(struct ibv_context *context,
+static struct ibv_qp *create_qp(struct ibv_context *context,
 			 struct ibv_qp_init_attr_ex *attr)
 {
 	struct mlx5_create_qp		cmd;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
