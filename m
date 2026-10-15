Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D245F30F924
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027243; cv=none; b=awFNOf2XPST2b5mTKEwqEzdWBiZT71N4sJEGeKZZsgzYrcgnR5ZfgtlFRjY5bu7/2G9N0mfw5SXV+w4s9AB/5UY9ykgtnoVHOuYzjTw6fNxfVbybhl/rA8ashWz2hsyfbikdPVW5zy5y4xZ5y9smuvDQWqLj2gYnP5G9VrcPS/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027243; c=relaxed/simple;
	bh=qCLNVKxLJkWXFqU35WMp1J14wsmA3k67348rp/dRJkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKTiseWIwZRdOUutAJN3PzNpe1dA+vh8qs8pZtIFZx1YrAALyFJWRhLxvZAchiMh9Qi43Mz65D0Iorqp+lHzAE5sLCXYzTaHDvPlweJbDLX0qqDgUdLzy/R9nEIfAtlSgxalKd2guXXAS2NgFCs28oktxopSyuVynZucQ+RsQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=KvNZmTl0; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="KvNZmTl0"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e23be41cf8so2220932e0c.2
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027241; x=1792632041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y5chewDA2yXm++fmFIK5GXVdJVUzcHX3WO7RnkNaGWg=;
        b=KvNZmTl0Su5Lbo3eueXTZHWJQsh/ZNAopMV6QJy0HlJhtE2qRl8X+5+nJTZT4onw7m
         VZenifnogHCG49q2hqV/y+ITyknc6Pi3AP5G1VVEvPyGn5TU9jL/QKr6YPpDrBUADdRC
         Cz5ECQk04EK8+KEcBa3zipmsJEXgPUtbMXfWA4YkNqzay6QSzcnbwBu3jzDF9+LhuZUN
         2rLnNYA7K/9IB7/Svj+RSnlmop6HmukMDkYBFBu4zYfWeL5MVVrB9EZ12HmhEsbHah4J
         33Pn9PRqAtrQVtBOHx/4141fFGJdLME5irzT+3Ghk58d8YF29/HblJs7eJbdHFOBBg39
         8Kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027241; x=1792632041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y5chewDA2yXm++fmFIK5GXVdJVUzcHX3WO7RnkNaGWg=;
        b=1ncB70SLsxXjCTMmmtZtCvF9XAtcc2EyIOTr2O49tmr0dXBuEWQYNLfPugjNmgc6Ex
         GPyIbZXRVfhv1EoOFaNHAQC3O54zYa1TIBSqsqDCKFybJ9OnlUJeLq4LKKX/JDMkQ7n1
         eHH5jrQJ8neXvw6Of2IFv+idWPmsQ7egH90Lq3O1k8MmNsMkErXHz87Mfb5wvsKWJrFT
         FvWg4nzLqDkAatQ0u03e6zq6c7CM6zfx4FD2OKtdjKdiOKdwZVleGJC3AfamooYwSDg0
         31/sW8JVYebj8YdngCPk4wvKEns87vApzAV9r+y1QGwF0mPltlIm/ealzvJQWVVKsibL
         47Mw==
X-Gm-Message-State: AFq9FYI73dFVVel1409fhnrwCcDYc3J+SCyjPJUtk1yXav2hisKc4SD6
	TxBqPjrPYhgwmVCQWzBllMiEI+VCm1VeyYdCcyQEB2VoS0pTAA2eCgwY7nhJ8Xa57EIu38+nKAb
	IaiyOGw==
X-Gm-Gg: AYBFou3a80np0uOj84oep7LX3xaCecrPl2zddJncYm6Pi+IMcYQ+FOAMwlIO1iGdbqg
	4ekmGhWIcLKJ8So2pZHgfQk8UnLuf76LumhnF+44x2wf+q/wDIa2S6PDdERyy32KXTEyai3VaGh
	qDQ8MwqXbNlgLTHPe3A4aBpdeCPa0zCP8KC55G4ku2nArWojQNUOUS2kVTPJYh1CohIGc+WB4DE
	5GOvun/tG5F4fB/e6VIscOr5uKW4SAPm7jzPIa6/WPDxeWD6EA3unRoifTHOFgyc1ObKfkoGx7z
	uacpserD4TXYcSHSxnwZ0388y9Z3yNbiXAwFgxk9MWzJGxIlFmY8nf4dqiItx7QYVpOJMGKnAju
	hMfjnyoICsnIrW1k8qf2RY1SP08YT9zftHThtexg5zpQUIzjW3mfw7r3FoAiZpTG1wKVUPz5Ir8
	1lmvE8252nozk+HFT6nm+Jb1hbVQkDuQTwEOrQhs8n1CNo+Jlb9/o9j8kE2msa82TjZvkmgnsgM
	Cn39Mtv3ukgUsfIrgyI+4wHTpNJF0jk9+liNHIYSGnsPXgr/p2vDz8xmgU40l2dTGMm2d2BLpod
	LyiR0hkYRw==
X-Received: by 2002:a05:6122:4899:b0:5e3:315:b654 with SMTP id 71dfb90a1353d-5e91f24c1femr5986454e0c.1.1792027240607;
        Wed, 14 Oct 2026 18:20:40 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:39 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 4/6] RDMA/irdma: Split CQ setup to umode and kmode
Date: Thu, 15 Oct 2026 01:19:38 +0000
Message-ID: <20261015011940.4122452-5-dhu@x6u.co>
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

This split is similar to QP, and SRQ that is already present in existing
irdma driver. Only variable plumbing was done, while umode and kmode setup
logic is identical as before.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 232 +++++++++++++++-------------
 1 file changed, 126 insertions(+), 106 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index ab25445f3828..7162b37fa6ff 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2624,6 +2624,126 @@ static inline int cq_validate_flags(u32 flags, u8 hw_rev)
 	return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOTSUPP : 0;
 }
 
+static int irdma_setup_kmode_cq(struct irdma_device *iwdev,
+				struct irdma_cq *iwcq,
+				struct irdma_cq_init_info *info,
+				const struct ib_cq_init_attr *attr)
+{
+	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_sc_dev *dev = &rf->sc_dev;
+	int entries = attr->cqe;
+	bool cqe_64byte_ena;
+	u8 cqe_size;
+	int rsize;
+
+	if (entries < 1 || entries > rf->max_cqe)
+		return -EINVAL;
+
+	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
+			 true : false;
+	cqe_size = cqe_64byte_ena ? 64 : 32;
+
+	entries += 2;
+	if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
+		entries *= 2;
+
+	if (entries & 1)
+		entries += 1; /* cq size must be an even number */
+
+	if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
+		entries += 2;
+
+	ukinfo->cq_size = entries;
+
+	if (cqe_64byte_ena)
+		rsize = ukinfo->cq_size * sizeof(struct irdma_extended_cqe);
+	else
+		rsize = ukinfo->cq_size * sizeof(struct irdma_cqe);
+	iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
+	iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
+					   iwcq->kmem.size,
+					   &iwcq->kmem.pa, GFP_KERNEL);
+	if (!iwcq->kmem.va)
+		return -ENOMEM;
+
+	iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3, 64);
+	iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
+						  iwcq->kmem_shadow.size,
+						  &iwcq->kmem_shadow.pa,
+						  GFP_KERNEL);
+	if (!iwcq->kmem_shadow.va)
+		return -ENOMEM;
+
+	info->shadow_area_pa = iwcq->kmem_shadow.pa;
+	ukinfo->shadow_area = iwcq->kmem_shadow.va;
+	ukinfo->cq_base = iwcq->kmem.va;
+	info->cq_base_pa = iwcq->kmem.pa;
+
+	return 0;
+}
+
+static int irdma_setup_umode_cq(struct irdma_device *iwdev,
+				struct irdma_cq *iwcq,
+				struct irdma_cq_init_info *info,
+				struct ib_udata *udata)
+{
+	struct irdma_create_cq_req req = {};
+	struct irdma_pci_f *rf = iwdev->rf;
+	struct irdma_ucontext *ucontext;
+	struct irdma_cq_mr *cqmr_shadow;
+	struct irdma_cq_mr *cqmr;
+	unsigned long flags;
+	int err_code;
+
+	iwcq->user_mode = true;
+	ucontext = rdma_udata_to_drv_context(udata, struct irdma_ucontext,
+					     ibucontext);
+	/* Even though the last member of struct irdma_create_cq_req
+	 * was always user_shadow_area, we need backwards compat with
+	 * the legacy i40iw struct i40iw_ucreate_cq which stopped
+	 * at user_cq_buffer.
+	 */
+	err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
+	if (err_code)
+		return err_code;
+
+	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+	iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
+				    &ucontext->cq_reg_mem_list);
+	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+	if (!iwcq->iwpbl)
+		return -EPROTO;
+
+	cqmr = &iwcq->iwpbl->cq_mr;
+
+	if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+	    IRDMA_FEATURE_CQ_RESIZE) {
+		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
+		iwcq->iwpbl_shadow =
+			irdma_get_pbl((unsigned long)req.user_shadow_area,
+				      &ucontext->cq_reg_mem_list);
+		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+
+		if (!iwcq->iwpbl_shadow)
+			return -EPROTO;
+
+		cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
+		info->shadow_area_pa = cqmr_shadow->cq_pbl.addr;
+	} else {
+		info->shadow_area_pa = cqmr->shadow;
+	}
+	if (iwcq->iwpbl->pbl_allocated) {
+		info->virtual_map = true;
+		info->pbl_chunk_size = 1;
+		info->first_pm_pbl_idx = cqmr->cq_pbl.idx;
+	} else {
+		info->cq_base_pa = cqmr->cq_pbl.addr;
+	}
+
+	return 0;
+}
+
 /**
  * irdma_create_cq - create cq
  * @ibcq: CQ allocated
@@ -2647,11 +2767,9 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	struct irdma_cqp_request *cqp_request;
 	struct cqp_cmds_info *cqp_info;
 	struct irdma_cq_uk_init_info *ukinfo = &info.cq_uk_init_info;
-	unsigned long flags;
 	int err_code;
 	int entries = attr->cqe;
 	bool cqe_64byte_ena;
-	u8 cqe_size;
 
 	err_code = cq_validate_flags(attr->flags, dev->hw_attrs.uk_attrs.hw_rev);
 	if (err_code)
@@ -2679,7 +2797,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	ukinfo->cq_id = cq_num;
 	cqe_64byte_ena = dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_64_BYTE_CQE ?
 			 true : false;
-	cqe_size = cqe_64byte_ena ? 64 : 32;
 	ukinfo->avoid_mem_cflct = cqe_64byte_ena;
 	iwcq->ibcq.cqe = info.cq_uk_init_info.cq_size;
 	if (attr->comp_vector < rf->ceqs_count)
@@ -2689,109 +2806,12 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	info.type = IRDMA_CQ_TYPE_IWARP;
 	info.vsi = &iwdev->vsi;
 
-	if (udata) {
-		struct irdma_ucontext *ucontext;
-		struct irdma_create_cq_req req = {};
-		struct irdma_cq_mr *cqmr;
-		struct irdma_cq_mr *cqmr_shadow;
-
-		iwcq->user_mode = true;
-		ucontext =
-			rdma_udata_to_drv_context(udata, struct irdma_ucontext,
-						  ibucontext);
-		/* Even though the last member of struct irdma_create_cq_req
-		 * was always user_shadow_area, we need backwards compat with
-		 * the legacy i40iw struct i40iw_ucreate_cq which stopped
-		 * at user_cq_buffer.
-		 */
-		err_code = ib_copy_validate_udata_in(udata, req, user_cq_buf);
-		if (err_code)
-			goto cq_free_rsrc;
-
-		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
-					    &ucontext->cq_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
-		if (!iwcq->iwpbl) {
-			err_code = -EPROTO;
-			goto cq_free_rsrc;
-		}
-
-		cqmr = &iwcq->iwpbl->cq_mr;
-
-		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
-		    IRDMA_FEATURE_CQ_RESIZE) {
-			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-			iwcq->iwpbl_shadow = irdma_get_pbl(
-					(unsigned long)req.user_shadow_area,
-					&ucontext->cq_reg_mem_list);
-			spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
-
-			if (!iwcq->iwpbl_shadow) {
-				err_code = -EPROTO;
-				goto cq_free_rsrc;
-			}
-			cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
-			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
-		} else {
-			info.shadow_area_pa = cqmr->shadow;
-		}
-		if (iwcq->iwpbl->pbl_allocated) {
-			info.virtual_map = true;
-			info.pbl_chunk_size = 1;
-			info.first_pm_pbl_idx = cqmr->cq_pbl.idx;
-		} else {
-			info.cq_base_pa = cqmr->cq_pbl.addr;
-		}
-	} else {
-		/* Kmode allocations */
-		int rsize;
-
-		if (entries < 1 || entries > rf->max_cqe) {
-			err_code = -EINVAL;
-			goto cq_free_rsrc;
-		}
-
-		entries += 2;
-		if (!cqe_64byte_ena && dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
-			entries *= 2;
-
-		if (entries & 1)
-			entries += 1; /* cq size must be an even number */
-
-		if (entries * cqe_size == IRDMA_HW_PAGE_SIZE)
-			entries += 2;
-
-		ukinfo->cq_size = entries;
-
-		if (cqe_64byte_ena)
-			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_extended_cqe);
-		else
-			rsize = info.cq_uk_init_info.cq_size * sizeof(struct irdma_cqe);
-		iwcq->kmem.size = ALIGN(round_up(rsize, 256), 256);
-		iwcq->kmem.va = dma_alloc_coherent(dev->hw->device,
-						   iwcq->kmem.size,
-						   &iwcq->kmem.pa, GFP_KERNEL);
-		if (!iwcq->kmem.va) {
-			err_code = -ENOMEM;
-			goto cq_free_rsrc;
-		}
-
-		iwcq->kmem_shadow.size = ALIGN(IRDMA_SHADOW_AREA_SIZE << 3,
-					       64);
-		iwcq->kmem_shadow.va = dma_alloc_coherent(dev->hw->device,
-							  iwcq->kmem_shadow.size,
-							  &iwcq->kmem_shadow.pa,
-							  GFP_KERNEL);
-		if (!iwcq->kmem_shadow.va) {
-			err_code = -ENOMEM;
-			goto cq_free_rsrc;
-		}
-		info.shadow_area_pa = iwcq->kmem_shadow.pa;
-		ukinfo->shadow_area = iwcq->kmem_shadow.va;
-		ukinfo->cq_base = iwcq->kmem.va;
-		info.cq_base_pa = iwcq->kmem.pa;
-	}
+	if (udata)
+		err_code = irdma_setup_umode_cq(iwdev, iwcq, &info, udata);
+	else
+		err_code = irdma_setup_kmode_cq(iwdev, iwcq, &info, attr);
+	if (err_code)
+		goto cq_free_rsrc;
 
 	info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
 					 (u32)IRDMA_MAX_CQ_READ_THRESH);
-- 
2.56.0.385.gd3acb90ef8-goog

