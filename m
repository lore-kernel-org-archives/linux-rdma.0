From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] mlx4_core: Clean up enabling of SENSE_PORT for older (ConnectX-1/-2) HCAs
Date: Thu, 27 Sep 2012 10:47:16 -0700
Message-ID: <1348768037-3660-2-git-send-email-roland@kernel.org>
References: <1348768037-3660-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348768037-3660-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Instead of having a hard-coded "PCI device ID != 0x1003" (which
obviously breaks as newer devices with ID != 0x1003 become available),
instead let's set a flag in our PCI device table for the older devices
where we're supposed to force using SENSE_PORT.  This also avoids
enabling SENSE_PORT for virtual functions by mistake.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   28 ++++++++++++++--------------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index ef1a39d..4d40b21 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -297,8 +297,8 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	mlx4_dbg(dev, "Steering mode is: %s\n",
 		 mlx4_steering_mode_str(dev->caps.steering_mode));
 
-	/* Sense port always allowed on supported devices for ConnectX1 and 2 */
-	if (dev->pdev->device != 0x1003)
+	/* Sense port always allowed on supported devices for ConnectX-1 and -2 */
+	if (mlx4_priv(dev)->pci_dev_data & MLX4_PCI_DEV_FORCE_SENSE_PORT)
 		dev->caps.flags |= MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
 
 	dev->caps.log_num_macs  = log_num_mac;
@@ -2312,29 +2312,29 @@ int mlx4_restart_one(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
 	/* MT25408 "Hermon" SDR */
-	{ PCI_VDEVICE(MELLANOX, 0x6340), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6340), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" DDR */
-	{ PCI_VDEVICE(MELLANOX, 0x634a), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x634a), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" QDR */
-	{ PCI_VDEVICE(MELLANOX, 0x6354), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6354), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" DDR PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x6732), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6732), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" QDR PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x673c), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x673c), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" EN 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x6368), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6368), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25408 "Hermon" EN 10GigE PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x6750), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6750), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25458 ConnectX EN 10GBASE-T 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x6372), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6372), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x675a), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x675a), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT26468 ConnectX EN 10GigE PCIe gen2*/
-	{ PCI_VDEVICE(MELLANOX, 0x6764), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6764), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT26438 ConnectX EN 40GigE PCIe gen2 5GT/s */
-	{ PCI_VDEVICE(MELLANOX, 0x6746), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x6746), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT26478 ConnectX2 40GigE PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x676e), 0 },
+	{ PCI_VDEVICE(MELLANOX, 0x676e), MLX4_PCI_DEV_FORCE_SENSE_PORT },
 	/* MT25400 Family [ConnectX-2 Virtual Function] */
 	{ PCI_VDEVICE(MELLANOX, 0x1002), MLX4_PCI_DEV_IS_VF },
 	/* MT27500 Family [ConnectX-3] */
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 65f73d6..f7156b7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -694,6 +694,7 @@ struct mlx4_steer {
 
 enum {
 	MLX4_PCI_DEV_IS_VF		= 1 << 0,
+	MLX4_PCI_DEV_FORCE_SENSE_PORT	= 1 << 1,
 };
 
 struct mlx4_priv {
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
