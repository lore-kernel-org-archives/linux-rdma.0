From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V2 8/8] RDMA/mlx5: Add mlx5 initial support of the new infrastructure
Date: Tue, 19 Jul 2016 18:23:32 +0300
Message-ID: <1468941812-32286-9-git-send-email-matanb@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It adds the following:
* Creating a context command
    * handler
    * validator
* Querying a device
    * handler
    * validator

It also populate the type table in the IB device.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Makefile        |  3 +-
 drivers/infiniband/hw/mlx5/main.c          | 12 +++++-
 drivers/infiniband/hw/mlx5/mlx5_user_cmd.c | 69 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h          |  3 ++
 4 files changed, 84 insertions(+), 3 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/mlx5_user_cmd.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 7493a83..c1fed38 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
-mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o \
+		ib_virt.o mlx5_user_cmd.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c72797c..9ba97b0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -45,6 +45,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <linux/mlx5/port.h>
 #include <linux/mlx5/vport.h>
 #include <rdma/ib_smi.h>
@@ -2467,10 +2468,16 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_rsrc;
 
-	err = ib_register_device(&dev->ib_dev, NULL);
+	err = rdma_initialize_common_types(&dev->ib_dev, UVERBS_COMMON_TYPES);
 	if (err)
 		goto err_odp;
 
+	dev->ib_dev.types = &mlx5_types;
+
+	err = ib_register_device(&dev->ib_dev, NULL);
+	if (err)
+		goto err_remove_common_types;
+
 	err = create_umr_res(dev);
 	if (err)
 		goto err_dev;
@@ -2491,7 +2498,8 @@ err_umrc:
 
 err_dev:
 	ib_unregister_device(&dev->ib_dev);
-
+err_remove_common_types:
+	ib_uverbs_uobject_types_remove(&dev->ib_dev);
 err_odp:
 	mlx5_ib_odp_remove_one(dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_user_cmd.c b/drivers/infiniband/hw/mlx5/mlx5_user_cmd.c
new file mode 100644
index 0000000..d1f7a02
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/mlx5_user_cmd.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2016, Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <rdma/uverbs_ioctl_cmd.h>
+#include "user.h"
+
+/* Refactor this to separate the versions */
+enum mlx5_alloc_ucontext_args {
+	ALLOC_UCONTEXT_IN,
+	ALLOC_UCONTEXT_OUT,
+};
+
+enum mlx5_device_actions {
+	DEVICE_ALLOC_CONTEXT,
+	DEVICE_QUERY,
+};
+
+DECLARE_UVERBS_TYPE(
+	mlx5_device,
+	UVERBS_CTX_ACTION(
+		DEVICE_ALLOC_CONTEXT, uverbs_get_context, NULL,
+		&uverbs_get_context_spec,
+		&UVERBS_ATTR_CHAIN_SPEC(
+			/*
+			 * Declared with size 0 as we current provide
+			 * backward compatibility (0 = variable size)
+			 */
+			UVERBS_ATTR_PTR_IN(ALLOC_UCONTEXT_IN, 0),
+			UVERBS_ATTR_PTR_OUT(ALLOC_UCONTEXT_OUT, 0),
+			),
+	),
+	UVERBS_ACTION(
+		DEVICE_QUERY, uverbs_query_device_handler, NULL,
+		&uverbs_query_device_spec,
+	),
+);
+
+struct uverbs_types mlx5_types = UVERBS_TYPES(
+	UVERBS_TYPE(UVERBS_TYPE_DEVICE, mlx5_device)
+);
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 61bc308..ae6d8ab 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -194,4 +194,7 @@ static inline int get_srq_user_index(struct mlx5_ib_ucontext *ucontext,
 
 	return verify_assign_uidx(cqe_version, ucmd->uidx, user_index);
 }
+
+extern struct uverbs_types mlx5_types;
+
 #endif /* MLX5_IB_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
