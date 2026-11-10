Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283266;
	b=ARfAX+S11Q6D7CC55NxiFPSWPSJzGqaXdmBrmTen7UjD0gBc8KqszJ7Kei6OE5yZmjIp
	 lFhSCbbxsS4siDQtgRxdON/UIzzB3MpiJSzkPuIvJGTlAHoMlHfV6xrwnkWs8a5JJUZ1O
	 Q7Xzo5mEbjfwuxWQWbbIoQkWI1wa2Z1LIVSQNyjhUaWAQfhK0DS7BdxqY18OcasLhnOsV
	 948LJNErCKuae47de4yvlhHUdqaZ7KYwd3x3KYroV2Z9yj9VcFM7/gAVkX3LZAJsYxb61
	 NtDZCiT3l9F7L58QtXnoxCg1TTVigSL4Yup18tgazUeBchA6bcEaCqeK5MBr3bmi2og==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283266;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PKphDZkzTg89bagw/VeofXp/dpQ9JgIITBwvTW81wk0=;
	b=ZQ+vJ20atTGUDS5pS80kPA5oq35v/njjWiUbbGh7Zd+2xyx+HH/oaGfB3lgTElRPSr1R
	 NAa/YwEFeaL+FqBDyh4GOsqRBoCzaqqLgG7bguPA8JHJvS8W63p4twAJVsl9gvLeuVmwg
	 zs7TRy15WcSBvunId9MGZ48DT+RC1o14aVkQyfysyxaC8W9FDY2dQqxNVl8fJo9RiUJTy
	 OqPsYF2t8SNKfm0imR3gUDB6oopb+c8BW/FcOGBBXeWmv9CFna1PgbrBj/S1D3vdH2AVo
	 JJ95lj6JGwUBsg++Bw3OhlssmO8X0IP38hb5sEAsmzc4qMrqsBOR+26I1rvK3aXyaSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L1X1acTG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC960A3801;
	Tue, 10 Nov 2026 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L1X1acTG
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283265;
	b=yIzfgDpbtVHy2K/7TPhu8b2owkAHRE+uUiqUAa0bg6bWkTxVTWy2UbE1wjKcB2sR6MxF
	 NjCZj1tPld/k74zxCfuS5I9Rj9h7nbd0AUUAY9CGUvMfXg3TL1giYr4u1oGCU1uHG6hRJ
	 P1DUjPynzo/B5hix4yaFSFqGapUe4EvID8V1PAoWm4gOIBdh0mkZb7DX9mEDZGrqS5pTE
	 tEkHkR7LPGW5SVzbhc8nqJKcg4yg0y7olz8qbKX0o3/vVlwX6pI/gbMvZ40wXlNa6q/0k
	 cA8zEsIi/6AkWkrf5Md+6O9ItMza3VOdqYORne6ljBAvfxk1GQ7sBw4Ts9T4jiczbwA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283265;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PKphDZkzTg89bagw/VeofXp/dpQ9JgIITBwvTW81wk0=;
	b=R+OcSjvExJOunZrvWIRWp0yuXJfOgt/tB/6MwS3nsaJqL9BVYtcn8RbMJQLmD30RdQaC
	 8OjyxwysFqiUXbV/ciMZtIxwL9p/WQyM6byuhZoMLPcbJstqp1H1c3c3E+Hv2L89KUFy0
	 Jd26gB9cbPtxPOABQkAcE6R9XVWj2nqeE6+ZrOOmyMLasEWAeBDvetqlZyYDS8BsEooB1
	 QQh9NJgmH5KUOxBIV9R5fU+TURjiwFvM2nnBpZOZ0wr2ZorOStzAD6ZKAQHcn507JvV8F
	 k6SM2X7vPd4cVsrRsoIH5Yid3S3XoRrgD06v49e0PhNH30UR4w5tFcZd1MLy0I18xxw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9B7AF1F00901;
	Tue, 10 Nov 2026 04:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283265;
	bh=PKphDZkzTg89bagw/VeofXp/dpQ9JgIITBwvTW81wk0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=L1X1acTG06C5pou7fjErSc7KasC8/PA/N6ATtIZWYQU9kqPZh3CH7qr1tMeAUTUlI
	 N54ofCowFEHHtj/oS+qp1RJyQa801+Qe3oN1K2Z4bNwJQ7Gt0MErcfGggIhDmC8XA/
	 66/cxbv1lt13OCujuwUSNCj/6ksF1NUrXP1ngtsUYmW4z7xYg8xJD/zYI5a2Mw6A4z
	 Mii8dJBZIswHFyDlqFzSMfJRGL8CZPMHKKvVFq0wS7oM4sA3bU6hkoj3i1HqwMvEn5
	 JCZssjayDntPa+h3GOtegV8Obkv+b0yqo3zh6Rtk/5w//LoEfLegGZkhxMxCxER9ni
	 xQOIcaYJXX0ug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4989248820;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:43 -0800
Subject: [PATCH rdma-next v3 10/13] RDMA/core: queue pair attributes for
 unconnected transports
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
Message-Id: <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=11059;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=46nf8vmxA5cvwFWLk+XCkPpml52wE+g/uOVrDjI7OKk=;
 b=YxFSH7qDsk3nBwQO2XdrGkkBJEbYwsHHP9vzQnu4behDa0toJnLI/Pv5wnlLeGBiJE0oIAvMb
 iV7PAu1znRVCRAHve+erCCA4s55aau3CAhshZd+lqRbhva7BjeXuQV0
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

A queue pair on an unconnected transport is created with more than the
connected attributes. A job key authorizing it to act within a job, the
initiator identity it sends under, and the ordering guarantees the caller
wants it to keep.

The QP holds a reference to its job key for as long as it lives, so the
job cannot go away underneath it.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_std_types_qp.c | 173 ++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c               |   5 +
 include/rdma/ib_verbs.h                       |  14 +++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |   3 +
 4 files changed, 195 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 249206d2992f..a1112083fb73 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -79,6 +79,157 @@ static void set_caps(struct ib_qp_init_attr *attr,
 	}
 }
 
+/* A QP may relax what its type guarantees on this device, but not ask for
+ * more than the device advertises for it.
+ */
+static int create_qp_semantics_check(struct ib_device *device,
+				     const struct ib_qp_semantics *req)
+{
+	struct ib_qp_semantics adv = {};
+	u32 m = req->comp_mask;
+	int ret;
+
+	if (!device->ops.query_qp_semantics)
+		return -EOPNOTSUPP;
+
+	ret = device->ops.query_qp_semantics(device, IB_QPT_RU, &adv);
+	if (ret)
+		return ret;
+
+	if (m & ~adv.comp_mask)
+		return -EINVAL;
+
+	if (((m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER) &&
+	     (req->msg_order & ~adv.msg_order)) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_RAW) &&
+	     req->max_rdma_raw_size > adv.max_rdma_raw_size) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAR) &&
+	     req->max_rdma_war_size > adv.max_rdma_war_size) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAW) &&
+	     req->max_rdma_waw_size > adv.max_rdma_waw_size) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_PDU) &&
+	     req->max_pdu > adv.max_pdu) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_IMM) &&
+	     req->imm_data_size > adv.imm_data_size) ||
+	    ((m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE) &&
+	     (req->usage_flags & ~adv.usage_flags)))
+		return -EINVAL;
+
+	return 0;
+}
+
+/* Process the optional creation attributes. A job to act within, a source
+ * identity, a set of ordering guarantees to ask for. They and the checks on
+ * a requested QP number belong to a reliable unconnected QP.
+ */
+static int create_qp_opt_attrs(struct uverbs_attr_bundle *attrs,
+			       struct ib_device *device, struct ib_pd *pd,
+			       struct ib_qp_init_attr *attr,
+			       struct ib_qp_semantics *sem)
+{
+	struct ib_uverbs_qp_semantics usem = {};
+	struct ib_jkey *jkey;
+	bool has_semantics;
+	u32 m;
+	int ret;
+
+	has_semantics = uverbs_attr_is_valid(attrs,
+					     UVERBS_ATTR_CREATE_QP_SEMANTICS);
+
+	if (attr->qp_type != IB_QPT_RU) {
+		if (has_semantics ||
+		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID) ||
+		    uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY))
+			return -EOPNOTSUPP;
+
+		return 0;
+	}
+
+	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_SRC_ID)) {
+		ret = uverbs_copy_from(&attr->src_id, attrs,
+				       UVERBS_ATTR_CREATE_QP_SRC_ID);
+		if (ret)
+			return ret;
+	}
+
+	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_JOB_KEY)) {
+		jkey = uverbs_attr_get_obj(attrs,
+					   UVERBS_ATTR_CREATE_QP_JOB_KEY);
+		if (IS_ERR(jkey))
+			return PTR_ERR(jkey);
+
+		/* a key acts within the PD it was made on */
+		if (jkey->pd != pd)
+			return -EINVAL;
+
+		attr->jkey = jkey;
+	}
+
+	if (attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
+		if (attr->source_qpn & IB_UVERBS_QPN_UET_RESERVED_MASK)
+			return -EINVAL;
+
+		/* a relative QP is named within a job, so it needs a key */
+		if (!(attr->source_qpn &
+		      IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT) &&
+		    !attr->jkey)
+			return -EINVAL;
+	}
+
+	if (has_semantics) {
+		ret = uverbs_copy_from_or_zero(&usem, attrs,
+					       UVERBS_ATTR_CREATE_QP_SEMANTICS);
+		if (ret)
+			return ret;
+
+		m = usem.comp_mask;
+		if ((m & ~QP_SEMANTICS_MASK_ALL) ||
+		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER) &&
+		     (usem.msg_order & ~QP_ORDER_ALL)) ||
+		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE) &&
+		     (usem.usage_flags & ~QP_USAGE_ALL)) ||
+		    memchr_inv(usem.reserved, 0, sizeof(usem.reserved)))
+			return -EINVAL;
+
+		/* only the fields comp_mask selects reach the driver */
+		sem->comp_mask = m;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER)
+			sem->msg_order = usem.msg_order;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_RAW)
+			sem->max_rdma_raw_size = usem.max_rdma_raw_size;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_WAR)
+			sem->max_rdma_war_size = usem.max_rdma_war_size;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_WAW)
+			sem->max_rdma_waw_size = usem.max_rdma_waw_size;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_PDU)
+			sem->max_pdu = usem.max_pdu;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_USAGE)
+			sem->usage_flags = usem.usage_flags;
+		if (m & IB_UVERBS_QP_SEMANTICS_MASK_IMM)
+			sem->imm_data_size = usem.imm_data_size;
+
+		/* nor an ordering whose data-ordering size it gives as 0 */
+		if (((m & IB_UVERBS_QP_SEMANTICS_MASK_RAW) &&
+		     !sem->max_rdma_raw_size &&
+		     (sem->msg_order & QP_ORDER_RAW_SIZED)) ||
+		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAR) &&
+		     !sem->max_rdma_war_size &&
+		     (sem->msg_order & QP_ORDER_WAR_SIZED)) ||
+		    ((m & IB_UVERBS_QP_SEMANTICS_MASK_WAW) &&
+		     !sem->max_rdma_waw_size &&
+		     (sem->msg_order & QP_ORDER_WAW_SIZED)))
+			return -EINVAL;
+
+		ret = create_qp_semantics_check(device, sem);
+		if (ret)
+			return ret;
+
+		attr->qp_semantics = sem;
+	}
+
+	return 0;
+}
+
 /* The attributes the QP would be modified with via modify_qp calls. Used for
  * implementations that support having QPs be in RTS immediately after QP
  * creation. These attributes arrive in the same format the modify command
@@ -137,6 +288,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	struct ib_qp_init_attr attr = {};
 	struct ib_qp_attr qp_attr = {};
 	u32 qp_attr_mask;
+	struct ib_qp_semantics qp_semantics = {};
 	struct ib_uverbs_qp_cap cap = {};
 	struct ib_rwq_ind_table *rwq_ind_tbl = NULL;
 	struct ib_qp *qp;
@@ -191,6 +343,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	case IB_UVERBS_QPT_UC:
 	case IB_UVERBS_QPT_UD:
 	case IB_UVERBS_QPT_XRC_INI:
+	case IB_UVERBS_QPT_RU:
 	case IB_UVERBS_QPT_DRIVER:
 		if (uverbs_attr_is_valid(attrs,
 					 UVERBS_ATTR_CREATE_QP_XRCD_HANDLE) ||
@@ -242,6 +395,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		return -EINVAL;
 	}
 
+	/* only a device that implements the transport takes an RU QP */
+	if (attr.qp_type == IB_QPT_RU &&
+	    !(device->attrs.device_cap_flags & IB_DEVICE_RU))
+		return -EOPNOTSUPP;
+
 	ret = uverbs_get_flags32(&attr.create_flags, attrs,
 			 UVERBS_ATTR_CREATE_QP_FLAGS,
 			 IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
@@ -265,6 +423,10 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		attr.create_flags |= IB_QP_CREATE_SOURCE_QPN;
 	}
 
+	ret = create_qp_opt_attrs(attrs, device, pd, &attr, &qp_semantics);
+	if (ret)
+		return ret;
+
 	ret = create_qp_attr_set(attrs, device, &attr, &qp_attr,
 				 &qp_attr_mask);
 	if (ret)
@@ -395,6 +557,17 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_CREATE_QP_FLAGS,
 			     enum ib_uverbs_qp_create_flags,
 			     UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_QP_SRC_ID,
+			   UVERBS_ATTR_TYPE(u32),
+			   UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_QP_SEMANTICS,
+			   UVERBS_ATTR_STRUCT(struct ib_uverbs_qp_semantics,
+					      imm_data_size),
+			   UA_OPTIONAL),
+	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_QP_JOB_KEY,
+			UVERBS_OBJECT_JKEY,
+			UVERBS_ACCESS_READ,
+			UA_OPTIONAL),
 	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_QP_ATTR,
 			   UVERBS_ATTR_STRUCT(struct ib_uverbs_ex_modify_qp,
 					      reserved),
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3b551979e52f..9359318141b7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1343,6 +1343,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	qp->qp_type = attr->qp_type;
 	qp->rwq_ind_tbl = attr->rwq_ind_tbl;
 	qp->srq = attr->srq;
+	qp->jkey = attr->jkey;
 	qp->event_handler = __ib_qp_event_handler;
 	qp->registered_event_handler = attr->event_handler;
 	qp->port = attr->port_num;
@@ -1451,11 +1452,15 @@ void ib_qp_usecnt_inc(struct ib_qp *qp)
 		atomic_inc(&qp->srq->usecnt);
 	if (qp->rwq_ind_tbl)
 		atomic_inc(&qp->rwq_ind_tbl->usecnt);
+	if (qp->jkey)
+		atomic_inc(&qp->jkey->usecnt);
 }
 EXPORT_SYMBOL(ib_qp_usecnt_inc);
 
 void ib_qp_usecnt_dec(struct ib_qp *qp)
 {
+	if (qp->jkey)
+		atomic_dec(&qp->jkey->usecnt);
 	if (qp->rwq_ind_tbl)
 		atomic_dec(&qp->rwq_ind_tbl->usecnt);
 	if (qp->srq)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ce6707160a12..8be766b80ce0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1243,6 +1243,9 @@ enum ib_qp_create_flags {
  * callback to destroy the passed in QP.
  */
 
+struct ib_jkey;
+struct ib_qp_semantics;
+
 struct ib_qp_init_attr {
 	/* This callback occurs in workqueue context */
 	void                  (*event_handler)(struct ib_event *, void *);
@@ -1263,6 +1266,15 @@ struct ib_qp_init_attr {
 	u32			port_num;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	u32			source_qpn;
+
+	/* The initiator ID this QP sends with, the caller's rank in its job.
+	 * UET lets the caller choose it; the JobID is what is trusted.
+	 */
+	u32			src_id;
+	/* the job this QP belongs to */
+	struct ib_jkey		*jkey;
+	/* what the caller asked the QP to guarantee, NULL if it didn't ask */
+	struct ib_qp_semantics	*qp_semantics;
 };
 
 struct ib_qp_open_attr {
@@ -2009,6 +2021,8 @@ struct ib_qp {
 	enum ib_qp_type		qp_type;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
+	/* the job key this pair was created within, NULL if none */
+	struct ib_jkey	       *jkey;
 	u32			port;
 
 	bool			integrity_en;
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index b2bf8ca92397..1de6a1ffd92c 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -179,6 +179,9 @@ enum uverbs_attrs_create_qp_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_QP_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+	UVERBS_ATTR_CREATE_QP_SRC_ID,
+	UVERBS_ATTR_CREATE_QP_SEMANTICS,
+	UVERBS_ATTR_CREATE_QP_JOB_KEY,
 	UVERBS_ATTR_CREATE_QP_ATTR,
 };
 

-- 
2.56.0


