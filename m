Received: from mail-yx1-f103.google.com (mail-yx1-f103.google.com [74.125.224.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8DB426405
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615589; cv=none; b=qdhkBB+5DcyQENnjN21oN9oW+o1S8vGaM3fsNc1V7ks4YXqKsd5xn48RloxYLo7q27egfU5U/rTb+/aDX6fdLVEHufRE2dNyQcyCfS2/ZLbRzo3MU2YWR13WLUqkJN61tAZ0qgZQr7YJMlxJUSpIWmbyA/5SKPWVBHY2ZWfCBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615589; c=relaxed/simple;
	bh=p0D92gq20cNipHKJ+jLu5cRicCBh+6esehE3Rzkt6FE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJHhgykX6iV/wpVcHzACY7jgbW90aJSixkyEraG8i0MJ8KPghKT7c0gS3zSUntgBVxUUsHmcc7TbOasnmZF9gEy6LdEJxRDbf+Shj/OKw51hA2JhDkDUyurOYqrOBD+WoBwTRZv9xQCslvkJIuk6yaPdASgykMm7F9hcZflCnAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=g+k5wbH8; arc=none smtp.client-ip=74.125.224.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g+k5wbH8"
Received: by mail-yx1-f103.google.com with SMTP id 956f58d0204a3-664d530fcfdso14434759d50.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615586; x=1785220386;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XPTHQ8WeCf3thoAUAQTl/UIloo0liXpJSqK6eraUK58=;
        b=n4Yj3GO2OwBkUgCUcZY9otSvB4zLJPT5HVGyt+GySCweBUgBhoZW44MqapDerBALud
         uZJrKR74q7KjoeHTZhJBbG8sjPSLpQx23Fgib3xMFjCIjhjHjaTBdGB/hDnlK+UjMULp
         8vb5pPP1rwTpaxiWwxXw0d+htkvXK0e0fv1JhccY6Q1S1xRhb9y9WQsEXyaaA+C9J3ux
         yrVRN+9R5P0bJ/GXwd87gs/3f+1WDKjyKGsPGcMnkVLjA9DyXsCjdWjuDKRcI0Bnmjl3
         8zFRzZwpOM7eB4rOFWd3o2dgAST/TOw3QKTHDX4RsaByUdRB3320QauUlKPjNqxHmJjJ
         +MKw==
X-Gm-Message-State: AOJu0YwZgtYyhb4q4KzbpOKjAclsnKD/9Uy+YddjgKrQoc7Hs2Ni0fTR
	IUHCf315KPvYX5wthVqFDbw0yhsFo8sMfg4gPG6lYqf9cHcLwcNiM6NE96Allqm1tagb1QNirF4
	x+Z6TQbKOWtrburN7E+1SSZbZOKxcc8JycCdQVJHRiPlf4JvQx0ocG9KbIyPJ89UIHgDuiL8xtW
	lCRr9uWUhpyzjx5kZTtHllrcyhIlsP4DO0P6wlyzxjc8ucdzEybKN4nw+AN+BgB2R3ogdK4gAdz
	cicASDY6RQlGkZgPN73
X-Gm-Gg: AR+sD11BJuUrOBUnKP90wxB2+8Agd+RIXr3pserrtTnodQpmqXeLJyOHk9fKw4kqGpF
	8VROf5PKRoui9SJBX71XTndS65aKFzNYAwNwGT/idzeVl+vkfhAyGgdYxYt0ZQDvNwauurOMeCm
	0RMFGGowrG3HfrZBUgp8nhvDc7TjKEErJL9ilvhZpC8ALKHr0+LCkc7Vg2YDLsP6okQwV09gzUp
	7XiIyMk2x6u5W49IuKDt/Fp+Uc1BzTKXpKPt0azbaL7azd0eSBM24anP1D626EKSnnJMQ+AVW7J
	372oWg+GBIjT0RNdDQFPm8KlxY7kNUr0w8O2erOI779C6d8LSMyYQWxy7SpXhzfxUokrrlIMRNA
	yJBK+ox4Q7jtVDO5jl5uxauJvBORhMDCw2Hld3bIMNVhl2irquxJm50dTIZHEt/GR8OqEki8wf8
	COgpWHTXtSRbOdAwLLblabrDGPuIMqmBMwNs5e
X-Received: by 2002:a05:690e:2497:b0:668:27c1:9a0a with SMTP id 956f58d0204a3-6683bb689a9mr3612990d50.24.1784615586042;
        Mon, 20 Jul 2026 23:33:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6683b84c128sm937800d50.28.2026.07.20.23.33.05
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:33:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-380b630c505so13975960a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615584; x=1785220384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XPTHQ8WeCf3thoAUAQTl/UIloo0liXpJSqK6eraUK58=;
        b=g+k5wbH8HE7WxNjYTh3sdWUtLEljWlLWvPMIqNw0HkxpVuNIJGHwzgihv12Ngits+d
         lTDrzyx1e8d6Vq9JgsxjnjxZLz7vaXQHIFcupBFobBvRYR6Fm2xQcqcoRG7N/ffVz149
         kJ3rgYovtsqTArFyG/ecaFUynXEjQzVOynxXs=
X-Received: by 2002:a17:90b:5103:b0:37f:9ce1:736b with SMTP id 98e67ed59e1d1-38e4b56bd50mr18368580a91.33.1784615584076;
        Mon, 20 Jul 2026 23:33:04 -0700 (PDT)
X-Received: by 2002:a17:90b:5103:b0:37f:9ce1:736b with SMTP id 98e67ed59e1d1-38e4b56bd50mr18368552a91.33.1784615583477;
        Mon, 20 Jul 2026 23:33:03 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2900a37sm35230176c88.0.2026.07.20.23.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:33:02 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	alhouseenyousef@gmail.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next v4 2/4] RDMA/bnxt_re: Defer toggle page free to rdma_user_mmap_entry teardown
Date: Tue, 21 Jul 2026 04:54:38 -0700
Message-Id: <20260721115440.24021-3-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Fix the page lifetime by making the rdma_user_mmap_entry the sole owner
of the toggle page allocation. Creating the rdma_user_mmap_entry and page
during the CQ/SRQ creation time. Freeing the page is handled when the
mmap free is called. Introduce struct bnxt_re_toggle_mem to carry
the mmap_offset for the lifetime of the GET_TOGGLE_MEM uobject handle.

bnxt_re_destroy_cq/srq can erase the entry from the XArray and call
rdma_user_mmap_entry_remove() on the toggle_entry concurrently with
the caller's xa_load() and its subsequent use of that toggle_entry.
Guard against this by taking an extra kref directly on the
toggle_entry's rdma_user_mmap_entry while the GET_TOGGLE_MEM handle
exists, released when the handle is destroyed. This pins exactly the
resource that GET_TOGGLE_MEM hands out (the mmap offset/page),
independent of the CQ/SRQ's own lifetime.

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 40 ++++++++++++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  2 +
 drivers/infiniband/hw/bnxt_re/uapi.c     | 51 ++++++++++++++++++------
 3 files changed, 75 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index dbf89abde85b..0ff862ca982c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2169,7 +2169,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 
 		if (uctx)
-			free_page((unsigned long)srq->uctx_srq_page);
+			rdma_user_mmap_entry_remove(&srq->toggle_entry->rdma_entry);
 	}
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
@@ -2282,10 +2282,17 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 				rc = -ENOMEM;
 				goto fail_destroy_srq;
 			}
+			srq->toggle_entry = bnxt_re_mmap_entry_insert(uctx, (u64)srq->uctx_srq_page,
+								      BNXT_RE_MMAP_TOGGLE_PAGE,
+								      NULL);
+			if (!srq->toggle_entry) {
+				rc = -ENOMEM;
+				goto fail_free_srq_page;
+			}
 			if (xa_is_err(xa_store(&uctx->srq_xa, srq->qplib_srq.id,
 					       ib_srq->uobject, GFP_KERNEL))) {
 				rc = -ENOMEM;
-				goto fail_free_srq_page;
+				goto fail_remove_toggle_entry;
 			}
 			resp.comp_mask |= BNXT_RE_SRQ_TOGGLE_PAGE_SUPPORT;
 		}
@@ -2303,10 +2310,13 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 fail_respond:
 	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
 		xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
-		free_page((unsigned long)srq->uctx_srq_page);
+		goto fail_remove_toggle_entry;
 	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, &srq->qplib_srq);
 	goto fail;
+fail_remove_toggle_entry:
+	rdma_user_mmap_entry_remove(&srq->toggle_entry->rdma_entry);
+	goto fail_destroy_srq;
 fail_free_srq_page:
 	free_page((unsigned long)srq->uctx_srq_page);
 fail_destroy_srq:
@@ -3519,7 +3529,7 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 
 		if (uctx)
-			free_page((unsigned long)cq->uctx_cq_page);
+			rdma_user_mmap_entry_remove(&cq->toggle_entry->rdma_entry);
 	}
 
 	bnxt_re_put_nq(rdev, nq);
@@ -3600,10 +3610,16 @@ int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *att
 			rc = -ENOMEM;
 			goto destroy_cq;
 		}
+		cq->toggle_entry = bnxt_re_mmap_entry_insert(uctx, (u64)cq->uctx_cq_page,
+							     BNXT_RE_MMAP_TOGGLE_PAGE, NULL);
+		if (!cq->toggle_entry) {
+			rc = -ENOMEM;
+			goto free_cq_page;
+		}
 		if (xa_is_err(xa_store(&uctx->cq_xa, cq->qplib_cq.id,
 				       ibcq->uobject, GFP_KERNEL))) {
 			rc = -ENOMEM;
-			goto free_cq_page;
+			goto remove_toggle_entry;
 		}
 		resp.comp_mask |= BNXT_RE_CQ_TOGGLE_PAGE_SUPPORT;
 	}
@@ -3619,6 +3635,10 @@ int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *att
 free_mem:
 	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
 		xa_erase(&uctx->cq_xa, cq->qplib_cq.id);
+remove_toggle_entry:
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
+		rdma_user_mmap_entry_remove(&cq->toggle_entry->rdma_entry);
+	goto destroy_cq;
 free_cq_page:
 	free_page((unsigned long)cq->uctx_cq_page);
 destroy_cq:
@@ -5063,6 +5083,16 @@ void bnxt_re_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
 	bnxt_entry = container_of(rdma_entry, struct bnxt_re_user_mmap_entry,
 				  rdma_entry);
 
+	/*
+	 * For toggle pages the kernel VA was stored directly in mem_offset
+	 * at creation time (bnxt_re_create_user_cq / bnxt_re_create_srq).
+	 * Free it here — this is the only place it is freed, ensuring the
+	 * page outlives every concurrent bnxt_re_mmap() call that may have
+	 * incremented the entry's reference count.
+	 */
+	if (bnxt_entry->mmap_flag == BNXT_RE_MMAP_TOGGLE_PAGE)
+		free_page((unsigned long)bnxt_entry->mem_offset);
+
 	if (bnxt_entry->dpi_valid)
 		bnxt_qplib_free_uc_dpi(&bnxt_entry->uctx->rdev->qplib_res,
 				       &bnxt_entry->dpi);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 4c78c183784b..b7b33f6acf91 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -80,6 +80,7 @@ struct bnxt_re_srq {
 	struct ib_umem		*umem;
 	spinlock_t		lock;		/* protect srq */
 	void			*uctx_srq_page;
+	struct bnxt_re_user_mmap_entry *toggle_entry;
 };
 
 struct bnxt_re_qp {
@@ -114,6 +115,7 @@ struct bnxt_re_cq {
 	struct ib_umem		*resize_umem;
 	int			resize_cqe;
 	void			*uctx_cq_page;
+	struct bnxt_re_user_mmap_entry *toggle_entry;
 };
 
 struct bnxt_re_mr {
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index c5e4e6e47b5f..97bc0e755511 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -213,19 +213,23 @@ DECLARE_UVERBS_GLOBAL_METHODS(BNXT_RE_OBJECT_NOTIFY_DRV,
 			      &UVERBS_METHOD(BNXT_RE_METHOD_NOTIFY_DRV));
 
 /* Toggle MEM */
+struct bnxt_re_toggle_mem {
+	struct bnxt_re_user_mmap_entry *toggle_entry;
+	u64 mmap_offset;
+};
+
 static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bundle *attrs)
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs, BNXT_RE_TOGGLE_MEM_HANDLE);
-	enum bnxt_re_mmap_flag mmap_flag = BNXT_RE_MMAP_TOGGLE_PAGE;
+	struct bnxt_re_user_mmap_entry *toggle_entry = NULL;
 	enum bnxt_re_get_toggle_mem_type res_type;
-	struct bnxt_re_user_mmap_entry *entry;
+	struct bnxt_re_toggle_mem *tmem;
 	struct ib_uobject *res_uobj;
 	struct bnxt_re_ucontext *uctx;
 	struct ib_ucontext *ib_uctx;
 	u32 length = PAGE_SIZE;
-	u64 mem_offset;
+	u64 mmap_offset = 0;
 	u32 offset = 0;
-	u64 addr = 0;
 	u32 res_id;
 	int err;
 
@@ -243,6 +247,10 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		return err;
 
 	/*
+	 * Hold xa_lock across xa_load + kref_get so that a concurrent
+	 * bnxt_re_destroy_cq/srq cannot call __xa_erase and remove the
+	 * toggle_entry between our load and our reference on it.
+	 *
 	 * bnxt_re_create_cq/srq() publishes the uobject into cq_xa/srq_xa
 	 * before returning to the uverbs core, but the core only sets
 	 * uobject->object once the create callback has returned success.
@@ -257,7 +265,13 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		res_uobj = xa_load(&uctx->cq_xa, res_id);
 		if (res_uobj && res_uobj->object) {
 			cq = container_of(res_uobj->object, struct bnxt_re_cq, ib_cq);
-			addr = (u64)cq->uctx_cq_page;
+			if (cq->toggle_entry)
+				mmap_offset =
+					rdma_user_mmap_get_offset(&cq->toggle_entry->rdma_entry);
+			if (mmap_offset) {
+				kref_get(&cq->toggle_entry->rdma_entry.ref);
+				toggle_entry = cq->toggle_entry;
+			}
 		}
 		xa_unlock(&uctx->cq_xa);
 	} else if (res_type == BNXT_RE_SRQ_TOGGLE_MEM) {
@@ -267,24 +281,34 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		res_uobj = xa_load(&uctx->srq_xa, res_id);
 		if (res_uobj && res_uobj->object) {
 			srq = container_of(res_uobj->object, struct bnxt_re_srq, ib_srq);
-			addr = (u64)srq->uctx_srq_page;
+			if (srq->toggle_entry)
+				mmap_offset =
+					rdma_user_mmap_get_offset(&srq->toggle_entry->rdma_entry);
+			if (mmap_offset) {
+				kref_get(&srq->toggle_entry->rdma_entry.ref);
+				toggle_entry = srq->toggle_entry;
+			}
 		}
 		xa_unlock(&uctx->srq_xa);
 	} else {
 		return -EOPNOTSUPP;
 	}
 
-	if (!addr)
+	if (!mmap_offset)
 		return -EOPNOTSUPP;
 
-	entry = bnxt_re_mmap_entry_insert(uctx, addr, mmap_flag, &mem_offset);
-	if (!entry)
+	tmem = kzalloc_obj(*tmem);
+	if (!tmem) {
+		rdma_user_mmap_entry_put(&toggle_entry->rdma_entry);
 		return -ENOMEM;
+	}
 
-	uobj->object = entry;
+	tmem->toggle_entry = toggle_entry;
+	tmem->mmap_offset = mmap_offset;
+	uobj->object = tmem;
 	uverbs_finalize_uobj_create(attrs, BNXT_RE_TOGGLE_MEM_HANDLE);
 	err = uverbs_copy_to(attrs, BNXT_RE_TOGGLE_MEM_MMAP_PAGE,
-			     &mem_offset, sizeof(mem_offset));
+			     &mmap_offset, sizeof(mmap_offset));
 	if (err)
 		return err;
 
@@ -305,9 +329,10 @@ static int get_toggle_mem_obj_cleanup(struct ib_uobject *uobject,
 				      enum rdma_remove_reason why,
 				      struct uverbs_attr_bundle *attrs)
 {
-	struct bnxt_re_user_mmap_entry *entry = uobject->object;
+	struct bnxt_re_toggle_mem *tmem = uobject->object;
 
-	rdma_user_mmap_entry_remove(&entry->rdma_entry);
+	rdma_user_mmap_entry_put(&tmem->toggle_entry->rdma_entry);
+	kfree(tmem);
 	return 0;
 }
 
-- 
2.39.3

