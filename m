From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 13/20] IB/mlx5: Implement the ODP capability query verb
Date: Sun,  2 Mar 2014 12:49:31 +0200
Message-ID: <1393757378-16412-14-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch adds infrastructure to support the ODP capability query verb in the
mlx5 driver. The verb will read the capabilities from the device, and enable
only those capabilities that both the driver and the device supports.
At this point ODP is not supported, so no capability is copied from the
device, but the patch exposes the global ODP device capability bit to
designate that the new verb can be called.

Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Makefile  |  1 +
 drivers/infiniband/hw/mlx5/main.c    | 13 +++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 +++++
 drivers/infiniband/hw/mlx5/odp.c     | 69 ++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 drivers/infiniband/hw/mlx5/odp.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 4ea0135..27a7015 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 
 mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o
+mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7b9c078..f8015ac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -318,6 +318,12 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
+		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
+	props->odp_caps = dev->odp_caps;
+#endif
+
 out:
 	kfree(in_mad);
 	kfree(out_mad);
@@ -1397,6 +1403,10 @@ static int init_one(struct pci_dev *pdev,
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	dev->ib_dev.uverbs_ex_cmd_mask =
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_ODP_CAPS);
+#endif
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
@@ -1441,6 +1451,9 @@ static int init_one(struct pci_dev *pdev,
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	mlx5_ib_internal_query_odp_caps(dev);
+#endif
 
 	if (mdev->caps.flags & MLX5_DEV_CAP_FLAG_XRC) {
 		dev->ib_dev.alloc_xrcd = mlx5_ib_alloc_xrcd;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 29f58c1..767e791 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -392,6 +392,9 @@ struct mlx5_ib_dev {
 	struct mlx5_mr_cache		cache;
 	struct timer_list		delay_timer;
 	int				fill_delay;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	struct ib_odp_caps	odp_caps;
+#endif
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
@@ -569,6 +572,11 @@ void mlx5_umr_cq_handler(struct ib_cq *cq, void *cq_context);
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+int mlx5_ib_query_odp_caps(struct ib_device *ibdev, struct ib_odp_caps *caps);
+int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev);
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
 static inline void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
new file mode 100644
index 0000000..71ef604
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2014 Mellanox Technologies. All rights reserved.
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
+#include "mlx5_ib.h"
+
+#define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do {	\
+	if (be32_to_cpu(reg.field_name) & MLX5_ODP_SUPPORT_##bit_name)	\
+		ib_caps->field_name |= IB_ODP_SUPPORT_##bit_name;	\
+} while (0)
+
+int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev)
+{
+	int err;
+	struct mlx5_odp_caps hw_caps;
+	struct ib_odp_caps *caps = &dev->odp_caps;
+
+	memset(caps, 0, sizeof(*caps));
+
+	if (!(dev->mdev.caps.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
+		return 0;
+
+	err = mlx5_query_odp_caps(&dev->mdev, &hw_caps);
+	if (err)
+		goto out;
+
+	/* At this point we would copy the capability bits that the driver
+	 * supports from the hw_caps struct to the caps struct. However, no
+	 * such capabilities are supported so far. */
+out:
+	return err;
+}
+
+int mlx5_ib_query_odp_caps(struct ib_device *ibdev, struct ib_odp_caps *caps)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+
+	memcpy(caps, &dev->odp_caps, sizeof(*caps));
+
+	return 0;
+}
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
