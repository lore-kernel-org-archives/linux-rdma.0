From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/6] net/mlx5_core: Export transport objects
Date: Thu, 10 Dec 2015 21:54:30 +0200
Message-ID: <1449777273-9219-4-git-send-email-majd@mellanox.com>
References: <1449777273-9219-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449777273-9219-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To be used by mlx5_ib in the following patches for implementing
RAW PACKET QP.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 10 ++-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.h | 72 ---------------------
 include/linux/mlx5/transobj.h                      | 74 ++++++++++++++++++++++
 5 files changed, 85 insertions(+), 75 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/transobj.h
 create mode 100644 include/linux/mlx5/transobj.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0983a20..47b2811 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -36,8 +36,8 @@
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/vport.h>
+#include <linux/mlx5/transobj.h>
 #include "wq.h"
-#include "transobj.h"
 #include "mlx5_core.h"
 
 #define MLX5E_MAX_NUM_TC	8
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 7504d11..9474343 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -37,7 +37,7 @@
 #include <linux/mlx5/srq.h>
 #include <rdma/ib_verbs.h>
 #include "mlx5_core.h"
-#include "transobj.h"
+#include <linux/mlx5/transobj.h>
 
 void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index b4c87c7..7523cb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -32,7 +32,7 @@
 
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
-#include "transobj.h"
+#include <linux/mlx5/transobj.h>
 
 int mlx5_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn)
 {
@@ -53,6 +53,7 @@ int mlx5_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn)
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_alloc_transport_domain);
 
 void mlx5_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn)
 {
@@ -68,6 +69,7 @@ void mlx5_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn)
 
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_dealloc_transport_domain);
 
 int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *rqn)
 {
@@ -94,6 +96,7 @@ int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen)
 	memset(out, 0, sizeof(out));
 	return mlx5_cmd_exec_check_status(dev, in, inlen, out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_modify_rq);
 
 void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn)
 {
@@ -133,6 +136,7 @@ int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen)
 	memset(out, 0, sizeof(out));
 	return mlx5_cmd_exec_check_status(dev, in, inlen, out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_modify_sq);
 
 void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn)
 {
@@ -162,6 +166,7 @@ int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_core_create_tir);
 
 int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
 			 int inlen)
@@ -187,6 +192,7 @@ void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn)
 
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_destroy_tir);
 
 int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *tisn)
@@ -203,6 +209,7 @@ int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_core_create_tis);
 
 void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn)
 {
@@ -216,6 +223,7 @@ void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn)
 
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_destroy_tis);
 
 int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
 			 u32 *rmpn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.h b/drivers/net/ethernet/mellanox/mlx5/core/transobj.h
deleted file mode 100644
index 74cae51..0000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.h
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * Copyright (c) 2013-2015, Mellanox Technologies, Ltd.  All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef __TRANSOBJ_H__
-#define __TRANSOBJ_H__
-
-int mlx5_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn);
-void mlx5_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn);
-int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			u32 *rqn);
-int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen);
-void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn);
-int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			u32 *sqn);
-int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen);
-void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn);
-int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tirn);
-int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
-			 int inlen);
-void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
-int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *tisn);
-void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn);
-int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *rmpn);
-int mlx5_core_modify_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen);
-int mlx5_core_destroy_rmp(struct mlx5_core_dev *dev, u32 rmpn);
-int mlx5_core_query_rmp(struct mlx5_core_dev *dev, u32 rmpn, u32 *out);
-int mlx5_core_arm_rmp(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
-int mlx5_core_create_xsrq(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			  u32 *rmpn);
-int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 rmpn);
-int mlx5_core_query_xsrq(struct mlx5_core_dev *dev, u32 rmpn, u32 *out);
-int mlx5_core_arm_xsrq(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
-
-int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
-			 u32 *rqtn);
-int mlx5_core_modify_rqt(struct mlx5_core_dev *dev, u32 rqtn, u32 *in,
-			 int inlen);
-void mlx5_core_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn);
-
-#endif /* __TRANSOBJ_H__ */
diff --git a/include/linux/mlx5/transobj.h b/include/linux/mlx5/transobj.h
new file mode 100644
index 0000000..821e71b
--- /dev/null
+++ b/include/linux/mlx5/transobj.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c) 2013-2015, Mellanox Technologies, Ltd.  All rights reserved.
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
+#ifndef __TRANSOBJ_H__
+#define __TRANSOBJ_H__
+
+#include <linux/mlx5/driver.h>
+
+int mlx5_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn);
+void mlx5_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn);
+int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			u32 *rqn);
+int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen);
+void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn);
+int mlx5_core_create_sq(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			u32 *sqn);
+int mlx5_core_modify_sq(struct mlx5_core_dev *dev, u32 sqn, u32 *in, int inlen);
+void mlx5_core_destroy_sq(struct mlx5_core_dev *dev, u32 sqn);
+int mlx5_core_create_tir(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			 u32 *tirn);
+int mlx5_core_modify_tir(struct mlx5_core_dev *dev, u32 tirn, u32 *in,
+			 int inlen);
+void mlx5_core_destroy_tir(struct mlx5_core_dev *dev, u32 tirn);
+int mlx5_core_create_tis(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			 u32 *tisn);
+void mlx5_core_destroy_tis(struct mlx5_core_dev *dev, u32 tisn);
+int mlx5_core_create_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			 u32 *rmpn);
+int mlx5_core_modify_rmp(struct mlx5_core_dev *dev, u32 *in, int inlen);
+int mlx5_core_destroy_rmp(struct mlx5_core_dev *dev, u32 rmpn);
+int mlx5_core_query_rmp(struct mlx5_core_dev *dev, u32 rmpn, u32 *out);
+int mlx5_core_arm_rmp(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
+int mlx5_core_create_xsrq(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			  u32 *rmpn);
+int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 rmpn);
+int mlx5_core_query_xsrq(struct mlx5_core_dev *dev, u32 rmpn, u32 *out);
+int mlx5_core_arm_xsrq(struct mlx5_core_dev *dev, u32 rmpn, u16 lwm);
+
+int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
+			 u32 *rqtn);
+int mlx5_core_modify_rqt(struct mlx5_core_dev *dev, u32 rqtn, u32 *in,
+			 int inlen);
+void mlx5_core_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn);
+
+#endif /* __TRANSOBJ_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
