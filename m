From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH v2 2/2] rdma/ucma: Integrate rdma cm into ioctl
 framework
Date: Wed, 15 Jun 2016 17:14:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB062523@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This provides an example of integrating the rdma cm into the
generic ioctl framework, along with porting the command used
to create an id.

A real solution would require porting all of the commands,
most of which would be straightforward.  The difficulty is
adopting the existing event interface to support events from
other name spaces.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c   |  124 ++++++++++++++++++++++++++++++--------
 include/uapi/rdma/rdma_ioctl.h   |    2 +
 include/uapi/rdma/rdma_user_cm.h |   15 ++++-
 3 files changed, 112 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b289ce0..340d35b 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -45,6 +45,7 @@
 #include <linux/nsproxy.h>
 
 #include <rdma/rdma_user_cm.h>
+#include <rdma/rdma_uapi.h>
 #include <rdma/ib_marshall.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/rdma_cm_ib.h>
@@ -208,6 +209,22 @@ error:
 	return NULL;
 }
 
+static struct ucma_context *ucma_alloc_ctx2(struct uda_obj *obj)
+{
+	struct ucma_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	INIT_WORK(&ctx->close_work, ucma_close_id);
+	atomic_set(&ctx->ref, 1);
+	init_completion(&ctx->comp);
+	INIT_LIST_HEAD(&ctx->mc_list);
+	obj->kcontext = ctx;
+	return ctx;
+}
+
 static struct ucma_multicast* ucma_alloc_multicast(struct ucma_context *ctx)
 {
 	struct ucma_multicast *mc;
@@ -429,9 +446,9 @@ done:
 	return ret;
 }
 
-static int ucma_get_qp_type(struct rdma_ucm_create_id *cmd, enum ib_qp_type *qp_type)
+static int ucma_get_qp_type(struct rdma_ucm_id_attr *attr, enum ib_qp_type *qp_type)
 {
-	switch (cmd->ps) {
+	switch (attr->ps) {
 	case RDMA_PS_TCP:
 		*qp_type = IB_QPT_RC;
 		return 0;
@@ -440,49 +457,44 @@ static int ucma_get_qp_type(struct rdma_ucm_create_id *cmd, enum ib_qp_type *qp_
 		*qp_type = IB_QPT_UD;
 		return 0;
 	case RDMA_PS_IB:
-		*qp_type = cmd->qp_type;
+		*qp_type = attr->qp_type;
 		return 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
-			      int in_len, int out_len)
+static long ucma_create_id(struct uda_ns *ns, void *data)
 {
-	struct rdma_ucm_create_id cmd;
-	struct rdma_ucm_create_id_resp resp;
+	struct rdma_ucm_id_attr *attr;
+	struct uda_iovec *resp;
 	struct ucma_context *ctx;
 	enum ib_qp_type qp_type;
+	struct uda_ioctl *ioctl = data;
+	struct uda_obj *obj;
 	int ret;
 
-	if (out_len < sizeof(resp))
-		return -ENOSPC;
-
-	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
-		return -EFAULT;
+	obj = ioctl->u.obj[0];
+	attr = UDA_ARG_DATA(ioctl, 0);
 
-	ret = ucma_get_qp_type(&cmd, &qp_type);
+	ret = ucma_get_qp_type(attr, &qp_type);
 	if (ret)
 		return ret;
 
-	mutex_lock(&file->mut);
-	ctx = ucma_alloc_ctx(file);
-	mutex_unlock(&file->mut);
+	ctx = ucma_alloc_ctx2(obj);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->uid = cmd.uid;
 	ctx->cm_id = rdma_create_id(current->nsproxy->net_ns,
-				    ucma_event_handler, ctx, cmd.ps, qp_type);
+				    ucma_event_handler, ctx, attr->ps, qp_type);
 	if (IS_ERR(ctx->cm_id)) {
 		ret = PTR_ERR(ctx->cm_id);
 		goto err1;
 	}
 
-	resp.id = ctx->id;
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp))) {
+	resp = UDA_ARG_DATA(ioctl, 1);
+	if (copy_to_user((void __user *)(unsigned long) resp->addr,
+			 &obj->instance_id, sizeof(obj->instance_id))) {
 		ret = -EFAULT;
 		goto err2;
 	}
@@ -491,9 +503,6 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 err2:
 	rdma_destroy_id(ctx->cm_id);
 err1:
-	mutex_lock(&file->mut);
-	idr_remove(&ctx_idr, ctx->id);
-	mutex_unlock(&file->mut);
 	kfree(ctx);
 	return ret;
 }
@@ -1539,10 +1548,65 @@ file_put:
 	return ret;
 }
 
+static long ucma_check_create_id(struct uda_ioctl *ioctl)
+{
+	long ret;
+
+	if (ioctl->flags || ioctl->obj_cnt || ioctl->arg_cnt != 3)
+		return -EINVAL;
+
+	ret = uda_check_arg(ioctl, 1, RDMA_UCM_ID_ATTR,
+			    sizeof(struct rdma_ucm_id_attr));
+	if (ret)
+		return ret;
+
+	ret = uda_check_arg(ioctl, 2, UDA_IOVEC,
+			    sizeof(struct uda_iovec));
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static uda_ioctl_handler_t ucma_check_ops[] = {
+	[RDMA_USER_CM_CMD_CREATE_ID] = ucma_check_create_id,
+};
+
+#define RDMA_UCM_DESC(_OP, _func, _flags)	\
+	[RDMA_USER_CM_CMD_ ## _OP] = {		\
+		.flags = _flags,		\
+		.func = _func,			\
+		.name = "RDMA_UCM_" #_OP	\
+	}
+
+static struct uda_ioctl_desc ucma_ops[] = {
+	RDMA_UCM_DESC(CREATE_ID, ucma_create_id, UDA_OPEN | UDA_EVENT),
+};
+
+static struct uda_ioctl_desc *ucma_get_desc(struct uda_ioctl *ioctl)
+{
+	u32 op;
+
+	op = ioctl->op - RDMA_UCM_BASE;
+	if (ucma_check_ops[op](ioctl))
+		return NULL;
+
+	return &ucma_ops[op];
+}
+
+static struct uda_ns ucma_ns = {
+	.idr = IDR_INIT(ucma_ns.idr),
+	.lock = __MUTEX_INITIALIZER(ucma_ns.lock),
+	.ioctl_base = RDMA_UCM_BASE,
+	.num_ioctls = 1,
+	.ioctl_desc = ucma_get_desc,
+	.name = "rdma cm"
+};
+
 static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 				   const char __user *inbuf,
 				   int in_len, int out_len) = {
-	[RDMA_USER_CM_CMD_CREATE_ID] 	 = ucma_create_id,
+	[RDMA_USER_CM_CMD_CREATE_ID] 	 = NULL,
 	[RDMA_USER_CM_CMD_DESTROY_ID]	 = ucma_destroy_id,
 	[RDMA_USER_CM_CMD_BIND_IP]	 = ucma_bind_ip,
 	[RDMA_USER_CM_CMD_RESOLVE_IP]	 = ucma_resolve_ip,
@@ -1686,6 +1750,7 @@ static const struct file_operations ucma_fops = {
 	.open 	 = ucma_open,
 	.release = ucma_close,
 	.write	 = ucma_write,
+	.unlocked_ioctl = uda_ioctl,
 	.poll    = ucma_poll,
 	.llseek	 = no_llseek,
 };
@@ -1720,13 +1785,19 @@ static int __init ucma_init(void)
 		goto err1;
 	}
 
+	ret = uda_add_ns(&ucma_ns);
+	if (ret)
+		goto err2;
+
 	ucma_ctl_table_hdr = register_net_sysctl(&init_net, "net/rdma_ucm", ucma_ctl_table);
 	if (!ucma_ctl_table_hdr) {
 		pr_err("rdma_ucm: couldn't register sysctl paths\n");
 		ret = -ENOMEM;
-		goto err2;
+		goto err3;
 	}
 	return 0;
+err3:
+	uda_remove_ns(&ucma_ns);
 err2:
 	device_remove_file(ucma_misc.this_device, &dev_attr_abi_version);
 err1:
@@ -1737,6 +1808,7 @@ err1:
 static void __exit ucma_cleanup(void)
 {
 	unregister_net_sysctl_table(ucma_ctl_table_hdr);
+	uda_remove_ns(&ucma_ns);
 	device_remove_file(ucma_misc.this_device, &dev_attr_abi_version);
 	misc_deregister(&ucma_misc);
 	idr_destroy(&ctx_idr);
diff --git a/include/uapi/rdma/rdma_ioctl.h b/include/uapi/rdma/rdma_ioctl.h
index 6839044..f422a03 100644
--- a/include/uapi/rdma/rdma_ioctl.h
+++ b/include/uapi/rdma/rdma_ioctl.h
@@ -106,6 +106,7 @@ struct uda_raw_ioctl {
 /* name spaces */
 enum {
 	UDA_NS_MGR,
+	RDMA_UCM,
 };
 
 #define UDA_NS_BASE(NS)		(NS * UDA_OP_RANGE)
@@ -126,6 +127,7 @@ enum {
 	UDA_OBJ_ID,
 	UDA_UCONTEXT,
 	UDA_NS_ATTR,
+	RDMA_UCM_ID_ATTR
 };
 
 struct uda_iovec {
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 3066718..75dbec6 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -38,8 +38,10 @@
 #include <linux/in6.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_user_sa.h>
+#include <rdma/rdma_ioctl.h>
 
-#define RDMA_USER_CM_ABI_VERSION	4
+#define RDMA_USER_CM_ABI_VERSION	5
+#define RDMA_UCM_BASE			UDA_NS_BASE(RDMA_UCM)
 
 #define RDMA_MAX_PRIVATE_DATA		256
 
@@ -66,7 +68,8 @@ enum {
 	RDMA_USER_CM_CMD_QUERY,
 	RDMA_USER_CM_CMD_BIND,
 	RDMA_USER_CM_CMD_RESOLVE_ADDR,
-	RDMA_USER_CM_CMD_JOIN_MCAST
+	RDMA_USER_CM_CMD_JOIN_MCAST,
+	RDMA_USER_CM_MAX_CMD
 };
 
 /*
@@ -82,8 +85,14 @@ struct rdma_ucm_create_id {
 	__u64 uid;
 	__u64 response;
 	__u16 ps;
+	__u8 qp_type;
+	__u8 resv[5];
+};
+
+struct rdma_ucm_id_attr {
+	__u16 ps;
 	__u8  qp_type;
-	__u8  reserved[5];
+	__u8  resv[5];
 };
 
 struct rdma_ucm_create_id_resp {
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
