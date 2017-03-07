From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Tue, 7 Mar 2017 22:56:53 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that the following error message is reported on the console=0A=
while loading an RDMA driver with I/O MMU support enabled:=0A=
=0A=
DMAR: Allocating domain for mlx5_0 failed=0A=
=0A=
Ensure that DMA mapping operations that use to_pci_dev() to=0A=
access to struct pci_dev see the correct PCI device. E.g. the s390=0A=
and powerpc DMA mapping operations use to_pci_dev() even with I/O=0A=
MMU support disabled.=0A=
=0A=
This patch preserves the following changes of the DMA mapping updates=0A=
patch series:=0A=
- Introduction of dma_virt_ops.=0A=
- Removal of ib_device.dma_ops.=0A=
- Removal of struct ib_dma_mapping_ops.=0A=
- Removal of an if-statement from each ib_dma_*() operation.=0A=
- IB HW drivers no longer set dma_device directly.=0A=
=0A=
Reported-by: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>=0A=
Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=0A=
Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")=0A=
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>=0A=
---=0A=
 drivers/infiniband/core/device.c | 26 ++++++++++++++++++++------=0A=
 include/rdma/ib_verbs.h          | 30 +++++++++++++++++-------------=0A=
 2 files changed, 37 insertions(+), 19 deletions(-)=0A=
=0A=
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/dev=
ice.c=0A=
index 593d2ce6ec7c..addf869045cc 100644=0A=
--- a/drivers/infiniband/core/device.c=0A=
+++ b/drivers/infiniband/core/device.c=0A=
@@ -336,12 +336,26 @@ int ib_register_device(struct ib_device *device,=0A=
 	struct device *parent =3D device->dev.parent;=0A=
 =0A=
 	WARN_ON_ONCE(!parent);=0A=
-	if (!device->dev.dma_ops)=0A=
-		device->dev.dma_ops =3D parent->dma_ops;=0A=
-	if (!device->dev.dma_mask)=0A=
-		device->dev.dma_mask =3D parent->dma_mask;=0A=
-	if (!device->dev.coherent_dma_mask)=0A=
-		device->dev.coherent_dma_mask =3D parent->coherent_dma_mask;=0A=
+	WARN_ON_ONCE(device->dma_device);=0A=
+	if (device->dev.dma_ops) {=0A=
+		/*=0A=
+		 * The caller provided custom DMA operations. Copy the=0A=
+		 * DMA-related fields that are used by e.g. dma_alloc_coherent()=0A=
+		 * into device->dev.=0A=
+		 */=0A=
+		device->dma_device =3D &device->dev;=0A=
+		if (!device->dev.dma_mask)=0A=
+			device->dev.dma_mask =3D parent->dma_mask;=0A=
+		if (!device->dev.coherent_dma_mask)=0A=
+			device->dev.coherent_dma_mask =3D=0A=
+				parent->coherent_dma_mask;=0A=
+	} else {=0A=
+		/*=0A=
+		 * The caller did not provide custom DMA operations. Use the=0A=
+		 * DMA mapping operations of the parent device.=0A=
+		 */=0A=
+		device->dma_device =3D parent;=0A=
+	}=0A=
 =0A=
 	mutex_lock(&device_mutex);=0A=
 =0A=
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h=0A=
index 0f1813c13687..99e4423eb2b8 100644=0A=
--- a/include/rdma/ib_verbs.h=0A=
+++ b/include/rdma/ib_verbs.h=0A=
@@ -1863,6 +1863,9 @@ struct ib_port_immutable {=0A=
 };=0A=
 =0A=
 struct ib_device {=0A=
+	/* Do not access @dma_device directly from ULP nor from HW drivers. */=0A=
+	struct device                *dma_device;=0A=
+=0A=
 	char                          name[IB_DEVICE_NAME_MAX];=0A=
 =0A=
 	struct list_head              event_handler_list;=0A=
@@ -3007,7 +3010,7 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq=
, int wc_cnt)=0A=
  */=0A=
 static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr=
)=0A=
 {=0A=
-	return dma_mapping_error(&dev->dev, dma_addr);=0A=
+	return dma_mapping_error(dev->dma_device, dma_addr);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3021,7 +3024,7 @@ static inline u64 ib_dma_map_single(struct ib_device =
*dev,=0A=
 				    void *cpu_addr, size_t size,=0A=
 				    enum dma_data_direction direction)=0A=
 {=0A=
-	return dma_map_single(&dev->dev, cpu_addr, size, direction);=0A=
+	return dma_map_single(dev->dma_device, cpu_addr, size, direction);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3035,7 +3038,7 @@ static inline void ib_dma_unmap_single(struct ib_devi=
ce *dev,=0A=
 				       u64 addr, size_t size,=0A=
 				       enum dma_data_direction direction)=0A=
 {=0A=
-	dma_unmap_single(&dev->dev, addr, size, direction);=0A=
+	dma_unmap_single(dev->dma_device, addr, size, direction);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3052,7 +3055,7 @@ static inline u64 ib_dma_map_page(struct ib_device *d=
ev,=0A=
 				  size_t size,=0A=
 					 enum dma_data_direction direction)=0A=
 {=0A=
-	return dma_map_page(&dev->dev, page, offset, size, direction);=0A=
+	return dma_map_page(dev->dma_device, page, offset, size, direction);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3066,7 +3069,7 @@ static inline void ib_dma_unmap_page(struct ib_device=
 *dev,=0A=
 				     u64 addr, size_t size,=0A=
 				     enum dma_data_direction direction)=0A=
 {=0A=
-	dma_unmap_page(&dev->dev, addr, size, direction);=0A=
+	dma_unmap_page(dev->dma_device, addr, size, direction);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3080,7 +3083,7 @@ static inline int ib_dma_map_sg(struct ib_device *dev=
,=0A=
 				struct scatterlist *sg, int nents,=0A=
 				enum dma_data_direction direction)=0A=
 {=0A=
-	return dma_map_sg(&dev->dev, sg, nents, direction);=0A=
+	return dma_map_sg(dev->dma_device, sg, nents, direction);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3094,7 +3097,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *=
dev,=0A=
 				   struct scatterlist *sg, int nents,=0A=
 				   enum dma_data_direction direction)=0A=
 {=0A=
-	dma_unmap_sg(&dev->dev, sg, nents, direction);=0A=
+	dma_unmap_sg(dev->dma_device, sg, nents, direction);=0A=
 }=0A=
 =0A=
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,=0A=
@@ -3102,7 +3105,8 @@ static inline int ib_dma_map_sg_attrs(struct ib_devic=
e *dev,=0A=
 				      enum dma_data_direction direction,=0A=
 				      unsigned long dma_attrs)=0A=
 {=0A=
-	return dma_map_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);=0A=
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,=0A=
+				dma_attrs);=0A=
 }=0A=
 =0A=
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,=0A=
@@ -3110,7 +3114,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_de=
vice *dev,=0A=
 					 enum dma_data_direction direction,=0A=
 					 unsigned long dma_attrs)=0A=
 {=0A=
-	dma_unmap_sg_attrs(&dev->dev, sg, nents, direction, dma_attrs);=0A=
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);=0A=
 }=0A=
 /**=0A=
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry=
=0A=
@@ -3152,7 +3156,7 @@ static inline void ib_dma_sync_single_for_cpu(struct =
ib_device *dev,=0A=
 					      size_t size,=0A=
 					      enum dma_data_direction dir)=0A=
 {=0A=
-	dma_sync_single_for_cpu(&dev->dev, addr, size, dir);=0A=
+	dma_sync_single_for_cpu(dev->dma_device, addr, size, dir);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3167,7 +3171,7 @@ static inline void ib_dma_sync_single_for_device(stru=
ct ib_device *dev,=0A=
 						 size_t size,=0A=
 						 enum dma_data_direction dir)=0A=
 {=0A=
-	dma_sync_single_for_device(&dev->dev, addr, size, dir);=0A=
+	dma_sync_single_for_device(dev->dma_device, addr, size, dir);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3182,7 +3186,7 @@ static inline void *ib_dma_alloc_coherent(struct ib_d=
evice *dev,=0A=
 					   dma_addr_t *dma_handle,=0A=
 					   gfp_t flag)=0A=
 {=0A=
-	return dma_alloc_coherent(&dev->dev, size, dma_handle, flag);=0A=
+	return dma_alloc_coherent(dev->dma_device, size, dma_handle, flag);=0A=
 }=0A=
 =0A=
 /**=0A=
@@ -3196,7 +3200,7 @@ static inline void ib_dma_free_coherent(struct ib_dev=
ice *dev,=0A=
 					size_t size, void *cpu_addr,=0A=
 					dma_addr_t dma_handle)=0A=
 {=0A=
-	dma_free_coherent(&dev->dev, size, cpu_addr, dma_handle);=0A=
+	dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);=0A=
 }=0A=
 =0A=
 /**=0A=
-- =0A=
2.12.0=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
