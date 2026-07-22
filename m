Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C1843B498
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709376; cv=none; b=CAzO4+AOm2toXWnegOBb21CmtJYD/pbRXj17z3t/kzVHMw+zzSistrBPQYA0WOF4oIkVSMC2DcMPndtwi63mq4PBuJ3CRhI5B5eQnvglhNcpg9lroUHTpfzC10+LZu+hzLLUhGv09XYAHt02Sec86xU5KTIUvn6EjW8KIZM+IbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709376; c=relaxed/simple;
	bh=2jkEcNelGTbyYpo6y7Jl+65HcoPWouy1262c5Ch1InU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ja1HLqWXFTsEkEorF1PrFWCjDUMaVOBbrbfxigVImrp3lUH/AHZ+WeBM6VkVBejp5T2Nsr2rqvbppXbcz2Th3+8ozrOYkb50YhO1etF+A6YCbElSWESuiSySI/afJnNMBHaJOhKwPR+AwmAIW1h6YDWcB3FG3T5fL/Hygd/TryE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OY0L/9+Z; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OY0L/9+Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784709375; x=1816245375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4yXSZViofPOs86DYPG8lUA3VshS0hn8h3QlfTrpGXr8=;
  b=OY0L/9+ZbW7TLEgRydCtchpyoUsDrTCwpOqEpN8j5VV2hW40UWrXHMjB
   V6kWRYOiZXuP1QBp5M2kZpfK4NTCX0KqTpaTIwJmUP/d5qBd3PM4wNopb
   5Svg5XpejyoMgcqWjlMFX+m2EsN2abcHYkzdzBQe3JzvlytXW29+zFvuH
   BHW64Jzk0GzrC3Nu1cOMERe4LaA5j6dSq/wDDWgg0FSjpl7HEKp0pjweY
   Quhe65gsDGV4zVEjuW9GteAsoYR2/5eWLIzhaTOSigKRt1n0rCaHXDDCu
   L+Bti5v2XpF9gL4b20NJhiqQvoNR9nKuWynQT9h+qeD5sLXtNSzom3E/1
   w==;
X-CSE-ConnectionGUID: W+y9dMinQX63aYuVL1EcaA==
X-CSE-MsgGUID: 9dTdxXnqQjGIe0tIsgnsOQ==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="24119330"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:36:11 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:5770]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.17:2525] with esmtp (Farcaster)
 id f80d63c4-fd85-4037-b615-515951a16a99; Wed, 22 Jul 2026 08:36:11 +0000 (UTC)
X-Farcaster-Flow-ID: f80d63c4-fd85-4037-b615-515951a16a99
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 08:36:11 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 08:36:09 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v11 3/6] RDMA/core: Expose Completion Counter capabilities to userspace
Date: Wed, 22 Jul 2026 08:36:00 +0000
Message-ID: <20260722083603.30334-4-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722083603.30334-1-mrgolin@amazon.com>
References: <20260722083603.30334-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a dedicated query interface for completion counter capabilities
via UVERBS_METHOD_QUERY_COMP_CNTR_CAPS on the device object.

The query returns the maximum number of counters, maximum counter
value, and a bitmask of supported QP attach operations. Each field
is an optional ioctl attribute, allowing userspace to request only
the capabilities it needs.

Drivers implement the query_comp_cntr_caps operation to report
device-specific capabilities.

Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/core/device.c              |  1 +
 .../infiniband/core/uverbs_std_types_device.c | 51 ++++++++++++++++++-
 include/rdma/ib_verbs.h                       |  9 ++++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  7 +++
 4 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a4c57279f19d..ddf75867ac61 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2829,6 +2829,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, post_srq_recv);
 	SET_DEVICE_OP(dev_ops, process_mad);
 	SET_DEVICE_OP(dev_ops, query_ah);
+	SET_DEVICE_OP(dev_ops, query_comp_cntr_caps);
 	SET_DEVICE_OP(dev_ops, query_device);
 	SET_DEVICE_OP(dev_ops, query_gid);
 	SET_DEVICE_OP(dev_ops, query_pkey);
diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 12ca15739cd2..ce0a7de00405 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -472,6 +472,42 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_GID_ENTRY)(
 	return ret;
 }
 
+static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_comp_cntr_caps caps = {};
+	struct ib_ucontext *ucontext;
+	struct ib_device *ib_dev;
+	int ret;
+
+	ucontext = ib_uverbs_get_ucontext(attrs);
+	if (IS_ERR(ucontext))
+		return PTR_ERR(ucontext);
+	ib_dev = ucontext->device;
+
+	if (!ib_dev->ops.query_comp_cntr_caps)
+		return -EOPNOTSUPP;
+
+	ret = ib_dev->ops.query_comp_cntr_caps(ib_dev, &caps, attrs);
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_COUNTERS,
+			     &caps.max_counters, sizeof(caps.max_counters));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_VALUE,
+			     &caps.max_value, sizeof(caps.max_value));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
+			     &caps.supported_qp_attach_ops,
+			     sizeof(caps.supported_qp_attach_ops));
+	return IS_UVERBS_COPY_ERR(ret) ? ret : 0;
+}
+
 DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_METHOD_GET_CONTEXT,
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
@@ -542,6 +578,18 @@ DECLARE_UVERBS_NAMED_METHOD(
 					       netdev_ifindex),
 			    UA_MANDATORY));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_QUERY_COMP_CNTR_CAPS,
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_COUNTERS,
+			    UVERBS_ATTR_TYPE(u32),
+			    UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_VALUE,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
+			    UVERBS_ATTR_TYPE(u32),
+			    UA_OPTIONAL));
+
 DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
 			      &UVERBS_METHOD(UVERBS_METHOD_GET_CONTEXT),
 			      &UVERBS_METHOD(UVERBS_METHOD_INVOKE_WRITE),
@@ -550,7 +598,8 @@ DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_PORT_SPEED),
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_CONTEXT),
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_TABLE),
-			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_ENTRY));
+			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_ENTRY),
+			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS));
 
 const struct uapi_definition uverbs_def_obj_device[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_DEVICE),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 84a8904fbad4..033f4a2c965f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1755,6 +1755,12 @@ enum ib_qp_attach_comp_cntr_op {
 	IB_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE = IB_UVERBS_QP_ATTACH_COMP_CNTR_OP_REMOTE_RDMA_WRITE,
 };
 
+struct ib_comp_cntr_caps {
+	u64 max_value;
+	u32 max_counters;
+	u32 supported_qp_attach_ops; /* Bitmask of enum ib_qp_attach_comp_cntr_op */
+};
+
 struct ib_comp_cntr {
 	struct ib_device *device;
 	struct ib_uobject *uobject;
@@ -2689,6 +2695,9 @@ struct ib_device_ops {
 	int (*modify_comp_cntr)(struct ib_comp_cntr *cc, enum ib_comp_cntr_entry entry,
 				enum ib_comp_cntr_modify_op op, u64 value);
 	int (*read_comp_cntr)(struct ib_comp_cntr *cc, enum ib_comp_cntr_entry entry, u64 *value);
+	int (*query_comp_cntr_caps)(struct ib_device *dev,
+				    struct ib_comp_cntr_caps *caps,
+				    struct uverbs_attr_bundle *attrs);
 	struct ib_mr *(*get_dma_mr)(struct ib_pd *pd, int mr_access_flags);
 	struct ib_mr *(*reg_user_mr)(struct ib_pd *pd, u64 start, u64 length,
 				     u64 virt_addr, int mr_access_flags,
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 19a94b91987e..6a3d59d03f54 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -76,6 +76,7 @@ enum uverbs_methods_device {
 	UVERBS_METHOD_QUERY_GID_TABLE,
 	UVERBS_METHOD_QUERY_GID_ENTRY,
 	UVERBS_METHOD_QUERY_PORT_SPEED,
+	UVERBS_METHOD_QUERY_COMP_CNTR_CAPS,
 };
 
 enum uverbs_attrs_invoke_write_cmd_attr_ids {
@@ -94,6 +95,12 @@ enum uverbs_attrs_query_port_speed_cmd_attr_ids {
 	UVERBS_ATTR_QUERY_PORT_SPEED_RESP,
 };
 
+enum uverbs_attrs_query_comp_cntr_caps_attr_ids {
+	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_COUNTERS,
+	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_MAX_VALUE,
+	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
+};
+
 enum uverbs_attrs_get_context_attr_ids {
 	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
 	UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
-- 
2.47.3

