Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283266;
	b=Vw3hYtZKSV0P4g1HdmBLM5/yrxjdGakXoE7nIB4+3YvFS9nRp4hJRniJf2aed6Rnmd+A
	 3y+7rcOg90EqdGbfgGlGA0dHNjqnl5NltH0SOVx99QUXabN4GNI1myprVxiQTXpFgfl+F
	 791CItPE+oGo/opU5ojbQnRUH/xc43wd0lTOhzhxbflfwcpSxCaGSvXk7f0cYVCkDAdrb
	 rFN7MlMy3A/VDEj4MAbkChvKUDZtGVRs1lAc6nv58nyWPkjXQrXr+wb03uE440mbwbiIn
	 OtNFruUy1MFwAinCWjrRZ63AW4ic/bVkLqNT76pAwdlC6WoVoEChVG+iXM033+Mbcfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283266;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Wcknj0PS0gKmzkViGSH6RfNJju+kMe3lNhdoIq9cq8I=;
	b=LAtCdj2QSw8j6Ym7YN6awIicGBMQP9RgpxXSMdPOsepAtbP9aeYVXGX73Y4gcD3EWaoq
	 pucfBOXDMh+ib0M7BHdQzuMGb6sVqemlbn0EyTwyV9BvuCJV7sY/vtSadvRtYlmG8d49+
	 VrRvxw31rXwRdgDCGUOGToYEpjP95FHkKucFsNndy/2yCWYYmRD6ixub7+tjiSh4WTi+W
	 GJopjByo2P0wggxWvq+oh2stHO05mIJU3MCd1pDxIGGdBn8GfQzf9S4V8n7gvnjcc7QkV
	 pSqT9eOtN3TWnSmrcUNOrvGhN7Acxq6Iz4ggLiLM3mRqOQ+/QzZYQl0jLmytfnP5ptA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIkahEjy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2980160A263E;
	Tue, 10 Nov 2026 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIkahEjy
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283266;
	b=JssqFgWuNz0HYxrqMgtDByHsNFDB6xyZj9DDIte+dOr7l2qc35BLWYWGsANoJPVbj/Nf
	 uMtrrKp4LhROcxXa2hYCD7CRvJaaJL5aP5dOg7BMm0MxPdnJW1qvaDpkCB4KnYZP8wh2W
	 bYYFiyg12X0tXfwRqAvoxw00GFf2/qzulnQS8yFzzAeTHKWHxBXTXiBl2rV4kuQH2Y2uP
	 0YX4FJC5VxRd3urzgVc0PffL7Kt0yvoY5JA7sAXlsDcc8iuHBB1UOuFqwa2gEVusn+8Hh
	 GeGgmsXWzWvqqDEacXi5lz6jp+ZY6bhnXuztRF0eYgSCsFd7dG4IoNJup6K7QvJeSpg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283266;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Wcknj0PS0gKmzkViGSH6RfNJju+kMe3lNhdoIq9cq8I=;
	b=2D2kSoLIOjVLEDOc+U26NED2p6PfnBSzowmL/YuRaHF/w0XelvZSKQ0i42VLxw5Q4kJ6
	 1voz5joBq+6krTU5vlR6B0OEaAaKRKO+s7daP4LkXAhUozItZI0DRDDofCoFRvrCfPh3p
	 RFTpTYoH1hn1j/MdfGy8I3yXdEvgUzswe++zdtzlO+4dCH4ey1a9vAvuGQVaI6Pq0Dgdn
	 p+VY5gTYUcvEelIpCfp2P/sxBZ26D5bp7UbC5RqAy95LUeIdOcmtvm7II0eXPXUgaRNNF
	 0k372JT0Ba75bv9pBl0T04cdTw6GMcJkZhsYPfYEs5aiWMEf158GpybUYwSLh4TXQIw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 96E8C1F008A3;
	Tue, 10 Nov 2026 04:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283266;
	bh=Wcknj0PS0gKmzkViGSH6RfNJju+kMe3lNhdoIq9cq8I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kIkahEjyzPD+uEqqqO4Vu/iECvPi8K60gpCdueAe8h1WQI4xY4n+vPggfQm+UGRcv
	 ZnEf7/j8fto5NuIA5sNOlEnkF0Ntek/H7d2uUX3n7+5SCTdKvy+zKIf4VmCRLnGJzI
	 bawZJSYXIuxJ2bRz3khRJpZROXcdLiGb/QHF/GLg+8neqoN+58kxLwG+wN55kEoxoq
	 04vMEBJiO1wP1zHaV10ORRmKJcc0j31qzWmoM6Naw2QwYZ71lX5z9HbH1rDRXfpa8u
	 3B94xpx4FRhKhwetUTC99WlNGej5wdVj/lIAV751mrFWWTFgu6Fg16SDgVjbsSMzuL
	 sLosLssbi594g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 385C74881C;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:42 -0800
Subject: [PATCH rdma-next v3 09/13] RDMA/core: create a queue pair ready to
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
Message-Id: <20261109-uet-ib-core-v3-9-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=7643;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=RLqM2vMCS4FzK/n1c8OJ0ZmKdIsM7d9SdyGOyBsW8m4=;
 b=yailhHz+PLGtGlY0fXCISgclHO3lsz6T1G8hfmJIcTq+o9fVYQ6bAU627EBMyzEU3cbhu5Tgw
 QRinXm7NoLpCEl3rTHM5QlUFBbKHvglIJFfiptfQQ/Se2ZZy0+2q1p+
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
is destroyed, and a later modify may change no more than those
attributes.

Note that the QP handle field is refused, since the create is what makes
the handle.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs.h              |  7 +++
 drivers/infiniband/core/uverbs_cmd.c          |  6 +++
 drivers/infiniband/core/uverbs_std_types_qp.c | 74 +++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c               |  7 ++-
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  1 +
 5 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 65a217bf65b5..59015a7a52f6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -325,6 +325,13 @@ int ib_uverbs_copy_qp_attr(struct uverbs_attr_bundle *attrs,
 			   const struct ib_uverbs_ex_modify_qp *src,
 			   u32 mask);
 
+/* what a reliable unconnected QP is created ready to send with, and all a
+ * later modify may change
+ */
+#define QP_ATTR_RU_MASK		(IB_QP_STATE | IB_QP_PKEY_INDEX |	\
+				 IB_QP_PORT | IB_QP_ACCESS_FLAGS |	\
+				 IB_QP_PATH_MTU)
+
 int ib_uverbs_kern_spec_to_ib_spec_filter(enum ib_flow_spec_type type,
 					  const void *kern_spec_mask,
 					  const void *kern_spec_val,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 140f1cf91527..afe891e7b42d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1913,6 +1913,12 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 		goto out;
 	}
 
+	if (qp->qp_type == IB_QPT_RU &&
+	    (cmd->base.attr_mask & ~QP_ATTR_RU_MASK)) {
+		ret = -EINVAL;
+		goto release_qp;
+	}
+
 	if ((cmd->base.attr_mask & IB_QP_AV)) {
 		if (cmd->base.attr_mask & IB_QP_STATE &&
 		    cmd->base.qp_state == IB_QPS_RTR) {
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 30fc20fb251f..249206d2992f 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -79,6 +79,55 @@ static void set_caps(struct ib_qp_init_attr *attr,
 	}
 }
 
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
+	if (attr->qp_type != IB_QPT_RU)
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
+	if ((uqpa.base.attr_mask & ~QP_ATTR_RU_MASK) ||
+	    ((uqpa.base.attr_mask & IB_QP_STATE) &&
+	     uqpa.base.qp_state != IB_QPS_RTS))
+		return -EINVAL;
+
+	ret = ib_uverbs_copy_qp_attr(attrs, device, qp_attr, &uqpa,
+				     uqpa.base.attr_mask);
+	if (ret)
+		return ret;
+
+	*mask = uqpa.base.attr_mask;
+
+	return 0;
+}
+
 static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	struct uverbs_attr_bundle *attrs)
 {
@@ -86,6 +135,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		uverbs_attr_get_uobject(attrs, UVERBS_ATTR_CREATE_QP_HANDLE),
 		typeof(*obj), uevent.uobject);
 	struct ib_qp_init_attr attr = {};
+	struct ib_qp_attr qp_attr = {};
+	u32 qp_attr_mask;
 	struct ib_uverbs_qp_cap cap = {};
 	struct ib_rwq_ind_table *rwq_ind_tbl = NULL;
 	struct ib_qp *qp;
@@ -214,6 +265,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
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
@@ -264,6 +320,20 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
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
@@ -325,6 +395,10 @@ DECLARE_UVERBS_NAMED_METHOD(
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
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 09b247462e65..3b551979e52f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1973,10 +1973,13 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 
 	/*
 	 * Bind this qp to a counter automatically based on the rdma counter
-	 * rules. This only set in RST2INIT with port specified
+	 * rules. This only set in RST2INIT with port specified, or in the
+	 * RST2RTS an RU QP is created with
 	 */
 	if (!qp->counter && (attr_mask & IB_QP_PORT) &&
-	    ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_INIT))
+	    (attr_mask & IB_QP_STATE) &&
+	    (attr->qp_state == IB_QPS_INIT ||
+	     (qp->qp_type == IB_QPT_RU && attr->qp_state == IB_QPS_RTS)))
 		rdma_counter_bind_qp_auto(qp, attr->port_num);
 
 	ret = ib_security_modify_qp(qp, attr, attr_mask, udata);
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


