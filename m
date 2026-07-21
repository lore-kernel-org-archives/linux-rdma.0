Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8C6429810
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615593; cv=none; b=gwN0RCWaqNyqQx163rq2Qb0M/6b+pror6KiSgdbBeR7ZKs3zNrXbHBjrWzuum6uZmyWC76ZfbWtB6K8+UklXNH4fpWnoaXVsD0Blj2euFmNZtSBH7RswoWgcMu/a6pIzPhPjvog7WgBc6yOOvELmCdgfKIl7lHCRHVRMKZV0IC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615593; c=relaxed/simple;
	bh=z+IUSuomUbjeKvJgZVc1GhZz2FhFjqKfgPjy358NwaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ayUFgfc1WksVZ5LPvKU7evLILSlsQja8ug5Z9kardkElhr8UIknlMd/JpMOqW1Mf80L3nOWJ2c6PJwt6n2hQy6MTRMjwCeJzAZOOqPydpaf3qCxaLoyG8oGHns6WOazioPWmOLH8CVyzSKDovkncGX9nUU4draQqoz1bTCI+Vms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WVNHOypF; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WVNHOypF"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so49371246d6.3
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615590; x=1785220390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VstyYg2V2ZY2aOSfjKEQb/dLN9GGHDaoxFFgH+QXpeU=;
        b=AfUh1v8bH0oandUeSQTVnXMIvNxpts9cM8Gy6aBGQop5MMcgt3ejgwEfn5D/aMCPCO
         K34j1e72g41x5afgf4JFm9rPTmY1PTLs0EhDWT+eHtOpIHvd+bWxie+7LgS96K4EP9Mi
         6lJl+xF+jBP4hrDM6y+oJS6eQr9OQ8cgIw1vYaYQDNJBiwAWpiU6B+CxhTRbj84TRULI
         9aAA329Vg2y4xQTxkR4I3uLt0zIOCecKnESIf/BrsPUCzKslPAZFaVYHExjp6QmOYZdc
         Ef1nauYSdBLaaTQfJdKz8qjlx/YoUzHHc1+BJi2K9SI72dk1Pyuad3YMLqjuAm2+S7VM
         yPmQ==
X-Gm-Message-State: AOJu0YzwDhKf0W02AWeN7L95GoUHzipCmO/luD5LzjyTuQ/UC7naERFf
	50tBk1MVygPH/SBhZNWn6SJ1V2YVogSsrxDz9n/ZL64wzZGuFZurQzjkRC8N18MEHAxiVX1bkoe
	61wi3MDleJDtBnfFNod5klAufEIL4fx3ccGSMSWX2kixSgX4633m/zCVO5hSd/YnOsGAmKIlo5H
	uw6o86vKO1MzRIL5aDLtBuAvPDCAQdcW0/TIuWXV5CIwW4TFBNRHl/p9FNjdu6l6ydUv8mpmJJL
	XZLjpppfJ6kwkvjmg==
X-Gm-Gg: AR+sD11T7mFXuCRiKzjNbJgvEkAY3CgGt8YFQDI9AbJC8H9T+wLPckpj992NFOpctE+
	6HK6WNQpPuyhBAdz9FmIV45G+L7Qd25EfSGNN2Yj6mmdHHyOJu+b0rQnrvUdYYpYoWYYQToL9p5
	n/+gcwg8cPX3/xqUUhti+F1SpFD3VcfEDACuEzb42zDX47VlFM/lRLhQrELSh6K+z6efCPZfb4E
	rGv1RGYC+RLmbi4RoSeVLBau3rM0a1CpwgD+kKUbA7BrLmSHTmFBcxbIwHZ/XkKrTDbhd5lwn1o
	ZgMpzpRJ4+ow52yR0HVgowjRdO0gvpqW1w2mHbj0JScY+eHmbXJF5Ui59V4sd1Ei9aa80UzrCdN
	VheVfsP5dwNtOZI0j2vNA1VmZErtEqTQvDtSCh3oY0yqv2vZKkQ+3kCUr/Dh8hCsZCaU9F7BEZz
	mhhVpjH8wip0Sc8vUI3wYf6BRmgczCc1e4oapf
X-Received: by 2002:a05:6214:3a8c:b0:8fd:6de3:dd85 with SMTP id 6a1803df08f44-907784dfc48mr173249816d6.59.1784615590241;
        Mon, 20 Jul 2026 23:33:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-907879e8f0bsm5460826d6.21.2026.07.20.23.33.09
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:33:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca860baea9fso18663014a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615589; x=1785220389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VstyYg2V2ZY2aOSfjKEQb/dLN9GGHDaoxFFgH+QXpeU=;
        b=WVNHOypF1B9EcK7u+yLJGZ8yVXFZEG12rYDPQm/ZJ/nMiiC/t6D/iX93YEZ9cRaqr1
         /LyQJjXZ3Dg8PHqbez1/pftAF+xyU27eXktZMTxbZsLW4zPKix20rvTkPEeliHYWQpJ0
         S4QTOo/1ZQLKonTBFL9DBoa6x7JmqTa7mLURc=
X-Received: by 2002:a05:6a20:4311:b0:3c3:8ead:6df0 with SMTP id adf61e73a8af0-3c3ad77a15amr19755502637.28.1784615588888;
        Mon, 20 Jul 2026 23:33:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:4311:b0:3c3:8ead:6df0 with SMTP id adf61e73a8af0-3c3ad77a15amr19755478637.28.1784615588421;
        Mon, 20 Jul 2026 23:33:08 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2900a37sm35230176c88.0.2026.07.20.23.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:33:07 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	alhouseenyousef@gmail.com,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH for-next v4 3/4] RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page
Date: Tue, 21 Jul 2026 04:54:39 -0700
Message-Id: <20260721115440.24021-4-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The current GET_TOGGLE_MEM ioctl requires the caller to supply
a type enum and a raw hardware queue ID (RES_ID). The kernel
looks up the CQ or SRQ by that ID without verifying that the
caller owns the resource.

Add a new, preferred code path that accepts standard uverbs
object handles (BNXT_RE_TOGGLE_MEM_CQ_HANDLE /
BNXT_RE_TOGGLE_MEM_SRQ_HANDLE) instead. The uverbs core validates
that the handle belongs to the calling context as part of resolving
it, so this path no longer needs the driver's own XArray lookup for
ownership checking. As with the legacy path, the toggle_entry's own
mmap-entry refcount (not a CQ/SRQ uobject reference) is what pins
the toggle page for the life of the GET_TOGGLE_MEM handle.

Only newer rdma-core versions support this path, if the
driver reports the supported resp mask
(BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT).
The existing TYPE + RES_ID path is retained for backward
compatibility with older rdma-core.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  2 +
 drivers/infiniband/hw/bnxt_re/uapi.c     | 55 +++++++++++++++++++++---
 include/uapi/rdma/bnxt_re-abi.h          |  4 ++
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0ff862ca982c..a14b17d4261f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4872,6 +4872,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 	if (_is_modify_qp_rate_limit_supported(dev_attr->dev_cap_flags2))
 		resp.comp_mask |= BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENABLED;
 
+	resp.comp_mask |= BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT;
+
 	if (udata->inlen) {
 		rc = ib_copy_validate_udata_in_cm(
 			udata, ureq, comp_mask,
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 97bc0e755511..feaf98631fc5 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -237,16 +237,52 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 	if (IS_ERR(ib_uctx))
 		return PTR_ERR(ib_uctx);
 
+	uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
+
+	/* New path: updated libbnxt_re passes the CQ or SRQ uverbs handle */
+	if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_CQ_HANDLE)) {
+		struct bnxt_re_cq *cq;
+
+		res_uobj = uverbs_attr_get_uobject(attrs,
+						   BNXT_RE_TOGGLE_MEM_CQ_HANDLE);
+		if (IS_ERR(res_uobj))
+			return PTR_ERR(res_uobj);
+		cq = container_of(res_uobj->object, struct bnxt_re_cq, ib_cq);
+		if (!cq->toggle_entry)
+			return -EOPNOTSUPP;
+		mmap_offset = rdma_user_mmap_get_offset(&cq->toggle_entry->rdma_entry);
+		if (!mmap_offset)
+			return -EOPNOTSUPP;
+		kref_get(&cq->toggle_entry->rdma_entry.ref);
+		toggle_entry = cq->toggle_entry;
+		goto alloc_tmem;
+	} else if (uverbs_attr_is_valid(attrs, BNXT_RE_TOGGLE_MEM_SRQ_HANDLE)) {
+		struct bnxt_re_srq *srq;
+
+		res_uobj = uverbs_attr_get_uobject(attrs,
+						   BNXT_RE_TOGGLE_MEM_SRQ_HANDLE);
+		if (IS_ERR(res_uobj))
+			return PTR_ERR(res_uobj);
+		srq = container_of(res_uobj->object, struct bnxt_re_srq, ib_srq);
+		if (!srq->toggle_entry)
+			return -EOPNOTSUPP;
+		mmap_offset = rdma_user_mmap_get_offset(&srq->toggle_entry->rdma_entry);
+		if (!mmap_offset)
+			return -EOPNOTSUPP;
+		kref_get(&srq->toggle_entry->rdma_entry.ref);
+		toggle_entry = srq->toggle_entry;
+		goto alloc_tmem;
+	}
+
 	err = uverbs_get_const(&res_type, attrs, BNXT_RE_TOGGLE_MEM_TYPE);
 	if (err)
 		return err;
-
-	uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
 	err = uverbs_copy_from(&res_id, attrs, BNXT_RE_TOGGLE_MEM_RES_ID);
 	if (err)
 		return err;
 
 	/*
+	 * Legacy path: old libbnxt_re sends TYPE + RES_ID.
 	 * Hold xa_lock across xa_load + kref_get so that a concurrent
 	 * bnxt_re_destroy_cq/srq cannot call __xa_erase and remove the
 	 * toggle_entry between our load and our reference on it.
@@ -297,6 +333,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 	if (!mmap_offset)
 		return -EOPNOTSUPP;
 
+alloc_tmem:
 	tmem = kzalloc_obj(*tmem);
 	if (!tmem) {
 		rdma_user_mmap_entry_put(&toggle_entry->rdma_entry);
@@ -343,10 +380,10 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TOGGLE_MEM,
 					    UA_MANDATORY),
 			    UVERBS_ATTR_CONST_IN(BNXT_RE_TOGGLE_MEM_TYPE,
 						 enum bnxt_re_get_toggle_mem_type,
-						 UA_MANDATORY),
+						 UA_OPTIONAL),
 			    UVERBS_ATTR_PTR_IN(BNXT_RE_TOGGLE_MEM_RES_ID,
 					       UVERBS_ATTR_TYPE(u32),
-					       UA_MANDATORY),
+					       UA_OPTIONAL),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
 						UVERBS_ATTR_TYPE(u64),
 						UA_MANDATORY),
@@ -355,7 +392,15 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_TOGGLE_MEM,
 						UA_MANDATORY),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_TOGGLE_MEM_MMAP_LENGTH,
 						UVERBS_ATTR_TYPE(u32),
-						UA_MANDATORY));
+						UA_MANDATORY),
+			    UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
+					    UVERBS_OBJECT_CQ,
+					    UVERBS_ACCESS_READ,
+					    UA_OPTIONAL),
+			    UVERBS_ATTR_IDR(BNXT_RE_TOGGLE_MEM_SRQ_HANDLE,
+					    UVERBS_OBJECT_SRQ,
+					    UVERBS_ACCESS_READ,
+					    UA_OPTIONAL));
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(BNXT_RE_METHOD_RELEASE_TOGGLE_MEM,
 				    UVERBS_ATTR_IDR(BNXT_RE_RELEASE_TOGGLE_MEM_HANDLE,
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index a4599d7b736a..c0ee9ce389ac 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -57,6 +57,8 @@ enum {
 	BNXT_RE_UCNTX_CMASK_POW2_DISABLED = 0x10ULL,
 	BNXT_RE_UCNTX_CMASK_MSN_TABLE_ENABLED = 0x40,
 	BNXT_RE_UCNTX_CMASK_QP_RATE_LIMIT_ENABLED = 0x80ULL,
+	 /* Some reserved fields to manage compatibility with Out of tree drivers */
+	BNXT_RE_UCNTX_CMASK_TOGGLE_MEM_UOBJ_SUPPORT = 0x400000ULL,
 };
 
 enum bnxt_re_wqe_mode {
@@ -218,6 +220,8 @@ enum bnxt_re_var_toggle_mem_attrs {
 	BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
 	BNXT_RE_TOGGLE_MEM_MMAP_OFFSET,
 	BNXT_RE_TOGGLE_MEM_MMAP_LENGTH,
+	BNXT_RE_TOGGLE_MEM_CQ_HANDLE,
+	BNXT_RE_TOGGLE_MEM_SRQ_HANDLE,
 };
 
 enum bnxt_re_toggle_mem_attrs {
-- 
2.39.3

