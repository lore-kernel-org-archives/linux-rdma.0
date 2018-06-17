From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 17/20] IB/mlx5: Add support for DEVX query UAR
Date: Sun, 17 Jun 2018 13:00:03 +0300
Message-ID: <20180617100006.30663-18-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Return a device UAR index for a given user index via the DEVX interface.

Security note:
The hardware protection mechanism works like this: Each device object that
is subject to UAR doorbells (QP/SQ/CQ) gets a UAR ID (called uar_page in
the device specification manual) upon its creation. Then upon doorbell,
hardware fetches the object context for which the doorbell was rang, and
validates that the UAR through which the DB was rang matches the UAR ID
of the object.

If no match the doorbell is silently ignored by the hardware.  Of
course, the user cannot ring a doorbell on a UAR that was not mapped to
it.

Now in devx, as the devx kernel does not manipulate the QP/SQ/CQ command
mailboxes (except tagging them with UID), we expose to the user its UAR
ID, so it can embed it in these objects in the expected specification
format. So the only thing the user can do is hurt itself by creating a
QP/SQ/CQ with a UAR ID other than his, and then in this case other users
may ring a doorbell on its objects.

The consequence of that will be that another user can schedule a QP/SQ
of the buggy user for execution (just insert it to the hardware schedule
queue or arm its CQ for event generation), no further harm is expected.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c        | 53 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  3 ++
 drivers/infiniband/hw/mlx5/qp.c          |  9 ++++--
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  6 ++++
 4 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d1cf14874323..386142684637 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -373,6 +373,50 @@ static bool devx_is_general_cmd(void *in)
 	}
 }
 
+/*
+ *Security note:
+ * The hardware protection mechanism works like this: Each device object that
+ * is subject to UAR doorbells (QP/SQ/CQ) gets a UAR ID (called uar_page in
+ * the device specification manual) upon its creation. Then upon doorbell,
+ * hardware fetches the object context for which the doorbell was rang, and
+ * validates that the UAR through which the DB was rang matches the UAR ID
+ * of the object.
+ * If no match the doorbell is silently ignored by the hardware. Of course,
+ * the user cannot ring a doorbell on a UAR that was not mapped to it.
+ * Now in devx, as the devx kernel does not manipulate the QP/SQ/CQ command
+ * mailboxes (except tagging them with UID), we expose to the user its UAR
+ * ID, so it can embed it in these objects in the expected specification
+ * format. So the only thing the user can do is hurt itself by creating a
+ * QP/SQ/CQ with a UAR ID other than his, and then in this case other users
+ * may ring a doorbell on its objects.
+ * The consequence of that will be that another user can schedule a QP/SQ
+ * of the buggy user for execution (just insert it to the hardware schedule
+ * queue or arm its CQ for event generation), no further harm is expected.
+ */
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_UAR)(struct ib_device *ib_dev,
+				  struct ib_uverbs_file *file,
+				  struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_ucontext *c = devx_ufile2uctx(file);
+	u32 user_idx;
+	s32 dev_idx;
+
+	if (uverbs_copy_from(&user_idx, attrs,
+			     MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX))
+		return -EFAULT;
+
+	dev_idx = bfregn_to_uar_index(to_mdev(ib_dev),
+				      &c->bfregi, user_idx, true);
+	if (dev_idx < 0)
+		return dev_idx;
+
+	if (uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_QUERY_UAR_DEV_IDX,
+			   &dev_idx, sizeof(dev_idx)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(struct ib_device *ib_dev,
 				  struct ib_uverbs_file *file,
 				  struct uverbs_attr_bundle *attrs)
@@ -743,6 +787,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(struct ib_device *ib_de
 	return err;
 }
 
+static DECLARE_UVERBS_NAMED_METHOD(MLX5_IB_METHOD_DEVX_QUERY_UAR,
+	&UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX, UVERBS_ATTR_TYPE(u32),
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	&UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_DEVX_QUERY_UAR_DEV_IDX, UVERBS_ATTR_TYPE(u32),
+			     UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
 static DECLARE_UVERBS_NAMED_METHOD(MLX5_IB_METHOD_DEVX_OTHER,
 	&UVERBS_ATTR_PTR_IN_SZ(MLX5_IB_ATTR_DEVX_OTHER_CMD_IN,
 			       UVERBS_ATTR_MIN_SIZE(MLX5_ST_SZ_BYTES(general_obj_in_cmd_hdr)),
@@ -807,7 +857,8 @@ static DECLARE_UVERBS_NAMED_METHOD(MLX5_IB_METHOD_DEVX_OBJ_QUERY,
 					 UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO)));
 
 static DECLARE_UVERBS_GLOBAL_METHODS(MLX5_IB_OBJECT_DEVX,
-	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_OTHER));
+	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_OTHER),
+	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_QUERY_UAR));
 
 static DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_DEVX_OBJ,
 	&UVERBS_TYPE_ALLOC_IDR(devx_obj_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 5e8abd8bcd71..a5560375047a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1331,4 +1331,7 @@ static inline int get_num_static_uars(struct mlx5_ib_dev *dev,
 unsigned long mlx5_ib_get_xlt_emergency_page(void);
 void mlx5_ib_put_xlt_emergency_page(void);
 
+int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+			struct mlx5_bfreg_info *bfregi, int bfregn,
+			bool dyn_bfreg);
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a4f1f638509f..f6389d0373d0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -641,9 +641,9 @@ static void mlx5_ib_lock_cqs(struct mlx5_ib_cq *send_cq,
 static void mlx5_ib_unlock_cqs(struct mlx5_ib_cq *send_cq,
 			       struct mlx5_ib_cq *recv_cq);
 
-static int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
-			       struct mlx5_bfreg_info *bfregi, int bfregn,
-			       bool dyn_bfreg)
+int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+			struct mlx5_bfreg_info *bfregi, int bfregn,
+			bool dyn_bfreg)
 {
 	int bfregs_per_sys_page;
 	int index_of_sys_page;
@@ -653,6 +653,9 @@ static int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 				MLX5_NON_FP_BFREGS_PER_UAR;
 	index_of_sys_page = bfregn / bfregs_per_sys_page;
 
+	if (index_of_sys_page >= bfregi->num_sys_pages)
+		return -EINVAL;
+
 	if (dyn_bfreg) {
 		index_of_sys_page += bfregi->num_static_sys_pages;
 		if (bfregn > bfregi->num_dyn_bfregs ||
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 97d216b8d053..1252695cd94b 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -47,6 +47,7 @@ enum mlx5_ib_alloc_dm_attrs {
 
 enum mlx5_ib_devx_methods {
 	MLX5_IB_METHOD_DEVX_OTHER  = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_DEVX_QUERY_UAR,
 };
 
 enum  mlx5_ib_devx_other_attrs {
@@ -60,6 +61,11 @@ enum mlx5_ib_devx_obj_create_attrs {
 	MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT,
 };
 
+enum  mlx5_ib_devx_query_uar_attrs {
+	MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_DEVX_QUERY_UAR_DEV_IDX,
+};
+
 enum mlx5_ib_devx_obj_destroy_attrs {
 	MLX5_IB_ATTR_DEVX_OBJ_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
 };
-- 
2.14.4
