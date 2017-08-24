From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/3] mlx5: Fix ABI break from revising the UAR pointer
Date: Thu, 24 Aug 2017 16:00:29 -0600
Message-ID: <1503612029-19854-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503612029-19854-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide two implementations of mlx5dv_init_obj, one that has the
historical behaviour that has existed until now of returning the
void **uar and a new version that returns the 'void *' version
renamed to arm_db.

Apps that use this feature must refer to it as arb_db, they will not
compile on pre-rdma-core 15 releases, and they will not dynamically
link to old versions either. This provides a sane level of safety for
the end users of this library.

Fixes: c6e3439aaa93 ("mlx5: Return pointer to CQ doorbell")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/ibverbs-providers.symbols |  2 ++
 providers/mlx5/CMakeLists.txt    |  2 +-
 providers/mlx5/libmlx5.map       |  5 +++++
 providers/mlx5/mlx5.c            | 24 ++++++++++++++++++++++--
 providers/mlx5/mlx5dv.h          |  2 +-
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index 5aa3b877b55b59..b03c33a2ba9fce 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -4,6 +4,8 @@ libmlx4.so.1 ibverbs-providers #MINVER#
 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13
  MLX5_1.1@MLX5_1.1 14
+ MLX5_1.2@MLX5_1.2 15
  mlx5dv_init_obj@MLX5_1.0 13
+ mlx5dv_init_obj@MLX5_1.2 15
  mlx5dv_query_device@MLX5_1.0 13
  mlx5dv_create_cq@MLX5_1.1 14
diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index 0fb9907bf258d1..ab6a42d8915a2a 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -11,7 +11,7 @@ if (MLX5_MW_DEBUG)
 endif()
 
 rdma_shared_provider(mlx5 libmlx5.map
-  1 1.1.${PACKAGE_VERSION}
+  1 1.2.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 6d9fb25f00a3db..e7fe9f41697009 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -11,3 +11,8 @@ MLX5_1.1 {
 	global:
 		mlx5dv_create_cq;
 } MLX5_1.0;
+
+MLX5_1.2 {
+	global:
+		mlx5dv_init_obj;
+} MLX5_1.1;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index dd825561ec740f..c949c0fce3c98b 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -42,6 +42,8 @@
 #include <sched.h>
 #include <sys/param.h>
 
+#include <util/symver.h>
+
 #include "mlx5.h"
 #include "mlx5-abi.h"
 
@@ -678,7 +680,7 @@ static int mlx5dv_get_cq(struct ibv_cq *cq_in,
 	cq_out->cqe_size  = mcq->cqe_sz;
 	cq_out->buf       = mcq->active_buf->buf;
 	cq_out->dbrec     = mcq->dbrec;
-	cq_out->uar	  = mctx->uar[0];
+	cq_out->arm_db	  = mctx->uar[0];
 
 	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
 
@@ -716,7 +718,9 @@ static int mlx5dv_get_srq(struct ibv_srq *srq_in,
 	return 0;
 }
 
-int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
+LATEST_SYMVER_FUNC(mlx5dv_init_obj, 1_2, "MLX5_1.2",
+		   int,
+		   struct mlx5dv_obj *obj, uint64_t obj_type)
 {
 	int ret = 0;
 
@@ -732,6 +736,22 @@ int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
 	return ret;
 }
 
+COMPAT_SYMVER_FUNC(mlx5dv_init_obj, 1_0, "MLX5_1.0",
+		   int,
+		   struct mlx5dv_obj *obj, uint64_t obj_type)
+{
+	int ret = 0;
+
+	ret = __mlx5dv_init_obj_1_2(obj, obj_type);
+	if (!ret && (obj_type & MLX5DV_OBJ_CQ)) {
+		/* ABI version 1.0 returns the void ** in this memory
+		 * location
+		 */
+		obj->cq.out->arm_db = to_mctx(obj->cq.in->context)->uar;
+	}
+	return ret;
+}
+
 static void adjust_uar_info(struct mlx5_device *mdev,
 			    struct mlx5_context *context,
 			    struct mlx5_alloc_ucontext_resp resp)
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index cff3a10457300f..1a2e257c4bcc6f 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -129,7 +129,7 @@ struct mlx5dv_cq {
 	__be32			*dbrec;
 	uint32_t		cqe_cnt;
 	uint32_t		cqe_size;
-	void			*uar;
+	void			*arm_db;
 	uint32_t		cqn;
 	uint64_t		comp_mask;
 };
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
