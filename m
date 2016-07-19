From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V2 7/8] RDMA/core: Add common code for querying device and init context
Date: Tue, 19 Jul 2016 18:23:31 +0300
Message-ID: <1468941812-32286-8-git-send-email-matanb@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We add the common (core) code for init context and querying
device. This includes the following parts:
* Macros for defining commands and validators
* Creating a context command
    * handler
    * validator
* Querying a device
    * handler
    * validator

Drivers could use the these validators in their validator's chain
and use the handler directly in the action (or just wrap it in the
driver's custom code).

Currently we use ib_udata to pass vendor specific information to the
driver. This should probably be refactored in the future.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h           |   4 +
 drivers/infiniband/core/uverbs_cmd.c       |   7 +-
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 202 +++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl.h                |  79 +++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  51 ++++++++
 5 files changed, 339 insertions(+), 4 deletions(-)

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
index ea50c08..dc3990f 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -206,3 +206,205 @@ free:
 }
 EXPORT_SYMBOL(rdma_initialize_common_types);
 
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
+	if(vendor) {
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
+DECLARE_UVERBS_ATTR_CHAIN_SPEC(
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
+	ret = ib_uverbs_uobject_type_initialize_ucontext(ucontext,
+							 &ib_dev->type_list);
+	if (ret)
+		goto err_context;
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
+err_context:
+	ib_dev->dealloc_ucontext(ucontext);
+
+err:
+	mutex_unlock(&file->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(uverbs_get_context);
+
+DECLARE_UVERBS_ATTR_CHAIN_SPEC(
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
+
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 7733b11..fb6c864 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -106,6 +106,85 @@ struct uverbs_types {
 	const struct uverbs_type_actions	**types;
 };
 
+#define UVERBS_ATTR(_id, _len, _type)					\
+	[_id] = {.len = _len, .type = _type}
+#define UVERBS_ATTR_PTR_IN(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_IN)
+#define UVERBS_ATTR_PTR_OUT(_id, _len)					\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_OUT)
+#define UVERBS_ATTR_IDR_SZ_IN(_id, _idr_type, _access, _new_sz)		\
+	[_id] = {.type = UVERBS_ATTR_TYPE_IDR,				\
+		 .idr = {.idr_type = _idr_type,				\
+			 .access = _access,				\
+			 .new_size = _new_sz} }
+#define UVERBS_ATTR_IDR_IN(_id, _idr_type, _access)			\
+	UVERBS_ATTR_IDR_SZ_IN(_id, _idr_type, _access, sizeof(struct ib_uobject))
+#define UVERBS_ATTR_CHAIN_SPEC_SZ(...)					\
+	(sizeof((const struct uverbs_attr_spec[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_attr_spec))
+#define UVERBS_ATTR_CHAIN_SPEC(...)					\
+	(const struct uverbs_attr_chain_spec)				\
+	{.attrs = (struct uverbs_attr_spec[]){__VA_ARGS__},		\
+	 .num_attrs = UVERBS_ATTR_CHAIN_SPEC_SZ(__VA_ARGS__)}
+#define DECLARE_UVERBS_ATTR_CHAIN_SPEC(name, ...)			\
+	const struct uverbs_attr_chain_spec name =			\
+		UVERBS_ATTR_CHAIN_SPEC(__VA_ARGS__)
+#define UVERBS_ATTR_ACTION_SPEC_SZ(...)					  \
+	(sizeof((const struct uverbs_attr_chain_spec *[]){__VA_ARGS__}) / \
+				 sizeof(const struct uverbs_attr_chain_spec *))
+#define UVERBS_ATTR_ACTION_SPEC(_distfn, _priv, ...)			\
+	{.dist = _distfn,						\
+	 .priv = _priv,							\
+	 .num_chains =	UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),	\
+	 .validator_chains = (const struct uverbs_attr_chain_spec *[]){__VA_ARGS__} }
+#define UVERBS_STD_ACTION_SPEC(...)						\
+	UVERBS_ATTR_ACTION_SPEC(ib_uverbs_std_dist,				\
+				(void *)UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),\
+				__VA_ARGS__)
+#define UVERBS_STD_ACTION(_handler, _priv, ...)				\
+	{								\
+		.priv = &(struct uverbs_action_std_handler)		\
+			{.handler = _handler,				\
+			 .priv = _priv},				\
+		.handler = uverbs_action_std_handle,			\
+		.chain = UVERBS_STD_ACTION_SPEC(__VA_ARGS__)}
+#define UVERBS_STD_CTX_ACTION(_handler, _priv, ...)			\
+	{								\
+		.priv = &(struct uverbs_action_std_ctx_handler)		\
+			{.handler = _handler,				\
+			 .priv = _priv},				\
+		.handler = uverbs_action_std_ctx_handle,		\
+		.chain = UVERBS_STD_ACTION_SPEC(__VA_ARGS__)}
+#define UVERBS_ACTIONS_SZ(...)					\
+	(sizeof((const struct uverbs_action []){__VA_ARGS__}) /		\
+	 sizeof(const struct uverbs_action))
+#define UVERBS_ACTION(action_idx, _handler, _priv,  ...)		\
+	[action_idx] = UVERBS_STD_ACTION(_handler, _priv, __VA_ARGS__)
+#define UVERBS_CTX_ACTION(action_idx, _handler, _priv,  ...)		\
+	[action_idx] = UVERBS_STD_CTX_ACTION(_handler, _priv, __VA_ARGS__)
+#define UVERBS_ACTIONS(...)					\
+	((const struct uverbs_type_actions)				\
+	  {.num_actions = UVERBS_ACTIONS_SZ(__VA_ARGS__),		\
+	   .actions = (const struct uverbs_action[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_TYPE(name, ...)					\
+	const struct uverbs_type_actions name = UVERBS_ACTIONS(__VA_ARGS__)
+#define UVERBS_TYPES_SZ(...)						\
+	(sizeof((const struct uverbs_type_actions *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type_actions *))
+#define UVERBS_TYPE_ACTIONS(type_idx, ...)				\
+	[type_idx] = &UVERBS_ACTIONS(__VA_ARGS__)
+#define UVERBS_TYPE(type_idx, type_ptr)					\
+	[type_idx] = ((const struct uverbs_type_actions * const)&type_ptr)
+#define UVERBS_TYPES(...)						\
+	{.num_types = UVERBS_TYPES_SZ(__VA_ARGS__),			\
+	 .types = (const struct uverbs_type_actions *[]){__VA_ARGS__} }
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
index 18e652d..185fed6 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -79,5 +79,56 @@ enum uverbs_common_types {
 	UVERBS_TYPE_XRCD,
 };
 
+#define UVERBS_COMMON_TYPES						       \
+	(UVERBS_TYPE_PD | UVERBS_TYPE_CQ | UVERBS_TYPE_QP | UVERBS_TYPE_SRQ |  \
+	 UVERBS_TYPE_AH | UVERBS_TYPE_MR | UVERBS_TYPE_MW | UVERBS_TYPE_FLOW | \
+	 UVERBS_TYPE_XRCD)
+
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
+extern const struct uverbs_attr_chain_spec uverbs_get_context_spec;
+extern const struct uverbs_attr_chain_spec uverbs_query_device_spec;
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
 #endif
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
