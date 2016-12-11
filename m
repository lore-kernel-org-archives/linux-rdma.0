From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 09/14] IB/core: Add uverbs types, actions, handlers and attributes
Date: Sun, 11 Dec 2016 14:58:03 +0200
Message-ID: <1481461088-56355-10-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We add the common (core) code for init context, query device,
reg_mr, create_cq, create_qp, modify_qp create_comp_channel and
init_pd.
This includes the following parts:
* Macros for defining commands and validators
* For each command
    * type declarations
          - destruction order
          - free function
          - uverbs action group
    * actions
    * handlers
    * attributes

Drivers could use the these attributes, actions or types when they
want to alter or add a new type. The could use the uverbs handler
directly in the action (or just wrap it in the driver's custom code).

Currently we use ib_udata to pass vendor specific information to the
driver. This should probably be refactored in the future.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h        |  14 +
 drivers/infiniband/core/uverbs.h           |   4 +
 drivers/infiniband/core/uverbs_cmd.c       |  21 +-
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 864 ++++++++++++++++++++++++++++-
 include/rdma/uverbs_ioctl_cmd.h            | 140 +++++
 include/uapi/rdma/ib_user_verbs.h          |  39 ++
 6 files changed, 1052 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..fccc7bc 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -153,4 +153,18 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_callback *cb);
 
+/* Remove ignored fields set in the attribute mask */
+static inline int modify_qp_mask(enum ib_qp_type qp_type, int mask)
+{
+	switch (qp_type) {
+	case IB_QPT_XRC_INI:
+		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
+	case IB_QPT_XRC_TGT:
+		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
+				IB_QP_RNR_RETRY);
+	default:
+		return mask;
+	}
+}
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d3ad81c..7c038a3 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -201,6 +201,10 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 int uverbs_dealloc_mw(struct ib_mw *mw);
+void uverbs_copy_query_dev_fields(struct ib_device *ib_dev,
+				  struct ib_uverbs_query_device_resp *resp,
+				  struct ib_device_attr *attr);
+
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
 			   struct ib_uverbs_event_file *ev_file,
 			   struct ib_ucq_object *uobj);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 79a1a8b..a3fc3f72 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -210,8 +210,7 @@ err:
 	return ret;
 }
 
-static void copy_query_dev_fields(struct ib_uverbs_file *file,
-				  struct ib_device *ib_dev,
+void uverbs_copy_query_dev_fields(struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
 				  struct ib_device_attr *attr)
 {
@@ -272,7 +271,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs);
+	uverbs_copy_query_dev_fields(ib_dev, &resp, &ib_dev->attrs);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -2013,20 +2012,6 @@ out_query:
 	return ret;
 }
 
-/* Remove ignored fields set in the attribute mask */
-static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
-{
-	switch (qp_type) {
-	case IB_QPT_XRC_INI:
-		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
-	case IB_QPT_XRC_TGT:
-		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
-				IB_QP_RNR_RETRY);
-	default:
-		return mask;
-	}
-}
-
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
@@ -3834,7 +3819,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
+	uverbs_copy_query_dev_fields(ib_dev, &resp.base, &attr);
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
 		goto end;
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index cb19f38..5ab6189 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -37,6 +37,7 @@
 #include <linux/file.h>
 #include "rdma_core.h"
 #include "uverbs.h"
+#include "core_priv.h"
 
 void uverbs_free_ah(const struct uverbs_type_alloc_action *uobject_type,
 		    struct ib_uobject *uobject)
@@ -151,28 +152,852 @@ void uverbs_free_event_file(const struct uverbs_type_alloc_action *type_alloc_ac
 	kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
 };
 
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_uhw_compat_spec,
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_UHW_IN, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)),
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)));
+
+static void create_udata(struct uverbs_attr_array *ctx, size_t num,
+			 struct ib_udata *udata)
+{
+	/*
+	 * This is for ease of conversion. The purpose is to convert all drivers
+	 * to use uverbs_attr_array instead of ib_udata.
+	 * Assume attr == 0 is input and attr == 1 is output.
+	 */
+	void * __user inbuf;
+	size_t inbuf_len = 0;
+	void * __user outbuf;
+	size_t outbuf_len = 0;
+
+	if (num >= 2) {
+		struct uverbs_attr_array *driver = &ctx[1];
+
+		WARN_ON(driver->num_attrs > 2);
+
+		if (uverbs_is_valid(driver, 0)) {
+			inbuf = driver->attrs[0].cmd_attr.ptr;
+			inbuf_len = driver->attrs[0].cmd_attr.len;
+		}
+
+		if (driver->num_attrs == 2 && uverbs_is_valid(driver, 1)) {
+			outbuf = driver->attrs[1].cmd_attr.ptr;
+			outbuf_len = driver->attrs[1].cmd_attr.len;
+		}
+	}
+	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_get_context_spec,
+	UVERBS_ATTR_PTR_OUT(GET_CONTEXT_RESP,
+			    struct ib_uverbs_get_context_resp));
+
+int uverbs_get_context(struct ib_device *ib_dev,
+		       struct ib_uverbs_file *file,
+		       struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_udata uhw;
+	struct ib_uverbs_get_context_resp resp;
+	struct ib_ucontext		 *ucontext;
+	struct file			 *filp;
+	int ret;
+
+	if (!uverbs_is_valid(common, GET_CONTEXT_RESP))
+		return -EINVAL;
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	mutex_lock(&file->mutex);
+
+	if (file->ucontext) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ucontext = ib_dev->alloc_ucontext(ib_dev, &uhw);
+	if (IS_ERR(ucontext)) {
+		ret = PTR_ERR(ucontext);
+		goto err;
+	}
+
+	ucontext->device = ib_dev;
+	ret = ib_uverbs_uobject_type_initialize_ucontext(ucontext);
+	if (ret)
+		goto err_ctx;
+
+	rcu_read_lock();
+	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+	ucontext->closing = 0;
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	ucontext->umem_tree = RB_ROOT;
+	init_rwsem(&ucontext->umem_rwsem);
+	ucontext->odp_mrs_count = 0;
+	INIT_LIST_HEAD(&ucontext->no_private_counters);
+
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
+		ucontext->invalidate_range = NULL;
+
+#endif
+
+	resp.num_comp_vectors = file->device->num_comp_vectors;
+
+	ret = get_unused_fd_flags(O_CLOEXEC);
+	if (ret < 0)
+		goto err_free;
+	resp.async_fd = ret;
+
+	filp = ib_uverbs_alloc_async_event_file(file, ib_dev);
+	if (IS_ERR(filp)) {
+		ret = PTR_ERR(filp);
+		goto err_fd;
+	}
+
+	if (copy_to_user(common->attrs[GET_CONTEXT_RESP].cmd_attr.ptr,
+			 &resp, sizeof(resp))) {
+		ret = -EFAULT;
+		goto err_file;
+	}
+
+	file->ucontext = ucontext;
+	ucontext->ufile = file;
+
+	fd_install(resp.async_fd, filp);
+
+	mutex_unlock(&file->mutex);
+
+	return 0;
+
+err_file:
+	ib_uverbs_free_async_event_file(file);
+	fput(filp);
+
+err_fd:
+	put_unused_fd(resp.async_fd);
+
+err_free:
+	put_pid(ucontext->tgid);
+	ib_uverbs_uobject_type_release_ucontext(ucontext);
+
+err_ctx:
+	ib_dev->dealloc_ucontext(ucontext);
+err:
+	mutex_unlock(&file->mutex);
+	return ret;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_query_device_spec,
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_RESP, struct ib_uverbs_query_device_resp),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_ODP, struct ib_uverbs_odp_caps),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_TIMESTAMP_MASK, u64),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_HCA_CORE_CLOCK, u64),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_CAP_FLAGS, u64));
+
+int uverbs_query_device_handler(struct ib_device *ib_dev,
+				struct ib_uverbs_file *file,
+				struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_device_attr attr = {};
+	struct ib_udata uhw;
+	int err;
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	err = ib_dev->query_device(ib_dev, &attr, &uhw);
+	if (err)
+		return err;
+
+	if (uverbs_is_valid(common, QUERY_DEVICE_RESP)) {
+		struct ib_uverbs_query_device_resp resp = {};
+
+		uverbs_copy_query_dev_fields(ib_dev, &resp, &attr);
+		if (copy_to_user(common->attrs[QUERY_DEVICE_RESP].cmd_attr.ptr,
+				 &resp, sizeof(resp)))
+			return -EFAULT;
+	}
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (uverbs_is_valid(common, QUERY_DEVICE_ODP)) {
+		struct ib_uverbs_odp_caps odp_caps;
+
+		odp_caps.general_caps = attr.odp_caps.general_caps;
+		odp_caps.per_transport_caps.rc_odp_caps =
+			attr.odp_caps.per_transport_caps.rc_odp_caps;
+		odp_caps.per_transport_caps.uc_odp_caps =
+			attr.odp_caps.per_transport_caps.uc_odp_caps;
+		odp_caps.per_transport_caps.ud_odp_caps =
+			attr.odp_caps.per_transport_caps.ud_odp_caps;
+
+		if (copy_to_user(common->attrs[QUERY_DEVICE_ODP].cmd_attr.ptr,
+				 &odp_caps, sizeof(odp_caps)))
+			return -EFAULT;
+	}
+#endif
+	if (uverbs_copy_to(common, QUERY_DEVICE_TIMESTAMP_MASK,
+			   &attr.timestamp_mask) == -EFAULT)
+		return -EFAULT;
+
+	if (uverbs_copy_to(common, QUERY_DEVICE_HCA_CORE_CLOCK,
+			   &attr.hca_core_clock) == -EFAULT)
+		return -EFAULT;
+
+	if (uverbs_copy_to(common, QUERY_DEVICE_CAP_FLAGS,
+			   &attr.device_cap_flags) == -EFAULT)
+		return -EFAULT;
+
+	return 0;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_alloc_pd_spec,
+	UVERBS_ATTR_IDR(ALLOC_PD_HANDLE, UVERBS_TYPE_PD,
+			UVERBS_IDR_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_alloc_pd_handler(struct ib_device *ib_dev,
+			    struct ib_uverbs_file *file,
+			    struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_ucontext *ucontext = file->ucontext;
+	struct ib_udata uhw;
+	struct ib_uobject *uobject;
+	struct ib_pd *pd;
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	pd = ib_dev->alloc_pd(ib_dev, ucontext, &uhw);
+	if (IS_ERR(pd))
+		return PTR_ERR(pd);
+
+	uobject = common->attrs[ALLOC_PD_HANDLE].obj_attr.uobject;
+	pd->device  = ib_dev;
+	pd->uobject = uobject;
+	pd->__internal_mr = NULL;
+	uobject->object = pd;
+	atomic_set(&pd->usecnt, 0);
+
+	return 0;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_reg_mr_spec,
+	UVERBS_ATTR_IDR(REG_MR_HANDLE, UVERBS_TYPE_MR, UVERBS_IDR_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(REG_MR_PD_HANDLE, UVERBS_TYPE_PD, UVERBS_IDR_ACCESS_READ,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(REG_MR_CMD, struct ib_uverbs_ioctl_reg_mr,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_OUT(REG_MR_RESP, struct ib_uverbs_ioctl_reg_mr_resp,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_reg_mr_handler(struct ib_device *ib_dev,
+			  struct ib_uverbs_file *file,
+			  struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_uverbs_ioctl_reg_mr		cmd;
+	struct ib_uverbs_ioctl_reg_mr_resp	resp;
+	struct ib_udata uhw;
+	struct ib_uobject *uobject;
+	struct ib_pd                *pd;
+	struct ib_mr                *mr;
+	int                          ret;
+
+	if (copy_from_user(&cmd, common->attrs[REG_MR_CMD].cmd_attr.ptr,
+			   sizeof(cmd)))
+		return -EFAULT;
+
+	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
+		return -EINVAL;
+
+	ret = ib_check_mr_access(cmd.access_flags);
+	if (ret)
+		return ret;
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	uobject = common->attrs[REG_MR_HANDLE].obj_attr.uobject;
+	pd = common->attrs[REG_MR_PD_HANDLE].obj_attr.uobject->object;
+
+	if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
+		if (!(pd->device->attrs.device_cap_flags &
+		      IB_DEVICE_ON_DEMAND_PAGING)) {
+			pr_debug("ODP support not available\n");
+			return -EINVAL;
+		}
+	}
+
+	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
+				     cmd.access_flags, &uhw);
+	if (IS_ERR(mr))
+		return PTR_ERR(mr);
+
+	mr->device  = pd->device;
+	mr->pd      = pd;
+	mr->uobject = uobject;
+	atomic_inc(&pd->usecnt);
+	uobject->object = mr;
+
+	resp.lkey      = mr->lkey;
+	resp.rkey      = mr->rkey;
+
+	if (copy_to_user(common->attrs[REG_MR_RESP].cmd_attr.ptr,
+			 &resp, sizeof(resp))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	ib_dereg_mr(mr);
+	return ret;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_dereg_mr_spec,
+	UVERBS_ATTR_IDR(DEREG_MR_HANDLE, UVERBS_TYPE_MR, UVERBS_IDR_ACCESS_DESTROY,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_dereg_mr_handler(struct ib_device *ib_dev,
+			    struct ib_uverbs_file *file,
+			    struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_mr             *mr;
+
+	mr = common->attrs[DEREG_MR_HANDLE].obj_attr.uobject->object;
+
+	/* dereg_mr doesn't support driver data */
+	return ib_dereg_mr(mr);
+};
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_comp_channel_spec,
+	UVERBS_ATTR_FD(CREATE_COMP_CHANNEL_FD, UVERBS_TYPE_COMP_CHANNEL,
+		       UVERBS_IDR_ACCESS_NEW,
+		       UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_create_comp_channel_handler(struct ib_device *ib_dev,
+				       struct ib_uverbs_file *file,
+				       struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_uverbs_event_file *ev_file;
+
+	if (!uverbs_is_valid(common, CREATE_COMP_CHANNEL_FD))
+		return -EINVAL;
+
+	ev_file = uverbs_fd_to_priv(common->attrs[CREATE_COMP_CHANNEL_FD].obj_attr.uobject);
+	kref_init(&ev_file->ref);
+	spin_lock_init(&ev_file->lock);
+	INIT_LIST_HEAD(&ev_file->event_list);
+	init_waitqueue_head(&ev_file->poll_wait);
+	ev_file->async_queue = NULL;
+	ev_file->uverbs_file = file;
+	ev_file->is_closed   = 0;
+
+	/*
+	 * The original code puts the handle in an event list....
+	 * Currently, it's on our context
+	 */
+
+	return 0;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_cq_spec,
+	UVERBS_ATTR_IDR(CREATE_CQ_HANDLE, UVERBS_TYPE_CQ, UVERBS_IDR_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_CQE, u32,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_USER_HANDLE, u64),
+	UVERBS_ATTR_FD(CREATE_CQ_COMP_CHANNEL, UVERBS_TYPE_COMP_CHANNEL, UVERBS_IDR_ACCESS_READ),
+	/*
+	 * Currently, COMP_VECTOR is mandatory, but that could be lifted in the
+	 * future.
+	 */
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_COMP_VECTOR, u32,
+			   UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_FLAGS, u32),
+	UVERBS_ATTR_PTR_OUT(CREATE_CQ_RESP_CQE, u32,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_create_cq_handler(struct ib_device *ib_dev,
+			     struct ib_uverbs_file *file,
+			     struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_ucontext *ucontext = file->ucontext;
+	struct ib_ucq_object           *obj;
+	struct ib_udata uhw;
+	int ret;
+	u64 user_handle = 0;
+	struct ib_cq_init_attr attr = {};
+	struct ib_cq                   *cq;
+	struct ib_uverbs_event_file    *ev_file = NULL;
+
+	ret = uverbs_copy_from(&attr.comp_vector, common, CREATE_CQ_COMP_VECTOR);
+	if (!ret)
+		ret = uverbs_copy_from(&attr.cqe, common, CREATE_CQ_CQE);
+	if (ret)
+		return ret;
+
+	/* Optional params */
+	if (uverbs_copy_from(&attr.flags, common, CREATE_CQ_FLAGS) == -EFAULT ||
+	    uverbs_copy_from(&user_handle, common, CREATE_CQ_USER_HANDLE) == -EFAULT)
+		return -EFAULT;
+
+	if (uverbs_is_valid(common, CREATE_CQ_COMP_CHANNEL)) {
+		ev_file = uverbs_fd_to_priv(common->attrs[CREATE_CQ_COMP_CHANNEL].obj_attr.uobject);
+		kref_get(&ev_file->ref);
+	}
+
+	if (attr.comp_vector >= ucontext->ufile->device->num_comp_vectors)
+		return -EINVAL;
+
+	obj = container_of(common->attrs[CREATE_CQ_HANDLE].obj_attr.uobject,
+			   typeof(*obj), uobject);
+	obj->uverbs_file	   = ucontext->ufile;
+	obj->comp_events_reported  = 0;
+	obj->async_events_reported = 0;
+	INIT_LIST_HEAD(&obj->comp_list);
+	INIT_LIST_HEAD(&obj->async_list);
+
+	/* Temporary, only until drivers get the new uverbs_attr_array */
+	create_udata(ctx, num, &uhw);
+
+	cq = ib_dev->create_cq(ib_dev, &attr, ucontext, &uhw);
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
+
+	cq->device        = ib_dev;
+	cq->uobject       = &obj->uobject;
+	cq->comp_handler  = ib_uverbs_comp_handler;
+	cq->event_handler = ib_uverbs_cq_event_handler;
+	cq->cq_context    = ev_file;
+	obj->uobject.object = cq;
+	obj->uobject.user_handle = user_handle;
+	atomic_set(&cq->usecnt, 0);
+
+	ret = uverbs_copy_to(common, CREATE_CQ_RESP_CQE, &cq->cqe);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	ib_destroy_cq(cq);
+	return ret;
+};
+
+static int qp_fill_attrs(struct ib_qp_init_attr *attr, struct ib_ucontext *ctx,
+			 const struct ib_uverbs_ioctl_create_qp *cmd,
+			 u32 create_flags)
+{
+	if (create_flags & ~(IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
+			     IB_QP_CREATE_CROSS_CHANNEL |
+			     IB_QP_CREATE_MANAGED_SEND |
+			     IB_QP_CREATE_MANAGED_RECV |
+			     IB_QP_CREATE_SCATTER_FCS))
+		return -EINVAL;
+
+	attr->create_flags = create_flags;
+	attr->event_handler = ib_uverbs_qp_event_handler;
+	attr->qp_context = ctx->ufile;
+	attr->sq_sig_type = cmd->sq_sig_all ? IB_SIGNAL_ALL_WR :
+		IB_SIGNAL_REQ_WR;
+	attr->qp_type = cmd->qp_type;
+
+	attr->cap.max_send_wr     = cmd->max_send_wr;
+	attr->cap.max_recv_wr     = cmd->max_recv_wr;
+	attr->cap.max_send_sge    = cmd->max_send_sge;
+	attr->cap.max_recv_sge    = cmd->max_recv_sge;
+	attr->cap.max_inline_data = cmd->max_inline_data;
+
+	return 0;
+}
+
+static void qp_init_uqp(struct ib_uqp_object *obj)
+{
+	obj->uevent.events_reported     = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
+	INIT_LIST_HEAD(&obj->mcast_list);
+}
+
+static int qp_write_resp(const struct ib_qp_init_attr *attr,
+			 const struct ib_qp *qp,
+			 struct uverbs_attr_array *common)
+{
+	struct ib_uverbs_ioctl_create_qp_resp resp = {
+		.qpn = qp->qp_num,
+		.max_recv_sge    = attr->cap.max_recv_sge,
+		.max_send_sge    = attr->cap.max_send_sge,
+		.max_recv_wr     = attr->cap.max_recv_wr,
+		.max_send_wr     = attr->cap.max_send_wr,
+		.max_inline_data = attr->cap.max_inline_data};
+
+	return uverbs_copy_to(common, CREATE_QP_RESP, &resp);
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_qp_spec,
+	UVERBS_ATTR_IDR(CREATE_QP_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(CREATE_QP_PD_HANDLE, UVERBS_TYPE_PD, UVERBS_IDR_ACCESS_READ,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(CREATE_QP_SEND_CQ, UVERBS_TYPE_CQ, UVERBS_IDR_ACCESS_READ,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(CREATE_QP_RECV_CQ, UVERBS_TYPE_CQ, UVERBS_IDR_ACCESS_READ,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(CREATE_QP_SRQ, UVERBS_TYPE_SRQ, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_USER_HANDLE, u64),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_CMD, struct ib_uverbs_ioctl_create_qp),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_CMD_FLAGS, u32),
+	UVERBS_ATTR_PTR_OUT(CREATE_QP_RESP, struct ib_uverbs_ioctl_create_qp_resp,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_create_qp_handler(struct ib_device *ib_dev,
+			     struct ib_uverbs_file *file,
+			     struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_ucontext *ucontext = file->ucontext;
+	struct ib_uqp_object           *obj;
+	struct ib_udata uhw;
+	int ret;
+	u64 user_handle = 0;
+	u32 create_flags = 0;
+	struct ib_uverbs_ioctl_create_qp cmd;
+	struct ib_qp_init_attr attr = {};
+	struct ib_qp                   *qp;
+	struct ib_pd			*pd;
+
+	ret = uverbs_copy_from(&cmd, common, CREATE_QP_CMD);
+	if (ret)
+		return ret;
+
+	/* Optional params */
+	if (uverbs_copy_from(&create_flags, common, CREATE_QP_CMD_FLAGS) == -EFAULT ||
+	    uverbs_copy_from(&user_handle, common, CREATE_QP_USER_HANDLE) == -EFAULT)
+		return -EFAULT;
+
+	if (cmd.qp_type == IB_QPT_XRC_INI) {
+		cmd.max_recv_wr = 0;
+		cmd.max_recv_sge = 0;
+	}
+
+	ret = qp_fill_attrs(&attr, ucontext, &cmd, create_flags);
+	if (ret)
+		return ret;
+
+	pd = common->attrs[CREATE_QP_PD_HANDLE].obj_attr.uobject->object;
+	attr.send_cq = common->attrs[CREATE_QP_SEND_CQ].obj_attr.uobject->object;
+	attr.recv_cq = common->attrs[CREATE_QP_RECV_CQ].obj_attr.uobject->object;
+	if (uverbs_is_valid(common, CREATE_QP_SRQ))
+		attr.srq = common->attrs[CREATE_QP_SRQ].obj_attr.uobject->object;
+	obj = (struct ib_uqp_object *)common->attrs[CREATE_QP_HANDLE].obj_attr.uobject;
+
+	if (attr.srq && attr.srq->srq_type != IB_SRQT_BASIC)
+		return -EINVAL;
+
+	qp_init_uqp(obj);
+	create_udata(ctx, num, &uhw);
+	qp = pd->device->create_qp(pd, &attr, &uhw);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+	qp->real_qp	  = qp;
+	qp->device	  = pd->device;
+	qp->pd		  = pd;
+	qp->send_cq	  = attr.send_cq;
+	qp->recv_cq	  = attr.recv_cq;
+	qp->srq		  = attr.srq;
+	qp->event_handler = attr.event_handler;
+	qp->qp_context	  = attr.qp_context;
+	qp->qp_type	  = attr.qp_type;
+	atomic_set(&qp->usecnt, 0);
+	atomic_inc(&pd->usecnt);
+	atomic_inc(&attr.send_cq->usecnt);
+	if (attr.recv_cq)
+		atomic_inc(&attr.recv_cq->usecnt);
+	if (attr.srq)
+		atomic_inc(&attr.srq->usecnt);
+	qp->uobject = &obj->uevent.uobject;
+	obj->uevent.uobject.object = qp;
+	obj->uevent.uobject.user_handle = user_handle;
+
+	ret = qp_write_resp(&attr, qp, common);
+	if (ret) {
+		ib_destroy_qp(qp);
+		return ret;
+	}
+
+	return 0;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_qp_xrc_tgt_spec,
+	UVERBS_ATTR_IDR(CREATE_QP_XRC_TGT_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_NEW,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_IDR(CREATE_QP_XRC_TGT_XRCD, UVERBS_TYPE_XRCD, UVERBS_IDR_ACCESS_READ,
+			UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_USER_HANDLE, u64),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_CMD, struct ib_uverbs_ioctl_create_qp),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_CMD_FLAGS, u32),
+	UVERBS_ATTR_PTR_OUT(CREATE_QP_XRC_TGT_RESP, struct ib_uverbs_ioctl_create_qp_resp,
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
+int uverbs_create_qp_xrc_tgt_handler(struct ib_device *ib_dev,
+				     struct ib_uverbs_file *file,
+				     struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_ucontext *ucontext = file->ucontext;
+	struct ib_uqp_object           *obj;
+	int ret;
+	u64 user_handle = 0;
+	u32 create_flags = 0;
+	struct ib_uverbs_ioctl_create_qp cmd;
+	struct ib_qp_init_attr attr = {};
+	struct ib_qp                   *qp;
+
+	ret = uverbs_copy_from(&cmd, common, CREATE_QP_XRC_TGT_CMD);
+	if (ret)
+		return ret;
+
+	/* Optional params */
+	if (uverbs_copy_from(&create_flags, common, CREATE_QP_CMD_FLAGS) == -EFAULT ||
+	    uverbs_copy_from(&user_handle, common, CREATE_QP_USER_HANDLE) == -EFAULT)
+		return -EFAULT;
+
+	ret = qp_fill_attrs(&attr, ucontext, &cmd, create_flags);
+	if (ret)
+		return ret;
+
+	obj = (struct ib_uqp_object *)common->attrs[CREATE_QP_HANDLE].obj_attr.uobject;
+	obj->uxrcd = container_of(common->attrs[CREATE_QP_XRC_TGT_XRCD].obj_attr.uobject,
+				  struct ib_uxrcd_object, uobject);
+	attr.xrcd = obj->uxrcd->uobject.object;
+
+	qp_init_uqp(obj);
+	qp = ib_create_qp(NULL, &attr);
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
+	qp->uobject = &obj->uevent.uobject;
+	obj->uevent.uobject.object = qp;
+	obj->uevent.uobject.user_handle = user_handle;
+	atomic_inc(&obj->uxrcd->refcnt);
+
+	ret = qp_write_resp(&attr, qp, common);
+	if (ret) {
+		ib_destroy_qp(qp);
+		return ret;
+	}
+
+	return 0;
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_modify_qp_spec,
+	UVERBS_ATTR_IDR(MODIFY_QP_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_WRITE),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_STATE, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_CUR_STATE, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_EN_SQD_ASYNC_NOTIFY, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_ACCESS_FLAGS, u32),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PKEY_INDEX, u16),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PORT, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_QKEY, u32),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_AV, struct ib_uverbs_qp_dest),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PATH_MTU, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_TIMEOUT, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RETRY_CNT, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RNR_RETRY, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RQ_PSN, u32),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MAX_RD_ATOMIC, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_ALT_PATH, struct ib_uverbs_qp_alt_path),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MIN_RNR_TIMER, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_SQ_PSN, u32),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MAX_DEST_RD_ATOMIC, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PATH_MIG_STATE, u8),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_DEST_QPN, u32));
+
+int uverbs_modify_qp_handler(struct ib_device *ib_dev,
+			     struct ib_uverbs_file *file,
+			     struct uverbs_attr_array *ctx, size_t num)
+{
+	struct uverbs_attr_array *common = &ctx[0];
+	struct ib_udata            uhw;
+	struct ib_qp              *qp;
+	struct ib_qp_attr         *attr;
+	struct ib_uverbs_qp_dest  av;
+	struct ib_uverbs_qp_alt_path alt_path;
+	u32 attr_mask = 0;
+	int ret;
+
+	if (!uverbs_is_valid(common, MODIFY_QP_HANDLE))
+		return -EINVAL;
+
+	qp = common->attrs[MODIFY_QP_HANDLE].obj_attr.uobject->object;
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+#define MODIFY_QP_CPY(_param, _fld, _attr)				\
+	({								\
+		int ret = uverbs_copy_from(_fld, common, _param);	\
+		if (!ret)						\
+			attr_mask |= _attr;				\
+		ret == -EFAULT ? ret : 0;				\
+	})
+
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_STATE, &attr->qp_state,
+				   IB_QP_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_CUR_STATE, &attr->cur_qp_state,
+				   IB_QP_CUR_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_EN_SQD_ASYNC_NOTIFY,
+				   &attr->en_sqd_async_notify,
+				   IB_QP_EN_SQD_ASYNC_NOTIFY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_ACCESS_FLAGS,
+				   &attr->qp_access_flags, IB_QP_ACCESS_FLAGS);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PKEY_INDEX, &attr->pkey_index,
+				   IB_QP_PKEY_INDEX);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PORT, &attr->port_num, IB_QP_PORT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_QKEY, &attr->qkey, IB_QP_QKEY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PATH_MTU, &attr->path_mtu,
+				   IB_QP_PATH_MTU);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_TIMEOUT, &attr->timeout,
+				   IB_QP_TIMEOUT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RETRY_CNT, &attr->retry_cnt,
+				   IB_QP_RETRY_CNT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RNR_RETRY, &attr->rnr_retry,
+				   IB_QP_RNR_RETRY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RQ_PSN, &attr->rq_psn,
+				   IB_QP_RQ_PSN);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MAX_RD_ATOMIC,
+				   &attr->max_rd_atomic,
+				   IB_QP_MAX_QP_RD_ATOMIC);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MIN_RNR_TIMER,
+				   &attr->min_rnr_timer, IB_QP_MIN_RNR_TIMER);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_SQ_PSN, &attr->sq_psn,
+				   IB_QP_SQ_PSN);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MAX_DEST_RD_ATOMIC,
+				   &attr->max_dest_rd_atomic,
+				   IB_QP_MAX_DEST_RD_ATOMIC);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PATH_MIG_STATE,
+				   &attr->path_mig_state, IB_QP_PATH_MIG_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_DEST_QPN, &attr->dest_qp_num,
+				   IB_QP_DEST_QPN);
+
+	if (ret)
+		goto err;
+
+	ret = uverbs_copy_from(&av, common, MODIFY_QP_AV);
+	if (!ret) {
+		attr_mask |= IB_QP_AV;
+		memcpy(attr->ah_attr.grh.dgid.raw, av.dgid, 16);
+		attr->ah_attr.grh.flow_label        = av.flow_label;
+		attr->ah_attr.grh.sgid_index        = av.sgid_index;
+		attr->ah_attr.grh.hop_limit         = av.hop_limit;
+		attr->ah_attr.grh.traffic_class     = av.traffic_class;
+		attr->ah_attr.dlid		    = av.dlid;
+		attr->ah_attr.sl		    = av.sl;
+		attr->ah_attr.src_path_bits	    = av.src_path_bits;
+		attr->ah_attr.static_rate	    = av.static_rate;
+		attr->ah_attr.ah_flags		    = av.is_global ? IB_AH_GRH : 0;
+		attr->ah_attr.port_num		    = av.port_num;
+	} else if (ret == -EFAULT) {
+		goto err;
+	}
+
+	ret = uverbs_copy_from(&alt_path, common, MODIFY_QP_ALT_PATH);
+	if (!ret) {
+		attr_mask |= IB_QP_ALT_PATH;
+		memcpy(attr->alt_ah_attr.grh.dgid.raw, alt_path.dest.dgid, 16);
+		attr->alt_ah_attr.grh.flow_label    = alt_path.dest.flow_label;
+		attr->alt_ah_attr.grh.sgid_index    = alt_path.dest.sgid_index;
+		attr->alt_ah_attr.grh.hop_limit     = alt_path.dest.hop_limit;
+		attr->alt_ah_attr.grh.traffic_class = alt_path.dest.traffic_class;
+		attr->alt_ah_attr.dlid		    = alt_path.dest.dlid;
+		attr->alt_ah_attr.sl		    = alt_path.dest.sl;
+		attr->alt_ah_attr.src_path_bits     = alt_path.dest.src_path_bits;
+		attr->alt_ah_attr.static_rate       = alt_path.dest.static_rate;
+		attr->alt_ah_attr.ah_flags	    = alt_path.dest.is_global ? IB_AH_GRH : 0;
+		attr->alt_ah_attr.port_num	    = alt_path.dest.port_num;
+		attr->alt_pkey_index		    = alt_path.pkey_index;
+		attr->alt_port_num		    = alt_path.port_num;
+		attr->alt_timeout		    = alt_path.timeout;
+	} else if (ret == -EFAULT) {
+		goto err;
+	}
+
+	create_udata(ctx, num, &uhw);
+
+	if (qp->real_qp == qp) {
+		ret = ib_resolve_eth_dmac(qp, attr, &attr_mask);
+		if (ret)
+			goto err;
+		ret = qp->device->modify_qp(qp, attr,
+			modify_qp_mask(qp->qp_type, attr_mask), &uhw);
+	} else {
+		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, attr_mask));
+	}
+
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	kfree(attr);
+	return ret;
+}
+
 DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
 		    /* 1 is used in order to free the comp_channel after the CQs */
 		    &UVERBS_TYPE_ALLOC_FD(1, sizeof(struct ib_uobject) + sizeof(struct ib_uverbs_event_file),
 					  uverbs_free_event_file,
 					  &uverbs_event_fops,
 					  "[infinibandevent]", O_RDONLY),
-		    /* TODO: implement actions for comp channel */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_COMP_CHANNEL_CREATE,
+					  uverbs_create_comp_channel_handler,
+					  &uverbs_create_comp_channel_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_cq,
 		    /* 1 is used in order to free the MR after all the MWs */
 		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
 					      uverbs_free_cq),
-		    /* TODO: implement actions for cq */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_CQ_CREATE,
+					  uverbs_create_cq_handler,
+					  &uverbs_create_cq_spec,
+					  &uverbs_uhw_compat_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_qp,
 		    /* 1 is used in order to free the MR after all the MWs */
 		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
 					      uverbs_free_qp),
-		    /* TODO: implement actions for qp */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_QP_CREATE,
+					  uverbs_create_qp_handler,
+					  &uverbs_create_qp_spec,
+					  &uverbs_uhw_compat_spec),
+			ADD_UVERBS_ACTION(UVERBS_QP_CREATE_XRC_TGT,
+					  uverbs_create_qp_xrc_tgt_handler,
+					  &uverbs_create_qp_xrc_tgt_spec),
+			ADD_UVERBS_ACTION(UVERBS_QP_MODIFY,
+					  uverbs_modify_qp_handler,
+					  &uverbs_modify_qp_spec,
+					  &uverbs_uhw_compat_spec)),
+);
 
 DECLARE_UVERBS_TYPE(uverbs_type_mw,
 		    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mw),
@@ -182,8 +1007,13 @@ DECLARE_UVERBS_TYPE(uverbs_type_mw,
 DECLARE_UVERBS_TYPE(uverbs_type_mr,
 		    /* 1 is used in order to free the MR after all the MWs */
 		    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr),
-		    /* TODO: implement actions for mr */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_MR_REG, uverbs_reg_mr_handler,
+					  &uverbs_reg_mr_spec,
+					  &uverbs_uhw_compat_spec),
+			ADD_UVERBS_ACTION(UVERBS_MR_DEREG,
+					  uverbs_dereg_mr_handler,
+					  &uverbs_dereg_mr_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_srq,
 		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0,
@@ -221,12 +1051,22 @@ DECLARE_UVERBS_TYPE(uverbs_type_xrcd,
 DECLARE_UVERBS_TYPE(uverbs_type_pd,
 		    /* 2 is used in order to free the PD after all objects */
 		    &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd),
-		    /* TODO: implement actions for pd */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_ACTION(UVERBS_PD_ALLOC,
+					  uverbs_alloc_pd_handler,
+					  &uverbs_alloc_pd_spec,
+					  &uverbs_uhw_compat_spec)));
 
 DECLARE_UVERBS_TYPE(uverbs_type_device, NULL,
-		    /* TODO: implement actions for device */
-		    NULL);
+		    &UVERBS_ACTIONS(
+			ADD_UVERBS_CTX_ACTION(UVERBS_DEVICE_ALLOC_CONTEXT,
+					      uverbs_get_context,
+					      &uverbs_get_context_spec,
+					      &uverbs_uhw_compat_spec),
+			ADD_UVERBS_ACTION(UVERBS_DEVICE_QUERY,
+					  &uverbs_query_device_handler,
+					  &uverbs_query_device_spec,
+					  &uverbs_uhw_compat_spec)));
 
 DECLARE_UVERBS_TYPES(uverbs_common_types,
 		     ADD_UVERBS_TYPE(UVERBS_TYPE_DEVICE, uverbs_type_device),
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index 614e80c..dee76d70 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -35,6 +35,13 @@
 
 #include <rdma/uverbs_ioctl.h>
 
+#define IB_UVERBS_VENDOR_FLAG	0x8000
+
+enum {
+	UVERBS_UHW_IN,
+	UVERBS_UHW_OUT,
+};
+
 enum uverbs_common_types {
 	UVERBS_TYPE_DEVICE, /* Don't use IDRs here */
 	UVERBS_TYPE_PD,
@@ -52,6 +59,139 @@ enum uverbs_common_types {
 	UVERBS_TYPE_LAST,
 };
 
+enum uverbs_create_qp_cmd_attr {
+	CREATE_QP_HANDLE,
+	CREATE_QP_PD_HANDLE,
+	CREATE_QP_SEND_CQ,
+	CREATE_QP_RECV_CQ,
+	CREATE_QP_SRQ,
+	CREATE_QP_USER_HANDLE,
+	CREATE_QP_CMD,
+	CREATE_QP_CMD_FLAGS,
+	CREATE_QP_RESP
+};
+
+enum uverbs_create_cq_cmd_attr {
+	CREATE_CQ_HANDLE,
+	CREATE_CQ_CQE,
+	CREATE_CQ_USER_HANDLE,
+	CREATE_CQ_COMP_CHANNEL,
+	CREATE_CQ_COMP_VECTOR,
+	CREATE_CQ_FLAGS,
+	CREATE_CQ_RESP_CQE,
+};
+
+enum uverbs_create_qp_xrc_tgt_cmd_attr {
+	CREATE_QP_XRC_TGT_HANDLE,
+	CREATE_QP_XRC_TGT_XRCD,
+	CREATE_QP_XRC_TGT_USER_HANDLE,
+	CREATE_QP_XRC_TGT_CMD,
+	CREATE_QP_XRC_TGT_CMD_FLAGS,
+	CREATE_QP_XRC_TGT_RESP
+};
+
+enum uverbs_modify_qp_cmd_attr {
+	MODIFY_QP_HANDLE,
+	MODIFY_QP_STATE,
+	MODIFY_QP_CUR_STATE,
+	MODIFY_QP_EN_SQD_ASYNC_NOTIFY,
+	MODIFY_QP_ACCESS_FLAGS,
+	MODIFY_QP_PKEY_INDEX,
+	MODIFY_QP_PORT,
+	MODIFY_QP_QKEY,
+	MODIFY_QP_AV,
+	MODIFY_QP_PATH_MTU,
+	MODIFY_QP_TIMEOUT,
+	MODIFY_QP_RETRY_CNT,
+	MODIFY_QP_RNR_RETRY,
+	MODIFY_QP_RQ_PSN,
+	MODIFY_QP_MAX_RD_ATOMIC,
+	MODIFY_QP_ALT_PATH,
+	MODIFY_QP_MIN_RNR_TIMER,
+	MODIFY_QP_SQ_PSN,
+	MODIFY_QP_MAX_DEST_RD_ATOMIC,
+	MODIFY_QP_PATH_MIG_STATE,
+	MODIFY_QP_DEST_QPN
+};
+
+enum uverbs_create_comp_channel_cmd_attr {
+	CREATE_COMP_CHANNEL_FD,
+};
+
+enum uverbs_get_context {
+	GET_CONTEXT_RESP,
+};
+
+enum uverbs_query_device {
+	QUERY_DEVICE_RESP,
+	QUERY_DEVICE_ODP,
+	QUERY_DEVICE_TIMESTAMP_MASK,
+	QUERY_DEVICE_HCA_CORE_CLOCK,
+	QUERY_DEVICE_CAP_FLAGS,
+};
+
+enum uverbs_alloc_pd {
+	ALLOC_PD_HANDLE,
+};
+
+enum uverbs_reg_mr {
+	REG_MR_HANDLE,
+	REG_MR_PD_HANDLE,
+	REG_MR_CMD,
+	REG_MR_RESP
+};
+
+enum uverbs_dereg_mr {
+	DEREG_MR_HANDLE,
+};
+
+extern const struct uverbs_attr_spec_group uverbs_uhw_compat_spec;
+extern const struct uverbs_attr_spec_group uverbs_get_context_spec;
+extern const struct uverbs_attr_spec_group uverbs_query_device_spec;
+extern const struct uverbs_attr_spec_group uverbs_alloc_pd_spec;
+extern const struct uverbs_attr_spec_group uverbs_reg_mr_spec;
+extern const struct uverbs_attr_spec_group uverbs_dereg_mr_spec;
+
+enum uverbs_actions_mr_ops {
+	UVERBS_MR_REG,
+	UVERBS_MR_DEREG,
+};
+
+extern const struct uverbs_action_group uverbs_actions_mr;
+
+enum uverbs_actions_comp_channel_ops {
+	UVERBS_COMP_CHANNEL_CREATE,
+};
+
+extern const struct uverbs_action_group uverbs_actions_comp_channel;
+
+enum uverbs_actions_cq_ops {
+	UVERBS_CQ_CREATE,
+};
+
+extern const struct uverbs_action_group uverbs_actions_cq;
+
+enum uverbs_actions_qp_ops {
+	UVERBS_QP_CREATE,
+	UVERBS_QP_CREATE_XRC_TGT,
+	UVERBS_QP_MODIFY,
+};
+
+extern const struct uverbs_action_group uverbs_actions_qp;
+
+enum uverbs_actions_pd_ops {
+	UVERBS_PD_ALLOC
+};
+
+extern const struct uverbs_action_group uverbs_actions_pd;
+
+enum uverbs_actions_device_ops {
+	UVERBS_DEVICE_ALLOC_CONTEXT,
+	UVERBS_DEVICE_QUERY,
+};
+
+extern const struct uverbs_action_group uverbs_actions_device;
+
 extern const struct uverbs_type uverbs_type_cq;
 extern const struct uverbs_type uverbs_type_qp;
 extern const struct uverbs_type uverbs_type_rwq_ind_table;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 25225eb..0b06c4d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -317,12 +317,25 @@ struct ib_uverbs_reg_mr {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_ioctl_reg_mr {
+	__u64 start;
+	__u64 length;
+	__u64 hca_va;
+	__u32 access_flags;
+	__u32 reserved;
+};
+
 struct ib_uverbs_reg_mr_resp {
 	__u32 mr_handle;
 	__u32 lkey;
 	__u32 rkey;
 };
 
+struct ib_uverbs_ioctl_reg_mr_resp {
+	__u32 lkey;
+	__u32 rkey;
+};
+
 struct ib_uverbs_rereg_mr {
 	__u64 response;
 	__u32 mr_handle;
@@ -566,6 +579,16 @@ struct ib_uverbs_ex_create_qp {
 	__u32  reserved1;
 };
 
+struct ib_uverbs_ioctl_create_qp {
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+	__u8  sq_sig_all;
+	__u8  qp_type;
+};
+
 struct ib_uverbs_open_qp {
 	__u64 response;
 	__u64 user_handle;
@@ -588,6 +611,15 @@ struct ib_uverbs_create_qp_resp {
 	__u32 reserved;
 };
 
+struct ib_uverbs_ioctl_create_qp_resp {
+	__u32 qpn;
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+};
+
 struct ib_uverbs_ex_create_qp_resp {
 	struct ib_uverbs_create_qp_resp base;
 	__u32 comp_mask;
@@ -613,6 +645,13 @@ struct ib_uverbs_qp_dest {
 	__u8  port_num;
 };
 
+struct ib_uverbs_qp_alt_path {
+	struct ib_uverbs_qp_dest dest;
+	__u16 pkey_index;
+	__u8  port_num;
+	__u8  timeout;
+};
+
 struct ib_uverbs_query_qp {
 	__u64 response;
 	__u32 qp_handle;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
