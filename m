From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 16/27] RDMA/uverbs: Add generic function to fill in flow action object
Date: Sun, 29 Jul 2018 15:58:54 +0300
Message-ID: <20180729125905.31989-17-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Refactor the initialization of a flow action object to a common function.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_std_types_flow_action.c |  7 ++-----
 drivers/infiniband/hw/mlx5/flow.c                      |  8 +++-----
 include/rdma/uverbs_std_types.h                        | 12 ++++++++++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c b/drivers/infiniband/core/uverbs_std_types_flow_action.c
index adb9209c4710..8beacfdb9f27 100644
--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
@@ -327,11 +327,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE)(struct ib_device
 	if (IS_ERR(action))
 		return PTR_ERR(action);
 
-	atomic_set(&action->usecnt, 0);
-	action->device = ib_dev;
-	action->type = IB_FLOW_ACTION_ESP;
-	action->uobject = uobj;
-	uobj->object = action;
+	uverbs_flow_action_fill_action(action, uobj, ib_dev,
+				       IB_FLOW_ACTION_ESP);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 2c7d75cb8ade..d0325e468801 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -7,6 +7,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/uverbs_types.h>
 #include <rdma/uverbs_ioctl.h>
+#include <rdma/uverbs_std_types.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/mlx5_user_ioctl_verbs.h>
 #include <rdma/ib_umem.h>
@@ -277,11 +278,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(struc
 	if (IS_ERR(action))
 		return PTR_ERR(action);
 
-	atomic_set(&action->usecnt, 0);
-	action->device = uobj->context->device;
-	action->type = IB_FLOW_ACTION_UNSPECIFIED;
-	action->uobject = uobj;
-	uobj->object = action;
+	uverbs_flow_action_fill_action(action, uobj, uobj->context->device,
+				       IB_FLOW_ACTION_UNSPECIFIED);
 
 	return 0;
 }
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 076f085d2dcf..3686da497cf6 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -125,5 +125,17 @@ static inline struct ib_uobject *__uobj_alloc(const struct uverbs_obj_type *type
 
 #define uobj_alloc(_type, _ufile) __uobj_alloc(uobj_get_type(_type), _ufile)
 
+static inline void uverbs_flow_action_fill_action(struct ib_flow_action *action,
+						  struct ib_uobject *uobj,
+						  struct ib_device *ib_dev,
+						  enum ib_flow_action_type type)
+{
+	atomic_set(&action->usecnt, 0);
+	action->device = ib_dev;
+	action->type = type;
+	action->uobject = uobj;
+	uobj->object = action;
+}
+
 #endif
 
-- 
2.14.4
