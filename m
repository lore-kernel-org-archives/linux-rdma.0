From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 36/37] IB/core: Remove ib_device.dma_device
Date: Fri, 20 Jan 2017 13:04:36 -0800
Message-ID: <20170120210437.26389-37-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add code in ib_register_device() for copying the DMA masks. Use
&ib_device.dev in DMA mapping operations instead of dma_device.
Remove ib_device.dma_device because due to this and previous patches
it is no longer used.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/device.c | 17 +++++++++--------
 include/rdma/ib_verbs.h          | 31 +++++++++++++------------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d543c4390447..cac1518de36e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -333,14 +333,15 @@ int ib_register_device(struct ib_device *device,
 	int ret;
 	struct ib_client *client;
 	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
-
-	WARN_ON_ONCE(!device->dev.parent && !device->dma_device);
-	WARN_ON_ONCE(device->dev.parent && device->dma_device
-		     && device->dev.parent != device->dma_device);
-	if (!device->dev.parent)
-		device->dev.parent = device->dma_device;
-	if (!device->dma_device)
-		device->dma_device = device->dev.parent;
+	struct device *parent = device->dev.parent;
+
+	WARN_ON_ONCE(!parent);
+	if (!device->dev.dma_ops)
+		device->dev.dma_ops = parent->dma_ops;
+	if (!device->dev.dma_mask)
+		device->dev.dma_mask = parent->dma_mask;
+	if (!device->dev.coherent_dma_mask)
+		device->dev.coherent_dma_mask = parent->coherent_dma_mask;
 
 	mutex_lock(&device_mutex);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd4e42dd1efc..f09ed2f81c91 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1840,8 +1840,6 @@ struct ib_port_immutable {
 };
 
 struct ib_device {
-	struct device                *dma_device;
-
 	char                          name[IB_DEVICE_NAME_MAX];
 
 	struct list_head              event_handler_list;
@@ -2968,7 +2966,7 @@ static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->mapping_error(dev, dma_addr);
-	return dma_mapping_error(dev->dma_device, dma_addr);
+	return dma_mapping_error(&dev->dev, dma_addr);
 }
 
 /**
@@ -2984,7 +2982,7 @@ static inline u64 ib_dma_map_single(struct ib_device *dev,
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->map_single(dev, cpu_addr, size, direction);
-	return dma_map_single(dev->dma_device, cpu_addr, size, direction);
+	return dma_map_single(&dev->dev, cpu_addr, size, direction);
 }
 
 /**
@@ -3001,7 +2999,7 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_single(dev, addr, size, direction);
 	else
-		dma_unmap_single(dev->dma_device, addr, size, direction);
+		dma_unmap_single(&dev->dev, addr, size, direction);
 }
 
 /**
@@ -3020,7 +3018,7 @@ static inline u64 ib_dma_map_page(struct ib_device *dev,
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->map_page(dev, page, offset, size, direction);
-	return dma_map_page(dev->dma_device, page, offset, size, direction);
+	return dma_map_page(&dev->dev, page, offset, size, direction);
 }
 
 /**
@@ -3037,7 +3035,7 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_page(dev, addr, size, direction);
 	else
-		dma_unmap_page(dev->dma_device, addr, size, direction);
+		dma_unmap_page(&dev->dev, addr, size, direction);
 }
 
 /**
@@ -3053,7 +3051,7 @@ static inline int ib_dma_map_sg(struct ib_device *dev,
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->map_sg(dev, sg, nents, direction);
-	return dma_map_sg(dev->dma_device, sg, nents, direction);
+	return dma_map_sg(&dev->dev, sg, nents, direction);
 }
 
 /**
@@ -3070,7 +3068,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->unmap_sg(dev, sg, nents, direction);
 	else
-		dma_unmap_sg(dev->dma_device, sg, nents, direction);
+		dma_unmap_sg(&dev->dev, sg, nents, direction);
 }
 
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
@@ -3081,9 +3079,7 @@ static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 	if (dev->dma_ops)
 		return dev->dma_ops->map_sg_attrs(dev, sg, nents, direction,
 						  dma_attrs);
-	else
-		return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
-					dma_attrs);
+	return dma_map_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
 }
 
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
@@ -3095,8 +3091,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 		return dev->dma_ops->unmap_sg_attrs(dev, sg, nents, direction,
 						  dma_attrs);
 	else
-		dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction,
-				   dma_attrs);
+		dma_unmap_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
@@ -3141,7 +3136,7 @@ static inline void ib_dma_sync_single_for_cpu(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->sync_single_for_cpu(dev, addr, size, dir);
 	else
-		dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);
+		dma_sync_single_for_cpu(&dev->dev, addr, size, dir);
 }
 
 /**
@@ -3159,7 +3154,7 @@ static inline void ib_dma_sync_single_for_device(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->sync_single_for_device(dev, addr, size, dir);
 	else
-		dma_sync_single_for_device(dev->dma_device, addr, size, dir);
+		dma_sync_single_for_device(&dev->dev, addr, size, dir);
 }
 
 /**
@@ -3182,7 +3177,7 @@ static inline void *ib_dma_alloc_coherent(struct ib_device *dev,
 		*dma_handle = handle;
 		return ret;
 	}
-	return dma_alloc_coherent(dev->dma_device, size, dma_handle, flag);
+	return dma_alloc_coherent(&dev->dev, size, dma_handle, flag);
 }
 
 /**
@@ -3199,7 +3194,7 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 	if (dev->dma_ops)
 		dev->dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
 	else
-		dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
+		dma_free_coherent(&dev->dev, size, cpu_addr, dma_handle);
 }
 
 /**
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
