Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465420;
	b=ZAPX3QkfLIdgqcjF95Yt707OyLCBGhUZPaML5sheyMmoBP8u2X/kPmyZFGEiu9jFeGbc
	 JC6Yl8InPZd0i1EOJ0y6jqumuYaV4zHlpRJCNCtPQamvS4TWyr7yIMddXoWcvzdywJaSX
	 B7mFXRgS2QNHAfM8K9hewO529nQUF7iO3tVwCwoRLp3ocOSPlQsPtAPsuqQmDsI4b1Z6j
	 k62jOCqoUREl74dqLG9Wuvi4eGstER3ODs0iCno28KiwYVnnICcT+VY5InJYW8iTDyjzb
	 tA+Q3Qfdkmv4F9gupnYUv0TTBDOpkvilf6DaL665EzwPqFD1cu2lFMPIp1X/tYFnG8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465420;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pK6wkyMg8PY1NA8s9Q2fhUm1/5nSDPtzRuEUvNyD4hU=;
	b=WA0jlv3TcR7ddTeEcKzX53h396LZol6/KKSArobvw5EjRDun+ADNUFtklvI2PLOjnvS3
	 ePAWwt16eVxX/7vYqzA4AlicX2pBuzvAPqzIPDSYuHCNDbIlr8FoEuRk8CRTyh4X9mwei
	 JTt6uh4AM9tSqYlDKwITRgZcbPY/r54g4eyK+igeAbAQvgD+avHJ0FcTjaRE+2eTt3hd9
	 go01SKPOxALJ+TuqmK0aG0ASs5gxDyfRZUL9D+PPGvEc6Rpn+1FlTyqkybbL99jf9DLOF
	 HN1UPLzuF2oGTTu07Szw34pKZntFrsGym6F+Snh1OoGYSs5oluwk6B/zq2kgoW13a+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bNOBpVgQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14864606A329;
	Tue, 20 Oct 2026 03:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bNOBpVgQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465419;
	b=dBvr7g/30qjXxTd7r+63T+lJVWbtxBPbLKHIPKyaGnc06bM9Idu5CcM0g7uQLvgW5uuz
	 rCB88k/f0BNq5QISwRq2PyU0fMyTcNiH+/pcktKlWKJvcMEc8P21bgheZAEgzJ14ii8g5
	 QX43z+S9H4QRsSBuXvip0lg0C2Lu5iYJwSu0Hk8ql/3V1qmegnz7M+PCQE/8+0tsZdf9R
	 +CSfCXjxk4/+Wh+fzDSFVh25jJdGqxahxrZ2mrqmUg78r8XkCz3w2x0zpP6TbNP9Qo4iY
	 kuk1i4K3j2IYXoAFbxIF2DyLB18ZZZ5CYZqFXCvAZEKfVwy9oGcSG6LTqJuRDQdfYdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465419;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pK6wkyMg8PY1NA8s9Q2fhUm1/5nSDPtzRuEUvNyD4hU=;
	b=Z4N7J9f/vDLpfbmDGsqzega79ZHO+8QqFSZAyWS5d03gm89AcdA/8kXsb0cYoA/Yb5PI
	 aAq19PRldLuD/dUWMqSso6m4WsoMLNQUVe/Vm4ljQ1m/VTyjOklP/+dmHD8BBGDDrtG7M
	 GKtM3bs4XamUoMRGnx4K8/fjoOXvFJyg0jvTrhZI4bbnXUG8K9cOq8jOzgiScmALQPfdl
	 vIkCpfMMjlkhgl3uO2tienMZwM8i+IcARomtJXfWy3zBTd+oIAWHRSaNaSB2MMwdq92vZ
	 YjjtYPlsB3jnHNGrqmytmMbxul14xuXHoNqiYWInIM92ReEcuGctQVMznb2MMda5J/w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A09BF1F000C4;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465419;
	bh=pK6wkyMg8PY1NA8s9Q2fhUm1/5nSDPtzRuEUvNyD4hU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bNOBpVgQ5xbHz6tO79Q+4/ozo7ocL1w5jLfZ8/FF2PKwGx6BlhIQLuSqq90s97j84
	 D1CUd0HBXRC2dYq0tdsvHMswFes2vFxvZKAlaG7xwv8OM5itJianDCg8MZZcIedFX1
	 6Tn5S6xGcf2EuWxB10addXErv8pO7s8YTA07UtRjZ9Gu5fVFvctbOhs3pACoN1spvk
	 w6VjnWYjNZ0+nupbbmoz0R8qo6ZkhuJo3oLfnsPqLCt/fw285Lcuo4/4jich50OcQB
	 JQ8k55iTUx2wMuHA15iE85Qxa1ekVaHa2cTXaW8shYg/AtISnT0ahnM9MdO1IIdo7q
	 g78FV8Hvi/8Kw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B70B40724;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:36 -0700
Subject: [PATCH rdma-next v2 09/13] RDMA/core: create a queue pair ready to
 send
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
Message-Id: <20261019-uet-ib-core-v2-9-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=5409;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=fjYmbaM78O8z3VKnOCRv57FNmInPGNiFJkeFjQOBCYs=;
 b=2WNAco30kBPtpprRz/gCTLreO/yJdUztsPp/I1zeg1BoUUjrLKb4uEYL9nVOM+t0NRHw+2O4B
 GYrfQQE6AY+B09DdKu7Tog1T9IHKOHxWYswveS8eD1enLTcSMr7NaOx
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Some transports have nothing to negotiate, so a queue pair can be ready
to send the moment it exists and the modify sequence carries no useful
information. Let a reliable unconnected queue pair be created with the
attributes that sequence would have supplied, in the same form the
modify command uses, and apply them as that modify to RTS once the
queue pair exists, so its checks run. A queue pair whose modify fails
is destroyed.

Note that the QP handle field is refused, since the create is what makes
the handle.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_std_types_qp.c | 80 +++++++++++++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  1 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 30fc20fb251f..c6225156fe30 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -79,6 +79,61 @@ static void set_caps(struct ib_qp_init_attr *attr,
 	}
 }
 
+/* what a reliable unconnected QP may be created ready to send with */
+#define CREATE_QP_ATTR_RU_MASK	(IB_QP_STATE | IB_QP_PKEY_INDEX |	\
+				 IB_QP_PORT | IB_QP_ACCESS_FLAGS |	\
+				 IB_QP_PATH_MTU)
+
+/* The attributes the QP would be modified with via modify_qp calls. Used for
+ * implementations that support having QPs be in RTS immediately after QP
+ * creation. These attributes arrive in the same format the modify command
+ * uses so that converter serves both, and they are applied as that modify
+ * to RTS, once the QP exists.
+ */
+static int create_qp_attr_set(struct uverbs_attr_bundle *attrs,
+			      struct ib_device *device,
+			      struct ib_qp_init_attr *attr,
+			      struct ib_qp_attr *qp_attr, u32 *mask)
+{
+	struct ib_uverbs_ex_modify_qp uqpa = {};
+	int ret;
+
+	*mask = 0;
+
+	if (!uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_ATTR))
+		return 0;
+
+	if (attr->qp_type != IB_QPT_RU ||
+	    !(device->attrs.device_cap_flags & IB_DEVICE_RU))
+		return -EOPNOTSUPP;
+
+	ret = uverbs_copy_from_or_zero(&uqpa, attrs,
+				       UVERBS_ATTR_CREATE_QP_ATTR);
+	if (ret)
+		return ret;
+
+	/* the create is what makes the handle, can't be one specified */
+	if (uqpa.base.qp_handle)
+		return -EINVAL;
+
+	if (uqpa.reserved || uqpa.base.reserved[0] || uqpa.base.reserved[1])
+		return -EINVAL;
+
+	ret = ib_uverbs_copy_qp_attr(attrs, device, qp_attr, &uqpa,
+				     uqpa.base.attr_mask);
+	if (ret)
+		return ret;
+
+	if ((uqpa.base.attr_mask & ~CREATE_QP_ATTR_RU_MASK) ||
+	    ((uqpa.base.attr_mask & IB_QP_STATE) &&
+	     uqpa.base.qp_state != IB_QPS_RTS))
+		return -EINVAL;
+
+	*mask = uqpa.base.attr_mask;
+
+	return 0;
+}
+
 static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	struct uverbs_attr_bundle *attrs)
 {
@@ -86,6 +141,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		uverbs_attr_get_uobject(attrs, UVERBS_ATTR_CREATE_QP_HANDLE),
 		typeof(*obj), uevent.uobject);
 	struct ib_qp_init_attr attr = {};
+	struct ib_qp_attr qp_attr = {};
+	u32 qp_attr_mask;
 	struct ib_uverbs_qp_cap cap = {};
 	struct ib_rwq_ind_table *rwq_ind_tbl = NULL;
 	struct ib_qp *qp;
@@ -214,6 +271,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		attr.create_flags |= IB_QP_CREATE_SOURCE_QPN;
 	}
 
+	ret = create_qp_attr_set(attrs, device, &attr, &qp_attr,
+				 &qp_attr_mask);
+	if (ret)
+		return ret;
+
 	srq = uverbs_attr_get_obj(attrs,
 				  UVERBS_ATTR_CREATE_QP_SRQ_HANDLE);
 	if (!IS_ERR(srq)) {
@@ -264,6 +326,20 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	obj->uevent.uobject.object = qp;
 	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_QP_HANDLE);
 
+	/* A reliable unconnected QP is ready to send once created. What the
+	 * caller passed is applied as the modify to RTS it stands in for, so
+	 * the modify's checks run. A failure here destroys the QP.
+	 */
+	if (attr.qp_type == IB_QPT_RU) {
+		qp_attr.qp_state = IB_QPS_RTS;
+		/* the driver's data was for create, there is none for this */
+		ret = ib_modify_qp_with_udata(qp, &qp_attr,
+					      qp_attr_mask | IB_QP_STATE,
+					      uverbs_get_cleared_udata(attrs));
+		if (ret)
+			return ret;
+	}
+
 	set_caps(&attr, &cap, false);
 	ret = uverbs_copy_to_struct_or_zero(attrs,
 					UVERBS_ATTR_CREATE_QP_RESP_CAP, &cap,
@@ -325,6 +401,10 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_CREATE_QP_FLAGS,
 			     enum ib_uverbs_qp_create_flags,
 			     UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_QP_ATTR,
+			   UVERBS_ATTR_STRUCT(struct ib_uverbs_ex_modify_qp,
+					      reserved),
+			   UA_OPTIONAL),
 	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_QP_SOURCE_QPN,
 			   UVERBS_ATTR_TYPE(u32),
 			   UA_OPTIONAL),
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 70de1e4001c3..b2bf8ca92397 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -179,6 +179,7 @@ enum uverbs_attrs_create_qp_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_QP_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+	UVERBS_ATTR_CREATE_QP_ATTR,
 };
 
 enum uverbs_attrs_destroy_qp_cmd_attr_ids {

-- 
2.56.0


