From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 4/7] IB/uverbs: Add command to register a DMA-BUF fd
Date: Mon,  1 Aug 2016 09:57:30 +0300
Message-ID: <1470034653-9097-5-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

The new command accept the file descriptor of a DMA-BUF object as input,
as well as the PD and access flags, and produces a memory region
accessing the device memory exposed by the DMA-BUF object.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 111 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   1 +
 include/rdma/ib_verbs.h               |   6 ++
 include/uapi/rdma/ib_user_verbs.h     |  18 ++++++
 5 files changed, 137 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd39bf9..491292740b67 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -275,5 +275,6 @@ IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 IB_UVERBS_DECLARE_EX_CMD(query_device);
 IB_UVERBS_DECLARE_EX_CMD(create_cq);
 IB_UVERBS_DECLARE_EX_CMD(create_qp);
+IB_UVERBS_DECLARE_EX_CMD(reg_dma_buf_mr);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 825021d1008b..ca1f40769019 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/dma-buf.h>
 
 #include <asm/uaccess.h>
 
@@ -1125,6 +1126,116 @@ put_uobjs:
 	return ret;
 }
 
+int ib_uverbs_ex_reg_dma_buf_mr(struct ib_uverbs_file *file,
+				struct ib_device *ib_dev,
+				struct ib_udata *ucore, struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_reg_dma_buf_mr      cmd;
+	struct ib_uverbs_ex_reg_dma_buf_mr_resp resp;
+	struct ib_uobject           *uobj;
+	struct ib_pd                *pd;
+	struct ib_mr                *mr;
+	struct dma_buf		    *dmabuf;
+	int                          ret;
+
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
+	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	if (ucore->outlen < (offsetof(typeof(resp), response_length) +
+			     sizeof(resp.response_length)))
+		return -ENOSPC;
+
+	ret = ib_check_mr_access(cmd.access_flags);
+	if (ret)
+		return ret;
+
+	dmabuf = dma_buf_get(cmd.fd);
+	if (IS_ERR(dmabuf))
+		return PTR_ERR(dmabuf);
+
+	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
+	if (!uobj) {
+		ret = -ENOMEM;
+		goto err_dma_buf;
+	}
+
+	init_uobj(uobj, 0, file->ucontext, &mr_lock_class);
+	down_write(&uobj->mutex);
+
+	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	if (!pd->device->reg_user_dma_buf_mr) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	mr = pd->device->reg_user_dma_buf_mr(pd, dmabuf, cmd.access_flags, uhw);
+	if (IS_ERR(mr)) {
+		ret = PTR_ERR(mr);
+		goto err_put;
+	}
+
+	mr->device  = pd->device;
+	mr->pd      = pd;
+	mr->uobject = uobj;
+
+	uobj->object = mr;
+	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	if (ret)
+		goto err_unreg;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.lkey      = mr->lkey;
+	resp.rkey      = mr->rkey;
+	resp.mr_handle = uobj->id;
+	resp.response_length = sizeof(resp);
+
+	if (ib_copy_to_udata(ucore, &resp, resp.response_length)) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	dma_buf_put(dmabuf);
+	put_pd_read(pd);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->mr_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+
+	return 0;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+
+err_unreg:
+	ib_dereg_mr(mr);
+
+err_put:
+	put_pd_read(pd);
+
+err_free:
+	put_uobj_write(uobj);
+
+err_dma_buf:
+	dma_buf_put(dmabuf);
+	return ret;
+}
+
 ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 			   struct ib_device *ib_dev,
 			   const char __user *buf, int in_len,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 31f422a70623..c5368f2b1cf0 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -130,6 +130,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
 	[IB_USER_VERBS_EX_CMD_CREATE_CQ]	= ib_uverbs_ex_create_cq,
 	[IB_USER_VERBS_EX_CMD_CREATE_QP]        = ib_uverbs_ex_create_qp,
+	[IB_USER_VERBS_EX_CMD_REG_DMA_BUF_MR]   = ib_uverbs_ex_reg_dma_buf_mr,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index da23ec0a06d7..9c4241aeec79 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1677,6 +1677,7 @@ struct ib_dma_mapping_ops {
 };
 
 struct iw_cm_verbs;
+struct dma_buf;
 
 struct ib_port_immutable {
 	int                           pkey_tbl_len;
@@ -1866,6 +1867,11 @@ struct ib_device {
 						    int mr_access_flags,
 						    struct ib_pd *pd,
 						    struct ib_udata *udata);
+	struct ib_mr *             (*reg_user_dma_buf_mr)(
+					struct ib_pd *pd,
+					struct dma_buf *dmabuf,
+					int mr_access_flags,
+					struct ib_udata *udata);
 	int                        (*dereg_mr)(struct ib_mr *mr);
 	struct ib_mr *		   (*alloc_mr)(struct ib_pd *pd,
 					       enum ib_mr_type mr_type,
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b6543d73d20a..aad37e4572b5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -95,6 +95,7 @@ enum {
 	IB_USER_VERBS_EX_CMD_CREATE_QP = IB_USER_VERBS_CMD_CREATE_QP,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_EX_CMD_REG_DMA_BUF_MR,
 };
 
 /*
@@ -320,6 +321,23 @@ struct ib_uverbs_rereg_mr_resp {
 	__u32 rkey;
 };
 
+struct ib_uverbs_ex_reg_dma_buf_mr {
+	__u64 response;
+	__u32 fd;
+	__u32 access_flags;
+	__u32 pd_handle;
+	__u32 comp_mask;
+};
+
+struct ib_uverbs_ex_reg_dma_buf_mr_resp {
+	__u32 mr_handle;
+	__u32 lkey;
+	__u32 rkey;
+	__u32 comp_mask;
+	__u32 response_length;
+	__u32 reserved;
+};
+
 struct ib_uverbs_dereg_mr {
 	__u32 mr_handle;
 };
-- 
1.7.11.2
