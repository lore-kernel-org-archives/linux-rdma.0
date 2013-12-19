From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: OFED DAPL support on System z platform
Date: Thu, 19 Dec 2013 12:53:14 +0100
Message-ID: <1387453998-27416-2-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387453998-27416-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch introduces the new verb command IB_USER_VERBS_CMD_KWRITE_MMIO
required for PCI I/O on Linux on System z. Since PCI I/O on System z
requires the execution of privileged instructions, a new verb command is
added so that userspace DAPL can trigger said instructions to initiate
I/O.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Reference-ID: NET1222
---
 drivers/infiniband/core/uverbs.h      |  3 ++
 drivers/infiniband/core/uverbs_cmd.c  | 46 ++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  8 +++++
 drivers/infiniband/hw/mlx4/main.c     | 67 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |  8 +++++
 include/rdma/ib_verbs.h               |  8 +++++
 include/uapi/rdma/ib_user_verbs.h     | 22 ++++++++++++
 7 files changed, 162 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d8f9c6c..044644f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -221,5 +221,8 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 IB_UVERBS_DECLARE_CMD(create_flow);
 IB_UVERBS_DECLARE_CMD(destroy_flow);
 #endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
+#ifdef __s390x__
+IB_UVERBS_DECLARE_CMD(kwrite_mmio);
+#endif
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2f0f01b..958ff30 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2052,6 +2052,52 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+#ifdef __s390x__
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
+			"The verb %s is not supported by the driver.\n",
+			"IB_USER_VERBS_CMD_KWRITE_MMIO");
+		ret = -ENOSYS;
+		goto cleanup;
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
+#endif
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2df31f6..eb39e55 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -117,8 +117,16 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
 #ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
+#ifndef __s390x__
 	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
+#else
+	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow,
+#endif
 #endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
+
+#ifdef __s390x__
+	[IB_USER_VERBS_CMD_KWRITE_MMIO]		= ib_uverbs_kwrite_mmio
+#endif
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f061264..6ad89df 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -622,6 +622,21 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		kfree(context);
 		return ERR_PTR(err);
 	}
+#ifdef __s390x__
+	context->uar_mmap = ioremap((phys_addr_t)context->uar.pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!context->uar_mmap) {
+		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
+		kfree(context);
+		return ERR_PTR(-ENOMEM);
+	}
+	context->bf_page_mmap = ioremap((phys_addr_t)(context->uar.pfn + dev->dev->caps.num_uars) << PAGE_SHIFT, PAGE_SIZE);
+	if (!context->bf_page_mmap) {
+		iounmap(context->uar_mmap);
+		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
+		kfree(context);
+		return ERR_PTR(-ENOMEM);
+	}
+#endif
 
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
@@ -632,6 +647,10 @@ static struct ib_ucontext *mlx4_ib_alloc_ucontext(struct ib_device *ibdev,
 		err = ib_copy_to_udata(udata, &resp, sizeof(resp));
 
 	if (err) {
+#ifdef __s390x__
+		iounmap(context->bf_page_mmap);
+		iounmap(context->uar_mmap);
+#endif
 		mlx4_uar_free(to_mdev(ibdev)->dev, &context->uar);
 		kfree(context);
 		return ERR_PTR(-EFAULT);
@@ -644,6 +663,10 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 {
 	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);
 
+#ifdef __s390x__
+	iounmap(context->bf_page_mmap);
+	iounmap(context->uar_mmap);
+#endif
 	mlx4_uar_free(to_mdev(ibcontext->device)->dev, &context->uar);
 	kfree(context);
 
@@ -652,6 +675,7 @@ static int mlx4_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 
 static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
+#ifndef __s390x__
 	struct mlx4_ib_dev *dev = to_mdev(context->device);
 
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
@@ -676,8 +700,43 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	return 0;
+#else
+	dev_alert(&context->device->dev,
+		"Memory mapping creation is not supported on this platform.\n");
+	return -EINVAL;
+#endif
 }
 
+#ifdef __s390x__
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
+	wmb();
+	memcpy_toio(location + cmd->offset, cmd->value, cmd->length);
+	mmiowb();
+
+	return 0;
+}
+#endif
 static struct ib_pd *mlx4_ib_alloc_pd(struct ib_device *ibdev,
 				      struct ib_ucontext *context,
 				      struct ib_udata *udata)
@@ -1617,7 +1676,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
+#ifndef __s390x__
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
+#else
+		(1ull << IB_USER_VERBS_CMD_OPEN_QP)		|
+		(1ull << IB_USER_VERBS_CMD_KWRITE_MMIO);
+#endif
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
@@ -1660,6 +1724,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
+#ifdef __s390x__
+	ibdev->ib_dev.kwrite_mmio	= mlx4_ib_kwrite_mmio;
+#endif
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 036b663..d507bbf 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -73,6 +73,10 @@ struct mlx4_ib_ucontext {
 	struct mlx4_uar		uar;
 	struct list_head	db_page_list;
 	struct mutex		db_page_mutex;
+#ifdef __s390x__
+	void __iomem		*uar_mmap;
+	void __iomem		*bf_page_mmap;
+#endif
 };
 
 struct mlx4_ib_pd {
@@ -753,4 +757,8 @@ void mlx4_ib_device_unregister_sysfs(struct mlx4_ib_dev *device);
 __be64 mlx4_ib_gen_node_guid(void);
 
 
+#ifdef __s390x__
+int mlx4_ib_kwrite_mmio(struct ib_ucontext  *ibcontext,
+			struct ib_uverbs_kwrite_mmio *cmd);
+#endif
 #endif /* MLX4_IB_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e393171..8de1c4d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -51,6 +51,9 @@
 
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
+#ifdef __s390x__
+#include <rdma/ib_user_verbs.h>
+#endif
 
 extern struct workqueue_struct *ib_wq;
 
@@ -1420,6 +1423,11 @@ struct ib_device {
 						  *flow_attr,
 						  int domain);
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
+#ifdef __s390x__
+	int			   (*kwrite_mmio) (
+					struct ib_ucontext *ib_ucontext,
+					struct ib_uverbs_kwrite_mmio *cmd);
+#endif
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index e3ddd86..d1b3bd6 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -89,8 +89,15 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP,
 #ifdef CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
+#ifndef __s390x__
 	IB_USER_VERBS_CMD_DESTROY_FLOW
+#else
+	IB_USER_VERBS_CMD_DESTROY_FLOW,
+#endif
 #endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
+#ifdef __s390x__
+	IB_USER_VERBS_CMD_KWRITE_MMIO = 52
+#endif
 };
 
 /*
@@ -850,4 +857,19 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+#ifdef __s390x__
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
+#endif
+
 #endif /* IB_USER_VERBS_H */
-- 
1.8.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
