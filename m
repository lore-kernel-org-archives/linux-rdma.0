From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/9] IB/mlx5: Introduce flow steering matcher object
Date: Sun,  8 Jul 2018 13:24:40 +0300
Message-ID: <20180708102445.25496-5-leon@kernel.org>
References: <20180708102445.25496-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180708102445.25496-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce flow steering matcher object and its create and destroy
methods.

This matcher object holds some mlx5 specific driver properties that
matches the underlay device specification when an mlx5 flow steering
group is created.

It will be used in downstream patches to be part of mlx5 specific create
flow method.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/Makefile      |   1 +
 drivers/infiniband/hw/mlx5/flow.c        | 132 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  11 +++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  33 +++++++-
 4 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/mlx5/flow.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 577e4c418bae..b8e4b15e2674 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -4,3 +4,4 @@ mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_vi
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
 mlx5_ib-$(CONFIG_MLX5_ESWITCH) += ib_rep.o
 mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += devx.o
+mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += flow.o
diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
new file mode 100644
index 000000000000..99409e516c7f
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
+ */
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_types.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/mlx5_user_ioctl_cmds.h>
+#include <rdma/ib_umem.h>
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/fs.h>
+#include "mlx5_ib.h"
+
+#define UVERBS_MODULE_NAME mlx5_ib
+#include <rdma/uverbs_named_ioctl.h>
+
+static const struct uverbs_attr_spec mlx5_ib_flow_type[] = {
+	[MLX5_IB_FLOW_TYPE_NORMAL] = {
+		.type = UVERBS_ATTR_TYPE_PTR_IN,
+		UVERBS_ATTR_TYPE(u16),
+	},
+	[MLX5_IB_FLOW_TYPE_SNIFFER] = {
+		/* No need to specify any data */
+		.type = UVERBS_ATTR_TYPE_PTR_IN,
+	},
+	[MLX5_IB_FLOW_TYPE_ALL_DEFAULT] = {
+		/* No need to specify any data */
+		.type = UVERBS_ATTR_TYPE_PTR_IN,
+	},
+	[MLX5_IB_FLOW_TYPE_MC_DEFAULT] = {
+		/* No need to specify any data */
+		.type = UVERBS_ATTR_TYPE_PTR_IN,
+	},
+};
+
+static int flow_matcher_cleanup(struct ib_uobject *uobject,
+				enum rdma_remove_reason why)
+{
+	struct mlx5_ib_flow_matcher *obj = uobject->object;
+	int ret = atomic_read(&obj->usecnt) ? -EBUSY : 0;
+
+	if (ib_is_destroy_retryable(ret, why, uobject))
+		return ret;
+
+	kfree(obj);
+	return 0;
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(struct ib_device *ib_dev,
+				   struct ib_uverbs_file *file,
+				   struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ib_dev);
+	void *cmd_in = uverbs_attr_get_alloced_ptr(attrs,
+						   MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
+	struct ib_uobject *uobj;
+	struct mlx5_ib_flow_matcher *obj;
+	int mask_len;
+	int err;
+
+	obj = kzalloc(sizeof(struct mlx5_ib_flow_matcher), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	obj->mask_len = uverbs_attr_get_len(attrs,
+					    MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK);
+	memcpy(obj->matcher_mask.match_params, cmd_in, obj->mask_len);
+	obj->flow_type = uverbs_attr_get_enum_id(attrs,
+						 MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE);
+
+	if (obj->flow_type == MLX5_IB_FLOW_TYPE_NORMAL) {
+		err = uverbs_copy_from(&obj->priority,
+				       attrs,
+				       MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE);
+		if (err)
+			goto end;
+	}
+
+	err = uverbs_copy_from(&obj->match_criteria_enable,
+			       attrs,
+			       MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA);
+	if (err)
+		goto end;
+
+	uobj = uverbs_attr_get_uobject(attrs, MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE);
+	uobj->object = obj;
+	obj->mdev = dev->mdev;
+	atomic_set(&obj->usecnt, 0);
+	return 0;
+
+end:
+	kfree(obj);
+	return err;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_FLOW_MATCHER_CREATE,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE,
+			 MLX5_IB_OBJECT_FLOW_MATCHER,
+			 UVERBS_ACCESS_NEW,
+			 UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(
+		MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK,
+		UVERBS_ATTR_SIZE(1, sizeof(struct mlx5_ib_match_params)),
+		UA_MANDATORY,
+		UA_ALLOC_AND_COPY),
+	UVERBS_ATTR_ENUM_IN(
+		MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE,
+		mlx5_ib_flow_type,
+		UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(
+		MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
+		UVERBS_ATTR_TYPE(u8),
+		UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	MLX5_IB_METHOD_FLOW_MATCHER_DESTROY,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_FLOW_MATCHER_DESTROY_HANDLE,
+			 MLX5_IB_OBJECT_FLOW_MATCHER,
+			 UVERBS_ACCESS_DESTROY,
+			 UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER,
+			UVERBS_TYPE_ALLOC_IDR(flow_matcher_cleanup),
+			&UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_CREATE),
+			&UVERBS_METHOD(MLX5_IB_METHOD_FLOW_MATCHER_DESTROY));
+
+DECLARE_UVERBS_OBJECT_TREE(flow_objects,
+			&UVERBS_OBJECT(MLX5_IB_OBJECT_FLOW_MATCHER));
+
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 67e86c8304a2..2e26a1354889 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -46,6 +46,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <rdma/mlx5-abi.h>
 #include <rdma/uverbs_ioctl.h>
+#include <rdma/mlx5_user_ioctl_cmds.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -179,6 +180,16 @@ struct mlx5_ib_flow_handler {
 	struct ib_counters		*ibcounters;
 };
 
+struct mlx5_ib_flow_matcher {
+	struct mlx5_ib_match_params matcher_mask;
+	u32			mask_len;
+	enum mlx5_ib_flow_type	flow_type;
+	u16			priority;
+	struct mlx5_core_dev	*mdev;
+	atomic_t		usecnt;
+	u8			match_criteria_enable;
+};
+
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	sniffer[MLX5_IB_NUM_SNIFFER_FTS];
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 1a05bb4b0b34..233d5d140179 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -33,6 +33,7 @@
 #ifndef MLX5_USER_IOCTL_CMDS_H
 #define MLX5_USER_IOCTL_CMDS_H
 
+#include <linux/types.h>
 #include <rdma/ib_user_ioctl_cmds.h>
 
 enum mlx5_ib_create_flow_action_attrs {
@@ -112,10 +113,40 @@ enum mlx5_ib_devx_umem_methods {
 	MLX5_IB_METHOD_DEVX_UMEM_DEREG,
 };
 
-enum mlx5_ib_devx_objects {
+enum mlx5_ib_objects {
 	MLX5_IB_OBJECT_DEVX = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_OBJECT_DEVX_OBJ,
 	MLX5_IB_OBJECT_DEVX_UMEM,
+	MLX5_IB_OBJECT_FLOW_MATCHER,
+};
+
+enum mlx5_ib_flow_matcher_create_attrs {
+	MLX5_IB_ATTR_FLOW_MATCHER_CREATE_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_FLOW_MATCHER_MATCH_MASK,
+	MLX5_IB_ATTR_FLOW_MATCHER_FLOW_TYPE,
+	MLX5_IB_ATTR_FLOW_MATCHER_MATCH_CRITERIA,
+};
+
+enum mlx5_ib_flow_matcher_destroy_attrs {
+	MLX5_IB_ATTR_FLOW_MATCHER_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum mlx5_ib_flow_matcher_methods {
+	MLX5_IB_METHOD_FLOW_MATCHER_CREATE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_FLOW_MATCHER_DESTROY,
+};
+
+#define MLX5_IB_DW_MATCH_PARAM 0x80
+
+struct mlx5_ib_match_params {
+	__u32	match_params[MLX5_IB_DW_MATCH_PARAM];
+};
+
+enum mlx5_ib_flow_type {
+	MLX5_IB_FLOW_TYPE_NORMAL,
+	MLX5_IB_FLOW_TYPE_SNIFFER,
+	MLX5_IB_FLOW_TYPE_ALL_DEFAULT,
+	MLX5_IB_FLOW_TYPE_MC_DEFAULT,
 };
 
 #endif
-- 
2.14.4
