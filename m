Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E329DB6E
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681094; cv=none; b=REYgpnhLlcEpFDw7PW2Gdxku7xMOCYc+4oJrX+rw0J8wY5wbkNbhq4am5SKNbcMKmCyMsGplWhIF7omL3hRmTtcbsiJTlrbEdI/DzUNFXTeIrTplA2d/fx7pMhdBxEQbaTVoCCol/9oZ9s0dRpqWNE89owrdfbu6K29EhEoANHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681094; c=relaxed/simple;
	bh=cxH9512e+CTI5Jky2MXS0ktqVT0z8e6PAc9Cygzg/WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMnPUffw7aEKmz2uAuTvK7lVB8+gj2Stci4Ak/zaue9ZSP/tX8eBM1Ub8KyF+CHbFMHTlcdtESImhgZtIIUyfFVoRX3iCxkUpfK2txwoWgW+45zxNHeGdsU9KTVe7ej6NWEmpzdmouakQuRZcHTFjvloonwP3tL44a5PfUdwKbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=ccmgS4m5; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="ccmgS4m5"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ab43af5e97so6840607b3.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 18:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1791681092; x=1792285892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y3A0l7hxn81J+DvMKRAk3QP8AHzodaRXzb3EEqbVgUg=;
        b=ccmgS4m5Y91w2kJJ35J93YZcjFBm+HFFfy6K48qPuLVPzS+q2UENzBnwnSKToqrOLN
         rjyDDppt8iwQZ92WonbAlzdhRuND0t2xTRIoen5wD4Yue0PpUusjYC9g7+epyExXQMRI
         22ro/DxVIvjixZR0MvwPo+KcgRpXwHtfFUHFvfh8T8INPECaohUTTTEDOG4fCSmkh0oa
         4HpDZwak3H1Fa4lnxSpVtZlqaPxpxarsg+av38X5znTfYMxUFNKG2UYTIduQym7zd8zM
         vRfnaeAFcq3WXSFOTl2uYrr1oh7Sj+nEfslzzOVN8g3T4tWq4vX9SxhFYDJ+VQwUoXVH
         LodA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791681092; x=1792285892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y3A0l7hxn81J+DvMKRAk3QP8AHzodaRXzb3EEqbVgUg=;
        b=I0jz22ycyB5TVr32PPYyAFlg+WFn0YqNlKGhPLpc9OdFCl40EpZEYo42T1eDQKgbB+
         CcczH5esKBKakteAtVJGcMlGLPuIcfIp9z04jDe2fBEV3HlK5j0RlN350kE+ZwS/7UqL
         oVhlem11VK1c3CVJKnQMzbkehhZM1Xwr5pD9cjJN+1To12KTKRr6ykAAIdnFfTTlNVUU
         V2a9xLeCXQLG6Bqzqfm/MZ6gLfY12MskWvNslV5FgYMSukDLNlQBnCbZabh0pdKSQGsH
         eN1OJAdEX+3ZqWCkOgBUzBX9UM7DGddH5cPwQdokiBUcWrdQHZZOOK4Z4KwjHpdPqR0Q
         ilGg==
X-Gm-Message-State: AFq9FYJ7yQXXQEU909xxMEiK42CgwzmbW2ZrUyCxiYbluwJ8YG/PKEYk
	2ZI9FSUXWvDJM+wd5XpmtuRGiUPj4+LKDABjqSiFao1083Mf5DMTWO+rxdmZCFZ7RVOd
X-Gm-Gg: AYBFou2R8pLAhW3RRB6vjikazLRn0X0IGK0LpQF7PwvsXQbnwe+i/dgspYNPCMFs1ec
	cECZUR4PgLOZlD/eoa5tOh/rTmoyolx9rJOnPQTF8052/+Kg5LiPpU2niw/gQy2q3qBBosDihDN
	HKep4/eImszlmqOYuBdW5A/ISJNYAc7TvEJVxgN7Rc/aVPY84Qp16kW2rrPJEU8gDi5rxXaNPkW
	n6HJTIj8MceF+6t/WvbPpSrzwyEJ9cndtv0f/MqNDlZB2nZOT0Ub0b8BhMIZPicDPFdT620Xf1Q
	IKGF/V6oMJjTmEU8fyG3VIjzcPp2TWS/bjzRjW86ltoK5JUn7/XogIhjRXjVhD4LOSEuy+GGSx9
	F/eGkiPCVPrIZ+paI9htcZYoXtxEAuyGZoWVB6PTFMff4uKEq3Spxz/I4y/5gtdYQMx8lmBgPgy
	/AsfPKyhb517LUqAealT92ldWarH0li40Nk8lQj7xzRC3adBf3IQWk/aBoTZ9HHQLESGlSNwkHk
	2mPipMoMFwlyREg3aXFebQHgZnt8AQI80KsNgdaUF5rgE16ZJbdcAQjXP0WK5JbK3aROtuhfPdC
	2a3f1WREXQ==
X-Received: by 2002:a05:690c:6d03:b0:8ae:68d9:cef4 with SMTP id 00721157ae682-8b07d46649emr18362307b3.28.1791681091696;
        Sat, 10 Oct 2026 18:11:31 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b07f263bc8sm21311817b3.45.2026.10.10.18.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 18:11:30 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next 3/5] RDMA/irdma: Support UMEM attribute for QP creation
Date: Sun, 11 Oct 2026 01:10:20 +0000
Message-ID: <20261011011022.1445352-4-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261011011022.1445352-1-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

Support the standard 1-step queue buffer creation
model for QP by using `UVERBS_ATTR_CREATE_QP_BUF_UMEM`
and `ib_umem_get_attr()`.

Add `irdma_setup_q_pbl_from_umem()` to allocate the
backing MR and program hardware pble directly from
the pinned umem. Proper umem and pble cleanup is
added to `irdma_free_qp_rsrc()` upon QP destruction.

We retain backward compatibility for legacy 2-step
registration if the UMEM attribute is not provided.

`irdma_alloc_iwmr()` assumed there is always a valid
PD, which is valid for regular MR, and QP. That is
not the case for CQ. This modernization fixes
`irdma_alloc_iwmr()` to take in an `ibdev` to avoid
a potential NULL dereference.

Note for MR teardown: This patch unifies the teardown
of legacy 2-step queue MR and modern 1-step dummy MR
via,

`refcount_dec_and_test(&iwmr->user_ring_refs)`

For legacy queue MR, ref count starts at 2 (one by
queue, and one by `ib_mr`), it goes to 1 during
queue teardown, while deferring memory teardown to
`irdma_dereg_mr`.

For 1-step dummy MR, ref count starts at 1, and
teardown happens cleanly here.

The teardown sequence (`ib_umem_release`, `irdma_free_pble`,
`kfree`) is inlined in `utils.c` here because
`irdma_free_iwmr` is statically scoped in `verbs.c`.
Combining was considered, and we think it belongs
to a future project.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/utils.c |  12 ++-
 drivers/infiniband/hw/irdma/verbs.c | 130 ++++++++++++++++++++++++----
 2 files changed, 124 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 290ad02ed657..1e5694a4fd91 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -1170,9 +1170,15 @@ void irdma_free_qp_rsrc(struct irdma_qp *iwqp)
 	kfree(iwqp->kqp.rq_wrid_mem);
 
 	if (iwqp->user_mode && iwqp->iwpbl) {
-		struct irdma_mr *iwmr = iwqp->iwpbl->iwmr;
-
-		refcount_dec(&iwmr->user_ring_refs);
+		struct irdma_pbl *iwpbl = iwqp->iwpbl;
+		struct irdma_mr *iwmr = iwpbl->iwmr;
+
+		if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
+			ib_umem_release(iwmr->region);
+			if (iwpbl->pbl_allocated)
+				irdma_free_pble(rf->pble_rsrc, &iwpbl->pble_alloc);
+			kfree(iwmr);
+		}
 	}
 }
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b2ffdc8e3d67..ab25445f3828 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -18,6 +18,12 @@ static const struct uapi_definition irdma_uapi_defs[] = {
 	{}
 };
 
+static struct irdma_pbl *irdma_setup_q_pbl_from_umem(struct irdma_device *iwdev,
+						     struct ib_umem *region,
+						     struct ib_pd *pd,
+						     enum irdma_memreg_type reg_type,
+						     struct irdma_mem_reg_req *req);
+
 /**
  * irdma_query_device - get device attributes
  * @ibdev: device pointer from stack
@@ -670,17 +676,6 @@ static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
 	iwqp->ctx_info.qp_compl_ctx = req->user_compl_ctx;
 	iwqp->user_mode = 1;
 
-	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-	iwqp->iwpbl = irdma_get_pbl((unsigned long)req->user_wqe_bufs,
-				    &ucontext->qp_reg_mem_list);
-	spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
-
-	if (!iwqp->iwpbl) {
-		ret = -ENODATA;
-		ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
-		return ret;
-	}
-
 	if (!ucontext->use_raw_attrs) {
 		/**
 		 * Maintain backward compat with older ABI which passes sq and
@@ -713,6 +708,52 @@ static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
 		ukinfo->rq_size = ukinfo->rq_depth >> ukinfo->rq_shift;
 	}
 
+	if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_BUF_UMEM)) {
+		struct irdma_mem_reg_req qp_req = {};
+		struct ib_umem *umem;
+		u32 total;
+
+		/* Legacy context does not provide depth info */
+		if (!ucontext->use_raw_attrs)
+			return -EOPNOTSUPP;
+
+		qp_req.sq_pages = DIV_ROUND_UP(ukinfo->sq_depth * IRDMA_QP_WQE_MIN_SIZE,
+					       IRDMA_HW_PAGE_SIZE);
+		/* In case srq is used, this will be a single page */
+		qp_req.rq_pages = DIV_ROUND_UP(ukinfo->rq_depth * IRDMA_QP_WQE_MIN_SIZE,
+					       IRDMA_HW_PAGE_SIZE);
+		total = qp_req.sq_pages + qp_req.rq_pages + IRDMA_SHADOW_PGCNT;
+
+		umem = ib_umem_get_attr(&iwdev->ibdev, attrs,
+					UVERBS_ATTR_CREATE_QP_BUF_UMEM,
+					total << IRDMA_HW_PAGE_SHIFT,
+					IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(umem))
+			return PTR_ERR(umem);
+
+		iwqp->iwpbl = irdma_setup_q_pbl_from_umem(iwdev, umem,
+							  iwqp->ibqp.pd,
+							  IRDMA_MEMREG_TYPE_QP,
+							  &qp_req);
+		if (IS_ERR(iwqp->iwpbl)) {
+			ret = PTR_ERR(iwqp->iwpbl);
+			iwqp->iwpbl = NULL;
+			ib_umem_release(umem);
+			return ret;
+		}
+	} else {
+		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
+		iwqp->iwpbl = irdma_get_pbl((unsigned long)req->user_wqe_bufs,
+					    &ucontext->qp_reg_mem_list);
+		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+
+		if (!iwqp->iwpbl) {
+			ret = -ENODATA;
+			ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
+			return ret;
+		}
+	}
+
 	irdma_setup_virt_qp(iwdev, iwqp, info);
 
 	return 0;
@@ -3490,10 +3531,11 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 }
 
 static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
+					 struct ib_device *ibdev,
 					 struct ib_pd *pd, u64 virt,
 					 enum irdma_memreg_type reg_type)
 {
-	struct irdma_device *iwdev = to_iwdev(pd->device);
+	struct irdma_device *iwdev = to_iwdev(ibdev);
 	struct irdma_pbl *iwpbl;
 	struct irdma_mr *iwmr;
 	unsigned long pgsz_bitmap;
@@ -3507,7 +3549,7 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 	iwpbl->iwmr = iwmr;
 	iwmr->region = region;
 	iwmr->ibmr.pd = pd;
-	iwmr->ibmr.device = pd->device;
+	iwmr->ibmr.device = ibdev;
 	iwmr->ibmr.iova = virt;
 	iwmr->type = reg_type;
 
@@ -3532,6 +3574,64 @@ static void irdma_free_iwmr(struct irdma_mr *iwmr)
 	kfree(iwmr);
 }
 
+static struct irdma_pbl *irdma_setup_q_pbl_from_umem(struct irdma_device *iwdev,
+						     struct ib_umem *region,
+						     struct ib_pd *pd,
+						     enum irdma_memreg_type reg_type,
+						     struct irdma_mem_reg_req *req)
+{
+	struct irdma_pbl *iwpbl;
+	struct irdma_mr *iwmr;
+	u32 total;
+	u8 lvl;
+	int err;
+
+	/* iWarp: Catch page not starting on OS page boundary */
+	if (!rdma_protocol_roce(&iwdev->ibdev, 1) && ib_umem_offset(region))
+		return ERR_PTR(-EINVAL);
+
+	iwmr = irdma_alloc_iwmr(region, &iwdev->ibdev, pd, region->address, reg_type);
+	if (IS_ERR(iwmr))
+		return ERR_CAST(iwmr);
+
+	iwpbl = &iwmr->iwpbl;
+
+	switch (reg_type) {
+	case IRDMA_MEMREG_TYPE_QP:
+		total = req->sq_pages + req->rq_pages + IRDMA_SHADOW_PGCNT;
+		lvl = (req->sq_pages + req->rq_pages) > 2 ? PBLE_LEVEL_1 : PBLE_LEVEL_0;
+		break;
+	case IRDMA_MEMREG_TYPE_CQ:
+		total = req->cq_pages +
+			((iwdev->rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+			  IRDMA_FEATURE_CQ_RESIZE) ? 0 : IRDMA_SHADOW_PGCNT);
+		lvl = req->cq_pages > 1 ? PBLE_LEVEL_1 : PBLE_LEVEL_0;
+		break;
+	case IRDMA_MEMREG_TYPE_SRQ:
+		total = req->rq_pages + IRDMA_SHADOW_PGCNT;
+		lvl = req->rq_pages > 1 ? PBLE_LEVEL_1 : PBLE_LEVEL_0;
+		break;
+	default:
+		err = -EINVAL;
+		goto err_free_mr;
+	}
+
+	if (total > iwmr->page_cnt) {
+		err = -EINVAL;
+		goto err_free_mr;
+	}
+
+	err = irdma_handle_q_mem(iwdev, req, iwpbl, lvl);
+	if (err)
+		goto err_free_mr;
+
+	return iwpbl;
+
+err_free_mr:
+	irdma_free_iwmr(iwmr);
+	return ERR_PTR(err);
+}
+
 static int irdma_reg_user_mr_type_qp(struct irdma_mem_reg_req req,
 				     struct ib_udata *udata,
 				     struct irdma_mr *iwmr)
@@ -3677,7 +3777,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 		return (struct ib_mr *)region;
 	}
 
-	iwmr = irdma_alloc_iwmr(region, pd, virt, req.reg_type);
+	iwmr = irdma_alloc_iwmr(region, pd->device, pd, virt, req.reg_type);
 	if (IS_ERR(iwmr)) {
 		ib_umem_release(region);
 		return (struct ib_mr *)iwmr;
@@ -3776,7 +3876,7 @@ static struct ib_mr *irdma_reg_user_mr_dmabuf(struct ib_pd *pd, u64 start,
 		return ERR_CAST(umem_dmabuf);
 	}
 
-	iwmr = irdma_alloc_iwmr(&umem_dmabuf->umem, pd, virt, IRDMA_MEMREG_TYPE_MEM);
+	iwmr = irdma_alloc_iwmr(&umem_dmabuf->umem, pd->device, pd, virt, IRDMA_MEMREG_TYPE_MEM);
 	if (IS_ERR(iwmr)) {
 		err = PTR_ERR(iwmr);
 		goto err_release;
-- 
2.56.0.385.gd3acb90ef8-goog

