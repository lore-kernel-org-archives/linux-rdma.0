Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706FA3242D9
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027249; cv=none; b=nsWw09ErOe027E5n0zw/hsybkrm5tww3Mcnzr5+XqLKxReQEvldoZpy0H/mIS174P12sbH7lOCWi3AkY+CuJMid0UIdCLDjGkZx+rsJzyCY5QwUNguTYEFLh8vZIQI8fjztBp7y0PTUqR5N8+/fDPKMLXiB95aJSy1cECeY2+TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027249; c=relaxed/simple;
	bh=05AdkyUQdCzH6xEkkEaPU08TCfAbBpzzTM6Lv9bU/Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPBQHA5pCZXfJHvL1I55H6P91/i32U1ox10y9meJXjwaKOEQVTU4fn50HQN7LcIhwcZr6ZHefU6pXlSj5DRuWuRlE2FRP8CWXfmD7a5jvaL1+r5dfjC89LXSb/vunCR6QPDIMqzpi7gwX3Ode6kGzUgswJy3l4XFeWC4ohjUe5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=qR4ivLnO; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="qR4ivLnO"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5e948e56b8eso855571e0c.2
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027245; x=1792632045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aR4E5pBkcL1wUPcb3FSSNDhs4mdbzNgOQvXrj9SQcJY=;
        b=qR4ivLnOYQLo7ys5ErrEWeokeFZ2fhdNbQkqQIq6x+gX5npK227/+yD+vcBJxCvvGr
         Li61UYsl4VQwcs9F3lx5NISPrAF43xpbMIzOnPjR3GuwlHb7q3lFGmPywsV5+DCzP3fl
         c+Lde396+6JOo5bfzVzZsFq3tGRviA/cbRMf56Bqn0OBLWqJ2r8rQ5udhvdIxJRJ3AmT
         s1tieb5lFNIdX0LhnOOQRf7YpE9N8m4WqQNwmkdts5EBeT22wnbKhQ0pna4eHqxh15Y8
         6sLUMeaHUx9cQCt6NyzvkD2sH/4JuY9ytQB9ADqeWplNPORMgmA0JIinCa15uVdYS2Ch
         UREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027245; x=1792632045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aR4E5pBkcL1wUPcb3FSSNDhs4mdbzNgOQvXrj9SQcJY=;
        b=hLov2W41nPo7odJIjO9IDAYMjSRdnC+H0Q1B5SuTgSCmyjXjejJLG9xrYHygqQG/62
         GfYeVuHxrV6/ECZFJ+OdI+x1WDrA7j4RtTxeSEl4k8jgBRn/lw2e8NkWnDFJ7Ak2/RLe
         LyNURqVFGg96cwiw/ld3/spPnsDQfifP4OTG4rp7/76t7qRd3nIkRawAg50Km6a7koW6
         RZXCeV0xOOm6y7f90TAeFKWQYEXaEMw1/Jl5W/yatIGAsDpHGHdsg/eYLoL8RFWZrTOa
         hini7e2RBAeFjTWJVNAmWI7QMSVPMTRW2aqBM05YvvEDVJZF1qsl4dbWTSS3IWc4oi5n
         lJ6w==
X-Gm-Message-State: AFq9FYITJ/6kE1QjwI3zFmchUZzzuPeAAtRvf7SScmk/Ibx85RpVJa7j
	KizFu/5joq11dvLkqJ4dgCFcSoYNi7zKIulhWtpmzFoFKJJ4ejG5DkrNdCv86EPk+iVY
X-Gm-Gg: AYBFou1MHb+aCk/VaKlFqreIOPQ6O3igai+H2III541y2gdvBIDE4is/mOB7yTIqlvQ
	YMBqPEDMKwrPFjT1mxij/0t12Kc17yfOnWPm98KUcKUJVMKqt4gk5Yd3N6pBR9bFbZZbTGtbq7H
	ucmQwUsifZvFPFwCQlBq7QHBvjIWEeWcfnd38UMRracgPxYarQgwkTtfJNUUY3mYWJytn3BEJj3
	FsW7t2oqhr65HvfFSVHJGa/v7F01Cp8BdH4pb+e2rj8rc+YXLK6em7Nd6eK81LWe1gRxkp1FWXk
	jsokVemGLuVVgMjDqM6KlCI8hS8BCskglxqKZg7NXu4JXHI3I4YHrzAeL+OdzEwWBwpY4YMMmrt
	V91RO6uzotVGVlW0KrxhoxQ14UUYT1oTZ4F2HJeW4hjYuUsD0eC8qjEUooPXxI8W4J5efCKJdwx
	1WVuv9e+cxR/OP4iQlWkuG3jyjxOh5RGQgvpTgcQHX5w3hZC60kEG9vNI3Zwki63hlkhwFR3Jbh
	xKSfYY878Qyx1mAnbo6K8Hq76NoJcPTX//wUNdXHqkGO7q7/B+8WGHUBTzUcpFP58vhO0jDtrUn
	YBXgKwlHEG1TNHYwFiRd
X-Received: by 2002:a05:6123:420d:10b0:5ea:c67:5d9a with SMTP id 71dfb90a1353d-5ea0cd230dfmr70692e0c.6.1792027245281;
        Wed, 14 Oct 2026 18:20:45 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:44 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 6/6] RDMA/irdma: Support UMEM attribute for SRQ creation
Date: Thu, 15 Oct 2026 01:19:40 +0000
Message-ID: <20261015011940.4122452-7-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015011940.4122452-1-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

Support the standard 1-step queue buffer creation for SRQ by
`UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via `ib_umem_get_attr()`.

Set up hardware pble directly from the pinned SRQ umem via
`irdma_setup_q_pbl_from_umem()`.

Proper umem and pble cleanup, and error unwind are added into existing
`irdma_srq_free_rsrc()` upon SRQ destruction.

We maintain backward compatibility for the legacy 2-step registration if
the UMEM attribute is not provided.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 68 ++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4f0831813119..5d085933c7f0 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1996,9 +1996,16 @@ static void irdma_srq_free_rsrc(struct irdma_pci_f *rf, struct irdma_srq *iwsrq)
 		iwsrq->kmem.va = NULL;
 	} else {
 		/* Not called in any failure path, so iwpbl is valid. */
-		struct irdma_mr *iwmr = iwsrq->iwpbl->iwmr;
+		if (iwsrq->iwpbl) {
+			struct irdma_mr *iwmr = iwsrq->iwpbl->iwmr;
 
-		refcount_dec(&iwmr->user_ring_refs);
+			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
+				ib_umem_release(iwmr->region);
+				if (iwsrq->iwpbl->pbl_allocated)
+					irdma_free_pble(rf->pble_rsrc, &iwsrq->iwpbl->pble_alloc);
+				kfree(iwmr);
+			}
+		}
 	}
 
 	irdma_free_rsrc(rf, rf->allocated_srqs, srq->srq_uk.srq_id);
@@ -2425,6 +2432,7 @@ static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct ib_udata *udata,
 				 struct uverbs_attr_bundle *attrs)
 {
+	struct irdma_srq_uk_init_info *ukinfo = &info->srq_uk_init_info;
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
 	struct irdma_srq_mr *srqmr;
@@ -2440,14 +2448,49 @@ static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&ucontext->srq_reg_mem_list_lock, flags);
-	iwpbl = irdma_get_pbl((unsigned long)req.user_srq_buf,
-			      &ucontext->srq_reg_mem_list);
-	spin_unlock_irqrestore(&ucontext->srq_reg_mem_list_lock, flags);
-	if (!iwpbl)
-		return -EPROTO;
+	if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_SRQ_BUF_UMEM)) {
+		struct irdma_mem_reg_req srq_req = {};
+		struct ib_umem *umem;
+		u32 total;
+		u8 shift;
 
-	iwsrq->iwpbl = iwpbl;
+		irdma_get_wqe_shift(ukinfo->uk_attrs, ukinfo->max_srq_frag_cnt, 0, &shift);
+		srq_req.rq_pages =
+			DIV_ROUND_UP((ukinfo->srq_size << shift) * IRDMA_QP_WQE_MIN_SIZE,
+				     IRDMA_HW_PAGE_SIZE);
+		total = srq_req.rq_pages + IRDMA_SHADOW_PGCNT;
+
+		umem = ib_umem_get_attr(&iwdev->ibdev, attrs,
+					UVERBS_ATTR_CREATE_SRQ_BUF_UMEM,
+					total << IRDMA_HW_PAGE_SHIFT,
+					IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(umem))
+			return PTR_ERR(umem);
+
+		iwsrq->iwpbl = irdma_setup_q_pbl_from_umem(iwdev, umem,
+							   iwsrq->ibsrq.pd,
+							   IRDMA_MEMREG_TYPE_SRQ,
+							   &srq_req);
+		if (IS_ERR(iwsrq->iwpbl)) {
+			ret = PTR_ERR(iwsrq->iwpbl);
+			iwsrq->iwpbl = NULL;
+			ib_umem_release(umem);
+			return ret;
+		}
+		iwpbl = iwsrq->iwpbl;
+	} else {
+		if (!req.user_srq_buf)
+			return -EINVAL;
+
+		spin_lock_irqsave(&ucontext->srq_reg_mem_list_lock, flags);
+		iwpbl = irdma_get_pbl((unsigned long)req.user_srq_buf,
+				      &ucontext->srq_reg_mem_list);
+		spin_unlock_irqrestore(&ucontext->srq_reg_mem_list_lock, flags);
+		if (!iwpbl)
+			return -EPROTO;
+
+		iwsrq->iwpbl = iwpbl;
+	}
 	srqmr = &iwpbl->srq_mr;
 
 	if (iwpbl->pbl_allocated) {
@@ -2615,7 +2658,12 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	if (iwsrq->user_mode && iwsrq->iwpbl) {
 		struct irdma_mr *iwmr = iwsrq->iwpbl->iwmr;
 
-		refcount_dec(&iwmr->user_ring_refs);
+		if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
+			ib_umem_release(iwmr->region);
+			if (iwsrq->iwpbl->pbl_allocated)
+				irdma_free_pble(rf->pble_rsrc, &iwsrq->iwpbl->pble_alloc);
+			kfree(iwmr);
+		}
 	}
 	irdma_free_rsrc(rf, rf->allocated_srqs, iwsrq->srq_num);
 	return err_code;
-- 
2.56.0.385.gd3acb90ef8-goog

