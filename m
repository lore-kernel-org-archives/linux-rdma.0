Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7344AE12F;
	Wed, 14 Oct 2026 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016480; cv=none; b=bPKijpmTlIOebf7RfxyGBD0iXDwd7SGEf0kqGWQsEeLN3x/1EfVAPug8byEYQZlemut8nD1gMApa82e98QIJfjjikBdc5fv/gT07g7n1AiEZKXD2G09BrEJA46wEg6vjj9nlibixdoCTJlBDQFGcnD4OFSo2gzQTiVOtTM+CPcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016480; c=relaxed/simple;
	bh=hV8+lO7X1LWEul6nJAUTgV3sXc4FYwDegQYOqRYifXU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NvagZgWcyb/AVyoHv5P/NtidSnNzcqdj+hv4zSAv2bYdVMqtYaOrz+bFg/jeZkuPAayWotFfAbmWIynyq4D1Mmeg8V/4ozYkPigXS3cckQnBlIqTfp8VaO0RjBfq64sGkeeowjMkGbcjA91p1EItcetOxuzAY+0YonNQ0MjiDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LetjE07h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LetjE07h"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E49C4C2BCFD;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016479;
	bh=hV8+lO7X1LWEul6nJAUTgV3sXc4FYwDegQYOqRYifXU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LetjE07hX8v0A7QHtmbRyOCUlzAPTtz7iUB+xM8bjB75dDwcVMAGgVFoxUevd0Fkb
	 n+0YeHx4N64dzc8GrUJwoAkfltMhj/BXtzLJewQ83I7UwwTmrT73/VoI961o020eLx
	 UYp/OZt7Avqgss4sqzVMzyghfME68/U73zFC1hg1a1p1HWeJvZgRZB1Ivm2fNQZ8h+
	 aD3egQ5F2zbc/ZyuEiZCJkm8g6OYc7qaSKb4GdCJ3Tq49+ndNgEfrOozthFaVRIItB
	 CwrwxwqQsrOi+ldklOcq7zzW9v5RsjBk4QneBXPlg0xnSdAlJVmvunUdjrTC5LK9dE
	 CArrHWMnqIzng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D384ECC6B33;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Wed, 14 Oct 2026 15:21:18 -0700
Subject: [PATCH rdma-next 09/13] RDMA/core: create a queue pair ready to
 send
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-uet-ib-core-v1-9-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=5409;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=/sxaO3vKB9ap9YO4IWz6G2w9/IndRfdDPvVURUBqodY=;
 b=VY2Y41tBBmMGAxyyEUHiyGNtkUWJfssvvIFQ3k50KrUR6i55jzrtHpJcpOTN2LshGDWmPodfr
 33QglJkiRjIBZYRuzvaIFTei3byC7AT+y4ifXfrJP3ZwNpg6GhO/yYl
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

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
index 29abfbd227bc..6a0cd11e7b31 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -178,6 +178,7 @@ enum uverbs_attrs_create_qp_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_QP_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM,
 	UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM,
+	UVERBS_ATTR_CREATE_QP_ATTR,
 };
 
 enum uverbs_attrs_destroy_qp_cmd_attr_ids {

-- 
2.56.0


