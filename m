From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 7/7] NVMe: CMB on DMA-BUF
Date: Mon,  1 Aug 2016 09:57:33 +0300
Message-ID: <1470034653-9097-8-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allocate a CMB region to user-space as a DMA-BUF object.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/nvme/host/Makefile      |   2 +-
 drivers/nvme/host/core.c        |  29 ++++
 drivers/nvme/host/dmabuf.c      | 308 ++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme-pci.h    |   2 +
 drivers/nvme/host/nvme.h        |   1 +
 drivers/nvme/host/pci.c         |   6 +
 include/uapi/linux/nvme_ioctl.h |  11 ++
 7 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 drivers/nvme/host/dmabuf.c

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index 9a3ca892b4a7..f8d4f5d33398 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -5,4 +5,4 @@ nvme-core-y				:= core.o
 nvme-core-$(CONFIG_BLK_DEV_NVME_SCSI)	+= scsi.o
 nvme-core-$(CONFIG_NVM)			+= lightnvm.o
 
-nvme-y					+= pci.o
+nvme-y					+= pci.o dmabuf.o
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d5fb55c0a9d9..5860b468ab39 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1209,6 +1209,33 @@ out_unlock:
 	return ret;
 }
 
+static int nvme_alloc_user_cmb(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+			       struct nvme_alloc_user_cmb __user *ucmd)
+{
+	struct nvme_alloc_user_cmb cmd;
+	int status;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+		return -EFAULT;
+	if (cmd.flags || cmd.rsvd1 || cmd.opcode)
+		return -EINVAL;
+
+	if (!ctrl->ops->alloc_user_cmb)
+		return -ENOTTY;
+
+	status = ctrl->ops->alloc_user_cmb(ctrl, cmd.size);
+	if (status < 0)
+		return status;
+
+	cmd.fd = status;
+	if (copy_to_user(ucmd, &cmd, sizeof(cmd)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
@@ -1228,6 +1255,8 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_RESCAN:
 		nvme_queue_scan(ctrl);
 		return 0;
+	case NVME_IOCTL_ALLOC_USER_CMB:
+		return nvme_alloc_user_cmb(ctrl, NULL, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/nvme/host/dmabuf.c b/drivers/nvme/host/dmabuf.c
new file mode 100644
index 000000000000..ab9484b40775
--- /dev/null
+++ b/drivers/nvme/host/dmabuf.c
@@ -0,0 +1,308 @@
+/*
+ * Copyright © 2016 Mellanox Technlogies. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/slab.h>
+#include <linux/genalloc.h>
+#include <linux/dma-buf.h>
+
+#include "nvme-pci.h"
+
+struct nvme_cmb_object {
+	struct nvme_dev *dev;
+	struct dma_buf *dma_buf;
+	void *addr;
+	dma_addr_t dma_addr;
+	int attachments;
+	struct kref refcount;
+};
+
+static size_t obj_size(struct nvme_cmb_object *obj)
+{
+	return obj->dma_buf->size;
+}
+
+struct nvme_cmb_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+};
+
+static void nvme_cmb_object_get(struct nvme_cmb_object *obj)
+{
+	kref_get(&obj->refcount);
+}
+
+static void nvme_cmb_object_release(struct kref *kref)
+{
+	struct nvme_cmb_object *obj =
+		container_of(kref, struct nvme_cmb_object, refcount);
+
+	WARN_ON(obj->attachments);
+	WARN_ON(obj->addr || obj->dma_addr);
+
+	if (obj->dma_buf)
+		dma_buf_put(obj->dma_buf);
+	kfree(obj);
+}
+
+static void nvme_cmb_object_put(struct nvme_cmb_object *obj)
+{
+	kref_put(&obj->refcount, nvme_cmb_object_release);
+}
+
+static int nvme_cmb_map_attach(struct dma_buf *dma_buf,
+			       struct device *target_dev,
+			       struct dma_buf_attachment *attach)
+{
+	struct nvme_cmb_attachment *cmb_attach;
+	struct nvme_cmb_object *obj = dma_buf->priv;
+	struct nvme_dev *dev = obj->dev;
+	int ret;
+
+	cmb_attach = kzalloc(sizeof(*cmb_attach), GFP_KERNEL);
+	if (!cmb_attach)
+		return -ENOMEM;
+
+	/*
+	 * TODO check there is no IOMMU enabled and there is peer to peer
+	 * access between target_dev and our device
+	 */
+
+	cmb_attach->dir = DMA_NONE;
+	attach->priv = cmb_attach;
+
+	if (!obj->attachments) {
+		obj->addr = nvme_alloc_cmb(dev, obj_size(obj), &obj->dma_addr);
+		if (!obj->addr) {
+			ret = -ENOMEM;
+			goto free;
+		}
+	}
+	++obj->attachments;
+
+	return 0;
+
+free:
+	kfree(cmb_attach);
+	return ret;
+}
+
+static void nvme_cmb_map_detach(struct dma_buf *dma_buf,
+				struct dma_buf_attachment *attach)
+{
+	struct nvme_cmb_attachment *cmb_attach = attach->priv;
+	struct nvme_cmb_object *obj = dma_buf->priv;
+	struct nvme_dev *dev = obj->dev;
+
+	if (!cmb_attach)
+		return;
+
+	if (!--obj->attachments) {
+		nvme_free_cmb(dev, obj->addr, obj_size(obj));
+		obj->addr = NULL;
+		obj->dma_addr = 0;
+	}
+
+	if (cmb_attach->dir != DMA_NONE) {
+		/* TODO something like dma_unmap_resource */
+		sg_free_table(&cmb_attach->sgt);
+	}
+
+	kfree(cmb_attach);
+	attach->priv = NULL;
+}
+
+static struct sg_table *nvme_cmb_map_dma_buf(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct nvme_cmb_attachment *cmb_attach = attach->priv;
+	struct nvme_cmb_object *obj = attach->dmabuf->priv;
+	int ret;
+
+	if (WARN_ON(dir == DMA_NONE || !cmb_attach))
+		return ERR_PTR(-EINVAL);
+
+	/* return the cached mapping when possible */
+	if (cmb_attach->dir == dir)
+		return &cmb_attach->sgt;
+
+	/*
+	 * two mappings with different directions for the same attachment are
+	 * not allowed
+	 */
+	if (WARN_ON(cmb_attach->dir != DMA_NONE))
+		return ERR_PTR(-EBUSY);
+
+	ret = sg_alloc_table(&cmb_attach->sgt, 1, GFP_KERNEL);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * TODO
+	 * 1. Use something like dma_map_resource to get DMA mapping for the
+	 *    BAR.
+	 * 2. no struct page for this address, just a pfn. Make sure callers
+	 *    don't need it.
+	 */
+	sg_dma_address(cmb_attach->sgt.sgl) = obj->dma_addr;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+	sg_dma_len(cmb_attach->sgt.sgl) = obj_size(obj);
+#endif
+
+	cmb_attach->dir = dir;
+
+	return &cmb_attach->sgt;
+}
+
+static void nvme_cmb_unmap_dma_buf(struct dma_buf_attachment *attach,
+				   struct sg_table *sgt,
+				   enum dma_data_direction dir)
+{
+	/* nothing to be done here */
+}
+
+static void nvme_cmb_dmabuf_release(struct dma_buf *dma_buf)
+{
+	struct nvme_cmb_object *obj = dma_buf->priv;
+
+	if (!obj)
+		return;
+
+	nvme_cmb_object_put(obj);
+}
+
+static void *nvme_cmb_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
+					 unsigned long page_num)
+{
+	struct nvme_cmb_object *obj = dma_buf->priv;
+
+	if (!obj || !obj->addr)
+		return NULL;
+
+	return obj->addr + (page_num << PAGE_SHIFT);
+}
+
+static void nvme_cmb_vm_open(struct vm_area_struct *vma)
+{
+	struct nvme_cmb_object *obj = vma->vm_private_data;
+
+	nvme_cmb_object_get(obj);
+}
+
+static void nvme_cmb_vm_close(struct vm_area_struct *vma)
+{
+	struct nvme_cmb_object *obj = vma->vm_private_data;
+
+	nvme_cmb_object_put(obj);
+}
+
+static int nvme_cmb_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct nvme_cmb_object *obj = vma->vm_private_data;
+	pgoff_t offset;
+	unsigned long pfn;
+	int err;
+
+	if (!obj->addr)
+		return VM_FAULT_SIGBUS;
+
+	offset = ((unsigned long)vmf->virtual_address - vma->vm_start);
+	pfn = ((unsigned long)obj->addr + offset) >> PAGE_SHIFT;
+
+	err = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+	switch (err) {
+	case -EAGAIN:
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+	case -EBUSY:
+		return VM_FAULT_NOPAGE;
+
+	case -ENOMEM:
+		return VM_FAULT_OOM;
+	}
+
+	return VM_FAULT_SIGBUS;
+}
+
+static const struct vm_operations_struct nvme_cmb_vm_ops = {
+	.fault = nvme_cmb_fault,
+	.open = nvme_cmb_vm_open,
+	.close = nvme_cmb_vm_close,
+};
+
+static int nvme_cmb_dmabuf_mmap(struct dma_buf *dma_buf,
+				struct vm_area_struct *vma)
+{
+	struct nvme_cmb_object *obj = dma_buf->priv;
+
+	/* Check for valid size. */
+	if (obj_size(obj) < vma->vm_end - vma->vm_start)
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &nvme_cmb_vm_ops;
+	vma->vm_private_data = obj;
+	vma->vm_page_prot =
+		pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+
+	nvme_cmb_object_get(obj);
+
+	return 0;
+}
+
+static const struct dma_buf_ops nvme_cmb_dmabuf_ops =  {
+	.attach = nvme_cmb_map_attach,
+	.detach = nvme_cmb_map_detach,
+	.map_dma_buf = nvme_cmb_map_dma_buf,
+	.unmap_dma_buf = nvme_cmb_unmap_dma_buf,
+	.release = nvme_cmb_dmabuf_release,
+	.kmap = nvme_cmb_dmabuf_kmap_atomic,
+	.kmap_atomic = nvme_cmb_dmabuf_kmap_atomic,
+	.mmap = nvme_cmb_dmabuf_mmap,
+};
+
+int nvme_pci_alloc_user_cmb(struct nvme_dev *dev, u64 size)
+{
+	struct nvme_cmb_object *obj;
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	int ret;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	kref_init(&obj->refcount);
+	obj->dev = dev;
+
+	exp_info.ops = &nvme_cmb_dmabuf_ops;
+	exp_info.size = size;
+	exp_info.flags = O_CLOEXEC | O_RDWR;
+	exp_info.priv = obj;
+
+	obj->dma_buf = dma_buf_export(&exp_info);
+	if (IS_ERR(obj->dma_buf)) {
+		ret = PTR_ERR(obj->dma_buf);
+		goto put_obj;
+	}
+
+	ret = dma_buf_fd(obj->dma_buf, exp_info.flags);
+	if (ret < 0)
+		goto put_obj;
+
+	return ret;
+
+put_obj:
+	nvme_cmb_object_put(obj);
+	return ret;
+}
+
diff --git a/drivers/nvme/host/nvme-pci.h b/drivers/nvme/host/nvme-pci.h
index 5b29508dc182..2292d2c24fda 100644
--- a/drivers/nvme/host/nvme-pci.h
+++ b/drivers/nvme/host/nvme-pci.h
@@ -18,6 +18,8 @@
 
 struct nvme_dev;
 
+int nvme_pci_alloc_user_cmb(struct nvme_dev *dev, u64 size);
+
 void *nvme_alloc_cmb(struct nvme_dev *dev, size_t size, dma_addr_t *dma_addr);
 void nvme_free_cmb(struct nvme_dev *dev, void *addr, size_t size);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 1daa0482de0e..3a65144f23be 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -152,6 +152,7 @@ struct nvme_ctrl_ops {
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*post_scan)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl, int aer_idx);
+	int (*alloc_user_cmb)(struct nvme_ctrl *ctrl, u64 size);
 };
 
 static inline bool nvme_ctrl_ready(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d3da5d9552dd..2a15755e845e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1947,6 +1947,11 @@ static int nvme_pci_reset_ctrl(struct nvme_ctrl *ctrl)
 	return nvme_reset(to_nvme_dev(ctrl));
 }
 
+static int nvme_pci_alloc_user_cmb_wrapper(struct nvme_ctrl *ctrl, u64 size)
+{
+	return nvme_pci_alloc_user_cmb(to_nvme_dev(ctrl), size);
+}
+
 static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.module			= THIS_MODULE,
 	.reg_read32		= nvme_pci_reg_read32,
@@ -1956,6 +1961,7 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.free_ctrl		= nvme_pci_free_ctrl,
 	.post_scan		= nvme_pci_post_scan,
 	.submit_async_event	= nvme_pci_submit_async_event,
+	.alloc_user_cmb		= nvme_pci_alloc_user_cmb_wrapper,
 };
 
 static int nvme_dev_map(struct nvme_dev *dev)
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index 50ff21f748b6..d66f5b56b163 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -55,6 +55,16 @@ struct nvme_passthru_cmd {
 
 #define nvme_admin_cmd nvme_passthru_cmd
 
+struct nvme_alloc_user_cmb {
+	/* in */
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u64 size;
+	/* out */
+	__u32 fd;
+};
+
 #define NVME_IOCTL_ID		_IO('N', 0x40)
 #define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
 #define NVME_IOCTL_SUBMIT_IO	_IOW('N', 0x42, struct nvme_user_io)
@@ -62,5 +72,6 @@ struct nvme_passthru_cmd {
 #define NVME_IOCTL_RESET	_IO('N', 0x44)
 #define NVME_IOCTL_SUBSYS_RESET	_IO('N', 0x45)
 #define NVME_IOCTL_RESCAN	_IO('N', 0x46)
+#define NVME_IOCTL_ALLOC_USER_CMB _IOWR('N', 0x47, struct nvme_alloc_user_cmb)
 
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
