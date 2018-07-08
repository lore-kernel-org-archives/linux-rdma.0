From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/9] IB: Enable uverbs_destroy_def_handler to be used by drivers
Date: Sun,  8 Jul 2018 13:24:39 +0300
Message-ID: <20180708102445.25496-4-leon@kernel.org>
References: <20180708102445.25496-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180708102445.25496-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enable uverbs_destroy_def_handler to be used by drivers and replace
current code to use it.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs.h           |  3 ---
 drivers/infiniband/core/uverbs_std_types.c |  1 +
 drivers/infiniband/hw/mlx5/devx.c          | 18 ++----------------
 include/rdma/ib_verbs.h                    |  3 +++
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index cbb727f0959f..1d06e6b4e0cd 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -247,9 +247,6 @@ void ib_uverbs_detach_umcast(struct ib_qp *qp,
 
 void create_udata(struct uverbs_attr_bundle *ctx, struct ib_udata *udata);
 long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
-int uverbs_destroy_def_handler(struct ib_device *ib_dev,
-			       struct ib_uverbs_file *file,
-			       struct uverbs_attr_bundle *attrs);
 
 struct ib_uverbs_flow_spec {
 	union {
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 912519fda3ba..718c8430d364 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -215,6 +215,7 @@ int uverbs_destroy_def_handler(struct ib_device *ib_dev,
 {
 	return 0;
 }
+EXPORT_SYMBOL(uverbs_destroy_def_handler);
 
 void create_udata(struct uverbs_attr_bundle *ctx, struct ib_udata *udata)
 {
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 192844bf6016..60ac1fbe940e 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -682,13 +682,6 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	return ret;
 }
 
-static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_DESTROY)(struct ib_device *ib_dev,
-				    struct ib_uverbs_file *file,
-				    struct uverbs_attr_bundle *attrs)
-{
-	return 0;
-}
-
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(struct ib_device *ib_dev,
 				   struct ib_uverbs_file *file,
 				   struct uverbs_attr_bundle *attrs)
@@ -961,13 +954,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(struct ib_device *ib_dev
 	return err;
 }
 
-static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_DEREG)(struct ib_device *ib_dev,
-				   struct ib_uverbs_file *file,
-				   struct uverbs_attr_bundle *attrs)
-{
-	return 0;
-}
-
 static int devx_umem_cleanup(struct ib_uobject *uobject,
 			     enum rdma_remove_reason why)
 {
@@ -1003,7 +989,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UVERBS_ATTR_TYPE(u32),
 			    UA_MANDATORY));
 
-DECLARE_UVERBS_NAMED_METHOD(
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_DEVX_UMEM_DEREG,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_UMEM_DEREG_HANDLE,
 			MLX5_IB_OBJECT_DEVX_UMEM,
@@ -1056,7 +1042,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 		UVERBS_ATTR_MIN_SIZE(MLX5_ST_SZ_BYTES(general_obj_out_cmd_hdr)),
 		UA_MANDATORY));
 
-DECLARE_UVERBS_NAMED_METHOD(
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	MLX5_IB_METHOD_DEVX_OBJ_DESTROY,
 	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DEVX_OBJ_DESTROY_HANDLE,
 			MLX5_IB_OBJECT_DEVX_OBJ,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 031d121190fd..01b9d5a54368 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4160,4 +4160,7 @@ void rdma_roce_rescan_device(struct ib_device *ibdev);
 
 struct ib_ucontext *ib_uverbs_get_ucontext(struct ib_uverbs_file *ufile);
 
+int uverbs_destroy_def_handler(struct ib_device *ib_dev,
+			       struct ib_uverbs_file *file,
+			       struct uverbs_attr_bundle *attrs);
 #endif /* IB_VERBS_H */
-- 
2.14.4
