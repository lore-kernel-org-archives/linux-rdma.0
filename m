Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D231E82B
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027246; cv=none; b=J0qqATcuRbsboGjx83s9OQAkqJCamGDhFXNryw2dFIHvYTRZErUWNez/tQgbWCFQvUco9H1HK/FrUV2LokYHdTL1LOy8r6/c9zecNY4C3v2yvpuVaOMAyJCwlEL85QbodGeqrIJ4tWdtshZUdht4QUCCFq/CVbwDULsri2HBg0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027246; c=relaxed/simple;
	bh=HeEYS4ZdYMFES3cNCOYwOV/M26i0VppeIk1NZ7IKm/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE0cGkErORBql1CV3E6E96+hmPxAgcQ7x/buTfSqrNVblhsfIAx1AOtdCDm7ux1teCu4xpz39NWAXrSdMKQA5DI8cP3J3TxRi02wYKzFUTCdgGpbxvkhbzRLpCaZpmppWSGDlEa9aOW+O3HWMQEohUuA4aZmeGsYeYvmYlW4GR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=e4mg+ZQL; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="e4mg+ZQL"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5e189660cbdso786298e0c.1
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027243; x=1792632043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d9DeaH+2kLV69uaObfPYF0BGWxoks2kBHmSQiHqO18M=;
        b=e4mg+ZQL8LLjKOwdvXfpe7Bg0+IsgnWXoEk8eH9Nx/8BcU5/RMWWijkv6qiI9VJ95s
         SGd8GxU2h3KdadH/NPL9txRvoQIUXd95yODqygW1lB2p1TaH/FZqepNOO+71rrGrV6Y4
         HpKlXcCUlwsQt2MsZUP6fIyOuYnngf62ep7tNKcnQcLPzFyKhw5Pikg4Gw/7XpJhKcdu
         6TMb3n08fdNTvq3/AVr00E1LVrhC3nsQLSf+KsBLFq4cCDdBlseewTHSmc4dQ1iaszoP
         KKBxkjq46mjosbQkD1j6RZSet0pngy9/FlafzRI4bbfPhbY9NyAGnkDaWB+sH7lEJGn0
         t/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027243; x=1792632043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d9DeaH+2kLV69uaObfPYF0BGWxoks2kBHmSQiHqO18M=;
        b=UggNaTQCEgncjN2Iw7moOqGhZrSDKCbd+UMdXwl5kzgBxQKAkaRK0mqPaI8lQweosN
         1HflXYaI+98BvMCmBfNwZ6DaD3Ccx6FKMg+UbAOrtPPMrDiX0ghUO9R37ltiUXb6g++t
         93NR4RIT8Eap58FepneCYtBPxhgBK7vV8BPLMH30OLzwTv/pHwUEd/bv9XHeubBDtISr
         XSbn3xsZb55xv1/4qSBvI8sTOFzuuux4Xfb6UgJ3G67Oj7Y9uSrHpTHZywvKnBp01rs/
         uZnQEq+Yu08PjW/AQAR+xsKL2Z1gW0kIJHE58V+LfeETQ/QONS4U045K3LvuzytOGdFM
         CMGQ==
X-Gm-Message-State: AFq9FYJWBsLRumo4FdZvt+kOSE2RQmVcNHBbBQHrMFbKdiYvbk2mNwck
	m5/MCezrbNOknhMU4ygm8nL23aSn3fr6tFwNgFplFKX6GxrkLrgpd7DfDq4EHi4BwCWh
X-Gm-Gg: AYBFou0QXzRkkQGsDTGy+p4zx0yXuWPDk0JKmUfg0EhbXzaWHtVsJbbLkEKTF/Nqx/8
	InVdy8cVNmbDQ9pevp82GjHDRd85ndSR2z8gVboJFhxoj4CGLy4nmTEggucmcKpAI/ZuEOV5zkp
	BAljnNBeeTVjHOufpFyaL1VkVrW2kpC0U+CJ1/h7dRdvD7wLn/7TgzRjXa460QRXlL0tPZ/trkg
	fuE9nob84cUKWlYeM6YPwK/gv+A5d5JHJg9rHN4uZrO5a5OnwWRD60G7sooflXXj6TzfvkX/oyt
	vPRvI03STpJFeBEqfSQjZqKWgKTS2kSdlMjVBMjtmDz0HEk3elI5byHakXa3/R+fFRqWtQy2IRb
	gJBH8QhAkG839G7gTs9xEKIuuO0RsOYt3vUTH6wVfxqIXBapGPF2GOelHGiixrKcsLLxkZfcCdp
	ALkUnDDDEfyDepzfiFJPwux7Qijxu1JK3QrDuq4Dpb89I2c8RdgYFR1dR3eSMSdUOUchCsA9j2E
	FnbixNbzZ20r1NyyxcXh4NycP/EtYeaIKTh0Jp8sFperQgNx74F5uvWEsFODIaXrBYp0c1Durpg
	C1kygH5+PSDI01F7Z/oD
X-Received: by 2002:a05:6122:17a2:b0:5cc:4a63:4a01 with SMTP id 71dfb90a1353d-5e91f483a40mr6046479e0c.11.1792027243301;
        Wed, 14 Oct 2026 18:20:43 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:42 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 5/6] RDMA/irdma: Support UMEM attribute for CQ creation
Date: Thu, 15 Oct 2026 01:19:39 +0000
Message-ID: <20261015011940.4122452-6-dhu@x6u.co>
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

Support the standard 1-step queue buffer creation model for CQ by
`UVERBS_ATTR_CREATE_CQ_BUF_UMEM`, `IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM`
via `ib_umem_get_attr()`.

Set up hardware pble directly from the pinned CQ and shadow umems via
`irdma_setup_q_pbl_from_umem()`.

Proper umem and pble cleanup are added into existing `irdma_cq_free_rsrc()`
upon CQ destruction.

We maintain backward compatibility for legacy 2-step registration if UMEM
attributes are not provided.

`irdma_resize_cq()` will have a possibility to deal with a pble/mr that
is created via one-step logic, after this change. Therefore, a proper
cleanup is added.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 135 +++++++++++++++++++++++-----
 1 file changed, 112 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 7162b37fa6ff..4f0831813119 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2028,13 +2028,24 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *iwcq)
 		if (iwcq->iwpbl) {
 			iwmr = iwcq->iwpbl->iwmr;
 
-			refcount_dec(&iwmr->user_ring_refs);
+			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
+				ib_umem_release(iwmr->region);
+				if (iwcq->iwpbl->pbl_allocated)
+					irdma_free_pble(rf->pble_rsrc, &iwcq->iwpbl->pble_alloc);
+				kfree(iwmr);
+			}
 		}
 
 		if (iwcq->iwpbl_shadow) {
 			iwmr = iwcq->iwpbl_shadow->iwmr;
 
-			refcount_dec(&iwmr->user_ring_refs);
+			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
+				ib_umem_release(iwmr->region);
+				if (iwcq->iwpbl_shadow->pbl_allocated)
+					irdma_free_pble(rf->pble_rsrc,
+							&iwcq->iwpbl_shadow->pble_alloc);
+				kfree(iwmr);
+			}
 		}
 	}
 
@@ -2161,6 +2172,7 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	struct irdma_dma_mem kmem_buf;
 	struct irdma_cq_mr *cqmr_buf;
 	struct irdma_pbl *iwpbl_buf = NULL;
+	struct irdma_pbl *old_iwpbl = NULL;
 	struct irdma_device *iwdev;
 	struct irdma_pci_f *rf;
 	struct irdma_cq_buf *cq_buf = NULL;
@@ -2273,17 +2285,12 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 
 	spin_lock_irqsave(&iwcq->lock, flags);
 	if (udata) {
-		struct irdma_pbl *old_iwpbl = iwcq->iwpbl;
+		old_iwpbl = iwcq->iwpbl;
 
 		/* Only update if the resize was successful. Otherwise, HW is
 		 * still pointing to the old PBL.
 		 */
 		iwcq->iwpbl = iwpbl_buf;
-		if (old_iwpbl) {
-			struct irdma_mr *old_iwmr = old_iwpbl->iwmr;
-
-			refcount_dec(&old_iwmr->user_ring_refs);
-		}
 	}
 	if (cq_buf) {
 		cq_buf->kmem_buf = iwcq->kmem;
@@ -2298,6 +2305,21 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	ibcq->cqe = info.cq_size - 1;
 	spin_unlock_irqrestore(&iwcq->lock, flags);
 
+	/* Old pble/umem is cleaned up outside spinlock's atomic context
+	 * since both of them take sleepable lock.
+	 */
+	if (old_iwpbl) {
+		struct irdma_mr *old_iwmr = old_iwpbl->iwmr;
+
+		if (old_iwmr && refcount_dec_and_test(&old_iwmr->user_ring_refs)) {
+			ib_umem_release(old_iwmr->region);
+			if (old_iwpbl->pbl_allocated)
+				irdma_free_pble(rf->pble_rsrc,
+						&old_iwpbl->pble_alloc);
+			kfree(old_iwmr);
+		}
+	}
+
 	return 0;
 error:
 	if (iwpbl_buf) {
@@ -2686,15 +2708,20 @@ static int irdma_setup_kmode_cq(struct irdma_device *iwdev,
 static int irdma_setup_umode_cq(struct irdma_device *iwdev,
 				struct irdma_cq *iwcq,
 				struct irdma_cq_init_info *info,
-				struct ib_udata *udata)
+				struct ib_udata *udata,
+				struct uverbs_attr_bundle *attrs)
 {
+	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
 	struct irdma_create_cq_req req = {};
 	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
 	struct irdma_ucontext *ucontext;
 	struct irdma_cq_mr *cqmr_shadow;
 	struct irdma_cq_mr *cqmr;
 	unsigned long flags;
+	bool cqe_64byte_ena;
 	int err_code;
+	u8 cqe_size;
 
 	iwcq->user_mode = true;
 	ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
@@ -2708,26 +2735,88 @@ static int irdma_setup_umode_cq(struct irdma_device *iwdev,
 	if (err_code)
 		return err_code;
 
-	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-	iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
-				    &ucontext->cq_reg_mem_list);
-	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
-	if (!iwcq->iwpbl)
-		return -EPROTO;
+	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
+			 true : false;
+	cqe_size = cqe_64byte_ena ? 64 : 32;
+
+	if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) {
+		struct ib_umem *umem;
+		struct irdma_mem_reg_req cq_req = {};
+		u8 shadow_pgcnt = (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+				   IRDMA_FEATURE_CQ_RESIZE) ? 0 : IRDMA_SHADOW_PGCNT;
+		u32 min_size;
+
+		cq_req.cq_pages = DIV_ROUND_UP(ukinfo->cq_size * cqe_size,
+					       IRDMA_HW_PAGE_SIZE);
+		min_size = (cq_req.cq_pages + shadow_pgcnt) << IRDMA_HW_PAGE_SHIFT;
+
+		umem = ib_umem_get_cq_buf(&iwdev->ibdev, attrs, min_size,
+					  IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(umem))
+			return PTR_ERR(umem);
+
+		iwcq->iwpbl = irdma_setup_q_pbl_from_umem(iwdev, umem, NULL,
+							  IRDMA_MEMREG_TYPE_CQ, &cq_req);
+		if (IS_ERR(iwcq->iwpbl)) {
+			err_code = PTR_ERR(iwcq->iwpbl);
+			iwcq->iwpbl = NULL;
+			ib_umem_release(umem);
+			return err_code;
+		}
+	} else {
+		if (!req.user_cq_buf)
+			return -EINVAL;
+
+		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
+					    &ucontext->cq_reg_mem_list);
+		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+		if (!iwcq->iwpbl)
+			return -EPROTO;
+	}
 
 	cqmr = &iwcq->iwpbl->cq_mr;
 
 	if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
 	    IRDMA_FEATURE_CQ_RESIZE) {
-		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		iwcq->iwpbl_shadow =
-			irdma_get_pbl((unsigned long)req.user_shadow_area,
-				      &ucontext->cq_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+		if (attrs &&
+		    uverbs_attr_is_valid(attrs, IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM)) {
+			struct ib_umem *shadow_umem;
+			struct irdma_mem_reg_req shadow_req = {
+				.cq_pages = IRDMA_SHADOW_PGCNT,
+			};
+
+			shadow_umem =
+				ib_umem_get_attr(&iwdev->ibdev, attrs,
+						 IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM,
+						 IRDMA_SHADOW_AREA_SIZE << 3,
+						 IB_ACCESS_LOCAL_WRITE);
+			if (IS_ERR(shadow_umem))
+				return PTR_ERR(shadow_umem);
+
+			iwcq->iwpbl_shadow =
+				irdma_setup_q_pbl_from_umem(iwdev, shadow_umem, NULL,
+							    IRDMA_MEMREG_TYPE_CQ,
+							    &shadow_req);
+			if (IS_ERR(iwcq->iwpbl_shadow)) {
+				err_code = PTR_ERR(iwcq->iwpbl_shadow);
+				iwcq->iwpbl_shadow = NULL;
+				ib_umem_release(shadow_umem);
+				return err_code;
+			}
+		} else {
+			if (!req.user_shadow_area)
+				return -EINVAL;
 
-		if (!iwcq->iwpbl_shadow)
-			return -EPROTO;
+			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+			iwcq->iwpbl_shadow =
+				irdma_get_pbl((unsigned long)req.user_shadow_area,
+					      &ucontext->cq_reg_mem_list);
+			spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
 
+			if (!iwcq->iwpbl_shadow)
+				return -EPROTO;
+		}
 		cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
 		info->shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 	} else {
@@ -2807,7 +2896,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	info.vsi = &iwdev->vsi;
 
 	if (udata)
-		err_code = irdma_setup_umode_cq(iwdev, iwcq, &info, udata);
+		err_code = irdma_setup_umode_cq(iwdev, iwcq, &info, udata, attrs);
 	else
 		err_code = irdma_setup_kmode_cq(iwdev, iwcq, &info, attr);
 	if (err_code)
-- 
2.56.0.385.gd3acb90ef8-goog

