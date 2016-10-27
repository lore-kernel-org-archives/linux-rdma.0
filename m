From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V5 08/10] IB/core: Implement compatibility layer for get context command
Date: Thu, 27 Oct 2016 17:43:16 +0300
Message-ID: <1477579398-6875-9-git-send-email-matanb@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477579398-6875-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement write -> ioctl compatibility layer for ib_uverbs_get_context
by translating the headers to ioctl headers and invoke the ioctl
parser.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |   6 ++
 drivers/infiniband/core/uverbs_cmd.c | 169 +++++++++++++++++------------------
 2 files changed, 87 insertions(+), 88 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ad4af37..9f9f748 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -84,7 +84,13 @@
  * released when the CQ is destroyed.
  */
 
+struct ib_uverbs_ioctl_hdr;
 long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+			 struct ib_uverbs_file *file,
+			 struct ib_uverbs_ioctl_hdr *hdr,
+			 void __user *buf,
+			 mm_segment_t oldfs);
 
 struct ib_uverbs_device {
 	atomic_t				refcount;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8fc1557..b1baa67 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,6 +37,8 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <rdma/rdma_user_ioctl.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 
 #include <asm/uaccess.h>
 
@@ -303,6 +305,55 @@ static void put_xrcd_read(struct ib_uobject *uobj)
 {
 	put_uobj_read(uobj);
 }
+
+static int get_vendor_num_attrs(size_t cmd, size_t resp, int in_len,
+				int out_len)
+{
+	return !!(cmd != in_len) + !!(resp != out_len);
+}
+
+static void init_ioctl_hdr(struct ib_uverbs_ioctl_hdr *hdr,
+			   struct ib_device *ib_dev,
+			   size_t num_attrs,
+			   u16 object_type,
+			   u16 action)
+{
+	hdr->length = sizeof(*hdr) + num_attrs * sizeof(hdr->attrs[0]);
+	hdr->flags = 0;
+	hdr->object_type = object_type;
+	hdr->driver_id = ib_dev->driver_id;
+	hdr->action = action;
+	hdr->num_attrs = num_attrs;
+}
+
+static void fill_attr_ptr(struct ib_uverbs_attr *attr, u16 attr_id, u16 len,
+			  const void * __user source)
+{
+	attr->attr_id = attr_id;
+	attr->len = len;
+	attr->reserved = 0;
+	attr->ptr_idr = (__u64)source;
+}
+
+static void fill_hw_attrs(struct ib_uverbs_attr *hw_attrs,
+			  const void __user *in_buf,
+			  const void __user *out_buf,
+			  size_t cmd_size, size_t resp_size,
+			  int in_len, int out_len)
+{
+	if (in_len > cmd_size)
+		fill_attr_ptr(&hw_attrs[UVERBS_UHW_IN],
+			      UVERBS_UHW_IN | IB_UVERBS_VENDOR_FLAG,
+			      in_len - cmd_size,
+			      in_buf + cmd_size);
+
+	if (out_len > resp_size)
+		fill_attr_ptr(&hw_attrs[UVERBS_UHW_OUT],
+			      UVERBS_UHW_OUT | IB_UVERBS_VENDOR_FLAG,
+			      out_len - resp_size,
+			      out_buf + resp_size);
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      struct ib_device *ib_dev,
 			      const char __user *buf,
@@ -310,104 +361,46 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
-	struct ib_udata                   udata;
-	struct ib_ucontext		 *ucontext;
-	struct file			 *filp;
-	int ret;
+	struct {
+		struct ib_uverbs_ioctl_hdr hdr;
+		struct ib_uverbs_attr  cmd_attrs[GET_CONTEXT_RESP + 1];
+		struct ib_uverbs_attr  hw_attrs[UVERBS_UHW_OUT + 1];
+	} ioctl_cmd;
+	mm_segment_t oldfs = get_fs();
+	long err;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
 
-	if (copy_from_user(&cmd, buf, sizeof cmd))
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	mutex_lock(&file->mutex);
-
-	if (file->ucontext) {
-		ret = -EINVAL;
-		goto err;
-	}
-
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	init_ioctl_hdr(&ioctl_cmd.hdr, ib_dev, ARRAY_SIZE(ioctl_cmd.cmd_attrs) +
+		       get_vendor_num_attrs(sizeof(cmd), sizeof(resp), in_len,
+					    out_len),
+		       UVERBS_TYPE_DEVICE, UVERBS_DEVICE_ALLOC_CONTEXT);
 
-	ucontext = ib_dev->alloc_ucontext(ib_dev, &udata);
-	if (IS_ERR(ucontext)) {
-		ret = PTR_ERR(ucontext);
+	/*
+	 * We have to have a direct mapping between the new format and the old
+	 * format. It's easily achievable with new attributes.
+	 */
+	fill_attr_ptr(&ioctl_cmd.cmd_attrs[GET_CONTEXT_RESP],
+		      GET_CONTEXT_RESP, sizeof(resp),
+		      (const void * __user)cmd.response);
+	fill_hw_attrs(ioctl_cmd.hw_attrs, buf,
+		      (const void * __user)cmd.response, sizeof(cmd),
+		      sizeof(resp), in_len, out_len);
+
+	set_fs(KERNEL_DS);
+	err = ib_uverbs_cmd_verbs(ib_dev, file, &ioctl_cmd.hdr,
+				  ioctl_cmd.cmd_attrs, oldfs);
+	set_fs(oldfs);
+
+	if (err < 0)
 		goto err;
-	}
-
-	ucontext->device = ib_dev;
-	INIT_LIST_HEAD(&ucontext->pd_list);
-	INIT_LIST_HEAD(&ucontext->mr_list);
-	INIT_LIST_HEAD(&ucontext->mw_list);
-	INIT_LIST_HEAD(&ucontext->cq_list);
-	INIT_LIST_HEAD(&ucontext->qp_list);
-	INIT_LIST_HEAD(&ucontext->srq_list);
-	INIT_LIST_HEAD(&ucontext->ah_list);
-	INIT_LIST_HEAD(&ucontext->wq_list);
-	INIT_LIST_HEAD(&ucontext->rwq_ind_tbl_list);
-	INIT_LIST_HEAD(&ucontext->xrcd_list);
-	INIT_LIST_HEAD(&ucontext->rule_list);
-	rcu_read_lock();
-	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
-	rcu_read_unlock();
-	ucontext->closing = 0;
-
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	ucontext->umem_tree = RB_ROOT;
-	init_rwsem(&ucontext->umem_rwsem);
-	ucontext->odp_mrs_count = 0;
-	INIT_LIST_HEAD(&ucontext->no_private_counters);
-
-	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
-		ucontext->invalidate_range = NULL;
-
-#endif
-
-	resp.num_comp_vectors = file->device->num_comp_vectors;
-
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		goto err_free;
-	resp.async_fd = ret;
-
-	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
-	if (IS_ERR(filp)) {
-		ret = PTR_ERR(filp);
-		goto err_fd;
-	}
-
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
-		ret = -EFAULT;
-		goto err_file;
-	}
-
-	file->ucontext = ucontext;
-	ucontext->ufile = file;
-
-	fd_install(resp.async_fd, filp);
-
-	mutex_unlock(&file->mutex);
-
-	return in_len;
-
-err_file:
-	ib_uverbs_free_async_event_file(file);
-	fput(filp);
-
-err_fd:
-	put_unused_fd(resp.async_fd);
-
-err_free:
-	put_pid(ucontext->tgid);
-	ib_dev->dealloc_ucontext(ucontext);
 
 err:
-	mutex_unlock(&file->mutex);
-	return ret;
+	return err == 0 ? in_len : err;
 }
 
 void uverbs_copy_query_dev_fields(struct ib_device *ib_dev,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
