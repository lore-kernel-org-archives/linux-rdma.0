From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND v1 rdma-next 1/6] RDMA/CM: move rdma_id_private to
 cma_priv.h
Date: Thu, 1 Feb 2018 08:20:14 -0800
Message-ID: <c33f46bd631dacb72890268294fb8f177e17f499.1518552800.git.swise@opengridcomputing.com>
References: <cover.1518552800.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move struct rdma_id_private to a new header cma_priv.h so the resource
tracking services in core/nldev.c can read useful information about cm_ids.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c      | 41 +--------------------
 drivers/infiniband/core/cma_priv.h | 75 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 40 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_priv.h

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e66963c..203519e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -62,6 +62,7 @@
 #include <rdma/iw_cm.h>
 
 #include "core_priv.h"
+#include "cma_priv.h"
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
@@ -327,46 +328,6 @@ struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev)
  * We do this by disabling removal notification while a callback is in process,
  * and reporting it after the callback completes.
  */
-struct rdma_id_private {
-	struct rdma_cm_id	id;
-
-	struct rdma_bind_list	*bind_list;
-	struct hlist_node	node;
-	struct list_head	list; /* listen_any_list or cma_device.list */
-	struct list_head	listen_list; /* per device listens */
-	struct cma_device	*cma_dev;
-	struct list_head	mc_list;
-
-	int			internal_id;
-	enum rdma_cm_state	state;
-	spinlock_t		lock;
-	struct mutex		qp_mutex;
-
-	struct completion	comp;
-	atomic_t		refcount;
-	struct mutex		handler_mutex;
-
-	int			backlog;
-	int			timeout_ms;
-	struct ib_sa_query	*query;
-	int			query_id;
-	union {
-		struct ib_cm_id	*ib;
-		struct iw_cm_id	*iw;
-	} cm_id;
-
-	u32			seq_num;
-	u32			qkey;
-	u32			qp_num;
-	pid_t			owner;
-	u32			options;
-	u8			srq;
-	u8			tos;
-	bool			tos_set;
-	u8			reuseaddr;
-	u8			afonly;
-	enum ib_gid_type	gid_type;
-};
 
 struct cma_multicast {
 	struct rdma_id_private *id_priv;
diff --git a/drivers/infiniband/core/cma_priv.h b/drivers/infiniband/core/cma_priv.h
new file mode 100644
index 0000000..1b6dfbf
--- /dev/null
+++ b/drivers/infiniband/core/cma_priv.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2005 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2002-2005, Network Appliance, Inc. All rights reserved.
+ * Copyright (c) 1999-2005, Mellanox Technologies, Inc. All rights reserved.
+ * Copyright (c) 2005-2006 Intel Corporation.  All rights reserved.
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
+struct rdma_id_private {
+	struct rdma_cm_id	id;
+
+	struct rdma_bind_list	*bind_list;
+	struct hlist_node	node;
+	struct list_head	list; /* listen_any_list or cma_device.list */
+	struct list_head	listen_list; /* per device listens */
+	struct cma_device	*cma_dev;
+	struct list_head	mc_list;
+
+	int			internal_id;
+	enum rdma_cm_state	state;
+	spinlock_t		lock;
+	struct mutex		qp_mutex;
+
+	struct completion	comp;
+	atomic_t		refcount;
+	struct mutex		handler_mutex;
+
+	int			backlog;
+	int			timeout_ms;
+	struct ib_sa_query	*query;
+	int			query_id;
+	union {
+		struct ib_cm_id	*ib;
+		struct iw_cm_id	*iw;
+	} cm_id;
+
+	u32			seq_num;
+	u32			qkey;
+	u32			qp_num;
+	pid_t			owner;
+	u32			options;
+	u8			srq;
+	u8			tos;
+	bool			tos_set;
+	u8			reuseaddr;
+	u8			afonly;
+	enum ib_gid_type	gid_type;
+};
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
