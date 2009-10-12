From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4: Use official names for supported devices
Date: Mon, 12 Oct 2009 16:29:36 +0200
Message-ID: <20091012142936.GA27977@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the official names for the supported devices as they are documented in
http://pciids.sourceforge.net/v2.2/pci.ids. The patch also removes device ID
0x6354 from the list of supported devices which is a none existent device.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/main.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 3dd481e..ed0100f 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1272,16 +1272,15 @@ int mlx4_restart_one(struct pci_dev *pdev)
 }
 
 static struct pci_device_id mlx4_pci_table[] = {
-	{ PCI_VDEVICE(MELLANOX, 0x6340) }, /* MT25408 "Hermon" SDR */
-	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25408 "Hermon" DDR */
-	{ PCI_VDEVICE(MELLANOX, 0x6354) }, /* MT25408 "Hermon" QDR */
-	{ PCI_VDEVICE(MELLANOX, 0x6732) }, /* MT25408 "Hermon" DDR PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x673c) }, /* MT25408 "Hermon" QDR PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x6368) }, /* MT25408 "Hermon" EN 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x6750) }, /* MT25408 "Hermon" EN 10GigE PCIe gen2 */
-	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 ConnectX EN 10GBASE-T 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
-	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 ConnectX EN 10GigE PCIe gen2*/
+	{ PCI_VDEVICE(MELLANOX, 0x6340) }, /* MT25408 [ConnectX VPI - IB SDR / 10GigE] */
+	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] */
+	{ PCI_VDEVICE(MELLANOX, 0x6732) }, /* MT26418 [ConnectX VPI PCIe 2.0 5GT/s - IB DDR / 10GigE] */
+	{ PCI_VDEVICE(MELLANOX, 0x673c) }, /* MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] */
+	{ PCI_VDEVICE(MELLANOX, 0x6368) }, /* MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s] */
+	{ PCI_VDEVICE(MELLANOX, 0x6750) }, /* MT26448 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] */
+	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 [ConnectX EN 10GigE 10GBaseT, PCIe 2.0 2.5GT/s] */
+	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT26458 [ConnectX EN 10GigE 10GBaseT, PCIe Gen2 5GT/s] */
+	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 [ConnectX EN 10GigE, PCIe 2.0 5GT/s] */
 	{ 0, }
 };
 
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
