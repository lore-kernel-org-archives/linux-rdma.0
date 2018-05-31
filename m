From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v3 05/14] IB/uverbs: Add create/destroy counters support
Date: Thu, 31 May 2018 16:43:32 +0300
Message-ID: <20180531134341.18441-6-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

User space application which uses counters functionality,
is expected to allocate/release the counters resources by
calling create/destroy verbs and in turn get a unique handle
that can be used to attach the counters to its counted type.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/Makefile                   |   2 +-
 drivers/infiniband/core/uverbs.h                   |   1 +
 drivers/infiniband/core/uverbs_std_types.c         |   3 +-
 .../infiniband/core/uverbs_std_types_counters.c    | 100 +++++++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  14 +++
 5 files changed, 118 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_counters.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 8d42373a2d8a..61667705d746 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -37,4 +37,4 @@ ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
 				rdma_core.o uverbs_std_types.o uverbs_ioctl.o \
 				uverbs_ioctl_merge.o uverbs_std_types_cq.o \
 				uverbs_std_types_flow_action.o uverbs_std_types_dm.o \
-				uverbs_std_types_mr.o
+				uverbs_std_types_mr.o uverbs_std_types_counters.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index cfb51618ab7a..5b2461fa634d 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -287,6 +287,7 @@ extern const struct uverbs_object_def UVERBS_OBJECT(UVERBS_OBJECT_RWQ_IND_TBL);
 extern const struct uverbs_object_def UVERBS_OBJECT(UVERBS_OBJECT_XRCD);
 extern const struct uverbs_object_def UVERBS_OBJECT(UVERBS_OBJECT_FLOW_ACTION);
 extern const struct uverbs_object_def UVERBS_OBJECT(UVERBS_OBJECT_DM);
+extern const struct uverbs_object_def UVERBS_OBJECT(UVERBS_OBJECT_COUNTERS);
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 569f48bd821e..b570acbd94af 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -302,7 +302,8 @@ static DECLARE_UVERBS_OBJECT_TREE(uverbs_default_objects,
 				  &UVERBS_OBJECT(UVERBS_OBJECT_RWQ_IND_TBL),
 				  &UVERBS_OBJECT(UVERBS_OBJECT_XRCD),
 				  &UVERBS_OBJECT(UVERBS_OBJECT_FLOW_ACTION),
-				  &UVERBS_OBJECT(UVERBS_OBJECT_DM));
+				  &UVERBS_OBJECT(UVERBS_OBJECT_DM),
+				  &UVERBS_OBJECT(UVERBS_OBJECT_COUNTERS));
 
 const struct uverbs_object_tree_def *uverbs_default_get_objects(void)
 {
diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
new file mode 100644
index 000000000000..a5bc50ceee13
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
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
+#include "uverbs.h"
+#include <rdma/uverbs_std_types.h>
+
+static int uverbs_free_counters(struct ib_uobject *uobject,
+				enum rdma_remove_reason why)
+{
+	struct ib_counters *counters = uobject->object;
+
+	if (why == RDMA_REMOVE_DESTROY &&
+	    atomic_read(&counters->usecnt))
+		return -EBUSY;
+
+	return counters->device->destroy_counters(counters);
+}
+
+static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_CREATE)(struct ib_device *ib_dev,
+							 struct ib_uverbs_file *file,
+							 struct uverbs_attr_bundle *attrs)
+{
+	struct ib_counters *counters;
+	struct ib_uobject *uobj;
+	int ret;
+
+	/*
+	 * This check should be removed once the infrastructure
+	 * have the ability to remove methods from parse tree once
+	 * such condition is met.
+	 */
+	if (!ib_dev->create_counters)
+		return -EOPNOTSUPP;
+
+	uobj = uverbs_attr_get_uobject(attrs, UVERBS_ATTR_CREATE_COUNTERS_HANDLE);
+	counters = ib_dev->create_counters(ib_dev, attrs);
+	if (IS_ERR(counters)) {
+		ret = PTR_ERR(counters);
+		goto err_create_counters;
+	}
+
+	counters->device = ib_dev;
+	counters->uobject = uobj;
+	uobj->object = counters;
+	atomic_set(&counters->usecnt, 0);
+
+	return 0;
+
+err_create_counters:
+	return ret;
+}
+
+static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_COUNTERS_CREATE,
+	&UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_COUNTERS_HANDLE,
+			 UVERBS_OBJECT_COUNTERS,
+			 UVERBS_ACCESS_NEW,
+			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+static DECLARE_UVERBS_NAMED_METHOD_WITH_HANDLER(UVERBS_METHOD_COUNTERS_DESTROY,
+	uverbs_destroy_def_handler,
+	&UVERBS_ATTR_IDR(UVERBS_ATTR_DESTROY_COUNTERS_HANDLE,
+			 UVERBS_OBJECT_COUNTERS,
+			 UVERBS_ACCESS_DESTROY,
+			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_COUNTERS,
+			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_counters),
+			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_CREATE),
+			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_DESTROY));
+
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 83e3890eef20..c28ce62d2e40 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -55,6 +55,7 @@ enum uverbs_default_objects {
 	UVERBS_OBJECT_WQ,
 	UVERBS_OBJECT_FLOW_ACTION,
 	UVERBS_OBJECT_DM,
+	UVERBS_OBJECT_COUNTERS,
 };
 
 enum {
@@ -131,4 +132,17 @@ enum uverbs_methods_mr {
 	UVERBS_METHOD_DM_MR_REG,
 };
 
+enum uverbs_attrs_create_counters_cmd_attr_ids {
+	UVERBS_ATTR_CREATE_COUNTERS_HANDLE,
+};
+
+enum uverbs_attrs_destroy_counters_cmd_attr_ids {
+	UVERBS_ATTR_DESTROY_COUNTERS_HANDLE,
+};
+
+enum uverbs_methods_actions_counters_ops {
+	UVERBS_METHOD_COUNTERS_CREATE,
+	UVERBS_METHOD_COUNTERS_DESTROY,
+};
+
 #endif
-- 
2.14.3
