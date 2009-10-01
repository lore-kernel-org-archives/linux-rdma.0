From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [ofa-general][PATCH] mlx4: Added 40Ge device ID
Date: Thu, 01 Oct 2009 15:15:34 +0200
Message-ID: <4AC4AB76.8050400@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 3dd481e..348b09b 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1282,6 +1282,7 @@ static struct pci_device_id mlx4_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 ConnectX EN 10GBASE-T 10GigE */
 	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
 	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 ConnectX EN 10GigE PCIe gen2*/
+	{ PCI_VDEVICE(MELLANOX, 0x676e) }, /* MT26478 "ConnectX2 40GigE, PCIe, 2.0 5Gt/s] */
 	{ 0, }
 };
 
-- 
1.6.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
