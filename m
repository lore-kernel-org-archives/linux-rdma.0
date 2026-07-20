Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE76424D5E
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553751; cv=none; b=CrO8SSx//3LVOdwRJsiuhUVLqCG6iBtTv+5N/o7fX9+mu0c6SWj3cJxW0dJRvrz8LF6Fjf8PgfJSepD4xv8ao0Hww3WW2Bu8jfBsUcvqg+E82xU3YaVgS3vKK4BcYKvea19W5jgdQPCqVuUQDuAQsoqEXhYJ4wXA8e1k9W4Zc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553751; c=relaxed/simple;
	bh=4sSuqCf7KRxMhHvN8rlqF7eFwlIU4oPoT8e+Relmgg8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgDGRIn5t9xAGuQtz5HT3Rljl1N1ssvsGzQ8jJzjQj9kQ1vJT0PkMsuTPWg/4CRYp75Qm2DBIC94MXFdAY8idcBqR6uC3rQ77tmkBAoYSJ14eM5li5YJoVc4NVW+V7wxTkT4I9uwBH/U/DwORi60/LGRpB32O5zt5ucDS+KDIXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=GqX890rV; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="GqX890rV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784553749; x=1816089749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nQh8+Oj3M4E4SOimLpiwqIaIrXpo29lscYN+nBVp/Yo=;
  b=GqX890rV2re/oHznvJ19rUa2hcLYtCkUZUxeOPGtTSmQRUR/JQ9HhVUO
   R+K11Lum/MgPZRwT//PIZPFX5e8uEa/YYLWi/RwaG27WiWFRk0jd1+ghQ
   JhBk9TBaLrXU18fzRYfqq/AzU2Tp9+vcEgYtMReX9zGyJxUZ9I0wJzBQ9
   7ZI1aR8yAMaFRzHuFH5bzE2N09M2keTF3dWoY/1objIqg5OnSg/zsid64
   g/5dvXjjKW493rbz4AkZ4uPQlR7OevYbGc4gxjY14WeqkKe/sP5jWWy2G
   QRKb+Yv8j1TB+qpIxfZZy45l17cdtXVMghyO9gF5S7MuGMNwR/GGGeUdF
   w==;
X-CSE-ConnectionGUID: 94f0/wC2SEqjg5Tzt9tv7w==
X-CSE-MsgGUID: 5xaa4wJFRnu/1//7x8sRjw==
X-IronPort-AV: E=Sophos;i="6.25,174,1779148800"; 
   d="scan'208";a="23977705"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 13:22:26 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:30346]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.115:2525] with esmtp (Farcaster)
 id 28d71173-793c-439f-ae7c-8f45e4bc0cea; Mon, 20 Jul 2026 13:22:26 +0000 (UTC)
X-Farcaster-Flow-ID: 28d71173-793c-439f-ae7c-8f45e4bc0cea
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 20 Jul 2026 13:22:26 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Mon, 20 Jul 2026
 13:22:24 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v10 1/6] RDMA/core: Add Completion Counters support
Date: Mon, 20 Jul 2026 13:22:16 +0000
Message-ID: <20260720132221.2551-2-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132221.2551-1-mrgolin@amazon.com>
References: <20260720132221.2551-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWA001.ant.amazon.com (10.13.139.110) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add core infrastructure for Completion Counters, a light-weight
alternative to polling CQ for tracking operation completions.

Define the UVERBS_OBJECT_COMP_CNTR ioctl object with create, destroy,
modify and read methods for both success and error counters. Add a QP
attach method on the QP object to associate a completion counter with a
queue pair.

Add ib_comp_cntr struct, ib_comp_cntr_attach_attr, device ops, and
DECLARE_RDMA_OBJ_SIZE for driver object allocation.

Only userspace Completion Counters are supported at this stage.

Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/core/Makefile              |   1 +
 drivers/infiniband/core/device.c              |   6 +
 drivers/infiniband/core/rdma_core.h           |   1 +
 .../core/uverbs_std_types_comp_cntr.c         | 159 ++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_qp.c |  51 +++++-
 drivers/infiniband/core/uverbs_uapi.c         |   1 +
 include/rdma/ib_verbs.h                       |  37 ++++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  36 ++++
 include/uapi/rdma/ib_user_ioctl_verbs.h       |  19 +++
 9 files changed, 310 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/uverbs_std_types_comp_cntr.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index ab7a2197bc86..47ef6b0afd29 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -38,6 +38,7 @@ ib_umad-y :=			user_mad.o
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
 				uverbs_std_types.o uverbs_ioctl.o \
 				uverbs_std_types_cq.o \
+				uverbs_std_types_comp_cntr.o \
 				uverbs_std_types_dmabuf.o \
 				uverbs_std_types_dmah.o \
 				uverbs_std_types_flow_action.o uverbs_std_types_dm.o \
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b8193e077a74..a4c57279f19d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2742,6 +2742,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, create_ah);
 	SET_DEVICE_OP(dev_ops, create_counters);
 	SET_DEVICE_OP(dev_ops, create_cq);
+	SET_DEVICE_OP(dev_ops, create_comp_cntr);
 	SET_DEVICE_OP(dev_ops, create_user_cq);
 	SET_DEVICE_OP(dev_ops, create_flow);
 	SET_DEVICE_OP(dev_ops, create_qp);
@@ -2762,6 +2763,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, destroy_ah);
 	SET_DEVICE_OP(dev_ops, destroy_counters);
 	SET_DEVICE_OP(dev_ops, destroy_cq);
+	SET_DEVICE_OP(dev_ops, destroy_comp_cntr);
 	SET_DEVICE_OP(dev_ops, destroy_flow);
 	SET_DEVICE_OP(dev_ops, destroy_flow_action);
 	SET_DEVICE_OP(dev_ops, destroy_qp);
@@ -2813,6 +2815,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, modify_hw_stat);
 	SET_DEVICE_OP(dev_ops, modify_port);
 	SET_DEVICE_OP(dev_ops, modify_qp);
+	SET_DEVICE_OP(dev_ops, qp_attach_comp_cntr);
 	SET_DEVICE_OP(dev_ops, modify_srq);
 	SET_DEVICE_OP(dev_ops, modify_wq);
 	SET_DEVICE_OP(dev_ops, peek_cq);
@@ -2836,12 +2839,14 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, query_ucontext);
 	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
 	SET_DEVICE_OP(dev_ops, read_counters);
+	SET_DEVICE_OP(dev_ops, read_comp_cntr);
 	SET_DEVICE_OP(dev_ops, reg_dm_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr_dmabuf);
 	SET_DEVICE_OP(dev_ops, req_notify_cq);
 	SET_DEVICE_OP(dev_ops, rereg_user_mr);
 	SET_DEVICE_OP(dev_ops, resize_user_cq);
+	SET_DEVICE_OP(dev_ops, modify_comp_cntr);
 	SET_DEVICE_OP(dev_ops, set_vf_guid);
 	SET_DEVICE_OP(dev_ops, set_vf_link_state);
 	SET_DEVICE_OP(dev_ops, ufile_hw_cleanup);
@@ -2850,6 +2855,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_OBJ_SIZE(dev_ops, ib_ah);
 	SET_OBJ_SIZE(dev_ops, ib_counters);
 	SET_OBJ_SIZE(dev_ops, ib_cq);
+	SET_OBJ_SIZE(dev_ops, ib_comp_cntr);
 	SET_OBJ_SIZE(dev_ops, ib_dmah);
 	SET_OBJ_SIZE(dev_ops, ib_mw);
 	SET_OBJ_SIZE(dev_ops, ib_pd);
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 56121103e9f4..2b91e8527287 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -159,6 +159,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile);
 
 extern const struct uapi_definition uverbs_def_obj_async_fd[];
 extern const struct uapi_definition uverbs_def_obj_counters[];
+extern const struct uapi_definition uverbs_def_obj_comp_cntr[];
 extern const struct uapi_definition uverbs_def_obj_cq[];
 extern const struct uapi_definition uverbs_def_obj_device[];
 extern const struct uapi_definition uverbs_def_obj_dm[];
diff --git a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
new file mode 100644
index 000000000000..7db3feace2a9
--- /dev/null
+++ b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+
+#include <rdma/uverbs_std_types.h>
+#include "rdma_core.h"
+#include "uverbs.h"
+
+static int uverbs_free_comp_cntr(struct ib_uobject *uobject, enum rdma_remove_reason why,
+				 struct uverbs_attr_bundle *attrs)
+{
+	struct ib_comp_cntr *cc = uobject->object;
+	int ret;
+
+	ret = cc->device->ops.destroy_comp_cntr(cc);
+	if (ret)
+		return ret;
+
+	kfree(cc);
+	return 0;
+}
+
+static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_CREATE)(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
+							  UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
+	struct ib_device *ib_dev = attrs->context->device;
+	struct ib_comp_cntr *cc;
+	int ret;
+
+	if (!ib_dev->ops.create_comp_cntr ||
+	    !ib_dev->ops.destroy_comp_cntr ||
+	    !ib_dev->ops.qp_attach_comp_cntr)
+		return -EOPNOTSUPP;
+
+	cc = rdma_zalloc_drv_obj(ib_dev, ib_comp_cntr);
+	if (!cc)
+		return -ENOMEM;
+
+	cc->device = ib_dev;
+	cc->uobject = uobj;
+
+	ret = ib_dev->ops.create_comp_cntr(cc, attrs);
+	if (ret)
+		goto err_free;
+
+	uobj->object = cc;
+	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
+	return 0;
+
+err_free:
+	kfree(cc);
+	return ret;
+}
+
+static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_MODIFY)(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_comp_cntr *cc = uverbs_attr_get_obj(attrs, UVERBS_ATTR_MODIFY_COMP_CNTR_HANDLE);
+	enum ib_comp_cntr_modify_op op;
+	enum ib_comp_cntr_entry entry;
+	u64 value;
+	int ret;
+
+	if (!cc->device->ops.modify_comp_cntr)
+		return -EOPNOTSUPP;
+
+	ret = uverbs_get_const(&entry, attrs, UVERBS_ATTR_MODIFY_COMP_CNTR_ENTRY);
+	if (ret)
+		return ret;
+
+	ret = uverbs_get_const(&op, attrs, UVERBS_ATTR_MODIFY_COMP_CNTR_OP);
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_from(&value, attrs, UVERBS_ATTR_MODIFY_COMP_CNTR_VALUE);
+	if (ret)
+		return ret;
+
+	return cc->device->ops.modify_comp_cntr(cc, entry, op, value);
+}
+
+static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_READ)(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_comp_cntr *cc = uverbs_attr_get_obj(attrs, UVERBS_ATTR_READ_COMP_CNTR_HANDLE);
+	enum ib_comp_cntr_entry entry;
+	u64 value = 0;
+	int ret;
+
+	if (!cc->device->ops.read_comp_cntr)
+		return -EOPNOTSUPP;
+
+	ret = uverbs_get_const(&entry, attrs, UVERBS_ATTR_READ_COMP_CNTR_ENTRY);
+	if (ret)
+		return ret;
+
+	ret = cc->device->ops.read_comp_cntr(cc, entry, &value);
+	if (ret)
+		return ret;
+
+	return uverbs_copy_to(attrs, UVERBS_ATTR_READ_COMP_CNTR_RESP_VALUE, &value, sizeof(value));
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_COMP_CNTR_CREATE,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE,
+			UVERBS_OBJECT_COMP_CNTR,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	UVERBS_METHOD_COMP_CNTR_DESTROY,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_DESTROY_COMP_CNTR_HANDLE,
+			UVERBS_OBJECT_COMP_CNTR,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_COMP_CNTR_MODIFY,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_MODIFY_COMP_CNTR_HANDLE,
+			UVERBS_OBJECT_COMP_CNTR,
+			UVERBS_ACCESS_WRITE,
+			UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(UVERBS_ATTR_MODIFY_COMP_CNTR_ENTRY,
+			     enum ib_uverbs_comp_cntr_entry,
+			     UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(UVERBS_ATTR_MODIFY_COMP_CNTR_OP,
+			     enum ib_uverbs_comp_cntr_modify_op,
+			     UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_MODIFY_COMP_CNTR_VALUE,
+			   UVERBS_ATTR_TYPE(u64),
+			   UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_COMP_CNTR_READ,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_READ_COMP_CNTR_HANDLE,
+			UVERBS_OBJECT_COMP_CNTR,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY),
+	UVERBS_ATTR_CONST_IN(UVERBS_ATTR_READ_COMP_CNTR_ENTRY,
+			     enum ib_uverbs_comp_cntr_entry,
+			     UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_READ_COMP_CNTR_RESP_VALUE,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(
+	UVERBS_OBJECT_COMP_CNTR,
+	UVERBS_TYPE_ALLOC_IDR(uverbs_free_comp_cntr),
+	&UVERBS_METHOD(UVERBS_METHOD_COMP_CNTR_CREATE),
+	&UVERBS_METHOD(UVERBS_METHOD_COMP_CNTR_DESTROY),
+	&UVERBS_METHOD(UVERBS_METHOD_COMP_CNTR_MODIFY),
+	&UVERBS_METHOD(UVERBS_METHOD_COMP_CNTR_READ));
+
+const struct uapi_definition uverbs_def_obj_comp_cntr[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_COMP_CNTR,
+				      UAPI_DEF_OBJ_NEEDS_FN(destroy_comp_cntr)),
+	{}
+};
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 5767607dd420..1a32a902bdba 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -372,11 +372,60 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UVERBS_ATTR_TYPE(struct ib_uverbs_destroy_qp_resp),
 			    UA_MANDATORY));
 
+static int UVERBS_HANDLER(UVERBS_METHOD_QP_ATTACH_COMP_CNTR)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *qp_uobj = uverbs_attr_get_uobject(
+		attrs, UVERBS_ATTR_QP_ATTACH_COMP_CNTR_HANDLE);
+	struct ib_comp_cntr *cc = uverbs_attr_get_obj(
+		attrs, UVERBS_ATTR_QP_ATTACH_COMP_CNTR_CNTR_HANDLE);
+	struct ib_qp_attach_comp_cntr_attr attr = {};
+	struct ib_qp *qp = qp_uobj->object;
+	int ret;
+
+	if (!cc->device->ops.qp_attach_comp_cntr)
+		return -EOPNOTSUPP;
+
+	if (qp->real_qp != qp)
+		return -EINVAL;
+
+	ret = uverbs_get_flags32(&attr.op_mask, attrs,
+				 UVERBS_ATTR_QP_ATTACH_COMP_CNTR_OP_MASK,
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_SEND |
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RECV |
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_READ |
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_READ |
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_WRITE |
+				 IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE);
+	if (ret)
+		return ret;
+
+	if (!attr.op_mask)
+		return -EINVAL;
+
+	return qp->device->ops.qp_attach_comp_cntr(qp, cc, &attr);
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_QP_ATTACH_COMP_CNTR,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_ATTACH_COMP_CNTR_HANDLE,
+			UVERBS_OBJECT_QP,
+			UVERBS_ACCESS_WRITE,
+			UA_MANDATORY),
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_ATTACH_COMP_CNTR_CNTR_HANDLE,
+			UVERBS_OBJECT_COMP_CNTR,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY),
+	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_QP_ATTACH_COMP_CNTR_OP_MASK,
+			     enum ib_uverbs_qp_attach_comp_cntr_op,
+			     UA_MANDATORY));
+
 DECLARE_UVERBS_NAMED_OBJECT(
 	UVERBS_OBJECT_QP,
 	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), uverbs_free_qp),
 	&UVERBS_METHOD(UVERBS_METHOD_QP_CREATE),
-	&UVERBS_METHOD(UVERBS_METHOD_QP_DESTROY));
+	&UVERBS_METHOD(UVERBS_METHOD_QP_DESTROY),
+	&UVERBS_METHOD(UVERBS_METHOD_QP_ATTACH_COMP_CNTR));
 
 const struct uapi_definition uverbs_def_obj_qp[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_QP,
diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index 4e2e556c8119..d150099b99d2 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -628,6 +628,7 @@ void uverbs_destroy_api(struct uverbs_api *uapi)
 static const struct uapi_definition uverbs_core_api[] = {
 	UAPI_DEF_CHAIN(uverbs_def_obj_async_fd),
 	UAPI_DEF_CHAIN(uverbs_def_obj_counters),
+	UAPI_DEF_CHAIN(uverbs_def_obj_comp_cntr),
 	UAPI_DEF_CHAIN(uverbs_def_obj_cq),
 	UAPI_DEF_CHAIN(uverbs_def_obj_device),
 	UAPI_DEF_CHAIN(uverbs_def_obj_dm),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d82d303b723..9a952750f068 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1746,6 +1746,34 @@ struct ib_cq {
 	struct rdma_restrack_entry res;
 };
 
+enum ib_qp_attach_comp_cntr_op {
+	IB_QP_ATTACH_COMP_CNTR_OP_SEND = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_SEND,
+	IB_QP_ATTACH_COMP_CNTR_OP_RECV = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RECV,
+	IB_QP_ATTACH_COMP_CNTR_OP_RDMA_READ = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_READ,
+	IB_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_READ = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_READ,
+	IB_QP_ATTACH_COMP_CNTR_OP_RDMA_WRITE = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_WRITE,
+	IB_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE,
+};
+
+struct ib_comp_cntr {
+	struct ib_device *device;
+	struct ib_uobject *uobject;
+};
+
+enum ib_comp_cntr_entry {
+	IB_COMP_CNTR_ENTRY_COMP = IB_UVERBS_COMP_CNTR_ENTRY_COMP,
+	IB_COMP_CNTR_ENTRY_ERR = IB_UVERBS_COMP_CNTR_ENTRY_ERR,
+};
+
+enum ib_comp_cntr_modify_op {
+	IB_COMP_CNTR_MODIFY_OP_SET = IB_UVERBS_COMP_CNTR_MODIFY_OP_SET,
+	IB_COMP_CNTR_MODIFY_OP_INC = IB_UVERBS_COMP_CNTR_MODIFY_OP_INC,
+};
+
+struct ib_qp_attach_comp_cntr_attr {
+	u32 op_mask; /* Bitmask of enum ib_qp_attach_comp_cntr_op */
+};
+
 struct ib_srq {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
@@ -2629,6 +2657,8 @@ struct ib_device_ops {
 			 struct ib_udata *udata);
 	int (*modify_qp)(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 			 int qp_attr_mask, struct ib_udata *udata);
+	int (*qp_attach_comp_cntr)(struct ib_qp *qp, struct ib_comp_cntr *cc,
+				   struct ib_qp_attach_comp_cntr_attr *attr);
 	int (*query_qp)(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 			int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
 	int (*destroy_qp)(struct ib_qp *qp, struct ib_udata *udata);
@@ -2650,6 +2680,12 @@ struct ib_device_ops {
 	 * post_destroy_cq - Free all kernel resources
 	 */
 	void (*post_destroy_cq)(struct ib_cq *cq);
+	int (*create_comp_cntr)(struct ib_comp_cntr *cc,
+				struct uverbs_attr_bundle *attrs);
+	int (*destroy_comp_cntr)(struct ib_comp_cntr *cc);
+	int (*modify_comp_cntr)(struct ib_comp_cntr *cc, enum ib_comp_cntr_entry entry,
+				enum ib_comp_cntr_modify_op op, u64 value);
+	int (*read_comp_cntr)(struct ib_comp_cntr *cc, enum ib_comp_cntr_entry entry, u64 *value);
 	struct ib_mr *(*get_dma_mr)(struct ib_pd *pd, int mr_access_flags);
 	struct ib_mr *(*reg_user_mr)(struct ib_pd *pd, u64 start, u64 length,
 				     u64 virt_addr, int mr_access_flags,
@@ -2883,6 +2919,7 @@ struct ib_device_ops {
 	DECLARE_RDMA_OBJ_SIZE(ib_ah);
 	DECLARE_RDMA_OBJ_SIZE(ib_counters);
 	DECLARE_RDMA_OBJ_SIZE(ib_cq);
+	DECLARE_RDMA_OBJ_SIZE(ib_comp_cntr);
 	DECLARE_RDMA_OBJ_SIZE(ib_dmah);
 	DECLARE_RDMA_OBJ_SIZE(ib_mw);
 	DECLARE_RDMA_OBJ_SIZE(ib_pd);
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 839835bd4b23..19a94b91987e 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -57,6 +57,7 @@ enum uverbs_default_objects {
 	UVERBS_OBJECT_ASYNC_EVENT,
 	UVERBS_OBJECT_DMAH,
 	UVERBS_OBJECT_DMABUF,
+	UVERBS_OBJECT_COMP_CNTR,
 };
 
 enum {
@@ -169,9 +170,16 @@ enum uverbs_attrs_destroy_qp_cmd_attr_ids {
 	UVERBS_ATTR_DESTROY_QP_RESP,
 };
 
+enum uverbs_attrs_qp_attach_comp_cntr_cmd_attr_ids {
+	UVERBS_ATTR_QP_ATTACH_COMP_CNTR_HANDLE,
+	UVERBS_ATTR_QP_ATTACH_COMP_CNTR_CNTR_HANDLE,
+	UVERBS_ATTR_QP_ATTACH_COMP_CNTR_OP_MASK,
+};
+
 enum uverbs_methods_qp {
 	UVERBS_METHOD_QP_CREATE,
 	UVERBS_METHOD_QP_DESTROY,
+	UVERBS_METHOD_QP_ATTACH_COMP_CNTR,
 };
 
 enum uverbs_attrs_create_srq_cmd_attr_ids {
@@ -438,4 +446,32 @@ enum uverbs_attrs_query_gid_entry_cmd_attr_ids {
 	UVERBS_ATTR_QUERY_GID_ENTRY_RESP_ENTRY,
 };
 
+enum uverbs_methods_comp_cntr {
+	UVERBS_METHOD_COMP_CNTR_CREATE,
+	UVERBS_METHOD_COMP_CNTR_DESTROY,
+	UVERBS_METHOD_COMP_CNTR_MODIFY,
+	UVERBS_METHOD_COMP_CNTR_READ,
+};
+
+enum uverbs_attrs_create_comp_cntr_cmd_attr_ids {
+	UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE,
+};
+
+enum uverbs_attrs_destroy_comp_cntr_cmd_attr_ids {
+	UVERBS_ATTR_DESTROY_COMP_CNTR_HANDLE,
+};
+
+enum uverbs_attrs_modify_comp_cntr_cmd_attr_ids {
+	UVERBS_ATTR_MODIFY_COMP_CNTR_HANDLE,
+	UVERBS_ATTR_MODIFY_COMP_CNTR_ENTRY,
+	UVERBS_ATTR_MODIFY_COMP_CNTR_OP,
+	UVERBS_ATTR_MODIFY_COMP_CNTR_VALUE,
+};
+
+enum uverbs_attrs_read_comp_cntr_cmd_attr_ids {
+	UVERBS_ATTR_READ_COMP_CNTR_HANDLE,
+	UVERBS_ATTR_READ_COMP_CNTR_ENTRY,
+	UVERBS_ATTR_READ_COMP_CNTR_RESP_VALUE,
+};
+
 #endif
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 51030c27d479..21f86cc7bb1f 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -300,4 +300,23 @@ struct ib_uverbs_buffer_desc {
 	__aligned_u64 length;
 };
 
+enum ib_uverbs_comp_cntr_entry {
+	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
+	IB_UVERBS_COMP_CNTR_ENTRY_ERR,
+};
+
+enum ib_uverbs_comp_cntr_modify_op {
+	IB_UVERBS_COMP_CNTR_MODIFY_OP_SET,
+	IB_UVERBS_COMP_CNTR_MODIFY_OP_INC,
+};
+
+enum ib_uverbs_qp_attach_comp_cntr_op {
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_SEND = 1 << 0,
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RECV = 1 << 1,
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_READ = 1 << 2,
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_READ = 1 << 3,
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_RDMA_WRITE = 1 << 4,
+	IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE = 1 << 5,
+};
+
 #endif
-- 
2.47.3

