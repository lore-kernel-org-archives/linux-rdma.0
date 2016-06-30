From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 8/8] RDMA/{hw, core}: Provide simple skeleton to IOCTL interface
Date: Thu, 30 Jun 2016 16:39:31 +0300
Message-ID: <1467293971-25688-9-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch presents simple skeleton to shared and hardware specific
code.

This code demonstrates how shared code specifications are written
(uverbs_create_qp_spec, uverbs_destroy_qp_spec and
uverbs_create_cq_spec), while the driver could choose implementing
a handler (which may call a common code function) or use a common
code function as handler directly (uverbs_destroy_qp_handler).

The driver declares an array of types UVERBS_TYPES. Each type could
be declared by pointer (UVERBS_TYPE) or directly inlined
(UVERBS_TYPE_ACTIONS).

A type is composed of actions (UVERBS_ACTION). Each action specifies
the handler and the chain of specifications used to validate the
action. This chain of specification could either be declared by
pointer or inlined (UVERBS_ATTR_CHAIN_SPEC).
Each such chain consists of attributes that could be either
PTR_IN, PTR_OUT, IDR_IN and maybe others in the future.
There's no need for IDR_OUT as it could just be written as ant other
esponse data.
Attributes states the type and length of their respected data. If an
attribute is an IDR attribute, the object type and required access
is also stated.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl_cmd.c |  40 ++++++++++
 drivers/infiniband/hw/ioctl-skel.c         | 119 +++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  35 +++++++++
 include/uapi/rdma/ib_user_verbs.h          |  19 +++++
 4 files changed, 213 insertions(+)
 create mode 100644 drivers/infiniband/hw/ioctl-skel.c

diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index d38b7ec..57e9d76 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -31,6 +31,7 @@
  */
 
 #include <rdma/uverbs_ioctl_cmd.h>
+#include <rdma/ib_user_verbs.h>
 #include <linux/bug.h>
 
 #define IB_UVERBS_VENDOR_FLAG	0x8000
@@ -55,3 +56,42 @@ int uverbs_action_std_handle(struct ib_device *ib_dev,
 
 	return priv->handler(ib_dev, ucontext, &ctx[0], &ctx[1], priv->priv);
 }
+
+DECLARE_UVERBS_ATTR_CHAIN_SPEC(
+	uverbs_create_qp_spec,
+	UVERBS_ATTR_PTR_IN(CREATE_QP_CMD, sizeof(struct rdma_ioctl_create_qp)),
+	UVERBS_ATTR_PTR_OUT(CREATE_QP_RESP, sizeof(struct ib_uverbs_create_qp_resp)),
+	UVERBS_ATTR_IDR_IN(CREATE_QP_QP, UVERBS_TYPE_QP,
+			   UVERBS_IDR_ACCESS_NEW),
+	UVERBS_ATTR_IDR_IN(CREATE_QP_PD, UVERBS_TYPE_PD,
+			   UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_IDR_IN(CREATE_QP_RECV_CQ, UVERBS_TYPE_CQ,
+			   UVERBS_IDR_ACCESS_READ),
+	UVERBS_ATTR_IDR_IN(CREATE_QP_SEND_CQ, UVERBS_TYPE_CQ,
+			   UVERBS_IDR_ACCESS_READ));
+
+DECLARE_UVERBS_ATTR_CHAIN_SPEC(
+	uverbs_destroy_qp_spec,
+	UVERBS_ATTR_PTR_OUT(DESTROY_QP_RESP, sizeof(struct ib_uverbs_destroy_qp_resp)),
+	UVERBS_ATTR_IDR_IN(DESTROY_QP_QP, UVERBS_TYPE_QP,
+			   UVERBS_IDR_ACCESS_DESTROY));
+
+DECLARE_UVERBS_ATTR_CHAIN_SPEC(
+	uverbs_create_cq_spec,
+	UVERBS_ATTR_PTR_IN(CREATE_CQ_CMD, sizeof(struct rdma_create_cq)),
+	UVERBS_ATTR_PTR_OUT(CREATE_CQ_RESP, sizeof(struct ib_uverbs_create_cq_resp)));
+
+
+int uverbs_destroy_qp_handler(struct ib_device *ib_dev,
+			      struct ib_ucontext *ucontext,
+			      struct uverbs_attr_array *common,
+			      struct uverbs_attr_array *vendor,
+			      void *priv)
+{
+	/*
+	 * Implementation:
+	 * 1. Serialize to kAPI
+	 * 2. Call ib_dev with @vendor as vendor specific data
+	 */
+	return 0;
+}
diff --git a/drivers/infiniband/hw/ioctl-skel.c b/drivers/infiniband/hw/ioctl-skel.c
new file mode 100644
index 0000000..4bb646e
--- /dev/null
+++ b/drivers/infiniband/hw/ioctl-skel.c
@@ -0,0 +1,119 @@
+/* Vendor demo */
+
+#include <rdma/uverbs_ioctl_cmd.h>
+
+/*
+ * Vendor could have its own object model as well
+ * enum {
+ *	MLX5_VENDOR_TYPE_OBJ
+ * };
+ */
+
+struct mlx5_ib_create_qp_vendor_cmd {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	sq_wqe_count;
+	__u32	rq_wqe_count;
+	__u32	rq_wqe_shift;
+	__u32	flags;
+	__u32	uidx;
+	__u32	reserved0;
+	__u64	sq_buf_addr;
+};
+
+struct mlx5_ib_create_qp_vendor_resp {
+	__u32	uuar_index;
+};
+
+struct mlx5_ib_create_cq_vendor_cmd {
+	__u64	buf_addr;
+	__u64	db_addr;
+	__u32	cqe_size;
+	__u32	reserved;
+};
+
+struct mlx5_ib_create_cq_vendor_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+/* Could be per vendor handler */
+static int create_qp_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv)
+{
+	/* Some smart things here */
+	return 0;
+}
+
+/* Could be per vendor handler */
+static int create_cq_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv)
+{
+	/* Some smart things here */
+	return 0;
+}
+
+enum mlx5_qp_commands {
+	MLX5_QP_COMMAND_CREATE,
+	MLX5_QP_COMMAND_DESTROY
+	/* TODO: Other commands */
+};
+
+enum mlx5_cq_commands {
+	MLX5_CQ_COMMAND_CREATE,
+};
+
+enum mlx5_qp_create {
+	MLX5_CREATE_QP_VENDOR_CMD = IB_UVERBS_VENDOR_FLAG,
+	MLX5_CREATE_QP_VENDOR_RESP,
+};
+
+DECLARE_UVERBS_TYPE(mlx5_ib_qp,
+	UVERBS_ACTION(
+		MLX5_QP_COMMAND_CREATE, create_qp_handler, NULL, &uverbs_create_qp_spec,
+		&UVERBS_ATTR_CHAIN_SPEC(
+			UVERBS_ATTR_PTR_IN(MLX5_CREATE_QP_VENDOR_CMD,
+					   sizeof(struct mlx5_ib_create_qp_vendor_cmd)),
+			UVERBS_ATTR_PTR_OUT(MLX5_CREATE_QP_VENDOR_RESP,
+					    sizeof(struct mlx5_ib_create_qp_vendor_resp)),
+			/*
+			 * User could have its own objects and IDRs
+			 * UVERBS_ATTR_IDR_IN(MLX_CREATE_QP_VENDOR_OBJ,
+			 *		   UVERBS_COMMON_TYPE_QP, 0)
+			 */
+			),
+	),
+	UVERBS_ACTION(MLX5_QP_COMMAND_DESTROY, uverbs_destroy_qp_handler, NULL,
+		      &uverbs_destroy_qp_spec),
+);
+
+enum mlx5_cq_create {
+	MLX5_CREATE_CQ_VENDOR_CMD = IB_UVERBS_VENDOR_FLAG,
+	MLX5_CREATE_CQ_VENDOR_RESP,
+};
+
+struct uverbs_types objects = UVERBS_TYPES(
+	/* Decalre types by pointer */
+	UVERBS_TYPE(UVERBS_TYPE_QP, mlx5_ib_qp),
+	/* Types could only declared in-lined */
+	UVERBS_TYPE_ACTIONS(
+		UVERBS_TYPE_CQ,
+		UVERBS_ACTION(
+			MLX5_CQ_COMMAND_CREATE, create_cq_handler, NULL,
+			&uverbs_create_cq_spec,
+			&UVERBS_ATTR_CHAIN_SPEC(
+				UVERBS_ATTR_PTR_IN(MLX5_CREATE_CQ_VENDOR_CMD,
+						   sizeof(struct mlx5_ib_create_cq_vendor_cmd)),
+				UVERBS_ATTR_PTR_OUT(MLX5_CREATE_QP_VENDOR_RESP,
+						    sizeof(struct mlx5_ib_create_cq_vendor_resp)),
+			),
+		),
+	)
+);
+
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index 07cf6fa..ffb4d80 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -49,5 +49,40 @@ struct uverbs_action_std_handler {
 		       void *priv);
 	void *priv;
 };
+
+enum uverbs_common_types {
+	UVERBS_TYPE_PD,
+	UVERBS_TYPE_CQ,
+	UVERBS_TYPE_QP,
+};
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
+extern const struct uverbs_attr_chain_spec uverbs_create_qp_spec;
+extern const struct uverbs_attr_chain_spec uverbs_destroy_qp_spec;
+extern const struct uverbs_attr_chain_spec uverbs_create_cq_spec;
+
+int uverbs_destroy_qp_handler(struct ib_device *ib_dev,
+			      struct ib_ucontext *ucontext,
+			      struct uverbs_attr_array *common,
+			      struct uverbs_attr_array *vendor,
+			      void *priv);
 #endif
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index b6543d7..c6b2ef0 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -368,6 +368,14 @@ struct ib_uverbs_ex_create_cq {
 	__u32 reserved;
 };
 
+struct rdma_create_cq {
+	__u64 user_handle;
+	__u32 cqe;
+	__u32 comp_vector;
+	__s32 comp_channel;
+	__u32 flags;
+};
+
 struct ib_uverbs_create_cq_resp {
 	__u32 cq_handle;
 	__u32 cqe;
@@ -518,6 +526,17 @@ struct ib_uverbs_create_qp {
 	__u64 driver_data[0];
 };
 
+struct rdma_ioctl_create_qp
+{
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+	__u8  sq_sig_all;
+	__u8  qp_type;
+};
+
 struct ib_uverbs_ex_create_qp {
 	__u64 user_handle;
 	__u32 pd_handle;
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
