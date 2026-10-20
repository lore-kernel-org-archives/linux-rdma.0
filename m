Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465420;
	b=R28cPjuwGMUjSbQFjT9pCTDXz8OiAuexlCT4NppS8E4rUGtdYWrleph5d2OJvuKssFmM
	 2pL2vmICD24KCLVu2n4Mk0Pttm3nc7qokLfcEsbtl5MKIsGHgHQlPZXE6cJzML7b24Smz
	 awpr6+0Mf8JlFdnJy+TynJ/Es2tmXp9tLsNzCtZuUGFgJMjG/kNP/XYpwjCLZadYSIFf8
	 F25c1sLnbXVHcflQQzkDs2sIWCbIcG4KDbuJudE+JHv1RnZOlDRBxzCfzIIh7DOvLXoDn
	 m7iKH6TnbTbNSHqzDQCX8yUyLWvPy2nzjnUy5hwKZ8RWbIuQj5BZJy5J9Jt81A2ZOeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465420;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4sTeldK05ZacyvwotzzJxYri5liUUWz7Hz9wa4K8tVU=;
	b=5P8LnNcPG5+TgaxNymMFsSt2oFKXXYa6okbjnUCC4AQySP85KJXwpSJXV/v+seKxL96H
	 w8jypr/r9A12j4/fNVl9sdICHfzkzg3mjRPGqENVvlEr3Or+iafJdgiNWU3XiTaJcC1it
	 yhs7OS9Aj5YL1drkACsUdhQawrj8iNbKVsEg1wlwLamMg9xK6gFTTKr4yaXhNRS6lcqaP
	 wm89Tpdi7iFM6updcDCcJUbcY3+Osw6H3hoW4ypX3iRP9ZlHnt/VIH3Kr8qU0KiKgRdJa
	 tcSOVTN5yPcl4l3IkSOHDkzCGH2HWDjUwDQIiudjZd+1VWG5pmphBop7972EzseuWxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7cqUAoC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A5F60A260C;
	Tue, 20 Oct 2026 03:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7cqUAoC
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465420;
	b=XfA8E5faXjuTnzTcsUxOQ/GHr2ZpaLG8+7j+2slXXjaKXPHnZ9MSX1B20cksMaeDzMF9
	 U5kgisTIvRVLxuisQlOtHThFiNorB6LoFpFb8bB8Qu5TyN2akjrStJOd+8zf9fSzd7hFR
	 a3Co/ahT+KGI/L6fVVjHKS70RkWKVG5ExeeiYH8WQotGi4xAHYjkQyzpHQ9yyatVIq/UB
	 m0aO48M1Dlqs239w270C09ZZnWnO7xvKfJuKifytiCVRbNTR4ehzMNIfSxf3tQv6Tr38j
	 1O+duyoJAGHkMOii24zytb79aIoHdQz8axc0b6ntf8TS2+2gUhWHHXayeU/C4nhzfdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465420;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4sTeldK05ZacyvwotzzJxYri5liUUWz7Hz9wa4K8tVU=;
	b=2ORXCy2sfpAIWwSIF5s8YDfKMqw+3PGNDL5igK33AugYsxW5AtW3lLobqWI/ZhMz1x/L
	 bX+ODf5TGdjA3b7G1xHCnU3ScC/aFx/fCySELvpInf/u0lrUZ5qmwG3SzVpCSsNRjc+Z4
	 mAuqDj9Gp2/ISTgHR+8XMQVSHL8qaaDTxvjnyti07en0xaLxZQ8RT6p9Coa+Fw7ofIzEM
	 SpJbSnR6xN6ZdGbwyDXJ5fNnY3xEqkfLKifhwEimeU7tXZo7wUfL7HmEpzPxvVVLwxlyy
	 4CFbuMBV/7fRmATCr/Z8GkluyEuA6R7B0TZlLAH7+3XE9B2kN8c6aSWkMhD0SRWNK4Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A629F1F000CE;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465420;
	bh=4sTeldK05ZacyvwotzzJxYri5liUUWz7Hz9wa4K8tVU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=K7cqUAoC0oQuz1mSmirKYkykbLWMc+Jj7tB8vxUIDIJGADqh4mB8XXf9Q40c/9wg7
	 xJEuEw4Io9qF4j+h1moTT8tf1I+3cVLwsREVfWG+HjKrXmyz/3NckcmCroEVRhrpIX
	 ypV0TQa+cPCefknF9OzNIIv3TarOyGRXfvTui3WoZM3K0YSKgsri2ayPPOSY0BxW3J
	 Cj6VtNdLIl3ArbXJ6umoJUQKSs0OVwElx2yE37w7th5yMlVZIl/2FSKbh0i9q8X1LG
	 BIpHCJm185/xODajP2DsjqWEu/ab2BW7qOOYFB/meKDo4wYxR6i8VHQkMdyIPJLx3z
	 bwrr957t2KoWg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5129040729;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:37 -0700
Subject: [PATCH rdma-next v2 10/13] RDMA/core: queue pair attributes for
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
Message-Id: <20261019-uet-ib-core-v2-10-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=9901;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=8+t5onTH6c07O/uhWyxmNclSXD8/qLdlQtZM6KLt+RE=;
 b=KedPBmKM/xlzB5d4wlWG4jldF4+cymhex7L+hciGqlkOKhwSdUbz6sMHbht7XniI4eG/rLVrl
 OJwK0sY2VpvABlyx9bpGPeUx+q4CeGLnrg8oRZDqh7kWRdBMzsmI0f+
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
 drivers/infiniband/core/uverbs_std_types_qp.c | 150 ++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c               |   5 +
 include/rdma/ib_verbs.h                       |  14 +++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |   3 +
 4 files changed, 172 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index c6225156fe30..47ca994f9ac9 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -79,6 +79,139 @@ static void set_caps(struct ib_qp_init_attr *attr,
 	}
 }
 
+/* the semantics fields, ordering bits and usage flags uverbs knows of */
+#define QP_SEMANTICS_MASK_ALL	((IB_UVERBS_QP_SEMANTICS_MASK_USAGE << 1) - 1)
+#define QP_ORDER_ALL		((IB_UVERBS_QP_ORDER_WAW << 1) - 1)
+#define QP_USAGE_ALL		IB_UVERBS_QP_USAGE_IMM_DATA_RQ
+
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
+	int ret;
+
+	has_semantics = uverbs_attr_is_valid(attrs,
+					     UVERBS_ATTR_CREATE_QP_SEMANTICS);
+
+	if (attr->qp_type != IB_QPT_RU ||
+	    !(device->attrs.device_cap_flags & IB_DEVICE_RU)) {
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
+		if ((usem.comp_mask & ~QP_SEMANTICS_MASK_ALL) ||
+		    (usem.msg_order & ~QP_ORDER_ALL) ||
+		    (usem.usage_flags & ~QP_USAGE_ALL) ||
+		    memchr_inv(usem.reserved, 0, sizeof(usem.reserved)))
+			return -EINVAL;
+
+		sem->comp_mask = usem.comp_mask;
+		sem->msg_order = usem.msg_order;
+		sem->max_rdma_raw_size = usem.max_rdma_raw_size;
+		sem->max_rdma_war_size = usem.max_rdma_war_size;
+		sem->max_rdma_waw_size = usem.max_rdma_waw_size;
+		sem->max_pdu = usem.max_pdu;
+		sem->usage_flags = usem.usage_flags;
+		sem->imm_data_size = usem.imm_data_size;
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
 /* what a reliable unconnected QP may be created ready to send with */
 #define CREATE_QP_ATTR_RU_MASK	(IB_QP_STATE | IB_QP_PKEY_INDEX |	\
 				 IB_QP_PORT | IB_QP_ACCESS_FLAGS |	\
@@ -143,6 +276,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	struct ib_qp_init_attr attr = {};
 	struct ib_qp_attr qp_attr = {};
 	u32 qp_attr_mask;
+	struct ib_qp_semantics qp_semantics = {};
 	struct ib_uverbs_qp_cap cap = {};
 	struct ib_rwq_ind_table *rwq_ind_tbl = NULL;
 	struct ib_qp *qp;
@@ -197,6 +331,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	case IB_UVERBS_QPT_UC:
 	case IB_UVERBS_QPT_UD:
 	case IB_UVERBS_QPT_XRC_INI:
+	case IB_UVERBS_QPT_RU:
 	case IB_UVERBS_QPT_DRIVER:
 		if (uverbs_attr_is_valid(attrs,
 					 UVERBS_ATTR_CREATE_QP_XRCD_HANDLE) ||
@@ -271,6 +406,10 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		attr.create_flags |= IB_QP_CREATE_SOURCE_QPN;
 	}
 
+	ret = create_qp_opt_attrs(attrs, device, pd, &attr, &qp_semantics);
+	if (ret)
+		return ret;
+
 	ret = create_qp_attr_set(attrs, device, &attr, &qp_attr,
 				 &qp_attr_mask);
 	if (ret)
@@ -401,6 +540,17 @@ DECLARE_UVERBS_NAMED_METHOD(
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
index 467a872ca395..ad281e565499 100644
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
@@ -1438,11 +1439,15 @@ void ib_qp_usecnt_inc(struct ib_qp *qp)
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
index 61a7ab60da65..83fa94d579c3 100644
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


