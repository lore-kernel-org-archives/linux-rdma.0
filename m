From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4: Adding CX3 device IDs
Date: Tue, 7 Dec 2010 16:23:45 +0200
Message-ID: <4CFE4371.1030100@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



As specified in pci.ids

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/main.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..d67123d 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1286,6 +1286,21 @@ static DEFINE_PCI_DEVICE_TABLE(mlx4_pci_table) = {
 	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 ConnectX EN 10GigE PCIe gen2*/
 	{ PCI_VDEVICE(MELLANOX, 0x6746) }, /* MT26438 ConnectX EN 40GigE PCIe gen2 5GT/s */
 	{ PCI_VDEVICE(MELLANOX, 0x676e) }, /* MT26478 ConnectX2 40GigE PCIe gen2 */
+	{ PCI_VDEVICE(MELLANOX, 0x1002) }, /* MT25400 Family [ConnectX-2 Virtual Function] */
+	{ PCI_VDEVICE(MELLANOX, 0x1003) }, /* MT27500 Family [ConnectX-3] */
+	{ PCI_VDEVICE(MELLANOX, 0x1004) }, /* MT27500 Family [ConnectX-3 Virtual Function] */
+	{ PCI_VDEVICE(MELLANOX, 0x1005) }, /* MT27510 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x1006) }, /* MT27511 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x1007) }, /* MT27520 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x1008) }, /* MT27521 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x1009) }, /* MT27530 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100a) }, /* MT27531 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100b) }, /* MT27540 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100c) }, /* MT27541 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100d) }, /* MT27550 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100e) }, /* MT27551 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x100f) }, /* MT27560 Family */
+	{ PCI_VDEVICE(MELLANOX, 0x1010) }, /* MT27561 Family */
 	{ 0, }
 };
 
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
