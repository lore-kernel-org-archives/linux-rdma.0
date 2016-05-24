From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Tue, 24 May 2016 17:35:26 +0300
Message-ID: <1464100526-31730-9-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement get_context by using CREATE action on the DEVICE object.
Currently, the command not requires any mandatory attribute, but could
get an optional vendor command and response descriptors.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile        |   2 +-
 drivers/infiniband/core/uverbs.h        |   9 ++
 drivers/infiniband/core/uverbs_cmd_nl.c | 151 ++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c   |  27 +++++-
 include/uapi/rdma/ib_user_ioctl.h       |   5 ++
 5 files changed, 192 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/uverbs_cmd_nl.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 2d976e3f..c764fdb 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -35,4 +35,4 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
-				uverbs_nl.o uverbs_cmd_common.o
+				uverbs_nl.o uverbs_cmd_nl.o uverbs_cmd_common.o
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 1f121dc..c4d1a49 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -327,4 +327,13 @@ IB_UVERBS_DECLARE_EX_CMD(query_device);
 IB_UVERBS_DECLARE_EX_CMD(create_cq);
 IB_UVERBS_DECLARE_EX_CMD(create_qp);
 
+#define IB_UVERBS_DECLARE_CMD_NL_CREATE(name)				       \
+	ssize_t ib_uverbs_nl_##name(struct ib_uverbs_file *filp,	       \
+				    struct ib_device *ib_dev,		       \
+				    struct ib_uverbs_ioctl_hdr *hdr,	       \
+				    struct nlattr **tb, struct ib_udata *uresp,\
+				    struct ib_udata *uhw)
+
+IB_UVERBS_DECLARE_CMD_NL_CREATE(context_create);
+
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd_nl.c b/drivers/infiniband/core/uverbs_cmd_nl.c
new file mode 100644
index 0000000..d12c54b
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_cmd_nl.c
@@ -0,0 +1,151 @@
+/*
+ * Copyright (c) 2016 Mellanox Technologies, LTD. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <net/netlink.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <linux/uaccess.h>
+
+#include "uverbs.h"
+#include "core_priv.h"
+
+long ib_uverbs_nl_context_create(struct ib_uverbs_file *file,
+				 struct ib_device *ib_dev,
+				 struct ib_uverbs_ioctl_hdr *hdr,
+				 struct nlattr **tb, struct ib_udata *uresp,
+				 struct ib_udata *uhw)
+{
+	struct ib_uverbs_get_context_resp resp;
+	struct ib_ucontext		 *ucontext;
+	int ret;
+	struct file			 *filp;
+	struct nlattr __user *nla;
+
+	mutex_lock(&file->mutex);
+
+	if (file->ucontext) {
+		pr_debug("uverbs context create with already existing context\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ucontext = ib_dev->alloc_ucontext(ib_dev, uhw);
+	if (IS_ERR(ucontext)) {
+		ret = PTR_ERR(ucontext);
+		goto err;
+	}
+	if (uhw->outptr - uhw->outbuf) {
+		__u32 vendor_len = uhw->outptr - uhw->outbuf;
+
+		nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_VENDOR,
+					sizeof(vendor_len), &vendor_len);
+		if (IS_ERR(nla)) {
+			ret = PTR_ERR(nla);
+			goto err_ctx;
+		}
+	}
+
+	ucontext->device = ib_dev;
+	INIT_LIST_HEAD(&ucontext->pd_list);
+	INIT_LIST_HEAD(&ucontext->mr_list);
+	INIT_LIST_HEAD(&ucontext->mw_list);
+	INIT_LIST_HEAD(&ucontext->cq_list);
+	INIT_LIST_HEAD(&ucontext->qp_list);
+	INIT_LIST_HEAD(&ucontext->srq_list);
+	INIT_LIST_HEAD(&ucontext->ah_list);
+	INIT_LIST_HEAD(&ucontext->xrcd_list);
+	INIT_LIST_HEAD(&ucontext->rule_list);
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
+	nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_RESP,
+				sizeof(resp), &resp);
+	if (IS_ERR(nla)) {
+		ret = PTR_ERR(nla);
+		goto err_file;
+	}
+
+	file->ucontext = ucontext;
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
+err_ctx:
+	ib_dev->dealloc_ucontext(ucontext);
+
+err:
+	mutex_unlock(&file->mutex);
+	return ret;
+	return 0;
+};
+
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index f5dc276..10c2412 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -884,6 +884,15 @@ void ib_build_udata_from_nl(struct ib_udata *udata, struct nlattr **tb,
 				    .len = sizeof(struct ib_uverbs_uptr)},\
 	[IBNL_PROVIDER_RESP_UPTR]	 = {.type = NLA_BINARY,		  \
 				    .len = sizeof(struct ib_uverbs_uptr)}
+
+static const struct nla_policy ibnl_create_device_policy[] = {
+	IBNL_VENDOR_POLICY_ATTRS,
+      /*
+       * If there are other command attributes:
+       * [IBNL_CREATE_DEVICE_CORE]		 = {.type = NLA_BINARY, .len = sizeof(cmd)},
+       */
+};
+
 struct object_action {
 	struct {
 		struct validate_op validator;
@@ -906,7 +915,23 @@ struct object_action {
 	} ops[];
 };
 
-static const struct object_action object_actions[IB_OBJ_TYPE_MAX];
+static const struct object_action object_actions[IB_OBJ_TYPE_MAX] = {
+	[IB_OBJ_TYPE_DEVICE] = {
+		.create = {
+			.fn = ib_uverbs_nl_context_create,
+			.validator = {.policy = ibnl_create_device_policy,
+				      /*
+				       * TODO: Mandatory fields validator
+				       * .mandatory_fields =
+				       *	IB_UVERBS_MANDATORY_FIELDS(IBNL_CREATE_DEVICE_CORE),
+				       */
+
+					.resp_min_sz = sizeof(struct ib_uverbs_get_context_resp),
+				},
+			.max_attrs = IB_UVERBS_MAX_ATTRS(IBNL_CREATE_DEVICE_MAX),
+		}
+	}
+};
 
 struct nla_validator_cb_priv {
 	int maxtype;
diff --git a/include/uapi/rdma/ib_user_ioctl.h b/include/uapi/rdma/ib_user_ioctl.h
index 3edb623..9e3db1e 100644
--- a/include/uapi/rdma/ib_user_ioctl.h
+++ b/include/uapi/rdma/ib_user_ioctl.h
@@ -118,4 +118,9 @@ enum ib_uverbs_common_resp_types {
 #define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
 					      struct ib_user_mad_reg_req2)
 
+enum ibnl_create_device {
+	IBNL_CREATE_DEVICE_CORE = IBNL_VENDOR_ATTRS_MAX,
+	IBNL_CREATE_DEVICE_MAX
+};
+
 #endif /* IB_USER_IOCTL_H */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
