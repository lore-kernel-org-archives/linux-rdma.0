From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/16] drm/ati_pcigart: stop using drm_pci_alloc
Date: Fri, 14 Jun 2019 15:47:12 +0200
Message-ID: <20190614134726.3827-3-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190614134726.3827-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <maxime.ripard-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ian Abbott <abbotti-GUHe90Wt2aFaa/9Udqfwiw@public.gmane.org>, H Hartley Sweeten <hsweeten-3FF4nKcrg1dE2c76skzGb0EOCMrvLtNR@public.gmane.org>
Cc: Intel Linux Wireless <linuxwifi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "moderated list:ARM PORT" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove usage of the legacy drm PCI DMA wrappers, and with that the
incorrect usage cocktail of __GFP_COMP, virt_to_page on DMA allocation
and SetPageReserved.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/gpu/drm/ati_pcigart.c | 27 +++++++++++----------------
 include/drm/ati_pcigart.h     |  5 ++++-
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
index 2362f07fe1fc..f66d4fccd812 100644
--- a/drivers/gpu/drm/ati_pcigart.c
+++ b/drivers/gpu/drm/ati_pcigart.c
@@ -41,21 +41,14 @@
 static int drm_ati_alloc_pcigart_table(struct drm_device *dev,
 				       struct drm_ati_pcigart_info *gart_info)
 {
-	gart_info->table_handle = drm_pci_alloc(dev, gart_info->table_size,
-						PAGE_SIZE);
-	if (gart_info->table_handle == NULL)
+	gart_info->table_vaddr = dma_alloc_coherent(&dev->pdev->dev,
+			gart_info->table_size, &gart_info->table_handle,
+			GFP_KERNEL);
+	if (!gart_info->table_vaddr)
 		return -ENOMEM;
-
 	return 0;
 }
 
-static void drm_ati_free_pcigart_table(struct drm_device *dev,
-				       struct drm_ati_pcigart_info *gart_info)
-{
-	drm_pci_free(dev, gart_info->table_handle);
-	gart_info->table_handle = NULL;
-}
-
 int drm_ati_pcigart_cleanup(struct drm_device *dev, struct drm_ati_pcigart_info *gart_info)
 {
 	struct drm_sg_mem *entry = dev->sg;
@@ -87,8 +80,10 @@ int drm_ati_pcigart_cleanup(struct drm_device *dev, struct drm_ati_pcigart_info
 	}
 
 	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN &&
-	    gart_info->table_handle) {
-		drm_ati_free_pcigart_table(dev, gart_info);
+	    gart_info->table_vaddr) {
+		dma_free_coherent(&dev->pdev->dev, gart_info->table_size,
+				gart_info->table_vaddr, gart_info->table_handle);
+		gart_info->table_vaddr = NULL;
 	}
 
 	return 1;
@@ -127,9 +122,9 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 			goto done;
 		}
 
-		pci_gart = gart_info->table_handle->vaddr;
-		address = gart_info->table_handle->vaddr;
-		bus_address = gart_info->table_handle->busaddr;
+		pci_gart = gart_info->table_vaddr;
+		address = gart_info->table_vaddr;
+		bus_address = gart_info->table_handle;
 	} else {
 		address = gart_info->addr;
 		bus_address = gart_info->bus_addr;
diff --git a/include/drm/ati_pcigart.h b/include/drm/ati_pcigart.h
index a728a1364e66..2ffe278ba3b3 100644
--- a/include/drm/ati_pcigart.h
+++ b/include/drm/ati_pcigart.h
@@ -18,7 +18,10 @@ struct drm_ati_pcigart_info {
 	void *addr;
 	dma_addr_t bus_addr;
 	dma_addr_t table_mask;
-	struct drm_dma_handle *table_handle;
+
+	dma_addr_t table_handle;
+	void *table_vaddr;
+
 	struct drm_local_map mapping;
 	int table_size;
 };
-- 
2.20.1
