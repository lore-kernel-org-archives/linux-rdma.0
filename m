From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: IB: increase DMA max_segment_size on Mellanox hardware
Date: Sun, 16 Jan 2011 21:09:44 -0500
Message-ID: <1295230184.2574.26.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By default, each device is assumed to be able only handle 64 KB chunks
during DMA. By giving the segment size a larger value, the block layer
will coalesce more S/G entries together for SRP, allowing larger
requests with the same sg_tablesize setting.

This ups the value on Mellanox hardware to 2 GB, though there is no HW
limit.

Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
--
It could be 3 GB or even (4 GB - 1), since it's an unsigned int, but we
should rarely see a 2 GB request anyways.

I think it is probably safe to do something similar for the qib and
ipath drivers, and perhaps the iWarp cards for iSER.

This patch also reduces the iterations in SRP's mapping code for some
upcoming patches I have.

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 5eee666..deb79d4 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1043,6 +1043,9 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 		}
 	}
 
+	/* not a HW limit, but no way to say infinity */
+	dma_set_max_seg_size(&pdev->dev, 2 * 1024 * 1024 * 1024);
+
 	mdev = (struct mthca_dev *) ib_alloc_device(sizeof *mdev);
 	if (!mdev) {
 		dev_err(&pdev->dev, "Device struct alloc failed, "
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..699852e 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1109,6 +1109,9 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
+	/* not a HW limit, but no way to say infinity */
+	dma_set_max_seg_size(&pdev->dev, 2 * 1024 * 1024 * 1024);
+
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv) {
 		dev_err(&pdev->dev, "Device struct alloc failed, "


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
