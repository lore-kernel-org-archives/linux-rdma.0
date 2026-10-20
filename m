Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465421;
	b=0Ix765M3oBPKpGVKcrz1ayJ50/ezs8a7FBELio4Vnh5vTociA7TCL/TBUJw1h1dTNfqA
	 DfsbZ7OAexNP+iws4dyKVCDDOZ5SDkqcWb5T7CKOivbU19Ebvj1G997d+Cj4/6jK20pwF
	 DBnNRYciijrtKQ7R0YOEjDUUHL7MLi5zYgAgHuL1mSOTMIs6INzLV7fPIG0uzNehFqvV+
	 jhnmrfO8z/H8vAx6Bs0iHoxmWnLdbVTEaB/LbC0jz81puEfIpDtEEGqjrTdvKf56CUJKN
	 7T6wmtezR1iCwE0RyA2XJtJUNWoySwAqx5eKYkN7H/JuorlsvyYjvfw4Gj9iMoOv67A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465421;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/Ab1uh8YHWrWUgLpyXRzWn4Xs0wb7H5DHI2xo0MMUWs=;
	b=q0GMtBwwWtXxmIxx15NMYzv0oMfDpQ9oeCYs++axLxcVYTiVf+jy56S1fv5GJdC/k2Cn
	 eZcGVorGPruYjkWODSoejpoed5r7fKoju+pbcbwS50GRB1O2cFgpkJFcHNztIbE93ssQY
	 bAMsZp+KUmLxjVLcLLggg8pANYnDR9x5CKs/8JLYXKjL5vymx1LV1yw5lsH1ZjNtZY70z
	 WaxPGHYsJt/jczBidMmTiITrfIxUUOMZzMaWN6Jt7SYUPGIJI5uf6+fC198e/3+lHOw5a
	 y/te1nWaWLh/l4ijRmY01s4ziAhUpXVTELtPmEiXMAUoHYuRftNUpf5wU6e+1OwX4Kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e50M4s84;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05679606A331;
	Tue, 20 Oct 2026 03:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e50M4s84
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465420;
	b=yU7GwA/+/yc7n0bmmahiR3hVyO3lSz4wbtfbrC3v3uMnJvSC2KOIrYDbLQ4DoRmTxgK5
	 FuhzB0J3HqxSJiXlTAQMo6ahT0iouAMjjgYoPJoreyo1yOc0yVd2o4BD00I+NlyGGjngp
	 tjbj0hYEyz8qP94b83c7xBKkN7trQXqVrhPUJ/DHS49NUhbXH8BN6qUJZ9A/vtJCIudTQ
	 lBmIlmVVceuS5Ga32xJXPh7qjLyCAUToHLMVTIr/6Gy0gcFcDBLwIz2XebBQAvOa1hoIc
	 uOhXvggg/imvIoRd39xYrX1wi30CdS2LlaazZe7wXnrDq6qxZPhFhSFjVZsq26s3+Iw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465420;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/Ab1uh8YHWrWUgLpyXRzWn4Xs0wb7H5DHI2xo0MMUWs=;
	b=OpUFSw9+S/ySl34yHrdTuf7ptoBZQgFLx16zRyePNh8TDjB38zuyNOma29wV6VraEaf/
	 3Obo1JkHkZTAKSPTQw3hgBbFCNLFvpiLhHqztlb5IELZ3Nx1kPAlUwU1nF5tR5/4Afg5S
	 rVKhpggBJiFG5MNJVgGxT5U4WKD+08Sm40SQ9Cpm/1+HqlN3xP5/2A4KOocPqjluFf7D7
	 GIo1/MAU2wxF6BGWpMethFt4x0+llwSbdjx10TDJl+NiSM1rLqKMFvTj3tLybKyuCKfJ4
	 MfEZoqcmaUq77g3DMXtt9yZDMml5sJcN79NRCvklvpz63HIOdj3414X/kjjCZVJlmIA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 03E141F000C8;
	Tue, 20 Oct 2026 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465420;
	bh=/Ab1uh8YHWrWUgLpyXRzWn4Xs0wb7H5DHI2xo0MMUWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=e50M4s8476weDuheny02SJGVt4EmSGoovYrBBZQ8nXzr7jx/TPSrML2+MwH1azd6M
	 egMg4OY0PXGhamLmdrNZ4YOqjyGee8jeJz91UqI6srOKeTg9rGCeTQfSz6w4B44CAl
	 DdTme9HTosVBP1D5GDIO5zCYIFaGAg/Cv5I91/H8NnfV4XIopwyYqcYzNjqMdHJq1B
	 eh23l4ikhhgDlzDcPt5idqAW6WC1bQqd57PJbkz/23sDL2sQdgybHlr47R8RKHc6Xl
	 h2pnnHSbn2p5DXdtukzt6tH77Fa/EKCyA/wyJkHIA/a86ft2P14qRp8lMc9/GsBWcT
	 m90zlVOoecXAA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 644DE40738;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:40 -0700
Subject: [PATCH rdma-next v2 13/13] RDMA/core: attach a memory region to a
 queue pair
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
Message-Id: <20261019-uet-ib-core-v2-13-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=9799;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=ALqFoJYTLaBFCfFuLMaETtzQCAzr0/lH33oJ0clrtDI=;
 b=d26wyw9Mamzxg5YxMEpkab3TO2Z1qwnBQbF93z7fwUZVoPT+yrBlXauJywVRpQU0FHy5KQyqU
 qjHFyLNYLpSBBaAqaPSAPiEwX+uUZQctu9osgmd5hRpnBV37UR5DLD8
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

A region registered against a protection domain is reachable from every QP
in it. When a device can narrow that, let a region be attached to one QP
and detached again, so the network only reaches the MR over that QP.

Which restrictions a device supports is reported through the memory region
access capability bits.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/device.c              |   2 +
 drivers/infiniband/core/uverbs_std_types_mr.c |   2 +-
 drivers/infiniband/core/uverbs_std_types_qp.c | 110 +++++++++++++++++++++++++-
 drivers/infiniband/core/verbs.c               |  10 +++
 include/rdma/ib_verbs.h                       |  11 ++-
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  12 +++
 6 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index fd45decf9c4f..1b838bf3600d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3018,6 +3018,8 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, query_pkey);
 	SET_DEVICE_OP(dev_ops, query_port);
 	SET_DEVICE_OP(dev_ops, query_port_speed);
+	SET_DEVICE_OP(dev_ops, qp_attach_mr);
+	SET_DEVICE_OP(dev_ops, qp_detach_mr);
 	SET_DEVICE_OP(dev_ops, query_qp);
 	SET_DEVICE_OP(dev_ops, query_qp_semantics);
 	SET_DEVICE_OP(dev_ops, query_srq);
diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 1ff45556e0b2..cb33d4e66507 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -42,7 +42,7 @@ static int uverbs_free_mr(struct ib_uobject *uobject,
 {
 	struct ib_mr *mr = uobject->object;
 
-	/* regions derived from this one still use it */
+	/* regions derived from this one, or the QP it is attached to, use it */
 	if (atomic_read(&mr->usecnt))
 		return -EBUSY;
 
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 47ca994f9ac9..4593965069f1 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -666,12 +666,120 @@ DECLARE_UVERBS_NAMED_METHOD(
 			     enum ib_uverbs_qp_attach_comp_cntr_op,
 			     UA_MANDATORY));
 
+/* bind a region to the QP that will use it */
+static int UVERBS_HANDLER(UVERBS_METHOD_QP_ATTACH_MR)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_qp *qp =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_ATTACH_MR_QP_HANDLE);
+	struct ib_mr *mr =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_ATTACH_MR_MR_HANDLE);
+	u64 caps = qp->device->attrs.device_cap_flags;
+	u32 id;
+	int ret;
+
+	if (!qp->device->ops.qp_attach_mr)
+		return -EOPNOTSUPP;
+
+	if (qp->real_qp != qp || qp->qp_type != IB_QPT_RU)
+		return -EINVAL;
+
+	if (mr->pd != qp->pd || mr->type != IB_MR_TYPE_USER)
+		return -EINVAL;
+
+	/* the device has to implement the access class the region asks for */
+	if (!(caps & (mr->jkey ? IB_DEVICE_MR_QP_JOB_RESTRICTED :
+				 IB_DEVICE_MR_QP_RESTRICTED)))
+		return -EOPNOTSUPP;
+
+	/* a region restricted to a job serves a QP in that job */
+	if (mr->jkey && (!qp->jkey || qp->jkey->job != mr->jkey->job))
+		return -EINVAL;
+
+	/* one QP at a time */
+	if (cmpxchg(&mr->attached_qp, NULL, qp))
+		return -EBUSY;
+
+	ret = xa_alloc(&qp->attached_mrs, &id, mr, xa_limit_32b, GFP_KERNEL);
+	if (ret)
+		goto err_claim;
+
+	ret = qp->device->ops.qp_attach_mr(qp, mr);
+	if (ret)
+		goto err_xa;
+
+	/* the QP holds the region until detach or its own destroy */
+	mr->attach_id = id;
+	atomic_inc(&mr->usecnt);
+
+	return 0;
+
+err_xa:
+	xa_erase(&qp->attached_mrs, id);
+err_claim:
+	WRITE_ONCE(mr->attached_qp, NULL);
+	return ret;
+}
+
+static int UVERBS_HANDLER(UVERBS_METHOD_QP_DETACH_MR)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_qp *qp =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_DETACH_MR_QP_HANDLE);
+	struct ib_mr *mr =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_QP_DETACH_MR_MR_HANDLE);
+	int ret;
+
+	if (!qp->device->ops.qp_detach_mr)
+		return -EOPNOTSUPP;
+
+	if (qp->real_qp != qp)
+		return -EINVAL;
+
+	if (READ_ONCE(mr->attached_qp) != qp)
+		return -EINVAL;
+
+	ret = qp->device->ops.qp_detach_mr(qp, mr);
+	if (ret)
+		return ret;
+
+	xa_erase(&qp->attached_mrs, mr->attach_id);
+	WRITE_ONCE(mr->attached_qp, NULL);
+	atomic_dec(&mr->usecnt);
+
+	return 0;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_QP_ATTACH_MR,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_ATTACH_MR_QP_HANDLE,
+			UVERBS_OBJECT_QP,
+			UVERBS_ACCESS_WRITE,
+			UA_MANDATORY),
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_ATTACH_MR_MR_HANDLE,
+			UVERBS_OBJECT_MR,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_QP_DETACH_MR,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_DETACH_MR_QP_HANDLE,
+			UVERBS_OBJECT_QP,
+			UVERBS_ACCESS_WRITE,
+			UA_MANDATORY),
+	UVERBS_ATTR_IDR(UVERBS_ATTR_QP_DETACH_MR_MR_HANDLE,
+			UVERBS_OBJECT_MR,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY));
+
 DECLARE_UVERBS_NAMED_OBJECT(
 	UVERBS_OBJECT_QP,
 	UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), uverbs_free_qp),
 	&UVERBS_METHOD(UVERBS_METHOD_QP_CREATE),
 	&UVERBS_METHOD(UVERBS_METHOD_QP_DESTROY),
-	&UVERBS_METHOD(UVERBS_METHOD_QP_ATTACH_COMP_CNTR));
+	&UVERBS_METHOD(UVERBS_METHOD_QP_ATTACH_COMP_CNTR),
+	&UVERBS_METHOD(UVERBS_METHOD_QP_ATTACH_MR),
+	&UVERBS_METHOD(UVERBS_METHOD_QP_DETACH_MR));
 
 const struct uapi_definition uverbs_def_obj_qp[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_QP,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ca5eac4a96b3..adcda33b04f2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1351,6 +1351,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 
 	spin_lock_init(&qp->mr_lock);
 	xa_init(&qp->comp_cntrs);
+	xa_init_flags(&qp->attached_mrs, XA_FLAGS_ALLOC);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
 	INIT_LIST_HEAD(&qp->sig_mrs);
 	init_completion(&qp->srq_completion);
@@ -1385,6 +1386,7 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 err_create:
 	rdma_restrack_put(&qp->res);
 	xa_destroy(&qp->comp_cntrs);
+	xa_destroy(&qp->attached_mrs);
 	kfree(qp);
 	return ERR_PTR(ret);
 
@@ -2212,6 +2214,7 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	struct ib_qp_security *sec;
 	struct ib_comp_cntr *cc;
 	unsigned long index;
+	struct ib_mr *mr;
 	int ret;
 
 	WARN_ON_ONCE(qp->mrs_used > 0);
@@ -2249,6 +2252,13 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 		atomic_dec(&cc->usecnt);
 	xa_destroy(&qp->comp_cntrs);
 
+	/* the driver ended the bindings with the QP, release the regions */
+	xa_for_each(&qp->attached_mrs, index, mr) {
+		WRITE_ONCE(mr->attached_qp, NULL);
+		atomic_dec(&mr->usecnt);
+	}
+	xa_destroy(&qp->attached_mrs);
+
 	ib_qp_usecnt_dec(qp);
 	if (sec)
 		ib_destroy_qp_security_end(sec);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 725b630a3b90..a93715323ad5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2003,6 +2003,8 @@ struct ib_qp {
 	struct list_head	xrcd_list;
 	struct xarray		comp_cntrs; /* op_mask -> comp_cntr */
 	u32			comp_cntr_op_mask;
+	/* regions attached to this QP, each held until detach or destroy */
+	struct xarray		attached_mrs;
 
 	/* count times opened, mcast attaches, flow attaches */
 	atomic_t		usecnt;
@@ -2091,8 +2093,11 @@ struct ib_mr {
 	struct ib_jkey	  *jkey;
 	/* the region this one was derived from, NULL if registered fresh */
 	struct ib_mr	  *parent;
-	/* regions derived from this one that are still registered */
+	/* regions derived from this one, and an attachment, that hold it */
 	atomic_t	   usecnt;
+	/* the QP this region is attached to, NULL if none */
+	struct ib_qp	  *attached_qp;
+	u32		   attach_id; /* index in attached_qp->attached_mrs */
 
 	struct ib_dm      *dm;
 	struct ib_sig_attrs *sig_attrs; /* only for IB_MR_TYPE_INTEGRITY MRs */
@@ -2844,6 +2849,9 @@ struct ib_device_ops {
 					struct ib_mr_ex_attr *attr,
 					struct ib_udata *udata);
 	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
+	/* attach/detach a region so it is bound to single QP (restricted) */
+	int (*qp_attach_mr)(struct ib_qp *qp, struct ib_mr *mr);
+	int (*qp_detach_mr)(struct ib_qp *qp, struct ib_mr *mr);
 	int (*query_qp_semantics)(struct ib_device *device,
 				  enum ib_qp_type qp_type,
 				  struct ib_qp_semantics *sem);
@@ -4863,6 +4871,7 @@ static inline void ib_mr_init_core_refs(struct ib_mr *mr)
 {
 	mr->jkey = NULL;
 	mr->parent = NULL;
+	mr->attached_qp = NULL;
 	atomic_set(&mr->usecnt, 0);
 
 	if (!(mr->device->attrs.device_cap_flags & IB_DEVICE_KEY64)) {
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index bc2797fc37fe..8de110b8db34 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -200,6 +200,18 @@ enum uverbs_methods_qp {
 	UVERBS_METHOD_QP_CREATE,
 	UVERBS_METHOD_QP_DESTROY,
 	UVERBS_METHOD_QP_ATTACH_COMP_CNTR,
+	UVERBS_METHOD_QP_ATTACH_MR,
+	UVERBS_METHOD_QP_DETACH_MR,
+};
+
+enum uverbs_attrs_qp_attach_mr_cmd_attr_ids {
+	UVERBS_ATTR_QP_ATTACH_MR_QP_HANDLE,
+	UVERBS_ATTR_QP_ATTACH_MR_MR_HANDLE,
+};
+
+enum uverbs_attrs_qp_detach_mr_cmd_attr_ids {
+	UVERBS_ATTR_QP_DETACH_MR_QP_HANDLE,
+	UVERBS_ATTR_QP_DETACH_MR_MR_HANDLE,
 };
 
 enum uverbs_attrs_create_srq_cmd_attr_ids {

-- 
2.56.0


