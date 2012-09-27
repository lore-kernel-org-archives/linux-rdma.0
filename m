From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
Date: Thu, 27 Sep 2012 10:47:15 -0700
Message-ID: <1348768037-3660-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

That way we can check flags later on, when we've finished with the
pci_device_id structure.  Also convert the "is VF" flag to an enum:
"Never do in the preprocessor what can be done in C."

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   29 ++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    6 ++++++
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 9f06e04..ef1a39d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -95,8 +95,6 @@ MODULE_PARM_DESC(log_num_mgm_entry_size, "log mgm size, that defines the num"
 					 " Not in use with device managed"
 					 " flow steering");
 
-#define MLX4_VF                                        (1 << 0)
-
 #define HCA_GLOBAL_CAP_MASK            0
 #define PF_CONTEXT_BEHAVIOUR_MASK      0
 
@@ -1915,7 +1913,7 @@ static void mlx4_free_ownership(struct mlx4_dev *dev)
 	iounmap(owner);
 }
 
-static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 {
 	struct mlx4_priv *priv;
 	struct mlx4_dev *dev;
@@ -1938,12 +1936,11 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/*
 	 * Check for BARs.
 	 */
-	if (((id == NULL) || !(id->driver_data & MLX4_VF)) &&
+	if (!(pci_dev_data & MLX4_PCI_DEV_IS_VF) &&
 	    !(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "Missing DCS, aborting."
-			"(id == 0X%p, id->driver_data: 0x%lx,"
-			" pci_resource_flags(pdev, 0):0x%lx)\n", id,
-			id ? id->driver_data : 0, pci_resource_flags(pdev, 0));
+			"(driver_data: 0x%x, pci_resource_flags(pdev, 0):0x%lx)\n",
+			pci_dev_data, pci_resource_flags(pdev, 0));
 		err = -ENODEV;
 		goto err_disable_pdev;
 	}
@@ -2008,7 +2005,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev->rev_id = pdev->revision;
 	/* Detect if this device is a virtual function */
-	if (id && id->driver_data & MLX4_VF) {
+	if (pci_dev_data & MLX4_PCI_DEV_IS_VF) {
 		/* When acting as pf, we normally skip vfs unless explicitly
 		 * requested to probe them. */
 		if (num_vfs && extended_func_num(pdev) > probe_vf) {
@@ -2154,6 +2151,7 @@ slave_start:
 	mlx4_sense_init(dev);
 	mlx4_start_sense(dev);
 
+	priv->pci_dev_data = pci_dev_data;
 	pci_set_drvdata(pdev, dev);
 
 	return 0;
@@ -2223,7 +2221,7 @@ static int __devinit mlx4_init_one(struct pci_dev *pdev,
 {
 	printk_once(KERN_INFO "%s", mlx4_version);
 
-	return __mlx4_init_one(pdev, id);
+	return __mlx4_init_one(pdev, id->driver_data);
 }
 
 static void mlx4_remove_one(struct pci_dev *pdev)
@@ -2303,8 +2301,13 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 
 int mlx4_restart_one(struct pci_dev *pdev)
 {
+	struct mlx4_dev	 *dev  = pci_get_drvdata(pdev);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int		  pci_dev_data;
+
+	pci_dev_data = priv->pci_dev_data;
 	mlx4_remove_one(pdev);
-	return __mlx4_init_one(pdev, NULL);
+	return __mlx4_init_one(pdev, pci_dev_data);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
@@ -2333,11 +2336,11 @@ static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
 	/* MT26478 ConnectX2 40GigE PCIe gen2 */
 	{ PCI_VDEVICE(MELLANOX, 0x676e), 0 },
 	/* MT25400 Family [ConnectX-2 Virtual Function] */
-	{ PCI_VDEVICE(MELLANOX, 0x1002), MLX4_VF },
+	{ PCI_VDEVICE(MELLANOX, 0x1002), MLX4_PCI_DEV_IS_VF },
 	/* MT27500 Family [ConnectX-3] */
 	{ PCI_VDEVICE(MELLANOX, 0x1003), 0 },
 	/* MT27500 Family [ConnectX-3 Virtual Function] */
-	{ PCI_VDEVICE(MELLANOX, 0x1004), MLX4_VF },
+	{ PCI_VDEVICE(MELLANOX, 0x1004), MLX4_PCI_DEV_IS_VF },
 	{ PCI_VDEVICE(MELLANOX, 0x1005), 0 }, /* MT27510 Family */
 	{ PCI_VDEVICE(MELLANOX, 0x1006), 0 }, /* MT27511 Family */
 	{ PCI_VDEVICE(MELLANOX, 0x1007), 0 }, /* MT27520 Family */
@@ -2366,7 +2369,7 @@ static pci_ers_result_t mlx4_pci_err_detected(struct pci_dev *pdev,
 
 static pci_ers_result_t mlx4_pci_slot_reset(struct pci_dev *pdev)
 {
-	int ret = __mlx4_init_one(pdev, NULL);
+	int ret = __mlx4_init_one(pdev, 0);
 
 	return ret ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 1bb3e5e..65f73d6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -692,6 +692,10 @@ struct mlx4_steer {
 	struct list_head steer_entries[MLX4_NUM_STEERS];
 };
 
+enum {
+	MLX4_PCI_DEV_IS_VF		= 1 << 0,
+};
+
 struct mlx4_priv {
 	struct mlx4_dev		dev;
 
@@ -699,6 +703,8 @@ struct mlx4_priv {
 	struct list_head	ctx_list;
 	spinlock_t		ctx_lock;
 
+	int			pci_dev_data;
+
 	struct list_head        pgdir_list;
 	struct mutex            pgdir_mutex;
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
