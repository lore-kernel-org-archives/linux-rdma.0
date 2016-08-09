From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V3 6/7] RDMA/core: Add uverbs types, actions, handlers and attributes
Date: Tue,  9 Aug 2016 19:39:34 +0300
Message-ID: <1470760775-6813-7-git-send-email-matanb@mellanox.com>
References: <1470760775-6813-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470760775-6813-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We add the common (core) code for init context, query device,
reg_mr and init_pd. This includes the following parts:
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
 drivers/infiniband/core/uverbs.h           |   4 +
 drivers/infiniband/core/uverbs_cmd.c       |   7 +-
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 382 +++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl.h                | 129 ++++++++++
 include/rdma/uverbs_ioctl_cmd.h            | 102 ++++++++
 include/uapi/rdma/ib_user_verbs.h          |  13 +
 6 files changed, 633 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b65a865..0e06a8e 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -195,6 +195,10 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
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
index 9648b80..e913dc0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -385,8 +385,7 @@ err:
 	return ret;
 }
 
-static void copy_query_dev_fields(struct ib_uverbs_file *file,
-				  struct ib_device *ib_dev,
+void uverbs_copy_query_dev_fields(struct ib_device *ib_dev,
 				  struct ib_uverbs_query_device_resp *resp,
 				  struct ib_device_attr *attr)
 {
@@ -447,7 +446,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, ib_dev, &resp, &ib_dev->attrs);
+	uverbs_copy_query_dev_fields(ib_dev, &resp, &ib_dev->attrs);
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -3623,7 +3622,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
+	uverbs_copy_query_dev_fields(ib_dev, &resp.base, &attr);
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
 		goto end;
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index af93569..aa6c3f5 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -167,3 +167,385 @@ void uverbs_free_pd(const struct uverbs_type_alloc_action *type_alloc_action,
 }
 EXPORT_SYMBOL(uverbs_free_pd);
 
+enum {
+	UVERBS_UHW_IN,
+	UVERBS_UHW_OUT,
+};
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_uhw_compat_spec,
+	UVERBS_ATTR_PTR_IN(UVERBS_UHW_IN, 0),
+	UVERBS_ATTR_PTR_OUT(UVERBS_UHW_OUT, 0));
+EXPORT_SYMBOL(uverbs_uhw_compat_spec);
+
+static void create_udata(struct uverbs_attr_array *vendor,
+			 struct ib_udata *udata)
+{
+	/*
+	 * This is for ease of conversion. The purpose is to convert all vendors
+	 * to use uverbs_attr_array instead of ib_udata.
+	 * Assume attr == 0 is input and attr == 1 is output.
+	 */
+	void * __user inbuf;
+	size_t inbuf_len = 0;
+	void * __user outbuf;
+	size_t outbuf_len = 0;
+
+	if (vendor) {
+		WARN_ON(vendor->num_attrs > 2);
+
+		if (vendor->attrs[0].valid) {
+			inbuf = vendor->attrs[0].cmd_attr.ptr;
+			inbuf_len = vendor->attrs[0].cmd_attr.len;
+		}
+
+		if (vendor->num_attrs == 2 && vendor->attrs[1].valid) {
+			outbuf = vendor->attrs[1].cmd_attr.ptr;
+			outbuf_len = vendor->attrs[1].cmd_attr.len;
+		}
+	}
+	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_get_context_spec,
+	UVERBS_ATTR_PTR_OUT(GET_CONTEXT_RESP,
+			    sizeof(struct ib_uverbs_get_context_resp)));
+EXPORT_SYMBOL(uverbs_get_context_spec);
+
+int uverbs_get_context(struct ib_device *ib_dev,
+		       struct ib_uverbs_file *file,
+		       struct uverbs_attr_array *common,
+		       struct uverbs_attr_array *vendor,
+		       void *priv)
+{
+	struct ib_udata uhw;
+	struct ib_uverbs_get_context_resp resp;
+	struct ib_ucontext		 *ucontext;
+	struct file			 *filp;
+	int ret;
+
+	if (!common->attrs[GET_CONTEXT_RESP].valid)
+		return -EINVAL;
+
+	/* Temporary, only until vendors get the new uverbs_attr_array */
+	create_udata(vendor, &uhw);
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
+	ib_uverbs_uobject_type_initialize_ucontext(ucontext);
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
+	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
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
+
+err:
+	mutex_unlock(&file->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(uverbs_get_context);
+DECLARE_UVERBS_CTX_ACTION(uverbs_action_get_context, uverbs_get_context, NULL,
+			  &uverbs_get_context_spec, &uverbs_uhw_compat_spec);
+EXPORT_SYMBOL(uverbs_action_get_context);
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_query_device_spec,
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_RESP, sizeof(struct ib_uverbs_query_device_resp)),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_ODP, sizeof(struct ib_uverbs_odp_caps)),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_TIMESTAMP_MASK, sizeof(__u64)),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_HCA_CORE_CLOCK, sizeof(__u64)),
+	UVERBS_ATTR_PTR_OUT(QUERY_DEVICE_CAP_FLAGS, sizeof(__u64)));
+EXPORT_SYMBOL(uverbs_query_device_spec);
+
+int uverbs_query_device_handler(struct ib_device *ib_dev,
+				struct ib_ucontext *ucontext,
+				struct uverbs_attr_array *common,
+				struct uverbs_attr_array *vendor,
+				void *priv)
+{
+	struct ib_device_attr attr = {};
+	struct ib_udata uhw;
+	int err;
+
+	/* Temporary, only until vendors get the new uverbs_attr_array */
+	create_udata(vendor, &uhw);
+
+	err = ib_dev->query_device(ib_dev, &attr, &uhw);
+	if (err)
+		return err;
+
+	if (common->attrs[QUERY_DEVICE_RESP].valid) {
+		struct ib_uverbs_query_device_resp resp = {};
+
+		uverbs_copy_query_dev_fields(ib_dev, &resp, &attr);
+		if (copy_to_user(common->attrs[QUERY_DEVICE_RESP].cmd_attr.ptr,
+				 &resp, sizeof(resp)))
+			return -EFAULT;
+	}
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (common->attrs[QUERY_DEVICE_ODP].valid) {
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
+	if (UVERBS_COPY_TO(common, QUERY_DEVICE_TIMESTAMP_MASK,
+			   &attr.timestamp_mask) == -EFAULT)
+		return -EFAULT;
+
+	if (UVERBS_COPY_TO(common, QUERY_DEVICE_HCA_CORE_CLOCK,
+			   &attr.hca_core_clock) == -EFAULT)
+		return -EFAULT;
+
+	if (UVERBS_COPY_TO(common, QUERY_DEVICE_CAP_FLAGS,
+			   &attr.device_cap_flags) == -EFAULT)
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(uverbs_query_device_handler);
+DECLARE_UVERBS_ACTION(uverbs_action_query_device, uverbs_query_device_handler, NULL,
+		      &uverbs_query_device_spec, &uverbs_uhw_compat_spec);
+EXPORT_SYMBOL(uverbs_action_query_device);
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_alloc_pd_spec,
+	UVERBS_ATTR_IDR(ALLOC_PD_HANDLE, UVERBS_TYPE_PD,
+			UVERBS_IDR_ACCESS_NEW));
+EXPORT_SYMBOL(uverbs_alloc_pd_spec);
+
+int uverbs_alloc_pd_handler(struct ib_device *ib_dev,
+			    struct ib_ucontext *ucontext,
+			    struct uverbs_attr_array *common,
+			    struct uverbs_attr_array *vendor,
+			    void *priv)
+{
+	struct ib_udata uhw;
+	struct ib_uobject *uobject;
+	struct ib_pd *pd;
+
+	if (!common->attrs[ALLOC_PD_HANDLE].valid)
+		return -EINVAL;
+
+	/* Temporary, only until vendors get the new uverbs_attr_array */
+	create_udata(vendor, &uhw);
+
+	pd = ib_dev->alloc_pd(ib_dev, ucontext, &uhw);
+	if (IS_ERR(pd))
+		return PTR_ERR(pd);
+
+	uobject = common->attrs[ALLOC_PD_HANDLE].obj_attr.uobject;
+	pd->device  = ib_dev;
+	pd->uobject = uobject;
+	uobject->object = pd;
+	pd->local_mr = NULL;
+	atomic_set(&pd->usecnt, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL(uverbs_alloc_pd_handler);
+DECLARE_UVERBS_ACTION(uverbs_action_alloc_pd, uverbs_alloc_pd_handler, NULL,
+		      &uverbs_alloc_pd_spec, &uverbs_uhw_compat_spec);
+EXPORT_SYMBOL(uverbs_action_alloc_pd);
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_reg_mr_spec,
+	UVERBS_ATTR_IDR(REG_MR_HANDLE, UVERBS_TYPE_MR, UVERBS_IDR_ACCESS_NEW),
+	UVERBS_ATTR_IDR(REG_MR_PD_HANDLE, UVERBS_TYPE_PD, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_PTR_IN(REG_MR_CMD, sizeof(struct ib_uverbs_ioctl_reg_mr)),
+	UVERBS_ATTR_PTR_OUT(REG_MR_RESP, sizeof(struct ib_uverbs_ioctl_reg_mr_resp)));
+EXPORT_SYMBOL(uverbs_reg_mr_spec);
+
+int uverbs_reg_mr_handler(struct ib_device *ib_dev,
+			  struct ib_ucontext *ucontext,
+			  struct uverbs_attr_array *common,
+			  struct uverbs_attr_array *vendor,
+			  void *priv)
+{
+	struct ib_uverbs_ioctl_reg_mr		cmd;
+	struct ib_uverbs_ioctl_reg_mr_resp	resp;
+	struct ib_udata uhw;
+	struct ib_uobject *uobject;
+	struct ib_pd                *pd;
+	struct ib_mr                *mr;
+	int                          ret;
+
+	if (!common->attrs[REG_MR_HANDLE].valid ||
+	    !common->attrs[REG_MR_PD_HANDLE].valid ||
+	    !common->attrs[REG_MR_CMD].valid ||
+	    !common->attrs[REG_MR_RESP].valid)
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, common->attrs[REG_MR_CMD].cmd_attr.ptr, sizeof(cmd)))
+		return -EFAULT;
+
+	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
+		return -EINVAL;
+
+	ret = ib_check_mr_access(cmd.access_flags);
+	if (ret)
+		return ret;
+
+	/* Temporary, only until vendors get the new uverbs_attr_array */
+	create_udata(vendor, &uhw);
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
+EXPORT_SYMBOL(uverbs_reg_mr_handler);
+
+DECLARE_UVERBS_ACTION(uverbs_action_reg_mr, uverbs_reg_mr_handler, NULL,
+		      &uverbs_reg_mr_spec, &uverbs_uhw_compat_spec);
+EXPORT_SYMBOL(uverbs_action_reg_mr);
+
+DECLARE_UVERBS_ACTIONS(
+	uverbs_actions_mr,
+	ADD_UVERBS_ACTION_PTR(UVERBS_MR_REG, &uverbs_action_reg_mr),
+);
+EXPORT_SYMBOL(uverbs_actions_mr);
+
+DECLARE_UVERBS_ACTIONS(
+	uverbs_actions_pd,
+	ADD_UVERBS_ACTION_PTR(UVERBS_PD_ALLOC, &uverbs_action_alloc_pd),
+);
+EXPORT_SYMBOL(uverbs_actions_pd);
+
+DECLARE_UVERBS_ACTIONS(
+	uverbs_actions_device,
+	ADD_UVERBS_ACTION_PTR(UVERBS_DEVICE_QUERY, &uverbs_action_query_device),
+	ADD_UVERBS_ACTION_PTR(UVERBS_DEVICE_ALLOC_CONTEXT, &uverbs_action_get_context),
+);
+EXPORT_SYMBOL(uverbs_actions_device);
+
+DECLARE_UVERBS_TYPE(uverbs_type_mr,
+		    /* 1 is used in order to free the MR after all the MWs */
+		    &UVERBS_TYPE_ALLOC(1, uverbs_free_mr),
+		    &uverbs_actions_mr);
+EXPORT_SYMBOL(uverbs_type_mr);
+
+DECLARE_UVERBS_TYPE(uverbs_type_pd,
+		    /* 2 is used in order to free the PD after all objects */
+		    &UVERBS_TYPE_ALLOC(2, uverbs_free_pd),
+		    &uverbs_actions_pd);
+EXPORT_SYMBOL(uverbs_type_pd);
+
+DECLARE_UVERBS_TYPE(uverbs_type_device, NULL, &uverbs_actions_device);
+EXPORT_SYMBOL(uverbs_type_device);
+
+DECLARE_UVERBS_TYPES(uverbs_types,
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_DEVICE, uverbs_type_device),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_PD, uverbs_type_pd),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_MR, uverbs_type_mr),
+);
+EXPORT_SYMBOL(uverbs_types);
+
+DECLARE_UVERBS_TYPES_GROUP(uverbs_types_group, &uverbs_types);
+EXPORT_SYMBOL(uverbs_types_group);
+
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index f2e207b..64d235f 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -133,6 +133,135 @@ struct uverbs_types_group {
 	void					*priv;
 };
 
+#define UVERBS_ATTR(_id, _len, _type)					\
+	[_id] = {.len = _len, .type = _type}
+#define UVERBS_ATTR_PTR_IN(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_IN)
+#define UVERBS_ATTR_PTR_OUT(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_OUT)
+#define UVERBS_ATTR_IDR_SZ(_id, _idr_type, _access, _new_sz)		\
+	[_id] = {.type = UVERBS_ATTR_TYPE_IDR,				\
+		 .idr = {.idr_type = _idr_type,				\
+			 .access = _access,				\
+			 .new_size = _new_sz} }
+#define UVERBS_ATTR_IDR(_id, _idr_type, _access)			\
+	UVERBS_ATTR_IDR_SZ(_id, _idr_type, _access, sizeof(struct ib_uobject))
+#define _UVERBS_ATTR_SPEC_SZ(...)					\
+	(sizeof((const struct uverbs_attr_spec[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_attr_spec))
+#define UVERBS_ATTR_SPEC(...)					\
+	((const struct uverbs_attr_group_spec)				\
+	 {.attrs = (struct uverbs_attr_spec[]){__VA_ARGS__},		\
+	  .num_attrs = _UVERBS_ATTR_SPEC_SZ(__VA_ARGS__)})
+#define DECLARE_UVERBS_ATTR_SPEC(name, ...)			\
+	const struct uverbs_attr_group_spec name =			\
+		UVERBS_ATTR_SPEC(__VA_ARGS__)
+#define _UVERBS_ATTR_ACTION_SPEC_SZ(...)				  \
+	(sizeof((const struct uverbs_attr_group_spec *[]){__VA_ARGS__}) / \
+	 sizeof(const struct uverbs_attr_group_spec *))
+#define _UVERBS_ATTR_ACTION_SPEC(_distfn, _priv, ...)			\
+	{.dist = _distfn,						\
+	 .priv = _priv,							\
+	 .num_groups =	_UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),	\
+	 .attr_groups = (const struct uverbs_attr_group_spec *[]){__VA_ARGS__} }
+#define UVERBS_ACTION_SPEC(...)						\
+	_UVERBS_ATTR_ACTION_SPEC(ib_uverbs_std_dist,				\
+				(void *)_UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),\
+				__VA_ARGS__)
+#define UVERBS_ACTION(_handler, _priv, ...)				\
+	((const struct uverbs_action) {					\
+		.priv = &(struct uverbs_action_std_handler)		\
+			{.handler = _handler,				\
+			 .priv = _priv},				\
+		.handler = uverbs_action_std_handle,			\
+		.spec = UVERBS_ACTION_SPEC(__VA_ARGS__)})
+#define UVERBS_CTX_ACTION(_handler, _priv, ...)			\
+	((const struct uverbs_action){					\
+		.priv = &(struct uverbs_action_std_ctx_handler)		\
+			{.handler = _handler,				\
+			 .priv = _priv},				\
+		.handler = uverbs_action_std_ctx_handle,		\
+		.spec = UVERBS_ACTION_SPEC(__VA_ARGS__)})
+#define _UVERBS_ACTIONS_SZ(...)					\
+	(sizeof((const struct uverbs_action *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_action *))
+#define ADD_UVERBS_ACTION(action_idx, _handler, _priv,  ...)		\
+	[action_idx] = &UVERBS_ACTION(_handler, _priv, __VA_ARGS__)
+#define DECLARE_UVERBS_ACTION(name, _handler, _priv, ...)		\
+	const struct uverbs_action name =				\
+		UVERBS_ACTION(_handler, _priv, __VA_ARGS__)
+#define ADD_UVERBS_CTX_ACTION(action_idx, _handler, _priv,  ...)		\
+	[action_idx] = &UVERBS_CTX_ACTION(_handler, _priv, __VA_ARGS__)
+#define DECLARE_UVERBS_CTX_ACTION(name, _handler, _priv, ...)	\
+	const struct uverbs_action name =				\
+		UVERBS_CTX_ACTION(_handler, _priv, __VA_ARGS__)
+#define ADD_UVERBS_ACTION_PTR(idx, ptr)					\
+	[idx] = ptr
+#define UVERBS_TYPE_ALLOC_ACTION(_order, _free_fn, _obj_size)		\
+	((const struct uverbs_type_alloc_action){.order = _order,	\
+						 .free_fn = _free_fn,	\
+						 .obj_size = _obj_size})
+#define UVERBS_ACTIONS(...)						\
+	((const struct uverbs_type_actions_group)			\
+	  {.num_actions = _UVERBS_ACTIONS_SZ(__VA_ARGS__),		\
+	   .actions = (const struct uverbs_action *[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_ACTIONS(name, ...)				\
+	const struct  uverbs_type_actions_group name =			\
+		UVERBS_ACTIONS(__VA_ARGS__)
+#define _UVERBS_ACTIONS_GROUP_SZ(...)					\
+	(sizeof((const struct uverbs_type_actions_group*[]){__VA_ARGS__}) / \
+	 sizeof(const struct uverbs_type_actions_group *))
+#define UVERBS_TYPE_ALLOC_SZ(_size, _order, _free_fn)			\
+	((const struct uverbs_type_alloc_action) {			\
+		.order = _order,					\
+		.obj_size = _size,					\
+		.free_fn = _free_fn})
+#define UVERBS_TYPE_ALLOC(_order, _free_fn)				\
+	 UVERBS_TYPE_ALLOC_SZ(sizeof(struct ib_uobject), _order, _free_fn)
+#define _DECLARE_UVERBS_TYPE(name, _alloc, _dist, _priv, ...)		\
+	const struct uverbs_type name = {				\
+		.alloc = _alloc,					\
+		.dist = _dist,						\
+		.priv = _priv,						\
+		.num_groups = _UVERBS_ACTIONS_GROUP_SZ(__VA_ARGS__),	\
+		.action_groups = (const struct uverbs_type_actions_group *[]){__VA_ARGS__} \
+	}
+#define DECLARE_UVERBS_TYPE(name, _alloc,  ...)			\
+	_DECLARE_UVERBS_TYPE(name, _alloc, ib_uverbs_std_dist, NULL, __VA_ARGS__)
+#define _UVERBS_TYPE_SZ(...)						\
+	(sizeof((const struct uverbs_type *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type *))
+#define ADD_UVERBS_TYPE_ACTIONS(type_idx, ...)				\
+	[type_idx] = &UVERBS_ACTIONS(__VA_ARGS__)
+#define ADD_UVERBS_TYPE(type_idx, type_ptr)				\
+	[type_idx] = ((const struct uverbs_type * const)&type_ptr)
+#define UVERBS_TYPES(...)  ((const struct uverbs_types)			\
+	{.num_types = _UVERBS_TYPE_SZ(__VA_ARGS__),			\
+	 .types = (const struct uverbs_type *[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_TYPES(name, ...)				\
+	const struct uverbs_types name = UVERBS_TYPES(__VA_ARGS__)
+
+#define _UVERBS_TYPES_SZ(...)						\
+	(sizeof((const struct uverbs_types *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_types *))
+
+#define UVERBS_TYPES_GROUP(_dist, _priv, ...)				\
+	((const struct uverbs_types_group){				\
+		.dist = _dist,						\
+		.priv = _priv,						\
+		.type_groups = (const struct uverbs_types *[]){__VA_ARGS__},	\
+		.num_groups = _UVERBS_TYPES_SZ(__VA_ARGS__)})
+#define _DECLARE_UVERBS_TYPES_GROUP(name, _dist, _priv, ...)		\
+	const struct uverbs_types_group name = UVERBS_TYPES_GROUP(_dist, _priv, __VA_ARGS__)
+#define DECLARE_UVERBS_TYPES_GROUP(name, ...)		\
+	_DECLARE_UVERBS_TYPES_GROUP(name, ib_uverbs_std_dist, NULL, __VA_ARGS__)
+
+#define UVERBS_COPY_TO(attr_array, idx, from)				\
+	((attr_array)->attrs[idx].valid ?				\
+	 (copy_to_user((attr_array)->attrs[idx].cmd_attr.ptr, (from),	\
+		       (attr_array)->attrs[idx].cmd_attr.len) ?		\
+	  -EFAULT : 0) : -ENOENT)
+
 /* =================================================
  *              Parsing infrastructure
  * =================================================
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index 083d805..11588d8 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -97,5 +97,107 @@ enum uverbs_common_types {
 	UVERBS_TYPE_LAST,
 };
 
+enum uverbs_create_qp_cmd_attr {
+	CREATE_QP_CMD,
+	CREATE_QP_RESP,
+	CREATE_QP_QP,
+	CREATE_QP_PD,
+	CREATE_QP_RECV_CQ,
+	CREATE_QP_SEND_CQ,
+};
+
+enum uverbs_destroy_qp_cmd_attr {
+	DESTROY_QP_RESP,
+	DESTROY_QP_QP,
+};
+
+enum uverbs_create_cq_cmd_attr {
+	CREATE_CQ_CMD,
+	CREATE_CQ_RESP,
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
+extern const struct uverbs_attr_group_spec uverbs_uhw_compat_spec;
+extern const struct uverbs_attr_group_spec uverbs_get_context_spec;
+extern const struct uverbs_attr_group_spec uverbs_query_device_spec;
+extern const struct uverbs_attr_group_spec uverbs_alloc_pd_spec;
+extern const struct uverbs_attr_group_spec uverbs_reg_mr_spec;
+
+int uverbs_get_context(struct ib_device *ib_dev,
+		       struct ib_uverbs_file *file,
+		       struct uverbs_attr_array *common,
+		       struct uverbs_attr_array *vendor,
+		       void *priv);
+
+int uverbs_query_device_handler(struct ib_device *ib_dev,
+				struct ib_ucontext *ucontext,
+				struct uverbs_attr_array *common,
+				struct uverbs_attr_array *vendor,
+				void *priv);
+
+int uverbs_alloc_pd_handler(struct ib_device *ib_dev,
+			    struct ib_ucontext *ucontext,
+			    struct uverbs_attr_array *common,
+			    struct uverbs_attr_array *vendor,
+			    void *priv);
+
+int uverbs_reg_mr_handler(struct ib_device *ib_dev,
+			  struct ib_ucontext *ucontext,
+			  struct uverbs_attr_array *common,
+			  struct uverbs_attr_array *vendor,
+			  void *priv);
+
+extern const struct uverbs_action uverbs_action_get_context;
+extern const struct uverbs_action uverbs_action_query_device;
+extern const struct uverbs_action uverbs_action_alloc_pd;
+extern const struct uverbs_action uverbs_action_reg_mr;
+
+enum uverbs_actions_mr_ops {
+	UVERBS_MR_REG
+};
+
+extern const struct uverbs_type_actions_group uverbs_actions_mr;
+
+enum uverbs_actions_pd_ops {
+	UVERBS_PD_ALLOC
+};
+
+extern const struct uverbs_type_actions_group uverbs_actions_pd;
+
+enum uverbs_actions_device_ops {
+	UVERBS_DEVICE_ALLOC_CONTEXT,
+	UVERBS_DEVICE_QUERY,
+};
+
+extern const struct uverbs_type_actions_group uverbs_actions_device;
+
+extern const struct uverbs_type uverbs_type_mr;
+extern const struct uverbs_type uverbs_type_pd;
+extern const struct uverbs_type uverbs_type_device;
+
+extern const struct uverbs_types uverbs_common_types;
+extern const struct uverbs_types_group uverbs_types_group;
 #endif
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b6543d7..8650ac6 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -298,12 +298,25 @@ struct ib_uverbs_reg_mr {
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
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
