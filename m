From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V5 09/10] IB/core: Add create_qp command to the new ABI
Date: Thu, 27 Oct 2016 17:43:17 +0300
Message-ID: <1477579398-6875-10-git-send-email-matanb@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477579398-6875-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since crating a XRC_TGT QP requires a different set of attributes,
we introduce a different command in order to create such a QP.
XRC_TGT QP creation command isn't tested at all.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 235 +++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  43 ++++++
 include/uapi/rdma/ib_user_verbs.h          |  19 +++
 3 files changed, 297 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index 623e02e..e0c1af9 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -696,6 +696,227 @@ DECLARE_UVERBS_ACTION(uverbs_action_create_cq, uverbs_create_cq_handler, NULL,
 		      &uverbs_create_cq_spec, &uverbs_uhw_compat_spec);
 EXPORT_SYMBOL(uverbs_action_create_cq);
 
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
+	return UVERBS_COPY_TO(common, CREATE_QP_RESP, &resp);
+}
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_qp_spec,
+	UVERBS_ATTR_IDR(CREATE_QP_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_NEW),
+	UVERBS_ATTR_IDR(CREATE_QP_PD_HANDLE, UVERBS_TYPE_PD, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_IDR(CREATE_QP_SEND_CQ, UVERBS_TYPE_CQ, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_IDR(CREATE_QP_RECV_CQ, UVERBS_TYPE_CQ, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_IDR(CREATE_QP_SRQ, UVERBS_TYPE_SRQ, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_USER_HANDLE, sizeof(__u64)),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_CMD, sizeof(struct ib_uverbs_ioctl_create_qp)),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_CMD_FLAGS, sizeof(__u32)),
+	UVERBS_ATTR_PTR_OUT(CREATE_QP_RESP, sizeof(struct ib_uverbs_ioctl_create_qp_resp)));
+EXPORT_SYMBOL(uverbs_create_qp_spec);
+
+int uverbs_create_qp_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv)
+{
+	struct ib_uqp_object           *obj;
+	struct ib_udata uhw;
+	int ret;
+	__u64 user_handle = 0;
+	__u32 create_flags = 0;
+	struct ib_uverbs_ioctl_create_qp cmd;
+	struct ib_qp_init_attr attr = {};
+	struct ib_qp                   *qp;
+	struct ib_pd			*pd;
+
+	if (!common->attrs[CREATE_QP_HANDLE].valid ||
+	    !common->attrs[CREATE_QP_PD_HANDLE].valid ||
+	    !common->attrs[CREATE_QP_SEND_CQ].valid ||
+	    !common->attrs[CREATE_QP_RECV_CQ].valid ||
+	    !common->attrs[CREATE_QP_RESP].valid)
+		return -EINVAL;
+
+	ret = UVERBS_COPY_FROM(&cmd, common, CREATE_QP_CMD);
+	if (ret)
+		return ret;
+
+	/* Optional params */
+	if (UVERBS_COPY_FROM(&create_flags, common, CREATE_QP_CMD_FLAGS) == -EFAULT ||
+	    UVERBS_COPY_FROM(&user_handle, common, CREATE_QP_USER_HANDLE) == -EFAULT)
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
+	if (common->attrs[CREATE_QP_SRQ].valid)
+		attr.srq = common->attrs[CREATE_QP_SRQ].obj_attr.uobject->object;
+	obj = (struct ib_uqp_object *)common->attrs[CREATE_QP_HANDLE].obj_attr.uobject;
+
+	if (attr.srq && attr.srq->srq_type != IB_SRQT_BASIC)
+		return -EINVAL;
+
+	qp_init_uqp(obj);
+	create_udata(vendor, &uhw);
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
+EXPORT_SYMBOL(uverbs_create_qp_handler);
+
+DECLARE_UVERBS_ACTION(uverbs_action_create_qp, uverbs_create_qp_handler, NULL,
+		      &uverbs_create_qp_spec, &uverbs_uhw_compat_spec);
+EXPORT_SYMBOL(uverbs_action_create_qp);
+
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_create_qp_xrc_tgt_spec,
+	UVERBS_ATTR_IDR(CREATE_QP_XRC_TGT_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_NEW),
+	UVERBS_ATTR_IDR(CREATE_QP_XRC_TGT_XRCD, UVERBS_TYPE_XRCD, UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_USER_HANDLE, sizeof(__u64)),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_CMD, sizeof(struct ib_uverbs_ioctl_create_qp)),
+	UVERBS_ATTR_PTR_IN(CREATE_QP_XRC_TGT_CMD_FLAGS, sizeof(__u32)),
+	UVERBS_ATTR_PTR_OUT(CREATE_QP_XRC_TGT_RESP, sizeof(struct ib_uverbs_ioctl_create_qp_resp)));
+EXPORT_SYMBOL(uverbs_create_qp_xrc_tgt_spec);
+
+int uverbs_create_qp_xrc_tgt_handler(struct ib_device *ib_dev,
+				     struct ib_ucontext *ucontext,
+				     struct uverbs_attr_array *common,
+				     struct uverbs_attr_array *vendor,
+				     void *priv)
+{
+	struct ib_uqp_object           *obj;
+	int ret;
+	__u64 user_handle = 0;
+	__u32 create_flags = 0;
+	struct ib_uverbs_ioctl_create_qp cmd;
+	struct ib_qp_init_attr attr = {};
+	struct ib_qp                   *qp;
+
+	if (!common->attrs[CREATE_QP_XRC_TGT_HANDLE].valid ||
+	    !common->attrs[CREATE_QP_XRC_TGT_XRCD].valid ||
+	    !common->attrs[CREATE_QP_XRC_TGT_RESP].valid)
+		return -EINVAL;
+
+	ret = UVERBS_COPY_FROM(&cmd, common, CREATE_QP_XRC_TGT_CMD);
+	if (ret)
+		return ret;
+
+	/* Optional params */
+	if (UVERBS_COPY_FROM(&create_flags, common, CREATE_QP_CMD_FLAGS) == -EFAULT ||
+	    UVERBS_COPY_FROM(&user_handle, common, CREATE_QP_USER_HANDLE) == -EFAULT)
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
+EXPORT_SYMBOL(uverbs_create_qp_xrc_tgt_handler);
+
+DECLARE_UVERBS_ACTION(uverbs_action_create_qp_xrc_tgt, uverbs_create_qp_xrc_tgt_handler,
+		      NULL, &uverbs_create_qp_spec);
+EXPORT_SYMBOL(uverbs_action_create_qp_xrc_tgt);
+
 DECLARE_UVERBS_ACTIONS(
 	uverbs_actions_comp_channel,
 	ADD_UVERBS_ACTION_PTR(UVERBS_COMP_CHANNEL_CREATE, &uverbs_action_create_comp_channel),
@@ -709,6 +930,13 @@ DECLARE_UVERBS_ACTIONS(
 EXPORT_SYMBOL(uverbs_actions_cq);
 
 DECLARE_UVERBS_ACTIONS(
+	uverbs_actions_qp,
+	ADD_UVERBS_ACTION_PTR(UVERBS_QP_CREATE, &uverbs_action_create_qp),
+	ADD_UVERBS_ACTION_PTR(UVERBS_QP_CREATE_XRC_TGT, &uverbs_action_create_qp_xrc_tgt),
+);
+EXPORT_SYMBOL(uverbs_actions_qp);
+
+DECLARE_UVERBS_ACTIONS(
 	uverbs_actions_mr,
 	ADD_UVERBS_ACTION_PTR(UVERBS_MR_REG, &uverbs_action_reg_mr),
 	ADD_UVERBS_ACTION_PTR(UVERBS_MR_DEREG, &uverbs_action_dereg_mr),
@@ -744,6 +972,13 @@ DECLARE_UVERBS_TYPE(uverbs_type_cq,
 		    &uverbs_actions_cq);
 EXPORT_SYMBOL(uverbs_type_cq);
 
+DECLARE_UVERBS_TYPE(uverbs_type_qp,
+		    /* 1 is used in order to free the MR after all the MWs */
+		    &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
+					      uverbs_free_qp),
+		    &uverbs_actions_qp);
+EXPORT_SYMBOL(uverbs_type_qp);
+
 DECLARE_UVERBS_TYPE(uverbs_type_mr,
 		    /* 1 is used in order to free the MR after all the MWs */
 		    &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr),
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index 7a2d8f1..ca82138 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -113,6 +113,18 @@ enum uverbs_common_types {
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
 enum uverbs_create_cq_cmd_attr {
 	CREATE_CQ_HANDLE,
 	CREATE_CQ_CQE,
@@ -123,6 +135,15 @@ enum uverbs_create_cq_cmd_attr {
 	CREATE_CQ_RESP_CQE,
 };
 
+enum uverbs_create_qp_xrc_tgt_cmd_attr {
+	CREATE_QP_XRC_TGT_HANDLE,
+	CREATE_QP_XRC_TGT_XRCD,
+	CREATE_QP_XRC_TGT_USER_HANDLE,
+	CREATE_QP_XRC_TGT_CMD,
+	CREATE_QP_XRC_TGT_CMD_FLAGS,
+	CREATE_QP_XRC_TGT_RESP
+};
+
 enum uverbs_create_comp_channel_cmd_attr {
 	CREATE_COMP_CHANNEL_FD,
 };
@@ -203,6 +224,18 @@ int uverbs_create_cq_handler(struct ib_device *ib_dev,
 			     struct uverbs_attr_array *vendor,
 			     void *priv);
 
+int uverbs_create_qp_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv);
+
+int uverbs_create_qp_xrc_tgt_handler(struct ib_device *ib_dev,
+				     struct ib_ucontext *ucontext,
+				     struct uverbs_attr_array *common,
+				     struct uverbs_attr_array *vendor,
+				     void *priv);
+
 extern const struct uverbs_action uverbs_action_get_context;
 extern const struct uverbs_action uverbs_action_create_cq;
 extern const struct uverbs_action uverbs_action_create_comp_channel;
@@ -210,6 +243,8 @@ extern const struct uverbs_action uverbs_action_query_device;
 extern const struct uverbs_action uverbs_action_alloc_pd;
 extern const struct uverbs_action uverbs_action_reg_mr;
 extern const struct uverbs_action uverbs_action_dereg_mr;
+extern const struct uverbs_action uverbs_action_create_qp;
+extern const struct uverbs_action uverbs_action_create_qp_xrc_tgt;
 
 enum uverbs_actions_mr_ops {
 	UVERBS_MR_REG,
@@ -230,6 +265,13 @@ enum uverbs_actions_cq_ops {
 
 extern const struct uverbs_type_actions_group uverbs_actions_cq;
 
+enum uverbs_actions_qp_ops {
+	UVERBS_QP_CREATE,
+	UVERBS_QP_CREATE_XRC_TGT,
+};
+
+extern const struct uverbs_type_actions_group uverbs_actions_qp;
+
 enum uverbs_actions_pd_ops {
 	UVERBS_PD_ALLOC
 };
@@ -244,6 +286,7 @@ enum uverbs_actions_device_ops {
 extern const struct uverbs_type_actions_group uverbs_actions_device;
 
 extern const struct uverbs_type uverbs_type_cq;
+extern const struct uverbs_type uverbs_type_qp;
 extern const struct uverbs_type uverbs_type_comp_channel;
 extern const struct uverbs_type uverbs_type_mr;
 extern const struct uverbs_type uverbs_type_pd;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0e9821b..14aff5f 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -579,6 +579,16 @@ struct ib_uverbs_ex_create_qp {
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
@@ -601,6 +611,15 @@ struct ib_uverbs_create_qp_resp {
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
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
