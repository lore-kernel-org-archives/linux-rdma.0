From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC v2 for accelerated IPoIB 6/6] mlx5_ib: skeleton for mlx5_ib to support ipoib_ops
Date: Mon, 20 Mar 2017 21:08:28 +0200
Message-ID: <1490036908-12528-7-git-send-email-erezsh@mellanox.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490036908-12528-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Makefile         |   2 +-
 drivers/infiniband/hw/mlx5/main.c           |   8 +
 drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c | 301 ++++++++++++++++++++++++++++
 3 files changed, 310 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 90ad2adc752f..0c4caa339565 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
-mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o cmd.o
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o cmd.o mlx5_ipoib_ops.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4a043cf35b9a..cde29d64cc43 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -72,6 +72,13 @@ enum {
 	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
 };
 
+struct net_device *mlx5_alloc_rdma_netdev(struct ib_device *hca,
+					  u8 port_num,
+					  enum rdma_netdev_t type,
+					  const char *name,
+					  unsigned char name_assign_type,
+					  void (*setup)(struct net_device *));
+
 static enum rdma_link_layer
 mlx5_port_type_cap_to_rdma_ll(int port_type_cap)
 {
@@ -3436,6 +3443,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.alloc_mr		= mlx5_ib_alloc_mr;
 	dev->ib_dev.map_mr_sg		= mlx5_ib_map_mr_sg;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
+	dev->ib_dev.alloc_rdma_netdev	= mlx5_alloc_rdma_netdev;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
 	if (mlx5_core_is_pf(mdev)) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c b/drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c
new file mode 100644
index 000000000000..35debab63611
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/mlx5_ipoib_ops.c
@@ -0,0 +1,301 @@
+/*
+ * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
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
+#include <linux/netdevice.h>
+#include <rdma/ib_ipoib_accel_ops.h>
+#include "mlx5_ib.h"
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/fs.h>
+
+/*FIX ME*/
+#include "../../ulp/ipoib/ipoib.h"
+
+#define IB_DEFAULT_Q_KEY   0xb1b
+
+int mlx5_ib_config_ipoib_qp(struct mlx5_ib_dev *ib_dev, struct mlx5_core_qp *qp)
+{
+	u32 *in;
+	struct mlx5_qp_context *context;
+	int inlen;
+	void *addr_path;
+	void *qpc;
+	int ret;
+
+	inlen = MLX5_ST_SZ_BYTES(create_qp_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_UD);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+	MLX5_SET(qpc, qpc, ulp_stateless_offload_mode,
+		 MLX5_QP_ENHANCED_ULP_STATELESS_MODE);
+
+	addr_path = MLX5_ADDR_OF(qpc, qpc, primary_address_path);
+	MLX5_SET(ads, addr_path, port, 1);
+	MLX5_SET(ads, addr_path, grh, 1);
+
+	ret = mlx5_core_create_qp(ib_dev->mdev, qp, in, inlen);
+	if (ret) {
+		pr_err("Failed creating IPoIB QP err : %d\n", ret);
+		goto clean_inbox;
+	}
+
+	/* QP states */
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		goto clean_inbox;
+
+	context->flags = cpu_to_be32(MLX5_QP_PM_MIGRATED << 11);
+	context->pri_path.port = 1;
+	context->qkey = cpu_to_be32(IB_DEFAULT_Q_KEY);
+
+	ret = mlx5_core_qp_modify(ib_dev->mdev,
+				  MLX5_CMD_OP_RST2INIT_QP, 0, context, qp);
+	if (ret) {
+		pr_warn("Failed to modify qp RST2INIT, err: %d\n", ret);
+		goto clean_in_modify;
+	}
+	memset(context, 0, sizeof(*context));
+
+	ret = mlx5_core_qp_modify(ib_dev->mdev,
+				  MLX5_CMD_OP_INIT2RTR_QP, 0, context,
+				  qp);
+	if (ret) {
+		pr_warn("Failed to modify qp INIT2RTR, err: %d\n", ret);
+		goto clean_in_modify;
+	}
+
+	ret = mlx5_core_qp_modify(ib_dev->mdev,
+				  MLX5_CMD_OP_RTR2RTS_QP, 0, context,
+				  qp);
+	if (ret) {
+		pr_warn("Failed to modify qp RTR2RTS, err: %d\n", ret);
+		goto clean_in_modify;
+	}
+
+	kvfree(in);
+	kfree(context);
+
+	return 0;
+
+clean_in_modify:
+	kvfree(in);
+clean_inbox:
+	kvfree(in);
+	return ret;
+}
+
+static void mlx5_ib_clean_qp(struct mlx5_ib_dev *ib_dev,
+			     struct mlx5_core_qp *qp)
+{
+	mlx5_core_destroy_qp(ib_dev->mdev, qp);
+	kfree(qp);
+}
+
+int mlx5_ib_dev_init(struct net_device *dev)
+{
+	void *next_priv = ipoib_accl_priv(dev);
+	struct ipoib_rdma_netdev *ipoib_accl_priv = netdev_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
+	struct mlx5_ib_dev *ib_dev;
+	int ret;
+
+	ib_dev = to_mdev(rn->hca);
+
+	ret = mlx5i_attach(ib_dev->mdev, next_priv);
+	if (ret) {
+		pr_err("Failed resources allocation for device: %s ret: %d\n",
+		       dev->name, ret);
+		return ret;
+	}
+
+	/* qp created set dev address */
+	dev->dev_addr[1] = (ipoib_accl_priv->qpn >> 16) & 0xff;
+	dev->dev_addr[2] = (ipoib_accl_priv->qpn >>  8) & 0xff;
+	dev->dev_addr[3] = (ipoib_accl_priv->qpn) & 0xff;
+
+	pr_debug("resources allocated for device: %s\n", dev->name);
+
+	return 0;
+}
+
+void mlx5_ib_dev_cleanup(struct net_device *dev)
+{
+	void *next_priv = ipoib_accl_priv(dev);
+	struct ipoib_rdma_netdev *ipoib_accl_priv = netdev_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
+	struct mlx5_ib_dev *ib_dev;
+	struct mlx5_qp_context context;
+	int ret;
+
+	ib_dev = to_mdev(rn->hca);
+	/* detach qp from flow-steering by reset it */
+	ret = mlx5_core_qp_modify(ib_dev->mdev,
+				  MLX5_CMD_OP_2RST_QP, 0, &context,
+				  (struct mlx5_core_qp *)ipoib_accl_priv->context);
+	if (ret)
+		pr_err("%s failed (ret: %d) to reset QP\n", __func__, ret);
+
+	mlx5i_detach(ib_dev->mdev, next_priv);
+	ipoib_accl_priv = netdev_priv(dev);
+
+	mlx5_ib_clean_qp(ib_dev, (struct mlx5_core_qp *)ipoib_accl_priv->context/*rn->context*/);
+}
+
+int mlx5_ib_dev_open(struct net_device *dev)
+{
+	void *next_priv = ipoib_accl_priv(dev);
+
+	return mlx5i_open(next_priv);
+}
+
+int mlx5_ib_dev_stop(struct net_device *dev)
+{
+	void *next_priv = ipoib_accl_priv(dev);
+
+	return mlx5i_close(next_priv);
+}
+
+void mlx5_ib_send(struct net_device *dev, struct sk_buff *skb,
+		  struct ipoib_ah *address, u32 dqpn, u32 dqkey)
+{
+	void *next_priv = ipoib_accl_priv(dev);
+
+	mlx5i_xmit(skb, next_priv, &to_mah(address->ah)->av, dqpn, dqkey);
+}
+
+int mlx5_ib_attach_mcast(struct net_device *dev, struct ib_device *hca,
+			 union ib_gid *gid, u16 lid, int set_qkey)
+{
+	struct ipoib_rdma_netdev *ipoib_accl_priv = netdev_priv(dev);
+	struct mlx5_ib_dev *ib_dev = to_mdev(hca);
+	int err;
+
+	pr_debug("%s attaching QPN 0x%x, MGID %pI6\n",
+		 dev->name, ipoib_accl_priv->qpn, gid->raw);
+
+	err = mlx5_core_attach_mcg(ib_dev->mdev, gid, ipoib_accl_priv->qpn);
+	if (err)
+		pr_err("%s failed attaching QPN 0x%x, MGID %pI6\n",
+		       dev->name, ipoib_accl_priv->qpn, gid->raw);
+
+	return err;
+}
+
+int mlx5_ib_detach_mcast(struct net_device *dev, struct ib_device *hca,
+			 union ib_gid *gid, u16 lid)
+{
+	struct ipoib_rdma_netdev *ipoib_accl_priv = netdev_priv(dev);
+	struct mlx5_ib_dev *ib_dev = to_mdev(hca);
+	int err;
+
+	pr_debug("%s de-attaching QPN 0x%x, MGID %pI6\n",
+		 dev->name, ipoib_accl_priv->qpn, gid->raw);
+
+	err = mlx5_core_detach_mcg(ib_dev->mdev, gid, ipoib_accl_priv->qpn);
+	if (err)
+		pr_err("%s failed dettaching QPN 0x%x, MGID %pI6\n",
+		       dev->name, ipoib_accl_priv->qpn, gid->raw);
+
+	return err;
+}
+
+static const struct net_device_ops ipoib_accel_netdev_ops = {
+	.ndo_open		 = mlx5_ib_dev_open,
+	.ndo_stop		 = mlx5_ib_dev_stop,
+	.ndo_init		 = mlx5_ib_dev_init,
+	.ndo_uninit		 = mlx5_ib_dev_cleanup,
+};
+
+struct net_device *mlx5_alloc_rdma_netdev(struct ib_device *hca,
+					  u8 port_num,
+					  enum rdma_netdev_t type,
+					  const char *name,
+					  unsigned char name_assign_type,
+					  void (*setup)(struct net_device *))
+{
+	struct net_device *dev;
+	struct mlx5_ib_dev *ib_dev = to_mdev(hca);
+	struct mlx5_core_qp *qp;
+	struct mlx5i_create_ext_param param;
+	struct rdma_netdev *rn;
+	struct ipoib_rdma_netdev *ipoib_accl_priv;
+	int ret;
+
+	if (type != RDMA_NETDEV_IPOIB)
+		return ERR_PTR(ENOTSUPP);
+
+	/* new IPoIB QP */
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp) {
+		pr_warn("Failed allocate memroy for QP\n");
+		return NULL;
+	}
+
+	/* config and move qp to RTS */
+	ret = mlx5_ib_config_ipoib_qp(ib_dev, qp);
+	if (ret) {
+		pr_warn("Failed config IPoIB QP ret: %d\n", ret);
+		goto clean_qp;
+	}
+
+	param.qpn = qp->qpn;
+	dev = mlx5i_create_netdev(ib_dev->mdev, name, setup, &param);
+	if (!dev) {
+		pr_err("%s: Failed to create net device\n", __func__);
+		goto clean_qp;
+	}
+
+	pr_debug("%s qpn: %d created\n", __func__, qp->qpn);
+
+	/* set func pointers */
+	rn = netdev_priv(dev);
+	rn->hca = hca;
+	rn->send = mlx5_ib_send;
+	rn->attach_mcast = mlx5_ib_attach_mcast;
+	rn->detach_mcast = mlx5_ib_detach_mcast;
+
+	dev->netdev_ops = &ipoib_accel_netdev_ops;
+
+	/* private members */
+	ipoib_accl_priv = netdev_priv(dev);
+	ipoib_accl_priv->context = qp;
+	ipoib_accl_priv->qpn = qp->qpn;
+
+	return dev;
+
+clean_qp:
+	mlx5_ib_clean_qp(ib_dev, qp);
+	return NULL;
+}
+
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
