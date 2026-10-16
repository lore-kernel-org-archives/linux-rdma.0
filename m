Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1FD4CF468
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182585; cv=none; b=b+k6j9tNK7DcVwxPkTMBoBHALJvTp+/4Kbh32I5POP/2/7gCzvdBsL9X0G150BLSoVdVkRYaQv9jwVPhsxzxhkbZ+Guq8wS8LDI+iwp23OOWWq0EP537zk5vCquMGxcrv0QK7ahA3HfEw6A6J7bLiv9wVmh3l0YEXY+lU2EVkk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182585; c=relaxed/simple;
	bh=zuqsIDr02iUaNUf24uD9AuyNgKxsfF+SdmXBLhWQafI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRkTQpa9N6lHGFtUcn7WmKUuR497u7mw62jRJ9KmJcvS77PAn3GkWrQNY2Xd3mOWUAhQKRrNOLit7uQJIW/E7l1ha9EefgUnOFu7peoUY5uOdWmdHYBJyLNkVTh9OupqBgL57c2ijZzEAsfVEz21RLA76mlwrBrZ5sAVz4/FZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=MOtCKBtU; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="MOtCKBtU"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5dc2dc6d3fdso123974e0c.0
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182581; x=1792787381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6gBm4eYWH8ADZOqk+02ZWT3WvoW2g25kohhyi8mFq8M=;
        b=MOtCKBtUyER/Gy+BEes9e1MsDQfrVlI6qkmpT6mBiv5CTpBEg8TELlmGpPZ9rJsi1j
         UIUr1orKWr0O79W1nstZ2H9cCRosIkULXa6lMCQo8w5DMMmgfG0UP+Bc8mWGjeHzFZsH
         yq1aIjsSK6mNPXbcFNyTkoQMIpBfF6cRx8Bgamuf9iI3EKxqSFXjHB1hmvuBxTEKe0tb
         C+xpcCYH+yPhPynNwz/crnvZO/mQZu8BO+ebPOboNaVDmm5t3dnfYl+3t/kB9G7HX4Xy
         b2LA7zy+oC6odicCe5UEBnKZwIXuVoVFauW0BxNVKTKW7Ab98A+jp/JUBoLBwm8fSkht
         jY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182581; x=1792787381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6gBm4eYWH8ADZOqk+02ZWT3WvoW2g25kohhyi8mFq8M=;
        b=qZcDn54devGucb94BKHPGUgHagzMfCMFCc1QivaMf7ziqRsln1/S2BA5vswX62Up25
         knKP26q1PC9oIAjW7DBM2+EORbze0L+O6NHdh1IIpJsZzUhF+HTpp3IiGrrt/yczGjOM
         RPck8/HCOOnvQlQc2cIyHQ58z/NthRV5swOwi10KDX4KiXaxtsG8aqoedWNZMhrK83Qh
         THdi2l0TTDifp6POA7NxaQJ5U080ec5o+9fkLeUs02qOkjNfW0mqBsQJQpL/ezlN7VWL
         1mXvx/glf6OhOTHQoIPcBar35APQnr+pAnD+qX88dbonLmwYKisPfarr8Q8jGDJ6MJ2+
         NC6Q==
X-Gm-Message-State: AFq9FYLAtK+P40/j9xhvBkSnRjPlDK/z2j8O+USlrYiFaxyXA2bOcmXL
	3xe+O+euv6Kg4I/6Z9hvIo+HvftoEJMzlojTXmxKxHCYqzrXA1B2cTzkRWPJotkdbnaZ
X-Gm-Gg: AYBFou0giHDsYRcGp2vGWR3yTrsDqPNUITcMYTsMaXyAymX8D3jr9i2hlR0gYRWJeIA
	Mm5+ZmiAhsZR2/YhNLflEBZLC/cMjouq4+6B1qCCl11v0v5IETkmHVbbGggFGR4I7PRG6oBeefN
	Uh/bG7KnGBE8JAHE4+S2z/SZx+uiMEDo3RooQtskjWXambil0q7xazjk8vV9DmJfSm7zPDN+ppD
	hyytKHj4OqZ0SoL1TUu7QL+lay8MUiIdirpPhFQNe88n1BiejV4XjpnSoBWa+9Ouiu8Wia+cR43
	BSvQTt/8xchsASfbFa5DWxxaJ1/0RcqMpMmwNDQhtG0/buOC+G+0NpGgal2vlze8pbABsmBUb4J
	MbuMO6fCJsM5csHKzdWmQTSjTZ6+Y3ccV5RY1cMvU9iDB3/1/gxeY5Q+Gn0c5heZoCW6V/QM1f0
	O3+Q+2RFODjbzf1bupA8/y/LTdto1DAXe/rOiwD2hZQMEnnXRk6wmhQVea48NHsi/nspZ0C4PBR
	VLAUtdlNe1la5dq96wtQBI57CjTnLNCh4Gvqpjm8gkacnPgjOvjXCl9cFc4kPIAFN9jsr/iA2Sv
	ui8HlvGnTA==
X-Received: by 2002:a05:6122:c1c4:b0:5c9:e022:f642 with SMTP id 71dfb90a1353d-5eaa9ecd066mr465972e0c.0.1792182580691;
        Fri, 16 Oct 2026 13:29:40 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:40 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 6/6] RDMA/irdma: Support UMEM attribute for SRQ creation
Date: Fri, 16 Oct 2026 20:29:09 +0000
Message-ID: <20261016202909.1289496-7-dhu@x6u.co>
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
index 02ed7ab99e48..d8f4358e5486 100644
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
2.56.0.176.g3575e65682-goog

