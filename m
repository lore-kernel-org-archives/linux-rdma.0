From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] RDMA/mad: Reduce MAD scope to mlx5_ib only
Date: Sun, 13 Jan 2019 15:57:04 +0200
Message-ID: <20190113135704.10032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Management Datagram Interface (MAD) is applicable
only when physical port is Infiniband. It makes MAD
command logic to be completely unrelated to eth/core
parts of mlx5.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c              | 37 +++++++++
 drivers/infiniband/hw/mlx5/cmd.h              |  2 +
 drivers/infiniband/hw/mlx5/mad.c              | 11 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 -
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mad.c | 75 -------------------
 include/linux/mlx5/driver.h                   |  2 -
 7 files changed, 47 insertions(+), 85 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mad.c

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 356bccc715ee..6bcc63aaa50b 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -345,3 +345,40 @@ int mlx5_cmd_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id,
 				       counter_set_id);
 	return err;
 }
+
+int mlx5_cmd_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
+		     u16 opmod, u8 port)
+{
+	int outlen = MLX5_ST_SZ_BYTES(mad_ifc_out);
+	int inlen = MLX5_ST_SZ_BYTES(mad_ifc_in);
+	int err = -ENOMEM;
+	void *data;
+	void *resp;
+	u32 *out;
+	u32 *in;
+
+	in = kzalloc(inlen, GFP_KERNEL);
+	out = kzalloc(outlen, GFP_KERNEL);
+	if (!in || !out)
+		goto out;
+
+	MLX5_SET(mad_ifc_in, in, opcode, MLX5_CMD_OP_MAD_IFC);
+	MLX5_SET(mad_ifc_in, in, op_mod, opmod);
+	MLX5_SET(mad_ifc_in, in, port, port);
+
+	data = MLX5_ADDR_OF(mad_ifc_in, in, mad);
+	memcpy(data, inb, MLX5_FLD_SZ_BYTES(mad_ifc_in, mad));
+
+	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
+	if (err)
+		goto out;
+
+	resp = MLX5_ADDR_OF(mad_ifc_out, out, response_mad_packet);
+	memcpy(outb, resp,
+	       MLX5_FLD_SZ_BYTES(mad_ifc_out, response_mad_packet));
+
+out:
+	kfree(out);
+	kfree(in);
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 1e76dc67a369..923a7b93f507 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -63,4 +63,6 @@ int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid);
 int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid);
 int mlx5_cmd_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id,
 			     u16 uid);
+int mlx5_cmd_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
+		     u16 opmod, u8 port);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 558638468edb..6c529e6f3a01 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -36,6 +36,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_pma.h>
 #include "mlx5_ib.h"
+#include "cmd.h"
 
 enum {
 	MLX5_IB_VENDOR_CLASS1 = 0x9,
@@ -51,9 +52,10 @@ static bool can_do_mad_ifc(struct mlx5_ib_dev *dev, u8 port_num,
 	return dev->mdev->port_caps[port_num - 1].has_smi;
 }
 
-int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
-		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		 const void *in_mad, void *response_mad)
+static int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey,
+			int ignore_bkey, u8 port, const struct ib_wc *in_wc,
+			const struct ib_grh *in_grh, const void *in_mad,
+			void *response_mad)
 {
 	u8 op_modifier = 0;
 
@@ -68,7 +70,8 @@ int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 	if (ignore_bkey || !in_wc)
 		op_modifier |= 0x2;
 
-	return mlx5_core_mad_ifc(dev->mdev, in_mad, response_mad, op_modifier, port);
+	return mlx5_cmd_mad_ifc(dev->mdev, in_mad, response_mad, op_modifier,
+				port);
 }
 
 static int process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 819207190343..cead0f97a7b1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1050,9 +1050,6 @@ void mlx5_ib_db_unmap_user(struct mlx5_ib_ucontext *context, struct mlx5_db *db)
 void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
 void mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
 void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
-int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
-		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		 const void *in_mad, void *response_mad);
 struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 				u32 flags, struct ib_udata *udata);
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9de9abacf7f6..0257731e6d42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 #
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o alloc.o qp.o port.o mr.o pd.o \
-		mad.o transobj.o vport.o sriov.o fs_cmd.o fs_core.o \
+		transobj.o vport.o sriov.o fs_cmd.o fs_core.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o diag/fs_tracepoint.o diag/fw_tracer.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mad.c b/drivers/net/ethernet/mellanox/mlx5/core/mad.c
deleted file mode 100644
index 3a3b0005fd2b..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/mad.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
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
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/cmd.h>
-#include "mlx5_core.h"
-
-int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
-		      u16 opmod, u8 port)
-{
-	int outlen = MLX5_ST_SZ_BYTES(mad_ifc_out);
-	int inlen = MLX5_ST_SZ_BYTES(mad_ifc_in);
-	int err = -ENOMEM;
-	void *data;
-	void *resp;
-	u32 *out;
-	u32 *in;
-
-	in = kzalloc(inlen, GFP_KERNEL);
-	out = kzalloc(outlen, GFP_KERNEL);
-	if (!in || !out)
-		goto out;
-
-	MLX5_SET(mad_ifc_in, in, opcode, MLX5_CMD_OP_MAD_IFC);
-	MLX5_SET(mad_ifc_in, in, op_mod, opmod);
-	MLX5_SET(mad_ifc_in, in, port, port);
-
-	data = MLX5_ADDR_OF(mad_ifc_in, in, mad);
-	memcpy(data, inb, MLX5_FLD_SZ_BYTES(mad_ifc_in, mad));
-
-	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
-	if (err)
-		goto out;
-
-	resp = MLX5_ADDR_OF(mad_ifc_out, out, response_mad_packet);
-	memcpy(outb, resp,
-	       MLX5_FLD_SZ_BYTES(mad_ifc_out, response_mad_packet));
-
-out:
-	kfree(out);
-	kfree(in);
-	return err;
-}
-EXPORT_SYMBOL_GPL(mlx5_core_mad_ifc);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 619d6fee96a1..22712c6b3940 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -898,8 +898,6 @@ int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
 			 u32 *out, int outlen);
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn);
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn);
-int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
-		      u16 opmod, u8 port);
 int mlx5_pagealloc_init(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_start(struct mlx5_core_dev *dev);
-- 
2.19.1
