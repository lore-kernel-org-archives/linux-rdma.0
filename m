Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1542F416841
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182588; cv=none; b=L6mkyIh5bzO15jGR7+7CnQJr5hXh3tLs3kmFPG5jz2jP2+rIdGZWLv0OTvnK9Xi6idoaa6YE/Ai7BdZsnuzKLRX10KU47By6rXuFTjI032Uld76H7BT7pi8UpwgbvMviZmLmL4loP6UTMMIPDSoD78t2J2dv99AkdJtP5Dpmh2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182588; c=relaxed/simple;
	bh=bMQmWFGPY6sQAqpnyfYL52EAJW5LWgWxFeeQ6WNqUh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am0LcdKbA2uAbL9Imx1Fx4zlMz3epTms97J9DF3/i7dcKvgQ8pA+QTYbuhBVMPf1nKbgecwX6gZKSg/bqrieHYQvNhLHsnG3LexanuU3+wsdhnFWqfckioyP/zolUqlOakvtwlWuPf0JRy05F06muN7gyLUu2+HRwTYikkR1K4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=tGggdkz1; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="tGggdkz1"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5e930a11148so230270e0c.2
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182579; x=1792787379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2FvNs1F6Aul+3XATGLPYMo6KW5l9NrOId+k/cxACZBM=;
        b=tGggdkz1fAlM7uvqXXO3WbtcVlKN5iO0R1amWpptAFKKA7JgeAsNkPX1d4nP7D80XL
         40DlJpT5RGSXZDEPzdcWMHFwsRI49Ec4kxFP0QgJQrSMJrGRAFoV66qcTdAiEl3Qbw7Z
         pzSMmztZLkMv+lU1Fdoe/4GbvS055VjlroQfBvLUsZONLjroVnpv3jKBS33mq6aigRQm
         RPGO0/KzYIN5/urhEgIUUp72W48M9/zVhN0Hh9SHua/fo/Njc8MD2XrXiZNSX/uQ0uNI
         x94AywvC61xLFDQxEcfLzkoMHFUBYecgXuOCI4WWhQPnR6DFthzisD15Jdd333ELt8fT
         hxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182579; x=1792787379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2FvNs1F6Aul+3XATGLPYMo6KW5l9NrOId+k/cxACZBM=;
        b=EC/M+ngiRTikaiIGBgKtqa1OZk577x8im6+E/dTRB9P0OUXIgcZgpAb5S7fMuIdmgE
         YLdRmlisd+liUrMVavwnwqZYlNljRXxXHR5RMg8dVE5ldt1dlUPQKSV2it98NF6oawTC
         ma7ys8Xf+MLYd9YwJ/OAYyhTdAuFVAntwg1oZOrkKug0RQljuSZ2DOYLqLfmsp9u7Fp/
         0fDrm2sbsBYrGKfhNYEfl+433bNGdO+EzL31zqRc2H0eKOJTzgMzWYN2QOGCV8d9JGoW
         TaVF0T0byjRvtXUnIaoV3sXOTYSEj550rlhRmwkcLfdxUAdSbAhGOis5i3GHtciFbcOR
         Lz7Q==
X-Gm-Message-State: AFq9FYJUouKXZB8HwadnMPFUIcdSRZ2rX4EqJaUgT7HjlAZyZqb1JWDK
	JwsfmDLO6c3CSHiGzqYWIIPP4HUlXwKaoVkKFl9Nk5+GN3u7EZZKXkmHRPhFRuFDXcujXiZWyTw
	SVkdw4g==
X-Gm-Gg: AYBFou2uEnaQ+1u2PV3intLzPsC4YRLThp7ygeDGm0t+gB/Lvn6duq8WOmDTLySz4o9
	USfF0e3qcn1EzFZo6xIgEQbwkKQcjZD2DjVWrKboShc765QULBOowqBkh2dhi/Wc1NICaFN45hX
	qW5Zy+v0AyU4IsD0ASVZgHcJCyHqHUwo9kVo/APPCPwfI2ZgnIbfwGVSj+cMiUg2hvtbN+alUA1
	IWl6t3lLW3kctJguL54gPJfVzQ44GesUGUffU1m3olxjfSZL1bqTKTLYxGozhaA1eWI8NpJmDku
	OJ1WomROhIWk9Zu46tqHTYkigbJvrasSJu1lPy1Z6WC/lKZTyZdgsoMMrU8VeIU4Fge4ixQ0J6h
	Pjzz14hVzNFHaBBCoVr0/KZEvXYKyosjL85t1ExxSXYQV6ba0aVCI7aBSPZoa/SEvx+mh8V94Nm
	qrrI3nAeD1lLzl1hfs/C/hHg5AnOiw0jXkCRexaxuHc5L4M6j/bIxDcUkLb69cSpIIRFP1m8t4u
	TeqProR9G5W5OXyBxA3b7TD0Lnumg0RK1BKGSLxLH8TZwdtb1y50FooRczSxF4p3Rt/sKJ0i7or
	f5xy3h/Fbg==
X-Received: by 2002:a05:6123:ae:b0:5ea:a9e1:d87f with SMTP id 71dfb90a1353d-5eaaa0c38demr556984e0c.3.1792182578872;
        Fri, 16 Oct 2026 13:29:38 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:38 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 5/6] RDMA/irdma: Support UMEM attribute for CQ creation
Date: Fri, 16 Oct 2026 20:29:08 +0000
Message-ID: <20261016202909.1289496-6-dhu@x6u.co>
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
 drivers/infiniband/hw/irdma/verbs.c | 129 +++++++++++++++++++++++-----
 1 file changed, 108 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4b7e9c2d9cff..02ed7ab99e48 100644
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
@@ -2746,14 +2768,18 @@ static int irdma_setup_umode_cq(struct irdma_device *iwdev,
 				struct irdma_cq_init_info *info,
 				struct uverbs_attr_bundle *attrs)
 {
+	struct irdma_cq_uk_init_info *ukinfo = &info->cq_uk_init_info;
 	struct ib_udata *udata = &attrs->driver_udata;
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
@@ -2767,26 +2793,87 @@ static int irdma_setup_umode_cq(struct irdma_device *iwdev,
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
+	if (uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_CQ_BUF_UMEM)) {
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
+		if (uverbs_attr_is_valid(attrs, IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM)) {
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
-- 
2.56.0.176.g3575e65682-goog

