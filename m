From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/6] IB/mlx5: Add null_mkey access
Date: Wed, 18 Jan 2017 16:58:09 +0200
Message-ID: <20170118145811.9136-5-leon@kernel.org>
References: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add mlx5_cmd_null_mkey() function to access null_mkey information
from firmware.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Makefile |  2 +-
 drivers/infiniband/hw/mlx5/cmd.c    | 48 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h    | 40 +++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/mlx5/cmd.c
 create mode 100644 drivers/infiniband/hw/mlx5/cmd.h

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 7493a83..90ad2ad 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
-mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o cmd.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
new file mode 100644
index 0000000..cdc2d30
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2017, Mellanox Technologies. All rights reserved.
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
+#include "cmd.h"
+
+int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)]   = {};
+	int err;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*null_mkey = MLX5_GET(query_special_contexts_out, out,
+				      null_mkey);
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
new file mode 100644
index 0000000..7ca8a7b
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2017, Mellanox Technologies. All rights reserved.
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
+#ifndef MLX5_IB_CMD_H
+#define MLX5_IB_CMD_H
+
+#include <linux/kernel.h>
+#include <linux/mlx5/driver.h>
+
+int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
+#endif /* MLX5_IB_CMD_H */
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
