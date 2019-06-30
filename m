From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 12/13] IB/mlx5: Add DEVX support for CQ events
Date: Sun, 30 Jun 2019 19:23:33 +0300
Message-ID: <20190630162334.22135-13-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add DEVX support for CQ events by creating and destroying the CQ via
mlx5_core and set an handler to manage its completions.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 39 +++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index de068fe94363..38064f4bfdf6 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -19,9 +19,12 @@
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
 
+static void dispatch_event_fd(struct list_head *fd_list, const void *data);
+
 enum devx_obj_flags {
 	DEVX_OBJ_FLAGS_INDIRECT_MKEY = 1 << 0,
 	DEVX_OBJ_FLAGS_DCT = 1 << 1,
+	DEVX_OBJ_FLAGS_CQ = 1 << 2,
 };
 
 struct devx_async_data {
@@ -89,6 +92,7 @@ struct devx_async_event_file {
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
 struct devx_obj {
 	struct mlx5_core_dev	*mdev;
+	struct mlx5_ib_dev	*ib_dev;
 	u64			obj_id;
 	u32			dinlen; /* destroy inbox length */
 	u32			dinbox[MLX5_MAX_DESTROY_INBOX_SIZE_DW];
@@ -96,6 +100,7 @@ struct devx_obj {
 	union {
 		struct mlx5_ib_devx_mr	devx_mr;
 		struct mlx5_core_dct	core_dct;
+		struct mlx5_core_cq	core_cq;
 	};
 	struct list_head event_sub; /* holds devx_event_subscription entries */
 };
@@ -1346,6 +1351,8 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		ret = mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
+		ret = mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
 	else
 		ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
 				    sizeof(out));
@@ -1369,6 +1376,29 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	return ret;
 }
 
+static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
+{
+	struct devx_obj *obj = container_of(mcq, struct devx_obj, core_cq);
+	struct mlx5_devx_event_table *table;
+	struct devx_event *event;
+	struct devx_obj_event *obj_event;
+	u32 obj_id = mcq->cqn;
+
+	table = &obj->ib_dev->devx_event_table;
+	rcu_read_lock();
+	event = xa_load(&table->event_xa, MLX5_EVENT_TYPE_COMP);
+	if (!event)
+		goto out;
+
+	obj_event = xa_load(&event->object_ids, obj_id);
+	if (!obj_event)
+		goto out;
+
+	dispatch_event_fd(&obj_event->obj_sub_list, eqe);
+out:
+	rcu_read_unlock();
+}
+
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct uverbs_attr_bundle *attrs)
 {
@@ -1420,6 +1450,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		err = mlx5_core_create_dct(dev->mdev, &obj->core_dct,
 					   cmd_in, cmd_in_len,
 					   cmd_out, cmd_out_len);
+	} else if (opcode == MLX5_CMD_OP_CREATE_CQ) {
+		obj->flags |= DEVX_OBJ_FLAGS_CQ;
+		obj->core_cq.comp = devx_cq_comp;
+		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
+					  cmd_in, cmd_in_len, cmd_out,
+					  cmd_out_len);
 	} else {
 		err = mlx5_cmd_exec(dev->mdev, cmd_in,
 				    cmd_in_len,
@@ -1432,6 +1468,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	INIT_LIST_HEAD(&obj->event_sub);
+	obj->ib_dev = dev;
 	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
 				   &obj_id);
 	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
@@ -1459,6 +1496,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
+		mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
 	else
 		mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
 			      sizeof(out));
-- 
2.20.1
