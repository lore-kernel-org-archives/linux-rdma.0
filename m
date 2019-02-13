From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/15] net/mlx5: Introduce Mellanox SmartNIC and modify page management logic
Date: Tue, 12 Feb 2019 22:55:35 -0800
Message-ID: <20190213065546.3013-5-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Mellanox's SmartNIC combines embedded CPU(e.g, ARM) processing power
with advanced network offloads to accelerate a multitude of security,
networking and storage applications.

With the introduction of the SmartNIC, there is a new PCI function
called Embedded CPU Physical Function(ECPF). And it's possible for a
PF to get its ICM pages from the ECPF PCI function. Driver shall
identify if it is running on such a function by reading a bit in
the initialization segment.

When firmware asks for pages, it would issue a page request event
specifying how many pages it requests and for which function. That
driver responds with a manage_pages command providing the requested
pages along with an indication for which function it is providing these
pages.

The encoding before this patch was as follows:
    function_id == 0: pages are requested for the function receiving
                      the EQE.
    function_id != 0: pages are requested for VF identified by the
                      function_id value

A new one bit field in the EQE identifies that pages are requested for
the ECPF.

The notion of page_supplier can be introduced here and to support that,
manage pages and query pages were modified so firmware can distinguish
the following cases:

1. Function provides pages for itself
2. PF provides pages for its VF
3. ECPF provides pages to itself
4. ECPF provides pages for another function

This distinction is possible through the introduction of the bit
"embedded_cpu_function" in query_pages, manage_pages and page request
EQE.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    |  9 ++++
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    | 25 +++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +-
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 54 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  2 +-
 include/linux/mlx5/device.h                   |  2 +-
 include/linux/mlx5/driver.h                   |  9 +++-
 include/linux/mlx5/mlx5_ifc.h                 | 12 +++--
 10 files changed, 94 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ecpf.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 0257731e6d42..07965350b903 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -35,7 +35,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/tc_tun.o
 #
 # Core extra
 #
-mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o
+mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o ecpf.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
new file mode 100644
index 000000000000..28b8c5c5c8c7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "ecpf.h"
+
+bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev)
+{
+	return (ioread32be(&dev->iseg->initializing) >> MLX5_ECPU_BIT_NUM) & 1;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
new file mode 100644
index 000000000000..8b684f0ab48f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_ECPF_H__
+#define __MLX5_ECPF_H__
+
+#include <linux/mlx5/driver.h>
+#include "mlx5_core.h"
+
+#ifdef CONFIG_MLX5_ESWITCH
+
+enum {
+	MLX5_ECPU_BIT_NUM = 23,
+};
+
+bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev);
+
+#else  /* CONFIG_MLX5_ESWITCH */
+
+static inline bool
+mlx5_read_embedded_cpu(struct mlx5_core_dev *dev) { return false; }
+
+#endif /* CONFIG_MLX5_ESWITCH */
+
+#endif /* __MLX5_ECPF_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e38aa206ab6d..bf810fd91454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -65,6 +65,7 @@
 #include "lib/vxlan.h"
 #include "lib/devcom.h"
 #include "diag/fw_tracer.h"
+#include "ecpf.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
@@ -901,6 +902,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	struct pci_dev *pdev = dev->pdev;
 	int err;
 
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		dev_warn(&dev->pdev->dev, "%s: interface is up, NOP\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index c68dcea5985b..b127044293b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -121,7 +121,7 @@ int mlx5_modify_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 				       u32 modify_bitmask);
 int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 					u32 element_id);
-int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev);
+int mlx5_wait_for_pages(struct mlx5_core_dev *dev, int *pages);
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
 			     struct ptp_system_timestamp *sts);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index a83b517b0714..41025387ff2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -48,6 +48,7 @@ enum {
 struct mlx5_pages_req {
 	struct mlx5_core_dev *dev;
 	u16	func_id;
+	u8	ec_function;
 	s32	npages;
 	struct work_struct work;
 };
@@ -143,6 +144,7 @@ static int mlx5_cmd_query_pages(struct mlx5_core_dev *dev, u16 *func_id,
 	MLX5_SET(query_pages_in, in, op_mod, boot ?
 		 MLX5_QUERY_PAGES_IN_OP_MOD_BOOT_PAGES :
 		 MLX5_QUERY_PAGES_IN_OP_MOD_INIT_PAGES);
+	MLX5_SET(query_pages_in, in, embedded_cpu_function, mlx5_core_is_ecpf(dev));
 
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (err)
@@ -253,7 +255,8 @@ static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
 	return err;
 }
 
-static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id)
+static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id,
+			     bool ec_function)
 {
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)]   = {0};
@@ -262,6 +265,7 @@ static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id)
 	MLX5_SET(manage_pages_in, in, opcode, MLX5_CMD_OP_MANAGE_PAGES);
 	MLX5_SET(manage_pages_in, in, op_mod, MLX5_PAGES_CANT_GIVE);
 	MLX5_SET(manage_pages_in, in, function_id, func_id);
+	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (err)
@@ -270,7 +274,7 @@ static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id)
 }
 
 static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
-		      int notify_fail)
+		      int notify_fail, bool ec_function)
 {
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	int inlen = MLX5_ST_SZ_BYTES(manage_pages_in);
@@ -305,6 +309,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	MLX5_SET(manage_pages_in, in, op_mod, MLX5_PAGES_GIVE);
 	MLX5_SET(manage_pages_in, in, function_id, func_id);
 	MLX5_SET(manage_pages_in, in, input_num_entries, npages);
+	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 	if (err) {
@@ -316,8 +321,11 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	dev->priv.fw_pages += npages;
 	if (func_id)
 		dev->priv.vfs_pages += npages;
+	else if (mlx5_core_is_ecpf(dev) && !ec_function)
+		dev->priv.peer_pf_pages += npages;
 
-	mlx5_core_dbg(dev, "err %d\n", err);
+	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x, err %d\n",
+		      npages, ec_function, func_id, err);
 
 	kvfree(in);
 	return 0;
@@ -328,7 +336,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 out_free:
 	kvfree(in);
 	if (notify_fail)
-		page_notify_fail(dev, func_id);
+		page_notify_fail(dev, func_id, ec_function);
 	return err;
 }
 
@@ -364,7 +372,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 }
 
 static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
-			 int *nclaimed)
+			 int *nclaimed, bool ec_function)
 {
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {0};
@@ -385,6 +393,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	MLX5_SET(manage_pages_in, in, op_mod, MLX5_PAGES_TAKE);
 	MLX5_SET(manage_pages_in, in, function_id, func_id);
 	MLX5_SET(manage_pages_in, in, input_num_entries, npages);
+	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
 	mlx5_core_dbg(dev, "npages %d, outlen %d\n", npages, outlen);
 	err = reclaim_pages_cmd(dev, in, sizeof(in), out, outlen);
@@ -410,6 +419,8 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	dev->priv.fw_pages -= num_claimed;
 	if (func_id)
 		dev->priv.vfs_pages -= num_claimed;
+	else if (mlx5_core_is_ecpf(dev) && !ec_function)
+		dev->priv.peer_pf_pages -= num_claimed;
 
 out_free:
 	kvfree(out);
@@ -423,9 +434,10 @@ static void pages_work_handler(struct work_struct *work)
 	int err = 0;
 
 	if (req->npages < 0)
-		err = reclaim_pages(dev, req->func_id, -1 * req->npages, NULL);
+		err = reclaim_pages(dev, req->func_id, -1 * req->npages, NULL,
+				    req->ec_function);
 	else if (req->npages > 0)
-		err = give_pages(dev, req->func_id, req->npages, 1);
+		err = give_pages(dev, req->func_id, req->npages, 1, req->ec_function);
 
 	if (err)
 		mlx5_core_warn(dev, "%s fail %d\n",
@@ -434,6 +446,10 @@ static void pages_work_handler(struct work_struct *work)
 	kfree(req);
 }
 
+enum {
+	EC_FUNCTION_MASK = 0x8000,
+};
+
 static int req_pages_handler(struct notifier_block *nb,
 			     unsigned long type, void *data)
 {
@@ -441,6 +457,7 @@ static int req_pages_handler(struct notifier_block *nb,
 	struct mlx5_core_dev *dev;
 	struct mlx5_priv *priv;
 	struct mlx5_eqe *eqe;
+	bool ec_function;
 	u16 func_id;
 	s32 npages;
 
@@ -450,6 +467,7 @@ static int req_pages_handler(struct notifier_block *nb,
 
 	func_id = be16_to_cpu(eqe->data.req_pages.func_id);
 	npages  = be32_to_cpu(eqe->data.req_pages.num_pages);
+	ec_function = be16_to_cpu(eqe->data.req_pages.ec_function) & EC_FUNCTION_MASK;
 	mlx5_core_dbg(dev, "page request for func 0x%x, npages %d\n",
 		      func_id, npages);
 	req = kzalloc(sizeof(*req), GFP_ATOMIC);
@@ -461,6 +479,7 @@ static int req_pages_handler(struct notifier_block *nb,
 	req->dev = dev;
 	req->func_id = func_id;
 	req->npages = npages;
+	req->ec_function = ec_function;
 	INIT_WORK(&req->work, pages_work_handler);
 	queue_work(dev->priv.pg_wq, &req->work);
 	return NOTIFY_OK;
@@ -479,7 +498,7 @@ int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot)
 	mlx5_core_dbg(dev, "requested %d %s pages for func_id 0x%x\n",
 		      npages, boot ? "boot" : "init", func_id);
 
-	return give_pages(dev, func_id, npages, 0);
+	return give_pages(dev, func_id, npages, 0, mlx5_core_is_ecpf(dev));
 }
 
 enum {
@@ -513,7 +532,7 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 			fwp = rb_entry(p, struct fw_page, rb_node);
 			err = reclaim_pages(dev, fwp->func_id,
 					    optimal_reclaimed_pages(),
-					    &nclaimed);
+					    &nclaimed, mlx5_core_is_ecpf(dev));
 
 			if (err) {
 				mlx5_core_warn(dev, "failed reclaiming pages (%d)\n",
@@ -535,6 +554,9 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 	WARN(dev->priv.vfs_pages,
 	     "VFs FW pages counter is %d after reclaiming all pages\n",
 	     dev->priv.vfs_pages);
+	WARN(dev->priv.peer_pf_pages,
+	     "Peer PF FW pages counter is %d after reclaiming all pages\n",
+	     dev->priv.peer_pf_pages);
 
 	return 0;
 }
@@ -567,10 +589,10 @@ void mlx5_pagealloc_stop(struct mlx5_core_dev *dev)
 	flush_workqueue(dev->priv.pg_wq);
 }
 
-int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev)
+int mlx5_wait_for_pages(struct mlx5_core_dev *dev, int *pages)
 {
 	unsigned long end = jiffies + msecs_to_jiffies(MAX_RECLAIM_VFS_PAGES_TIME_MSECS);
-	int prev_vfs_pages = dev->priv.vfs_pages;
+	int prev_pages = *pages;
 
 	/* In case of internal error we will free the pages manually later */
 	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
@@ -578,16 +600,16 @@ int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev)
 		return 0;
 	}
 
-	mlx5_core_dbg(dev, "Waiting for %d pages from %s\n", prev_vfs_pages,
+	mlx5_core_dbg(dev, "Waiting for %d pages from %s\n", prev_pages,
 		      dev->priv.name);
-	while (dev->priv.vfs_pages) {
+	while (*pages) {
 		if (time_after(jiffies, end)) {
-			mlx5_core_warn(dev, "aborting while there are %d pending pages\n", dev->priv.vfs_pages);
+			mlx5_core_warn(dev, "aborting while there are %d pending pages\n", *pages);
 			return -ETIMEDOUT;
 		}
-		if (dev->priv.vfs_pages < prev_vfs_pages) {
+		if (*pages < prev_pages) {
 			end = jiffies + msecs_to_jiffies(MAX_RECLAIM_VFS_PAGES_TIME_MSECS);
-			prev_vfs_pages = dev->priv.vfs_pages;
+			prev_pages = *pages;
 		}
 		msleep(50);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 6e178030d8fb..7b23fa8d2d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,7 +147,7 @@ static void mlx5_device_disable_sriov(struct mlx5_core_dev *dev)
 	if (MLX5_ESWITCH_MANAGER(dev))
 		mlx5_eswitch_disable_sriov(dev->priv.eswitch);
 
-	if (mlx5_wait_for_vf_pages(dev))
+	if (mlx5_wait_for_pages(dev, &dev->priv.vfs_pages))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 46223efa1877..f2070350f60a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -591,7 +591,7 @@ struct mlx5_eqe_cmd {
 };
 
 struct mlx5_eqe_page_req {
-	u8		rsvd0[2];
+	__be16		ec_function;
 	__be16		func_id;
 	__be32		num_pages;
 	__be32		rsvd1[5];
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 039c9398614c..cce4e8293384 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -522,6 +522,7 @@ struct mlx5_priv {
 	atomic_t		reg_pages;
 	struct list_head	free_list;
 	int			vfs_pages;
+	int			peer_pf_pages;
 
 	struct mlx5_core_health health;
 
@@ -652,6 +653,7 @@ struct mlx5_core_dev {
 		u32 mcam[MLX5_ST_SZ_DW(mcam_reg)];
 		u32 fpga[MLX5_ST_SZ_DW(fpga_cap)];
 		u32 qcam[MLX5_ST_SZ_DW(qcam_reg)];
+		u8  embedded_cpu;
 	} caps;
 	u64			sys_image_guid;
 	phys_addr_t		iseg_base;
@@ -922,7 +924,7 @@ void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_start(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_stop(struct mlx5_core_dev *dev);
 void mlx5_core_req_pages_handler(struct mlx5_core_dev *dev, u16 func_id,
-				 s32 npages);
+				 s32 npages, bool ec_function);
 int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot);
 int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev);
 void mlx5_register_debugfs(void);
@@ -1076,6 +1078,11 @@ static inline int mlx5_core_is_pf(struct mlx5_core_dev *dev)
 	return !(dev->priv.pci_dev_data & MLX5_PCI_DEV_IS_VF);
 }
 
+static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
+{
+	return dev->caps.embedded_cpu;
+}
+
 #define MLX5_TOTAL_VPORTS(mdev) (1 + pci_sriov_get_totalvfs((mdev)->pdev))
 #define MLX5_VPORT_MANAGER(mdev) \
 	(MLX5_CAP_GEN(mdev, vport_group_manager) && \
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c5c679390fbd..46799b4c8859 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4441,7 +4441,8 @@ struct mlx5_ifc_query_pages_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x10];
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
 	u8         function_id[0x10];
 
 	u8         num_pages[0x20];
@@ -4460,7 +4461,8 @@ struct mlx5_ifc_query_pages_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
 	u8         function_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -5880,7 +5882,8 @@ struct mlx5_ifc_manage_pages_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x10];
+	u8         embedded_cpu_function[0x1];
+	u8         reserved_at_41[0xf];
 	u8         function_id[0x10];
 
 	u8         input_num_entries[0x20];
@@ -8749,7 +8752,8 @@ struct mlx5_ifc_initial_seg_bits {
 	u8         initializing[0x1];
 	u8         reserved_at_fe1[0x4];
 	u8         nic_interface_supported[0x3];
-	u8         reserved_at_fe8[0x18];
+	u8         embedded_cpu[0x1];
+	u8         reserved_at_fe9[0x17];
 
 	struct mlx5_ifc_health_buffer_bits health_buffer;
 
-- 
2.20.1
