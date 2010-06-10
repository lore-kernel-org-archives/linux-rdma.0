From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 10/19 V4] mlx4_core: Determine primary physical function
Date: Thu, 10 Jun 2010 22:02:08 +0300
Message-ID: <4C1136B0.6090104@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In multifunctional devices, only the primary function would succeed
to execute QUERY_FW command, all other would fail with _EACCES error.
Ownership on the device can also be claimed by reading a descriptor before
sw reset. If it is 0, no one claimed ownership on the device so far,
otherwise, you are not the owner.
A physical function that is not primary would behave as slave.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c       |    4 ++++
 drivers/net/mlx4/fw.h       |    1 +
 drivers/net/mlx4/main.c     |   32 ++++++++++++++++++++++++++++++--
 drivers/net/mlx4/mlx4.h     |    2 ++
 drivers/net/mlx4/reset.c    |   33 +++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h |    2 ++
 6 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index dc0570f..d1427e5 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -309,6 +309,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev_cap->max_rdma_global = 1 << (field & 0x3f);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_ACK_DELAY_OFFSET);
 	dev_cap->local_ca_ack_delay = field & 0x1f;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MTU_WIDTH_OFFSET);
+	dev_cap->pf_num = field;
+	if (dev_cap->pf_num > 1)
+		dev->flags |= MLX4_FLAG_MASTER;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_VL_PORT_OFFSET);
 	dev_cap->num_ports = field & 0xf;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_MSG_SZ_OFFSET);
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index d066c69..a9d7e55 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -64,6 +64,7 @@ struct mlx4_dev_cap {
 	int max_responder_per_qp;
 	int max_rdma_global;
 	int local_ca_ack_delay;
+	int pf_num;
 	int num_ports;
 	u32 max_msg_sz;
 	int ib_mtu[MLX4_MAX_PORTS + 1];
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 3331c33..9dca6f4 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -191,6 +191,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		return -ENODEV;
 	}
 
+	dev->caps.pf_num = dev_cap->pf_num;
 	dev->caps.num_ports	     = dev_cap->num_ports;
 	for (i = 1; i <= dev->caps.num_ports; ++i) {
 		dev->caps.vl_cap[i]	    = dev_cap->max_vl[i];
@@ -1296,6 +1297,19 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* We reset the device and enable SRIOV only for physical devices */
 	if (!mlx4_is_slave(dev)) {
+		/* Claim ownership on the device,
+		 * if already taken, act as slave*/
+		err = mlx4_get_ownership(dev);
+		if (err) {
+			if (err < 0) {
+				goto err_free_dev;
+			} else {
+				err = 0;
+				dev->flags |= MLX4_FLAG_SLAVE;
+				goto slave_start;
+			}
+		}
+
 		/*
 		 * Now reset the HCA before we touch the PCI capabilities or
 		 * attempt a firmware command, since a boot ROM may have left
@@ -1317,6 +1331,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
+slave_start:
 	if (mlx4_cmd_init(dev)) {
 		mlx4_err(dev, "Failed to init command interface, aborting.\n");
 		goto err_sriov;
@@ -1332,8 +1347,17 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	err = mlx4_init_hca(dev);
-	if (err)
-		goto err_cmd;
+	if (err) {
+		if (err == -EACCES) {
+			/* Not primary Physical function
+			 * Running in slave mode */
+			mlx4_cmd_cleanup(dev);
+			dev->flags |= MLX4_FLAG_SLAVE;
+			dev->flags &= ~MLX4_FLAG_MASTER;
+			goto slave_start;
+		} else
+			goto err_cmd;
+	}
 
 	/* In master functions, the communication channel must be initialized after obtaining
 	 * its address from fw */
@@ -1422,6 +1446,8 @@ err_sriov:
 		pci_disable_sriov(pdev);
 
 err_free_dev:
+	if (!mlx4_is_slave(dev))
+		mlx4_free_ownership(dev);
 	kfree(priv);
 
 err_release_regions:
@@ -1490,6 +1516,8 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 			pci_disable_sriov(pdev);
 		}
 
+		if (!mlx4_is_slave(dev))
+			mlx4_free_ownership(dev);
 		kfree(priv);
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 5206459..351956d 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -437,6 +437,8 @@ int mlx4_bitmap_init(struct mlx4_bitmap *bitmap, u32 num, u32 mask,
 void mlx4_bitmap_cleanup(struct mlx4_bitmap *bitmap);
 
 int mlx4_reset(struct mlx4_dev *dev);
+int mlx4_get_ownership(struct mlx4_dev *dev);
+void mlx4_free_ownership(struct mlx4_dev *dev);
 
 int mlx4_alloc_eq_table(struct mlx4_dev *dev);
 void mlx4_free_eq_table(struct mlx4_dev *dev);
diff --git a/drivers/net/mlx4/reset.c b/drivers/net/mlx4/reset.c
index e5741da..bef79c0 100644
--- a/drivers/net/mlx4/reset.c
+++ b/drivers/net/mlx4/reset.c
@@ -39,6 +39,39 @@
 
 #include "mlx4.h"
 
+
+#define MLX4_OWNER_BASE	0x8069c
+#define MLX4_OWNER_SIZE	4
+
+int mlx4_get_ownership(struct mlx4_dev *dev)
+{
+	void __iomem *owner;
+	u32 ret;
+
+	owner = ioremap(pci_resource_start(dev->pdev, 0) + MLX4_OWNER_BASE,
+			MLX4_OWNER_SIZE);
+	if (!owner) {
+		mlx4_err(dev, "Failed to obtain ownership bit\n");
+		return -ENOMEM;
+	}
+
+	ret = readl(owner);
+	return (int) !!ret;
+}
+
+void mlx4_free_ownership(struct mlx4_dev *dev)
+{
+	void __iomem *owner;
+
+	owner = ioremap(pci_resource_start(dev->pdev, 0) + MLX4_OWNER_BASE,
+			MLX4_OWNER_SIZE);
+	if (!owner) {
+		mlx4_err(dev, "Failed to obtain ownership bit\n");
+		return;
+	}
+	writel(0, owner);
+}
+
 int mlx4_reset(struct mlx4_dev *dev)
 {
 	void __iomem *reset;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 78a5fc9..c543210 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -45,6 +45,7 @@ enum {
 	MLX4_FLAG_MASTER	= 1 << 2,
 	MLX4_FLAG_SLAVE		= 1 << 3,
 	MLX4_FLAG_SRIOV		= 1 << 4,
+	MLX4_FLAG_PF		= 1 << 5,
 };
 
 enum {
@@ -182,6 +183,7 @@ static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 
 struct mlx4_caps {
 	u64			fw_ver;
+	int			pf_num;
 	int			num_ports;
 	int			vl_cap[MLX4_MAX_PORTS + 1];
 	int			ib_mtu_cap[MLX4_MAX_PORTS + 1];
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
