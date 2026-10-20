Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465420;
	b=eXC1QtuVXeT0hRLvEs3y+nbB5pKwIjJxdtvrAYwHMXwiy4yyS5J8lh/8yUtq5z/jO0tz
	 77Nv/K+pDqaernP+n254POqqeG14mIJJYZRqFL09bV05P7r9jRTeTbQsfQArfSFuEayLJ
	 jAAuFfu99ja3HiviIDNihHPfI+6c3v/s/2r5F6iaGxDWFwDIJ0IChrgGBKOMGlGMyiZ+K
	 ++nrdAvsGRG+3H95bSO+vxmAPopOdEkCkJK0oHy6l4ce8JYeAQnxRXzuik52ww0y4LVNf
	 qk+v9bpKyRDANm/dari+hGGH91sunzmV8Hxx1hWAm4+lQi8M81kOD2HWWtJUCq5N2fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465420;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rJA1ME9aVJPVdall37Fza1eaMeNcz0GRgu+xg/WPTE8=;
	b=5C2n5MZw3IUryk1UIzJEdTyMhrz+EKl7KMMoe4yfmbYBonEa9s2L4i1zaXuzek2m+twO
	 AY0Zj8OGXaXuDXyZFQPQTCh8/ycb+IB/+EYYWFfl03E8er6SDDGI+I3IOscKgpmwaRxTY
	 FRVIcZMyOIFqUKBhjvY9RhewWZwK9Ao6XaEPhZQZAc9j72FXWphKrAzBaEZTbe+jXe0KU
	 aHzefniVZel9fUGXre5vfW+F+cQDn16fJFrGHlNgsOACp2YS4LHb1mz8Xec7WrMHsks4g
	 iuTMaUdbSPmf3owmfPIEncOnM1aESqTBFHDE2AvdX1uPKs5mTFe58m+bORGnYpj879Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYAExmkm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE160A2603;
	Tue, 20 Oct 2026 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYAExmkm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465419;
	b=CXu7Incx2DYsuhujKEb1LJOxIRnUK2XU6tVYfYvDT4g2rTyc/RZnHe8qMxuNYh8YcYkD
	 u4ZY+nlXhpmoiYvGwWDH9j3LrApuVbYHwRhCfFne4Jnydzn3YK7444/FskV8a4O4MvJQv
	 U6WMoY/bVlDU67j3nCj5m+z/hECfcv3pZSKPWzpOO/rM20AFoHMvlVe4/hi2hW0iAKLPK
	 QuPVB37vGHM+GETZaxQlQGPpZ2kELXfB+GPHwDJDWljfKqhh+OJuyXri96eAXb+W+8uCc
	 d1FMSKfWUE/iC4ndaOGizna3xJMsLWwxrxk+CLzBphkyuhcm1UdMPh8rZhRilkrLE9Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465419;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rJA1ME9aVJPVdall37Fza1eaMeNcz0GRgu+xg/WPTE8=;
	b=MGfxOMS+J/sXIg+TqgKsPW6Nr7O5OkNnYH62/yW1Ui6L0OKa7mWeK1dFWoOG8Z2GWQQT
	 Lb82MZdbSZBulyWiraN8G2BOVVn2KIaKuB0ubiWuRClNScw1RJ5WUZTrDuj7rpIjnN/b7
	 jLzgpUhYBrF3Hi1xnRjDuU4kJfrkk0+DQh5uBs9OXjxnuV7ftqXUFlW/Mb8eOBCYlCnYI
	 bUvAMkiyiTvP59ar+sIOBQPjySjGz8Bg6n4FOGC9Mo6h6PFv1o2J0cFPzk6Lm/zJWVw9R
	 3zXrFblFiL+lc2fY0koDIA+j3xKsRXWvWX9ja0vWcS6F3F6QcmGkgo48Znb9yXBoDFg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E1DF21F000CD;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465419;
	bh=rJA1ME9aVJPVdall37Fza1eaMeNcz0GRgu+xg/WPTE8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AYAExmkm8+cJNvFePt5V1rF+sopiyBs+WPB76LmV0MXLDCZU4aN6XJEVo9Zlobg+I
	 PYVyRcMszykf2XRFUcdXiHM1QwskW95m7O3N/ElITlz0/oNsHWiITBrgP0OGMy8Pxp
	 r0SP3OCA+MYEA1sJkt1qgjEO8tKwl6wbJpM1JsHRz+VN2YrrRQZEZriQ095lug9GbX
	 IHMuIszNckRshidmqc7jtWa7sysD2/FyYcAJh1nVll8wQJz3Dka29/6+XlqyC0A9Y0
	 3Dgg4s2+qgl5UXUBLqfB8YbnGPhMm/cTrsgPRykQccTGD8NSInOk7gC9LuWQqltn9D
	 GRA2/Gfqy7xXA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5DF6A40733;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:39 -0700
Subject: [PATCH rdma-next v2 12/13] RDMA/core: 64-bit memory keys
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
Message-Id: <20261019-uet-ib-core-v2-12-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=5395;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=l/SvQB738ZzzsW40ZbLfYgaF+gfR5SifojhtKPNCnZU=;
 b=jIv0dTVbhOXUJgOv9VGEEqzz686xEM2v0kc3cz8L/yjqTG1XEX6dbnFmRAB+0urRMNj9tm8y+
 Q5OjMu7SqISCSX6FChvLeSCiWimpsQamEhhC7v31Cg09zRp4GwvZ+yb
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

A device whose keys are wider than 32 bits has no way to name a region
through lkey and rkey. Carry the wide pair on the region and return it
from registration when userspace asks for it.

The attributes are optional in both directions, so a kernel that does not
know them ignores the request, and a region without a wide key answers
zero.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 39 ++++++++++++++++++++++++++-
 include/rdma/ib_verbs.h                       | 12 +++++++--
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  4 +++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index e595c53fa34c..1ff45556e0b2 100644
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
@@ -364,6 +374,10 @@ static int reg_mr_ex_attr(struct uverbs_attr_bundle *attrs, struct ib_pd *pd,
 		if (ret)
 			return ret;
 
+		/* zero names no wide key, so it can't be one */
+		if (!ex->req_rkey64)
+			return -EINVAL;
+
 		if (ex->req_rkey64 > U32_MAX && !(caps & IB_DEVICE_KEY64))
 			return -EOPNOTSUPP;
 	} else if (uverbs_attr_is_valid(attrs,
@@ -547,7 +561,18 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_RKEY,
 			     &mr->rkey, sizeof(mr->rkey));
-	return ret;
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_LKEY64,
+			     &mr->lkey64, sizeof(mr->lkey64));
+	if (IS_UVERBS_COPY_ERR(ret))
+		return ret;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_REG_MR_RESP_RKEY64,
+			     &mr->rkey64, sizeof(mr->rkey64));
+
+	return IS_UVERBS_COPY_ERR(ret) ? ret : 0;
 }
 
 DECLARE_UVERBS_NAMED_METHOD(
@@ -583,6 +608,12 @@ DECLARE_UVERBS_NAMED_METHOD(
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
 
@@ -700,6 +731,12 @@ DECLARE_UVERBS_NAMED_METHOD(
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
index b86ac63fab36..725b630a3b90 100644
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
@@ -4851,8 +4854,8 @@ static inline u32 ib_inc_rkey(u32 rkey)
 
 /**
  * ib_mr_init_core_refs - clears what core reads back when an MR is
- *   deregistered.
- * @mr: struct ib_mr pointer to initialize.
+ *   deregistered, and the wide keys of an MR on a device without them.
+ * @mr: struct ib_mr pointer to initialize, with its device set.
  *
  * A driver's MR need not be zeroed, so every path that makes an MR calls this.
  */
@@ -4861,6 +4864,11 @@ static inline void ib_mr_init_core_refs(struct ib_mr *mr)
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
index fd8372c0c550..bc2797fc37fe 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -343,6 +343,8 @@ enum uverbs_attrs_query_mr_cmd_attr_ids {
 	UVERBS_ATTR_QUERY_MR_RESP_RKEY,
 	UVERBS_ATTR_QUERY_MR_RESP_LENGTH,
 	UVERBS_ATTR_QUERY_MR_RESP_IOVA,
+	UVERBS_ATTR_QUERY_MR_RESP_LKEY64,
+	UVERBS_ATTR_QUERY_MR_RESP_RKEY64,
 };
 
 enum uverbs_attrs_reg_dmabuf_mr_cmd_attr_ids {
@@ -374,6 +376,8 @@ enum uverbs_attrs_reg_mr_cmd_attr_ids {
 	UVERBS_ATTR_REG_MR_PARENT_MR_HANDLE,
 	UVERBS_ATTR_REG_MR_DERIVE_CNT,
 	UVERBS_ATTR_REG_MR_REQ_RKEY64,
+	UVERBS_ATTR_REG_MR_RESP_LKEY64,
+	UVERBS_ATTR_REG_MR_RESP_RKEY64,
 };
 
 enum uverbs_attrs_create_counters_cmd_attr_ids {

-- 
2.56.0


