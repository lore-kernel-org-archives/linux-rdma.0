Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB734B2055;
	Wed, 14 Oct 2026 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016480; cv=none; b=HDGznzfqfCGl7fzbjLh2ZltMaL6Ct7A8LtWVpeVVbMQE13Klz8AAqM57/ZloIoiF8CyoRME6LjAPWvb8NQ1spFyT3JauQFdj9Kp1MJrUfaWqWPr71a35fe6vofi9MXUZ3sbT/B7tgyOjWIp6SMjmA71A2bABuHx9z/+iiWKtV6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016480; c=relaxed/simple;
	bh=Fl8YPjvuQIf5JQZGvUCr8in34TkTfvrl8pGVhIzB+P4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YJslDdP2rTNGC9Rhi8MCFUwIK2fPEmUH6Z/2iwStExzR4PcVr5A5DbXfU8qBklF5Nz7TLpd/g9uebEOvUG0o9Fcpatm1Jby9hB0mxQ4Y8DujcgVxMyy3YQha5Xkm1RgWzVdgZi3Mmg/M1ixp3DtHdzXYZZajwOhg0iuPDLmvguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujhPHGLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujhPHGLO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25D4EC2BCF5;
	Wed, 14 Oct 2026 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016480;
	bh=Fl8YPjvuQIf5JQZGvUCr8in34TkTfvrl8pGVhIzB+P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ujhPHGLOzJeEHGeMJZiLMkkY+9B5ZhgaokJfyAcT5bYiMHWOVWlEhwS8ZhkbFOVXP
	 RAn3Bilkr+CUXNZujDlCy7BQ1vL/Oq2Tv9d7+pwXG54uQRlaMY0BI1lPW067nyQufI
	 HAQ2TTVQMpEqfKgbJPmoR8Y0dltZVxJ00J4qxrYFhNxupWPN95r46rNWAIfQoZALxo
	 qXQWKcH9ipId+o9ci5lG24bWtXlhvUhh59NDcURcpERVUabxZJf3QzqaCGChtxNIC1
	 ZFgb1iFTZq1vTYqSomOOxUtcHd7syR7nJ2MgW/1uKoJcCpR7IAfhtmSjLEDrJhckLi
	 //fr3qtsFRMVw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EDFCC6B2A;
	Wed, 14 Oct 2026 22:21:20 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Wed, 14 Oct 2026 15:21:21 -0700
Subject: [PATCH rdma-next 12/13] RDMA/core: 64-bit memory keys
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-uet-ib-core-v1-12-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=5447;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=Vu1vDErOxXP3nbf0y703gIP+CzA0WWv+OjC5ASK5//8=;
 b=W9XB/q5jfZMI62jNRiD0UENP62igoBFRYLOF6aFwHv4sv0cisXx6Y1aSyTXbD9e8IE8QodkTN
 nLbUtEfNe+YBbmlmC9DFnIrhcAX/0GAImlvBPCSY439iY2iLXBzyNIV
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

From: Eric Davis <eric.davis@broadcom.com>

A device whose keys are wider than 32 bits has no way to name a region
through lkey and rkey. Carry the wide pair on the region and return it
from registration when userspace asks for it.

The attributes are optional in both directions, so a kernel that does not
know them ignores the request, and a region without a wide key answers
zero.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 40 +++++++++++++++++++++++++++
 include/rdma/ib_verbs.h                       | 12 ++++++--
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  4 +++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 035efba54dcb..2957cae25a7b 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -185,6 +185,16 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_MR)(
 
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_MR_RESP_IOVA,
 			     &mr->iova, sizeof(mr->iova));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_MR_RESP_LKEY64,
+			     &mr->lkey64, sizeof(mr->lkey64));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_MR_RESP_RKEY64,
+			     &mr->rkey64, sizeof(mr->rkey64));
 
 	return IS_UVERBS_COPY_ERR(ret) ? ret : 0;
 }
@@ -367,6 +377,10 @@ static int reg_mr_ex_attr(struct uverbs_attr_bundle *attrs, struct ib_pd *pd,
 		if (ret)
 			return ret;
 
+		/* zero names no wide key, so it can't be one */
+		if (!ex->req_rkey64)
+			return -EINVAL;
+
 		if (ex->req_rkey64 > U32_MAX && !(caps & IB_DEVICE_KEY64))
 			return -EOPNOTSUPP;
 	} else if (uverbs_attr_is_valid(attrs,
@@ -550,6 +564,20 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_RKEY,
 			     &mr->rkey, sizeof(mr->rkey));
+	if (ret)
+		return ret;
+
+	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_REG_MR_RESP_LKEY64)) {
+		ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_LKEY64,
+				     &mr->lkey64, sizeof(mr->lkey64));
+		if (ret)
+			return ret;
+	}
+
+	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_REG_MR_RESP_RKEY64))
+		ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_RKEY64,
+				     &mr->rkey64, sizeof(mr->rkey64));
+
 	return ret;
 }
 
@@ -586,6 +614,12 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UVERBS_ATTR_TYPE(u64),
 			    UA_MANDATORY),
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_MR_RESP_IOVA,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_MR_RESP_LKEY64,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_QUERY_MR_RESP_RKEY64,
 			    UVERBS_ATTR_TYPE(u64),
 			    UA_OPTIONAL));
 
@@ -703,6 +737,12 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_REG_MR_REQ_RKEY64,
 			   UVERBS_ATTR_TYPE(u64),
 			   UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_REG_MR_RESP_LKEY64,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_REG_MR_RESP_RKEY64,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6a0d3a928d97..f9171b47ac1b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2084,6 +2084,9 @@ struct ib_mr {
 		struct list_head	qp_entry;	/* FR */
 	};
 
+	/* 64b keys, set by a driver reporting IB_DEVICE_KEY64, else zero */
+	u64		   lkey64;
+	u64		   rkey64;
 	/* the job this region is restricted to, NULL if it is unrestricted */
 	struct ib_jkey	  *jkey;
 	/* the region this one was derived from, NULL if registered fresh */
@@ -4854,8 +4857,8 @@ static inline u32 ib_inc_rkey(u32 rkey)
 
 /**
  * ib_mr_init_core_refs - clears what core reads back when an MR is
- *   deregistered.
- * @mr: struct ib_mr pointer to initialize.
+ *   deregistered, and the wide keys of an MR on a device without them.
+ * @mr: struct ib_mr pointer to initialize, with its device set.
  *
  * A driver's MR need not be zeroed, so every path that makes an MR calls this.
  */
@@ -4864,6 +4867,11 @@ static inline void ib_mr_init_core_refs(struct ib_mr *mr)
 	mr->jkey = NULL;
 	mr->parent = NULL;
 	atomic_set(&mr->usecnt, 0);
+
+	if (!(mr->device->attrs.device_cap_flags & IB_DEVICE_KEY64)) {
+		mr->lkey64 = 0;
+		mr->rkey64 = 0;
+	}
 }
 
 /**
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index e4f819ccc288..51910240a7e1 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -342,6 +342,8 @@ enum uverbs_attrs_query_mr_cmd_attr_ids {
 	UVERBS_ATTR_QUERY_MR_RESP_RKEY,
 	UVERBS_ATTR_QUERY_MR_RESP_LENGTH,
 	UVERBS_ATTR_QUERY_MR_RESP_IOVA,
+	UVERBS_ATTR_QUERY_MR_RESP_LKEY64,
+	UVERBS_ATTR_QUERY_MR_RESP_RKEY64,
 };
 
 enum uverbs_attrs_reg_dmabuf_mr_cmd_attr_ids {
@@ -373,6 +375,8 @@ enum uverbs_attrs_reg_mr_cmd_attr_ids {
 	UVERBS_ATTR_REG_MR_PARENT_MR_HANDLE,
 	UVERBS_ATTR_REG_MR_DERIVE_CNT,
 	UVERBS_ATTR_REG_MR_REQ_RKEY64,
+	UVERBS_ATTR_REG_MR_RESP_LKEY64,
+	UVERBS_ATTR_REG_MR_RESP_RKEY64,
 };
 
 enum uverbs_attrs_create_counters_cmd_attr_ids {

-- 
2.56.0


