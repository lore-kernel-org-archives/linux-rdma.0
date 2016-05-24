From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 5/8] IB/core: Add new ioctl for VERBS commands with netlink style parsing
Date: Tue, 24 May 2016 17:35:23 +0300
Message-ID: <1464100526-31730-6-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce a new RDMA IOCTL command. The VERBS ioctl command will
perform all validation and parsing supplied by IB CORE logic,
before serving the request.

The verbs ioctl is the base of all generic commands. A command starts
with a generic header:

struct ib_uverbs_uptr {
       __u64 ptr;
       __u32 len;
};

struct ib_uverbs_ioctl_hdr {
       __u32 length;
       __u16 flags;
       __u16 object_type;
       __u16 reserved;
       __u16 action;
       __u32 user_handler;
       /*
        * These fields represent core response only,
        * provider's response is given as a netlink attribute.
        */
       struct ib_uverbs_uptr resp;
};

This header declares the action and the object type. The first 8
actions on every object are reserved for common actions.

After the header, a stream of netlink attributes are given. These
attributes represent the command itself.

Every command validates its attributes using a generic way by:
1. Ensuring all attributes are known
2. Ensuring all attributes' sizes are correct
3. Ensuring all mandatory attributes exist

The actual uverbs implementation get an array of pointers to
netlink attributes represents the core command, a udata attribute
which the response will be written to (the response starts with a
header identical to netlink nested attribute header) and a udata
represents the vendor data.

Commands and responses are now extensible by nature, as new netlink
attributes could be added when required.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 247 +++++++++++++++++++++++++++++++++-
 include/rdma/ib_ioctl.h               |  11 ++
 include/uapi/rdma/ib_user_ioctl.h     |  61 +++++++++
 3 files changed, 318 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 68cf1fd..2f49eb7 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -850,9 +850,230 @@ out:
 	return ret;
 }
 
+struct mandatory_fields {
+	unsigned long *bitmap;
+};
+
+struct validate_op {
+	const struct nla_policy		*policy;
+	struct mandatory_fields		mandatory_fields;
+	size_t				resp_min_sz;
+};
+
+void ib_build_udata_from_nl(struct ib_udata *udata, struct nlattr **tb,
+			    uint16_t resp_type)
+{
+	struct ib_uverbs_uptr ucmd = {};
+	struct ib_uverbs_uptr uresp = {};
+	struct ib_uverbs_uptr *pucmd = &ucmd;
+	struct ib_uverbs_uptr *puresp = &uresp;
+
+	if (tb[IBNL_PROVIDER_CMD_UPTR])
+		pucmd = (struct ib_uverbs_uptr *)nla_data(tb[IBNL_PROVIDER_CMD_UPTR]);
+
+	if (tb[IBNL_PROVIDER_RESP_UPTR])
+		puresp = (struct ib_uverbs_uptr *)nla_data(tb[IBNL_PROVIDER_RESP_UPTR]);
+
+	INIT_UDATA_BUF_OR_NULL(udata, (const void __user *)pucmd->ptr,
+			       (void __user *)puresp->ptr, pucmd->len,
+			       puresp->len);
+}
+
+#define IBNL_VENDOR_POLICY_ATTRS					  \
+	[IBNL_PROVIDER_CMD_UPTR]	 = {.type = NLA_BINARY,		  \
+				    .len = sizeof(struct ib_uverbs_uptr)},\
+	[IBNL_PROVIDER_RESP_UPTR]	 = {.type = NLA_BINARY,		  \
+				    .len = sizeof(struct ib_uverbs_uptr)}
+struct object_action {
+	struct {
+		struct validate_op validator;
+		long (*fn)(struct ib_uverbs_file *filp,
+			   struct ib_device *ib_dev,
+			   struct ib_uverbs_ioctl_hdr *hdr,
+			   struct nlattr **tb, struct ib_udata *resp,
+			   struct ib_udata *uhw);
+		unsigned int max_attrs;
+	} create;
+	/* other ops */
+	struct {
+		struct validate_op validator;
+		long (*fn)(struct ib_uverbs_file *filp,
+			   struct ib_device *ib_dev,
+			   struct ib_uverbs_ioctl_hdr *hdr, uint32_t id,
+			   struct nlattr **tb, struct ib_udata *resp,
+			   struct ib_udata *uhw);
+		unsigned int max_attrs;
+	} ops[];
+};
+
+static const struct object_action object_actions[IB_OBJ_TYPE_MAX];
+
+struct nla_validator_cb_priv {
+	int maxtype;
+	unsigned long *fields;
+};
+
+static int ib_set_bit(const struct nlattr *nla, void *priv)
+{
+	struct nla_validator_cb_priv *validator =
+		(struct nla_validator_cb_priv *)priv;
+	u16 type = nla_type(nla);
+
+	if (type >= validator->maxtype)
+		return -EOPNOTSUPP;
+
+	set_bit(type, validator->fields);
+
+	return 0;
+};
+
+static int nla_strict_parse(struct nlattr **tb, int maxtype,
+			    const struct nlattr *head, int len,
+			    const struct validate_op *validate)
+{
+	int err = 0;
+	const struct nla_policy	*policy = validate->policy;
+	DECLARE_BITMAP(fields, maxtype);
+	struct nla_validator_cb_priv validate_priv = {.maxtype = maxtype,
+						      .fields = fields};
+
+	err = nla_validate(head, len, maxtype, policy);
+	if (err)
+		return err;
+
+	err = nla_parse_cb(tb, maxtype, head, len, policy, ib_set_bit,
+			   &validate_priv);
+	if (err) {
+		err = -EINVAL;
+		goto errout;
+	}
+
+	bitmap_and(fields, fields, validate->mandatory_fields.bitmap,
+		   IB_UVERBS_MAX_SUPPORTED_ATTRS);
+	if (!bitmap_equal(fields, validate->mandatory_fields.bitmap,
+			  IB_UVERBS_MAX_SUPPORTED_ATTRS)) {
+		err = -EINVAL;
+		goto errout;
+	}
+
+errout:
+	return err;
+}
+
+#define IB_UVERBS_MAX_CMD_SZ	4096
+
+static long ib_uverbs_cmd_verbs(struct file *filp,
+				struct ib_uverbs_ioctl_hdr *hdr,
+				void __user *buf)
+{
+	struct ib_uverbs_file *file = filp->private_data;
+	enum ib_uverbs_object_type obj_type = hdr->object_type;
+	void *cmd_buf = NULL;
+	struct nlattr **tb = NULL;
+	struct ib_device *ib_dev;
+	int srcu_key;
+	int err = 0;
+
+	if (obj_type >= IB_OBJ_TYPE_MAX)
+		return -EOPNOTSUPP;
+
+	cmd_buf = kmalloc(hdr->length, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOMEM;
+
+	if (copy_from_user(cmd_buf, buf, hdr->length - sizeof(*hdr))) {
+		pr_debug("copy_from_user failed while attempting to read uverbs command buffer: %p, %zd bytes\n",
+			 buf, hdr->length - sizeof(*hdr));
+		err = -EFAULT;
+		goto err1;
+	}
+
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	ib_dev = srcu_dereference(file->device->ib_dev,
+				  &file->device->disassociate_srcu);
+	if (!ib_dev) {
+		err = -EIO;
+		goto err;
+	}
+
+	/* TODO: handle flags, for example user specific object */
+
+	switch (hdr->action) {
+	case IBNL_OBJECT_CREATE: {
+		struct ib_udata uhw;
+		struct ib_udata uresp;
+		struct nlattr __user *nla_resp = NULL;
+
+		if (!object_actions[obj_type].create.fn) {
+			err = -EOPNOTSUPP;
+			goto err;
+		}
+
+		if (hdr->action || hdr->user_handler) {
+			pr_debug("invalid uverbs command. action=%d, user_handler=%d\n",
+				 hdr->action, hdr->user_handler);
+			err = -EINVAL;
+			goto err;
+		}
+
+		/* validate response */
+		if (hdr->resp.len < object_actions[obj_type].create.validator.resp_min_sz) {
+			err = -ENOSPC;
+			goto err;
+		}
+
+		tb = kcalloc(object_actions[obj_type].create.max_attrs + 1,
+			     sizeof(*tb), GFP_KERNEL);
+		if (!tb) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		err = nla_strict_parse(tb, object_actions[obj_type].create.max_attrs,
+				       (const struct nlattr *)cmd_buf,
+				       hdr->length - sizeof(*hdr),
+				       &object_actions[obj_type].create.validator);
+		if (err)
+			goto err;
+
+		ib_build_udata_from_nl(&uhw, tb,
+				       IBNL_RESPONSE_TYPE_VENDOR);
+
+		if (hdr->resp.len) {
+			INIT_UDATA_BUF_OR_NULL(&uresp, NULL,
+					       (void __user *)hdr->resp.ptr,
+					       0, hdr->resp.len);
+			nla_resp = ib_uverbs_nla_nest_start(&uresp,
+							    IBNL_RESPONSE_TYPE_RESP);
+			if (err)
+				goto err;
+		}
+
+		err = object_actions[obj_type].create.fn(file, ib_dev, hdr, tb,
+							 &uresp, &uhw);
+
+		if (nla_resp)
+			ib_uverbs_nla_nest_end(&uresp, nla_resp);
+		break;
+	}
+	default:
+		/* TODO: check object's specific actions */
+		return -ENOIOCTLCMD;
+	}
+err:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+err1:
+	kfree(cmd_buf);
+	kfree(tb);
+	return err;
+}
+
 static long ib_uverbs_ioctl(struct file *filp, unsigned int cmd,
 			    unsigned long arg)
 {
+	struct ib_uverbs_ioctl_hdr __user *user_hdr =
+		(struct ib_uverbs_ioctl_hdr __user *)arg;
+	struct ib_uverbs_ioctl_hdr hdr;
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_device *ib_dev;
 	int srcu_key;
@@ -878,7 +1099,31 @@ static long ib_uverbs_ioctl(struct file *filp, unsigned int cmd,
 		return ret;
 	}
 
-	return -ENOIOCTLCMD;
+	/*
+	 * Right now, we are supporting two possible calls
+	 * DIRECT	- go to driver, no parsing, no verification
+	 * VERBS	- pass verification, TLV parsing
+	 */
+	if (cmd != IB_IOCTL_VERBS)
+		return -ENOIOCTLCMD;
+
+	if (copy_from_user(&hdr, user_hdr, sizeof(hdr))) {
+		pr_debug("copy_from_user failed while attempting to read uverbs command header: %p. %zd bytes\n",
+			 user_hdr, sizeof(hdr));
+		return -EFAULT;
+	}
+
+	if (hdr.length > IB_UVERBS_MAX_CMD_SZ || hdr.length <= sizeof(hdr)) {
+		pr_debug("invalid uverbs ioctl command length %d\n", hdr.length);
+		return -EINVAL;
+	}
+
+	/* currently there are no flags supported */
+	if (hdr.flags || hdr.reserved)
+		return -EOPNOTSUPP;
+
+	return ib_uverbs_cmd_verbs(filp, &hdr,
+				   (__user void *)arg + sizeof(hdr));
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
diff --git a/include/rdma/ib_ioctl.h b/include/rdma/ib_ioctl.h
index 2d8db54..c1806ef 100644
--- a/include/rdma/ib_ioctl.h
+++ b/include/rdma/ib_ioctl.h
@@ -35,4 +35,15 @@
 
 #include <uapi/rdma/ib_user_ioctl.h>
 
+#define IB_UVERBS_MANDATORY_FIELDS(mandatory_bitmap)		\
+	{.bitmap = (unsigned long []){(mandatory_bitmap)} }
+
+#define IB_UVERBS_MAX_ATTRS(max_attr)				\
+	((max_attr) + IB_UVERBS_CHECK_MAX(max_attr) -		\
+		IB_UVERBS_CHECK_MAX(max_attr))
+
+#define IB_UVERBS_MAX_SUPPORTED_ATTRS	(BITS_PER_LONG)
+#define IB_UVERBS_CHECK_MAX(val) \
+	(sizeof(char[1 - 2 * !!((val) > IB_UVERBS_MAX_SUPPORTED_ATTRS)]))
+
 #endif /* IB_IOCTL_H */
diff --git a/include/uapi/rdma/ib_user_ioctl.h b/include/uapi/rdma/ib_user_ioctl.h
index f17e51a..3edb623 100644
--- a/include/uapi/rdma/ib_user_ioctl.h
+++ b/include/uapi/rdma/ib_user_ioctl.h
@@ -36,10 +36,71 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+struct ib_uverbs_uptr {
+	__u64 ptr;
+	__u32 len;
+};
+
+struct ib_uverbs_ioctl_hdr {
+	__u32 length;
+	__u16 flags;
+	__u16 object_type;
+	__u16 reserved;
+	__u16 action;
+	__u32 user_handler;
+	/*
+	 * These fields represent core response only,
+	 * provider's response is given as a netlink attribute.
+	 */
+	struct ib_uverbs_uptr resp;
+};
+
+enum ib_uverbs_object_type {
+	IB_OBJ_TYPE_OBJECT, /* query supported types */
+	IB_OBJ_TYPE_DEVICE,
+	IB_OBJ_TYPE_QP,
+	IB_OBJ_TYPE_CQ,
+	IB_OBJ_TYPE_PD,
+	IB_OBJ_TYPE_MR,
+	IB_OBJ_TYPE_MW,
+	IB_OBJ_TYPE_FLOW,
+	IB_OBJ_TYPE_MAX
+};
+
+enum ib_uverbs_object_type_flags {
+	/* vendor flag should go here */
+	IB_UVERBS_OBJECT_TYPE_FLAGS_MAX = 1 << 0,
+};
+
+enum ib_uverbs_common_actions {
+	IBNL_OBJECT_CREATE,
+	IBNL_OBJECT_DESTROY,
+	IBNL_OBJECT_QUERY,
+	IBNL_OBJECT_MODIFY,
+	IBNL_OBJECT_MAX = 8
+};
+
+/* Couldn't be extended! */
+enum ibnl_vendor_attrs {
+	IBNL_PROVIDER_CMD_UPTR,
+	IBNL_PROVIDER_RESP_UPTR,
+	IBNL_VENDOR_ATTRS_MAX
+};
+
+enum ib_uverbs_common_resp_types {
+	IBNL_RESPONSE_TYPE_RESP,
+	IBNL_RESPONSE_TYPE_VENDOR,
+	IBNL_RESPONSE_TYPE_MAX = 8
+};
+
 #define IB_IOCTL_MAGIC		0x1b
 
+#define IB_CMD_VERBS		0x1
 #define IB_CMD_DIRECT		0x2
 
+#define IB_IOCTL_VERBS \
+	_IOWR(IB_IOCTL_MAGIC, IB_CMD_VERBS, struct ib_uverbs_ioctl_hdr)
+
 #define IB_IOCTL_DIRECT \
 	_IOWR(IB_IOCTL_MAGIC, IB_CMD_DIRECT, unsigned long)
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
