Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6A9447239
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182580; cv=none; b=EYimXlSZ/0RukTWha8172mjtedE4WzTxXRDuM6DJsk5KNf0nQieUqpgihg7Sp0Wcd+K3arGMZ64hVVob7xvnzXn9ermLKHHyANAY3cF5r/MQu0h3OyDsQmEQkSOyHLn9InKPWkm7nI9tsrMsG5bX+Y/UdmEhq8kLdxpoyMb+J2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182580; c=relaxed/simple;
	bh=rIvIpPteAQqyktlVQXTcEWFq7uKDkaeyfC9U/aSI+I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2hek5GiyiMriIk4tUalaaNYsxQE3jntIibhnbDeTmwmnlN7nJv0xq65wZUiZrY7YFQv+EEDCczPWi5ySt2uB9aVUK2yMTuASrOgARE/ofb2hBA9QUdrxRdG7rik2b/vJD37NgG4tTZawHHNGn6ndrrBhg0+Rb6S3SblBZfwvec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=QCXKt+qf; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="QCXKt+qf"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5ea63f01606so181933e0c.1
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182574; x=1792787374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4+Xg4kCSvyEHmgKPh6OsSxZb9+Dx8EF4CgPvOIEBYZg=;
        b=QCXKt+qfI0QDL1uVqpVXuOfYP4JBmyv9wV606O1iDCjec1UqMlVPfTwhWOv68KxU4J
         TEv9j0gtTtK9lyNMhPflN7dKU6IXUO2+AnNAFF0ocqUzn9guH4w879WJyGBswm+kkiEC
         wq42t65pIjrakxfPdVyJE2is/bfL8OCszmZgYt6RRgUnQoJrp9R4ifGUTYw2/pfnxfBu
         wDB09QIWKkn/7oZy3P/di0HHU3OV+F9deik3LMCk+SLuC0Lua3JmALgv71TiKINOLzJG
         opnAaG8nRn5V24aMwLXzuPILxnSmyOUMe1u2c74ghWocHGWFYpDbWzebtpN00VAayu+d
         63NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182574; x=1792787374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4+Xg4kCSvyEHmgKPh6OsSxZb9+Dx8EF4CgPvOIEBYZg=;
        b=NKFpzzMI2Y9Xc5m23bSj/egakjb5+oXw7W1V6pZK9oFRDYTCAQb6pspjLoCJzjkgp6
         BDDu+Hn9jCGMNotiTpTjlZqHzTnqkNGDwifSd+uMue0SxMa/G7CrUki0iupoC3iwwFXf
         AkRNKZByomMU/obqdXRVfD4xPguSAfHtF8erXfc38doL3+lc7BqIpaR0xJSbOwAXTP4z
         EXKNIW5T4ki7u4/kwbTNBYiaWcYNQajSPjzAQqDKoz4zCd1ovqrXcSfLsTLD5M++yRZ+
         0KPioHMKmDTNjH7lhlOf72DeISon8M8zyIvEHWaZFg6R/7dtRZE1eVVzII9/zeWC/beO
         ANbQ==
X-Gm-Message-State: AFq9FYIZYYnNfYD6omPyehNUuIefZ08Jo28TOGLvKcdD/wLmDSwyLOZB
	7tODVb7150MjQS3TpoinRXyMWviKzEIC2ipcdhRg4GHR+B7UfoKPW6wwMoiQhzN+OLe4
X-Gm-Gg: AYBFou08o+gA8Is1hLfewrzyiBSViFuyCbm/j2WUBHer0rfETUeIiPtc4HI8grxtS4o
	46I/d5qNPC71XlU6IVMJXeIaUez7Of97LmvXt/4qxQPKqqOgC15H1jdUh3BLZITfPCPD7WC2Iv7
	1Zy55bWAMFzQoi+TH7VauX6DxGUxQujgW9w9/iNWECGKCmNR0dD/jpyGAq+q9YYErpPWQKaiWT3
	SAtaR/J7siT8cjN3LtDzeRtgvIjUYoq9jnLM5RB1nFz5uTUW9iHFCal5YyVvPrshpRG4fivUMHE
	MrTJRDLlUV2eRR5Bk5jj2FAUi9Lu91Iabjkw7KlUL5R/ZJqRJb6McuSBWH/xlgGOADVjOq9X6eI
	qo6pqKU9+TBbVKa1wsVl5O9ug4xW6HhmHGA81brmkpjILTunebTaYR4Docsc+cs4JP8w/0gALuQ
	J/hAaMlzlXeUWhzb7bcY5JuyDEU+GllTTI603POvTtKt0HQ9ZEy3fq7CcuMw+QWZvCr0QqJr8tg
	agFK3pLd8hQr/Z4N1z/Es1EfqCczGhj7w+NDl/eCelrSdOx0GzsjYmk3PrM+3Kk89new1oUTJ08
	5pxluybmpRPnUwUaMvQIkQ==
X-Received: by 2002:a05:6122:f05:b0:5e5:7ac3:c9d with SMTP id 71dfb90a1353d-5eaaa651fe4mr508869e0c.15.1792182574081;
        Fri, 16 Oct 2026 13:29:34 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:33 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for QP creation
Date: Fri, 16 Oct 2026 20:29:06 +0000
Message-ID: <20261016202909.1289496-4-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016202909.1289496-1-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

Support the standard 1-step queue buffer creation model for QP by using
`UVERBS_ATTR_CREATE_QP_BUF_UMEM` and `ib_umem_get_attr()`.

Add `irdma_setup_q_pbl_from_umem()` to allocate the backing MR and program
hardware pble directly from the pinned umem. Proper umem and pble cleanup
is added to `irdma_free_qp_rsrc()` upon QP destruction.

We retain backward compatibility for legacy 2-step registration if the
UMEM attribute is not provided.

`irdma_alloc_iwmr()` assumed there is always a valid PD, which is valid
for regular MR, and QP. That is not the case for CQ. This modernization
fixes `irdma_alloc_iwmr()` to take in an `ibdev` to avoid a potential
NULL dereference.

Note for MR teardown: This patch unifies the teardown of legacy 2-step
queue MR and modern 1-step dummy MR via,

`refcount_dec_and_test(&iwmr->user_ring_refs)`

For legacy queue MR, ref count starts at 2 (one by queue, and one by
`ib_mr`), it goes to 1 during queue teardown, while deferring memory
teardown to `irdma_dereg_mr`.

For 1-step dummy MR, ref count starts at 1, and teardown happens cleanly
here.

The teardown sequence (`ib_umem_release`, `irdma_free_pble`, `kfree`) is
inlined in `utils.c` here because `irdma_free_iwmr` is statically scoped
in `verbs.c`. Combining was considered, and we think it belongs to a
future project.

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
2.56.0.176.g3575e65682-goog

