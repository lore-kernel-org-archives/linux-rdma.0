From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv2] mlx4: Add a new supported 40 GigE device ID
Date: Mon, 12 Oct 2009 17:14:35 +0200
Message-ID: <20091012151435.GA30130@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add MT26438, ConnectX EN 40GigE PCIe 2.0 5GT/s to the list of supported
devices.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Resending the patch based on Roland's "for-linus" branch.
I will send another patch later to fix official names of supported
devices.


 drivers/net/mlx4/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 5dd7225..a06692f 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1283,6 +1283,7 @@ static struct pci_device_id mlx4_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT25458 ConnectX EN 10GBASE-T+Gen2 10GigE */
 	{ PCI_VDEVICE(MELLANOX, 0x6764) }, /* MT26468 ConnectX EN 10GigE PCIe gen2*/
 	{ PCI_VDEVICE(MELLANOX, 0x676e) }, /* MT26478 ConnectX2 40GigE PCIe gen2 */
+	{ PCI_VDEVICE(MELLANOX, 0x6746) }, /* MT26438 ConnectX EN 40GigE PCIe gen2 5GT/s */
 	{ 0, }
 };
 
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
