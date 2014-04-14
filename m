From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] IB/core/mlx4: add new verb command support
Date: Mon, 14 Apr 2014 19:01:05 +0200
Message-ID: <1397494869-43842-2-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397494869-43842-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current implementation of the userspace Infiniband verbs uses mapped
memory areas to directly access the device UAR and Blueflame page located
in the PCI I/O memory to initiate the I/O operations.
On the s390x platform access to the PCI I/O memory can be performed only
with using special privileged CPU instructions. Those privileged CPU
instructions cannot be used in userspace programs and this prevents using
mapped memory areas to directly access the PCI I/O memory on the s390x
platform.
Since, the existing Infiniband verbs use the mapped memory to access the
PCI I/O memory it is impossible to use them on the s390x platform without
modification.
There are two approaches could be implemented to solve this problem:
	* using a page fault handler to intercept mapped memory area
	  access errors, and handle them in the handler by issuing the
	  appropriate privileged CPU instructions;
	* modification of the existing verbs to avoid the mapped memory
	  areas usage on the s390x platform.
The page fault handler solution is the most complex one because it requires
not only modifcation of the virtual memory handling in Linux kernel but
also makes the developer to provide code for all the CPU instrutions which
work with memory program interpretation. This approach requires lots of
lines of code and noticable overhead during the program execution.
The modification of the existing verbs solution is much simpler and more
realible. It requires modification of the libraries provided in the DAPL
support packages to replace the usage of mapped memory areas used to
access the device UAR and Blueflame page with the device driver write
primitive calls supplying a special verb command to kernelspace.
The new verb command kernel handler processes the verb command and
executes the special privileged CPU instructions to pass the data to
the device PCI I/O memory. The only disadvantage of this approach is the
need to modify the userspace libraries and kernelspace device driver to
add support for the new verb command. The modification of the DAPL
applications is not required.
This patch introduces a new verb command IB_USER_VERBS_CMD_KWRITE_MMIO
which allows kernelspace driver to execute the privileged PCI I/O memory
access CPU instructions on requests from the userspace applications
instead of using the mapped memory areas.
This new verb command is passed to the kernelspace driver in the usual
way using the write() primitive to access user verbs device file.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 44 ++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  1 +
 drivers/infiniband/hw/mlx4/main.c     | 69 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |  4 ++
 include/rdma/ib_verbs.h               |  4 ++
 include/uapi/rdma/ib_user_verbs.h     | 14 +++++++
 7 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a283274..d61ebca 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -249,6 +249,7 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xsrq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
+IB_UVERBS_DECLARE_CMD(kwrite_mmio);
 
 #define IB_UVERBS_DECLARE_EX_CMD(name)				\
 	int ib_uverbs_ex_##name(struct ib_uverbs_file *file,	\
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ea6203e..a8b8b44 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2042,6 +2042,50 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+ssize_t ib_uverbs_kwrite_mmio(struct ib_uverbs_file *file,
+			const char __user *buf,
+			int in_len,
+			int out_len)
+{
+	struct ib_uverbs_kwrite_mmio	cmd_hdr;
+	ssize_t				ret = -EINVAL;
+	struct ib_uverbs_kwrite_mmio	*cmd = NULL;
+	ssize_t				cmd_length = 0;
+
+	if (file->device->ib_dev->kwrite_mmio == NULL) {
+		dev_alert(file->device->dev,
+			  "The verb %s is not supported by the driver.\n",
+			  "IB_USER_VERBS_CMD_KWRITE_MMIO");
+		return -ENOSYS;
+	}
+	if (in_len <= sizeof(cmd_hdr))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd_hdr, buf, sizeof(cmd_hdr)))
+		return -EFAULT;
+
+	if ((int)cmd_hdr.length <= 0)
+		return -EINVAL;
+
+	cmd_length = sizeof(cmd_hdr) + cmd_hdr.length;
+
+	cmd = kmalloc(cmd_length, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	if (copy_from_user(cmd, buf, cmd_length)) {
+		ret = -EFAULT;
+		goto cleanup;
+	}
+	mutex_lock(&file->mutex);
+	ret = file->device->ib_dev->kwrite_mmio(file->ucontext, cmd);
+	mutex_unlock(&file->mutex);
+
+cleanup:
+	kfree(cmd);
+	return ret;
+}
+
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08219fb..24f0c54 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -115,6 +115,7 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
+	[IB_USER_VERBS_CMD_KWRITE_MMIO]		= ib_uverbs_kwrite_mmio,
 };
 
 static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f9c12e9..2475f3c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -629,6 +629,23 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		return ERR_PTR(err);
 	}
 
+	context->uar_mmap = ioremap((phys_addr_t)context->uar.pfn
+					<< PAGE_SHIFT, PAGE_SIZE);
+	if (!context->uar_mmap) {
+		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
+		kfree(context);
+		return ERR_PTR(-ENOMEM);
+	}
+	context->bf_page_mmap = ioremap((phys_addr_t)(context->uar.pfn
+			+ dev->dev->caps.num_uars)
+			<< PAGE_SHIFT, PAGE_SIZE);
+	if (!context->bf_page_mmap) {
+		iounmap(context->uar_mmap);
+		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
+		kfree(context);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
@@ -638,6 +655,8 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		err = ib_copy_to_udata(udata, &resp, sizeof(resp));
 
 	if (err) {
+		iounmap(context->bf_page_mmap);
+		iounmap(context->uar_mmap);
 		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
 		kfree(context);
 		return ERR_PTR(-EFAULT);
@@ -650,6 +669,8 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 {
 	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);
 
+	iounmap(context->bf_page_mmap);
+	iounmap(context->uar_mmap);
 	mlx4_uar_free(to_mdev(ibcontext->device)->dev, &context->uar);
 	kfree(context);
 
@@ -658,6 +679,16 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 
 static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
+	/*
+	 * The UAR and Blueflame pages can not be accessed on the s390x
+	 * platform via mapped memory areas because access to the PCI I/O
+	 * memory can be performed only with special privileged CPU
+	 * instructions. To avoid confusing the userspace applicaion
+	 * developers, don't try to create mapped memory areas and always
+	 * return -EINVAL for a mapped memory area creation attempts on
+	 * the s390x platform.
+	 */
+#ifndef __s390x__
 	struct mlx4_ib_dev *dev = to_mdev(context->device);
 
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
@@ -682,6 +713,40 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	return 0;
+#else
+	dev_alert(&context->device->dev,
+		  "Cannot create memory mapping on this platform.\n");
+	return -EINVAL;
+#endif
+}
+
+int mlx4_ib_kwrite_mmio(struct ib_ucontext *ibcontext,
+			struct ib_uverbs_kwrite_mmio *cmd)
+{
+	struct mlx4_ib_ucontext *ctx = to_mucontext(ibcontext);
+	void __iomem *location = NULL;
+
+	if ((cmd->offset + cmd->length) > PAGE_SIZE)
+		return -EINVAL;
+	switch (cmd->location) {
+	case IB_UVERBS_KWRITE_MMIO_UAR:		/* UAR page */
+		location = ctx->uar_mmap;
+		break;
+	case IB_UVERBS_KWRITE_MMIO_BF_PAGE:	/* BF page */
+		location = ctx->bf_page_mmap;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!location)
+		return -ENOMEM;
+
+	wmb();		/* Ensure that the data was written to memory */
+	memcpy_toio(location + cmd->offset, cmd->value, cmd->length);
+	mmiowb();
+
+	return 0;
 }
 
 static struct ib_pd *mlx4_ib_alloc_pd(struct ib_device *ibdev,
@@ -1963,7 +2028,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
-		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+		(1ull << IB_USER_VERBS_CMD_OPEN_QP)		|
+		(1ull << IB_USER_VERBS_CMD_KWRITE_MMIO);
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
@@ -2006,6 +2072,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
+	ibdev->ib_dev.kwrite_mmio	= mlx4_ib_kwrite_mmio;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index a230683..b26e230 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -75,6 +75,8 @@ struct mlx4_ib_ucontext {
 	struct mlx4_uar		uar;
 	struct list_head	db_page_list;
 	struct mutex		db_page_mutex;
+	void __iomem		*uar_mmap;
+	void __iomem		*bf_page_mmap;
 };
 
 struct mlx4_ib_pd {
@@ -765,4 +767,6 @@ void mlx4_ib_steer_qp_free(struct mlx4_ib_dev *dev, u32 qpn, int count);
 int mlx4_ib_steer_qp_reg(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 			 int is_attach);
 
+int mlx4_ib_kwrite_mmio(struct ib_ucontext  *ibcontext,
+			struct ib_uverbs_kwrite_mmio *cmd);
 #endif /* MLX4_IB_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6793f32..bcd3d53 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -52,6 +52,7 @@
 
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
+#include <rdma/ib_user_verbs.h>
 
 extern struct workqueue_struct *ib_wq;
 
@@ -1455,6 +1456,9 @@ struct ib_device {
 						  *flow_attr,
 						  int domain);
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
+	int			   (*kwrite_mmio)(
+					struct ib_ucontext *ib_ucontext,
+					struct ib_uverbs_kwrite_mmio *cmd);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index cbfdd4c..ebf6bc8 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -87,6 +87,7 @@ enum {
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
 	IB_USER_VERBS_CMD_OPEN_QP,
+	IB_USER_VERBS_CMD_KWRITE_MMIO
 };
 
 enum {
@@ -861,4 +862,17 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+enum ib_uverbs_kwrite_mmio_location {
+	IB_UVERBS_KWRITE_MMIO_UAR,
+	IB_UVERBS_KWRITE_MMIO_BF_PAGE
+};
+
+struct ib_uverbs_kwrite_mmio {
+	__u16	offset;
+	__u16	length;
+	__u8	location;
+	__u8	reserved[3];
+	__u8	value[0];
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
