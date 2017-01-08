From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1] net/mlx4_core: VF probe fail when HW support 64-bit coherent DMA
Date: Sun,  8 Jan 2017 04:14:49 -0500
Message-ID: <1483866889-10700-1-git-send-email-shamir.rabinovitch@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CX3 firmware is unable to work with 64-bit coherent DMA. If IOMMU
support 64-bit coherent DMA mlx4_core driver will try to use it
and VF probe will fail due to firmware error.

Force all mlx4_core coherent DMA to 32-bit only!

Kernel log when issue occur:

[1383654.766249] mlx4_core 0006:01:00.1: Sending reset
[1383654.775971] mlx4_core 0006:01:00.0: Received reset from slave:1
[1383654.788087] mlx4_core 0006:01:00.1: Sending vhcr0
[1383664.318338] mlx4_core 0006:01:00.0: command 0x2e failed: fw status = 0x1
[1383664.318342] mlx4_core 0006:01:00.0: mlx4_master_process_vhcr: Failed
reading vhcr ret: 0xfffffffb
[1383664.318345] mlx4_core 0006:01:00.0: Failed processing vhcr for slave:1,
resetting slave
[1383664.318352] mlx4_core 0006:01:00.0: Turn on internal error to force
reset, slave=1, cmd=0x5
[1383664.318415] mlx4_core 0006:01:00.0: slave:1 is out of sync, cmd=0x5,
last command=0x0, reset is needed
[1383664.318418] mlx4_core 0006:01:00.0: Turn on internal error to force
reset, slave=1, cmd=0x5
[1383664.318501] mlx4_core 0006:01:00.0: slave:1 is out of sync, cmd=0x5,
last command=0x0, reset is needed
[1383664.318504] mlx4_core 0006:01:00.0: Turn on internal error to force
reset, slave=1, cmd=0x5
[1383664.318513] mlx4_core 0006:01:00.1: HCA minimum page size:1
[1383664.318515] mlx4_core 0006:01:00.1: UAR size:4096 != kernel PAGE_SIZE of
8192
[1383664.318517] mlx4_core 0006:01:00.1: Failed to obtain slave caps

Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 5e7840a..851d7f4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3701,14 +3701,11 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 			goto err_release_regions;
 		}
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	/* CX3 firmware 2.11.1280 does not support 64-bit coherent DMA */
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
-		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA mask\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting\n");
-			goto err_release_regions;
-		}
+		dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting\n");
+		goto err_release_regions;
 	}
 
 	/* Allow large DMA segments, up to the firmware limit of 1 GB */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
