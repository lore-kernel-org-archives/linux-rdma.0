Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283267;
	b=x/UW67QLy7JFlalJBHTtBEgSGVl0L1u/jIGD4WkaS7sgnpIqQYoGhVfq0N2euMVwq5ku
	 3gVJO1Aeul9jBqcqqNSkTcwqPISzXMDcN2bjacJxFXJcg7aLvRVIQrpYpInlt3DMfKFqW
	 wrVIUBicXrZF/NfEnROi1PEkY/hPtp7aJpYEM1ty8I60ZVIaaKTdS+Zc2nqmMqbG4/if1
	 KVIjmAj2ohBBbPASNo2tgb05YrMChIuJJbqHnQlRUNrrMGxhCxoPHj6uuW0qqe4ogryCW
	 FxmxSO5Dil/qMEvcFTjKK8F2rlaFpeAAKrBzJbr3i/jia8M6VlQ6J91ZpUaRzngqEfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283267;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7xPhRPscPA8H0xPKPYjBn2+4JKQdzjPGl9YX+89gLRI=;
	b=i/DrMvmzJoZTlIDKr2D9D4P11nuGXnEUurKv5xDwf0QzmRH+v0lZgl7wZj4u4jn7smTl
	 xGSLO2PnpyomPFAktytRyk7MHra2tFEkO7BkiTNGrLb1PPQM6QExVvEYLMVP6cjjTQo+V
	 GTPMSAYP+MnxG9OgpeOqucw2LsL1IgEY4po2nBHYXjnKKOv4C/r5Q6BmIZ3o/IHTJ0wlp
	 qTTXoSN5HsezygzOJGmQVJwGddYFBKFa0H73LaEcOhIEUTnjwuUCvYWqEGq47YgGG11py
	 KbkvtGQ1hYQLdIOPB5y8Rn4dImsAGni6IklqKHzZPM+Mxw/YhSYSptb0TNB69AMf+eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oijgP0qt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF760A5BDD;
	Tue, 10 Nov 2026 04:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oijgP0qt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283267;
	b=fHin0dTdLyOC+npEkavUCfxFh1bJ9VOkqUKBRhlEus0y1fAceIq/HWKFvvsjZlgGXR3x
	 zCZkgEVmpLD1l+cOkrx0+wpSxNMxfYSn8JObdNLxwgiy/4x5hIQiS0r1XCeIqRCG57nOd
	 X/UiSbz8D1oJlwoGlu495i2fyI1RK8biw2sgWUEC9lSYJMGAy6f2Df2csWIa+XFQN6iNb
	 hc8C2tzfkyUQfaa1YDlxNmdepA1oowMaQgLH9lRLdcjhbQwk+HxtR60K/HztKLu2YXybX
	 dVZaGetjOQ5s+mJ9C2aAK+bAm88v3CII5ishuXRKUVgWlyWYIUSFfqFz3aPeEySIfYA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283267;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7xPhRPscPA8H0xPKPYjBn2+4JKQdzjPGl9YX+89gLRI=;
	b=MYJDJzuX70sMFibpcCKSHkEzoy5sfCmDeQl3hL/XvSXPiPV19zgtiWKRuDYdHJNmo5e9
	 wKK4Ci/Z+aah9NusRvl8kTBJzPrqXyhY6nQloPKAoNz7b3XN2pWOazMCbOolpbSaV2gc3
	 9CS0FaZ5rvV/9uNvnjszIyDQZkApmeN0LNM5ZQHWpTjhKRJlrsPxsIe35xWEMkB7pjDRi
	 FumgwfT2ibRNDgMfCPHv06b5S94T3duh+ZSqA4eBRbKVEaNWWBy/SPuzA6Ssmklr3JRMc
	 B+Chh4ucLa9SjhFV3CyFXNPhaviHJz6ILM67/7EmJ86AXQ0yPbKWFTmpYqfs6B6C/uA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D2BEA1F008BC;
	Tue, 10 Nov 2026 04:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283267;
	bh=7xPhRPscPA8H0xPKPYjBn2+4JKQdzjPGl9YX+89gLRI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=oijgP0qtXwsIfOqXBWose154+T/e4jrI1/8tNu3PHutmhGOh/LEPC/KE4tDR3pFu6
	 g2ZvEhXUAuRX8V9+1dAs2vqVrbc9TBmyupAKPCHmRA9ba646kib5JepEraFfF3dbyC
	 UPGHNIdlvke3Kb3m8gtnE4K1x7sREh4uxqnF3SD34NWlIYngT3zl+gJWfFU/d0OU9T
	 V9xFfkNZnwBTgz+KtP1d+P2gKIBwU8N+ssY6+kAaSbtpuDe2iv4hbMXlzVWdJjmzPA
	 JtU3K/3ZPJuxK7tkKG/4Nl+cQcaJVK0rxQ3dOTobY074nLZeH87vX063b9dycWagof
	 Qhmf5AnIkFDsA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6D54F48828;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:45 -0800
Subject: [PATCH rdma-next v3 12/13] RDMA/core: 64-bit memory keys
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
Message-Id: <20261109-uet-ib-core-v3-12-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=5539;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=+Wwy106JslUunMctJkKztDN15WOV6hbxl3FHu2t0F1g=;
 b=CRb8nND6CxA1resacBWuDj1YYylZCkmZLQBwXGewxWv3/CtStk3v40gg3dBtfAUes4O2oqSMT
 mlTEoCudwVNAxoqrGIcbMEiaaU95q8d4C/FjH1MMjUOufQy8HWtQAKg
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
 include/rdma/ib_verbs.h                       | 15 +++++++++--
 include/uapi/rdma/ib_user_ioctl_cmds.h        |  4 +++
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 8d281d13d210..5a617a705904 100644
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
@@ -369,6 +379,10 @@ static int reg_mr_ex_attr(struct uverbs_attr_bundle *attrs, struct ib_pd *pd,
 		if (ret)
 			return ret;
 
+		/* zero names no wide key, so it can't be one */
+		if (!ex->req_rkey64)
+			return -EINVAL;
+
 		if (ex->req_rkey64 > U32_MAX && !(caps & IB_DEVICE_KEY64))
 			return -EOPNOTSUPP;
 	} else if (uverbs_attr_is_valid(attrs,
@@ -555,7 +569,18 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 
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
@@ -591,6 +616,12 @@ DECLARE_UVERBS_NAMED_METHOD(
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
 
@@ -708,6 +739,12 @@ DECLARE_UVERBS_NAMED_METHOD(
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
index 07fd5731d458..3b2903b1c40d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2084,6 +2084,12 @@ struct ib_mr {
 		struct list_head	qp_entry;	/* FR */
 	};
 
+	/* 64b keys, set by a driver reporting IB_DEVICE_KEY64, else zero. The
+	 * driver sets them on every registration path, rereg_user_mr included,
+	 * where it also keeps a caller-chosen rkey or fails.
+	 */
+	u64		   lkey64;
+	u64		   rkey64;
 	/* the job this region is restricted to, NULL if it is unrestricted */
 	struct ib_jkey	  *jkey;
 	/* the region this one was derived from, NULL if registered fresh */
@@ -4852,8 +4858,8 @@ static inline u32 ib_inc_rkey(u32 rkey)
 
 /**
  * ib_mr_init_core_refs - clears what core reads back when an MR is
- *   deregistered.
- * @mr: struct ib_mr pointer to initialize.
+ *   deregistered, and the wide keys of an MR on a device without them.
+ * @mr: struct ib_mr pointer to initialize, with its device set.
  *
  * A driver's MR need not be zeroed, so every path that makes an MR calls this.
  */
@@ -4862,6 +4868,11 @@ static inline void ib_mr_init_core_refs(struct ib_mr *mr)
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


