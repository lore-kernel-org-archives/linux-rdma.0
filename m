Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465418;
	b=LaUQk/gtI5VcLCPl4t/a1aq5X6j2cyT/8tcWr5xLOIO6WAuMYkL3uWgEWJXGKEEcUZIB
	 bDduT8iKhesBPgY/UxZQ63cA4v7KO2lCe82KXU0R1YwnBZAJkI6xX1z24enAzn5nzWiWO
	 hkuHJOYJosX3eScuhgAL+GK4bsgMac7Gi5JHOA1NzuOpkoPAS3OAC06XsLsWrgRuLOept
	 eaL9GrsZefrXIzUdIvUjl8HtdBox952uSRof6oKZff74M1AebtPuHpnIQRfY0LoBYxcm1
	 UQcTMYP0QPUYLh/EIO5z1PbZNt49bujCF5w4IJ+Ob39Tcp+wNFXCY5bvm72PXG2ISLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465418;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TPZVw1w4jUSInIuUyA3OktbSalsTbqfnem1lwCiQNVk=;
	b=jzxxsCx6Rngk+vPHlHhNLuivIPQQ7OEdiuU6Up1zheUyfrbQXxBTX1oaq2jlSxVZQ+iJ
	 mkt92c0rclUlraXnj1V6M3yBZPpOc/+g2oyO612sqRlSJ0TpowfwBTzPOyonJalpyfPEP
	 VtqXT633gI3hJtpTK+3wbS9iMy83Oh949JEliulRF1L4T8rqE4EzhNA9xKrhkJdQ9v34/
	 Wbzlu9E4lG/gj2rq7lEbrrBf2jri3AGp1wIXx5p8TmZ54puVFbbnUhRBqKCoWJWEkukQP
	 qOPHyUlbRUbEuwKx+z2yxhMTQ4N64k4Zh1gIlMSJ+Yl8gQYP3foDAfnwZBPDx3xetWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDeu1d67;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ABA606A33B;
	Tue, 20 Oct 2026 03:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDeu1d67
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465418;
	b=QQCXWA+fp5B6QSg6MRtpWHM/tbqs8s0riVsXocpRIwr+xIDt7y8uMUlmZtwk4GaOUToh
	 mIFrcDia6GkrMKKOh9s0gf7z3UjUPFeL/dfpsfa0ZAgOdpDLWWeh1e516wY7LBygUgeYf
	 z1bohua/AvKfuAnv07NDjTKuyZEYZb1otVB3/n8cgf8d6vYIn68TZy29h/oIeql39WPrH
	 51gWD845ICAE4g5Dw3JzqmaVe+ldop6d7UcvyYWrsYFUubI5bYzkkRFzCYHDJaTKc/MjG
	 /NNCB6guDkqSLrYPGTY7pZrS/LQnNwXAQG0eLAktJEpZTmyg7WNfX1M5MTPopu7l8yA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465418;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TPZVw1w4jUSInIuUyA3OktbSalsTbqfnem1lwCiQNVk=;
	b=l/UXleJxBOa8BwwLwLUd8K+xW/KWqp/qLGcWM2UpEaUHjoK0tvc81s17cs2o5nf4H8bM
	 5ygYMqbAPjqixFbdW0rnAtWaatf0XbVMD/svF85/3OMX3xrT8k81EhBS7oIVb8/XHrg/S
	 t+edfc3GvrxstFiA+8615oqXhq6sse5J/8queKkEYkiL09ckzRvGHdrmiZLMSTomLdNQR
	 ckMLDOMxJGS6Dhgg6tJLRx3bpR70qDDrMIG9E2IQzrif8Arj7Sh1ABrE7h4c5WvHmOH32
	 x46wy+X/3QfP5Jpt+yuc0O1/nM4J6l6UVKYCe2bkbv0TbYkC2AQA8FlwAW9jq0f/qzA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D583D1F000CB;
	Tue, 20 Oct 2026 03:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465417;
	bh=TPZVw1w4jUSInIuUyA3OktbSalsTbqfnem1lwCiQNVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RDeu1d67iTnXkDE/I8vrHHaBgkDw31v78X7SSMExL1ioG0tGkvSQ79Vtol5m9nyLx
	 0EQWgzQs4gxLs4Pbbt+bZhkoH8Gvoy8alJZJkUWv2aztPEia7c128v4H3i5Bg4XUwG
	 eklZRKUELOExsO0otxO9ZWbHibSVIxIMmNo9iHckkQB50Y8CbcAcEJxQkdVJvAcRhJ
	 46Tb9SA8xerSIeVWlAZ7+FC8PoTX+/I8cgiwSrJPWFTY3Pes8PzQ+cGzZAGI/j4Fca
	 DiWdV1Q4duboPxpVViLg9OAjLyUymGJaNW9+QpJNSol6YfFs9nTiUrIhh329nBG7iJ
	 Bmacv4A6VoOWg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3A7C340714;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:33 -0700
Subject: [PATCH rdma-next v2 06/13] RDMA/core: query the semantics a queue
 pair type guarantees
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-uet-ib-core-v2-6-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=9543;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=yk/xZEz4l9zOb4cXnyRsbn6fVawWYgk8s38FjSlbsvA=;
 b=Mot/6Ld7vc4MeogBTITBXX5YYF3Aoc1Rg8erogs+do0N9hMymi33JqecGkPLctNpjvPHCqjbi
 xNMe3FFJM7CCYHVhv0F53WMz4iXRjCjUHmq0lHELMLquCwYep9plZfF
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

An unconnected transport orders far less than a connected one, and how
much varies by device. Add a device method that reports, for a queue pair
type, which operations it orders against which, the largest packet it
puts on the wire, and how wide an immediate it carries.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/device.c                  |  1 +
 drivers/infiniband/core/uverbs_std_types_device.c | 73 ++++++++++++++++++++++-
 include/rdma/ib_verbs.h                           | 15 +++++
 include/uapi/rdma/ib_user_ioctl_cmds.h            |  6 ++
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 63 +++++++++++++++++++
 5 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7c65a9373701..8b1563de4726 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3011,6 +3011,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, query_port);
 	SET_DEVICE_OP(dev_ops, query_port_speed);
 	SET_DEVICE_OP(dev_ops, query_qp);
+	SET_DEVICE_OP(dev_ops, query_qp_semantics);
 	SET_DEVICE_OP(dev_ops, query_srq);
 	SET_DEVICE_OP(dev_ops, query_ucontext);
 	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index db65032e80b4..997fc82f9010 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -591,6 +591,76 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UVERBS_ATTR_TYPE(u32),
 			    UA_OPTIONAL));
 
+/* What a QP type guarantees on this device. Which operations it orders
+ * against, how large a packet it puts on the wire, how wide an immediate it
+ * carries.
+ */
+static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_QP_SEMANTICS)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uverbs_qp_semantics resp = {};
+	struct ib_qp_semantics sem = {};
+	struct ib_ucontext *ucontext;
+	struct ib_device *ib_dev;
+	enum ib_qp_type qp_type;
+	int ret;
+
+	ucontext = ib_uverbs_get_ucontext(attrs);
+	if (IS_ERR(ucontext))
+		return PTR_ERR(ucontext);
+	ib_dev = ucontext->device;
+
+	if (!ib_dev->ops.query_qp_semantics)
+		return -EOPNOTSUPP;
+
+	ret = uverbs_get_const(&qp_type, attrs,
+			       UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE);
+	if (ret)
+		return ret;
+
+	/* only the types userspace can create */
+	switch (qp_type) {
+	case IB_UVERBS_QPT_RC:
+	case IB_UVERBS_QPT_UC:
+	case IB_UVERBS_QPT_UD:
+	case IB_UVERBS_QPT_RAW_PACKET:
+	case IB_UVERBS_QPT_XRC_INI:
+	case IB_UVERBS_QPT_XRC_TGT:
+	case IB_UVERBS_QPT_RU:
+	case IB_UVERBS_QPT_DRIVER:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = ib_dev->ops.query_qp_semantics(ib_dev, qp_type, &sem);
+	if (ret)
+		return ret;
+
+	resp.comp_mask = sem.comp_mask;
+	resp.msg_order = sem.msg_order;
+	resp.max_rdma_raw_size = sem.max_rdma_raw_size;
+	resp.max_rdma_war_size = sem.max_rdma_war_size;
+	resp.max_rdma_waw_size = sem.max_rdma_waw_size;
+	resp.max_pdu = sem.max_pdu;
+	resp.usage_flags = sem.usage_flags;
+	resp.imm_data_size = sem.imm_data_size;
+
+	return uverbs_copy_to_struct_or_zero(
+		attrs, UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP, &resp,
+		sizeof(resp));
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_QUERY_QP_SEMANTICS,
+	UVERBS_ATTR_CONST_IN(UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE,
+			     enum ib_uverbs_qp_type,
+			     UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP,
+			    UVERBS_ATTR_STRUCT(struct ib_uverbs_qp_semantics,
+					       imm_data_size),
+			    UA_MANDATORY));
+
 DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
 			      &UVERBS_METHOD(UVERBS_METHOD_GET_CONTEXT),
 			      &UVERBS_METHOD(UVERBS_METHOD_INVOKE_WRITE),
@@ -600,7 +670,8 @@ DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DEVICE,
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_CONTEXT),
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_TABLE),
 			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_GID_ENTRY),
-			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS));
+			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_COMP_CNTR_CAPS),
+			      &UVERBS_METHOD(UVERBS_METHOD_QUERY_QP_SEMANTICS));
 
 const struct uapi_definition uverbs_def_obj_device[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_DEVICE),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 68f7a271cf7a..003b70424429 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2496,6 +2496,18 @@ struct ib_counters {
 	atomic_t	usecnt;
 };
 
+/* what a queue pair of a given type guarantees (query_qp_semantics) */
+struct ib_qp_semantics {
+	u32	comp_mask;		/* enum ib_uverbs_qp_semantics_mask */
+	u32	msg_order;		/* enum ib_uverbs_qp_msg_order */
+	u32	max_rdma_raw_size;
+	u32	max_rdma_war_size;
+	u32	max_rdma_waw_size;
+	u32	max_pdu;
+	u32	usage_flags;		/* enum ib_uverbs_qp_usage_flags */
+	u8	imm_data_size;		/* bits */
+};
+
 struct ib_counters_read_attr {
 	u64	*counters_buff;
 	u32	ncounters;
@@ -2751,6 +2763,9 @@ struct ib_device_ops {
 				       int mr_access_flags, struct ib_pd *pd,
 				       struct ib_udata *udata);
 	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
+	int (*query_qp_semantics)(struct ib_device *device,
+				  enum ib_qp_type qp_type,
+				  struct ib_qp_semantics *sem);
 	struct ib_mr *(*alloc_mr)(struct ib_pd *pd, enum ib_mr_type mr_type,
 				  u32 max_num_sg);
 	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 40fcd4bd1b5e..fb746257eb2c 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -77,6 +77,12 @@ enum uverbs_methods_device {
 	UVERBS_METHOD_QUERY_GID_ENTRY,
 	UVERBS_METHOD_QUERY_PORT_SPEED,
 	UVERBS_METHOD_QUERY_COMP_CNTR_CAPS,
+	UVERBS_METHOD_QUERY_QP_SEMANTICS,
+};
+
+enum uverbs_attrs_query_qp_semantics_attr_ids {
+	UVERBS_ATTR_QUERY_QP_SEMANTICS_QP_TYPE,
+	UVERBS_ATTR_QUERY_QP_SEMANTICS_RESP,
 };
 
 enum uverbs_attrs_invoke_write_cmd_attr_ids {
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 210f3f945bd7..3d05a6c7ca8f 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -318,6 +318,50 @@ struct ib_uverbs_buffer_desc {
 #define IB_UVERBS_QPN_UET_RESERVED_MASK		0x7f000000
 #define IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT	0x80000000
 
+enum ib_uverbs_qp_semantics_mask {
+	IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER	= 1 << 0,
+	IB_UVERBS_QP_SEMANTICS_MASK_RAW		= 1 << 1,
+	IB_UVERBS_QP_SEMANTICS_MASK_WAR		= 1 << 2,
+	IB_UVERBS_QP_SEMANTICS_MASK_WAW		= 1 << 3,
+	IB_UVERBS_QP_SEMANTICS_MASK_PDU		= 1 << 4,
+	IB_UVERBS_QP_SEMANTICS_MASK_IMM		= 1 << 5,
+	IB_UVERBS_QP_SEMANTICS_MASK_USAGE	= 1 << 6,
+};
+
+/* Ordering guarantees between operations on one QP. "X after Y" means an
+ * X may not pass a Y posted before it. A bit that is clear means the pair
+ * does not order that combination, and an application that needs it must
+ * wait for the earlier completion.
+ */
+enum ib_uverbs_qp_msg_order {
+	/* atomic after atomic */
+	IB_UVERBS_QP_ORDER_ATOMIC_RAR	= 1 << 0,
+	IB_UVERBS_QP_ORDER_ATOMIC_RAW	= 1 << 1,
+	IB_UVERBS_QP_ORDER_ATOMIC_WAR	= 1 << 2,
+	IB_UVERBS_QP_ORDER_ATOMIC_WAW	= 1 << 3,
+	/* rma after rma */
+	IB_UVERBS_QP_ORDER_RDMA_RAR	= 1 << 4,
+	IB_UVERBS_QP_ORDER_RDMA_RAW	= 1 << 5,
+	IB_UVERBS_QP_ORDER_RDMA_WAR	= 1 << 6,
+	IB_UVERBS_QP_ORDER_RDMA_WAW	= 1 << 7,
+	/* send against atomic and rma */
+	IB_UVERBS_QP_ORDER_RAS		= 1 << 8,
+	IB_UVERBS_QP_ORDER_SAR		= 1 << 9,
+	IB_UVERBS_QP_ORDER_SAS		= 1 << 10,
+	IB_UVERBS_QP_ORDER_SAW		= 1 << 11,
+	IB_UVERBS_QP_ORDER_WAS		= 1 << 12,
+	/* rma and atomic, either kind, against each other */
+	IB_UVERBS_QP_ORDER_RAR		= 1 << 13,
+	IB_UVERBS_QP_ORDER_RAW		= 1 << 14,
+	IB_UVERBS_QP_ORDER_WAR		= 1 << 15,
+	IB_UVERBS_QP_ORDER_WAW		= 1 << 16,
+};
+
+enum ib_uverbs_qp_usage_flags {
+	/* immediate data consumes a posted receive */
+	IB_UVERBS_QP_USAGE_IMM_DATA_RQ	= 1 << 0,
+};
+
 /* An address handle that names a peer using both transport+network addresses.
  * Used for reliable unconnected QPs in both work request address handles and
  * a Job address table.
@@ -327,6 +371,25 @@ struct ib_uverbs_ah_attr_ex {
 	__u32 remote_qpn;
 };
 
+struct ib_uverbs_qp_semantics {
+	__u32 comp_mask;		/* enum ib_uverbs_qp_semantics_mask */
+	__u32 msg_order;		/* enum ib_uverbs_qp_msg_order */
+	/*
+	 * Data ordering: the largest transfer, in bytes, for which the target
+	 * memory reflects the order of the pair under its RDMA_ and plain
+	 * msg_order bits. 0 if not provided, and those bits are then clear.
+	 * There is no read-after-read size, as two reads leave memory
+	 * unchanged.
+	 */
+	__u32 max_rdma_raw_size;	/* read after write */
+	__u32 max_rdma_war_size;	/* write after read */
+	__u32 max_rdma_waw_size;	/* write after write */
+	__u32 max_pdu;			/* largest packet, bytes */
+	__u32 usage_flags;		/* enum ib_uverbs_qp_usage_flags */
+	__u8  imm_data_size;		/* widest immediate, in bits */
+	__u8  reserved[3];
+};
+
 enum ib_uverbs_comp_cntr_entry {
 	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
 	IB_UVERBS_COMP_CNTR_ENTRY_ERR,

-- 
2.56.0


