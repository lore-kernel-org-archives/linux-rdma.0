Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384152;
	b=JVmErSU3/Lx7Z1VHJxyICF/Vk/W3EjdkijnTTGfrjfs2NkHJUAkFy2y5oFrxOXi1jmnv
	 L5GlTP6OSAA+ODLH7eyk62QOaH1Cbv3Zuso4Y4D6S4yDoEQg10RrDxQgOKs3x2uMnZ4yz
	 fER+bBQaJHGQg/TG8qZ28jEGDGNRlKEhzLP30/YKE8gcjtVARNhXuqf1koFR9HCyBsgFL
	 unQqPg9gdP85vne+Zx2TDziNFN5wASRFa3rFqH/LXvmv5jylEjJqQMqUsnhB90saiAYa4
	 Cb3HKTOVAIPA7xu2yH8dQlNmjg+ETL0007/4lpkGEpqEWxYgT638oHylykjL3PtvhEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knp/tm/TZZVuxSSAFhZ+sMDH3dqo4kKd8WvgszJHIrU=;
	b=lZX6mCHGXoOcGxOSCb4MUYaC9oc7O998+aWs2nCfmkO9HScU5qeE47qoDchoRq5EprMI
	 lVCaeI6B7/IWPQldB33G0SOsV4VZh4XMuXZKyYhFwTryKOPLv+bHFSXlIPjLjWICTpZee
	 ZUi9Mi/v2zmT48tupDqv9zrBMwnYQH/sWO41BreWomF8cBFE/wINm1RElipwAK4PwBiWi
	 HlqtSIt5b6/OVKG7Q4W94Tz8HZTJIOgTPGXF/MyAbF9HzNkiRbyfyBLhXjQCloRzzOABG
	 ra7A7DrHJqMLhO/jLco8egqI7OQEdCwDdLu8FF519jTcGNVv0DxxQw5ls2zDeKxkXSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=ogLD6Tp+;
	arc=none smtp.remote-ip=209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9C560A261E
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B9C560A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=ogLD6Tp+
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9908346255fso1186831241.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384151; x=1793988951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=knp/tm/TZZVuxSSAFhZ+sMDH3dqo4kKd8WvgszJHIrU=;
        b=ogLD6Tp+YyMdz7wHpzk2XoQGinbHqKDrCMTIeQNH+D07GyBSjKeQ/u0XIWZApRyT6j
         EQfrmIMyjPJBtCK0yMOK9/T+WtXdMU7MctcxAuwaNxJGr8O4JXreQzoYo3XL4r6nt16Y
         Ty2/Xm8wPCi4SezydQGiQ9ZJA55gxRZKDqhpXsMiQwle70Z87cyPb3QVasZXmiq4TmGe
         Jjv7nPieKeELmlm2NfN7Oh8RCgwNcnnQ5SHigFASw/+maW6e5IMdwsZvw14S3rZreDvu
         1eA2PV2lvLkDH5tVHx5/vPtXxO9BYJjXB9Em7CURiMw+WZb/Hs13XZfUL1b3Yw7FXXlL
         19Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384151; x=1793988951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=knp/tm/TZZVuxSSAFhZ+sMDH3dqo4kKd8WvgszJHIrU=;
        b=AIwWB/3P7s3E8quSZhIAfStFBxicg39kWl1EPqSoYrPGNjKRhiMrIBTB+SGyhTPE3D
         XHYKHKH1x6zk1hamu19055rR7AHqAqipEI6qEP+ujHZE3uzOX5DC4jRi5SQ4y2a0WZXQ
         DwWO97muF2Smbac++mP8zYkG0o5uOxxYInsPdjcRo2Y3g263hEDZFNrL2YseZpE4JCIc
         WP9JSnyC2jg5ErP1uX4uHhEtsYlTF921OsBCj6VdOpcpcWSGsy1QBIMOBIN13UTQh5ry
         b1priL1A1aT+tiAwSUF74K/LWwfn73dvWJhDqNascpHhDbpmIpsA6nUNLPP4QtsM2dTz
         ICbQ==
X-Forwarded-Encrypted: i=1; AKwUvBzEL8otdNbqhbEtAHrRut65CgAO8/S/mgFdxMetYs1VMQ3bPlAjJPjLq+CbnDxQ5mDKTzowqSfBEl1D@vger.kernel.org
X-Gm-Message-State: AFq9FYKdBglyNMLfYh+nDAsZ6ZrMGSN8U6h/5wDGW42xOQBpdWoYDzpl
	M07ET6Zp8wTkHeg2v3VnX5pOqNs0MZSIfYdB15e7m9pPTFn1qHWLGuwGJfONSejOwuqr
X-Gm-Gg: AYBFou1KnZnBZS4hRZMe+RhrYmt5m5eqgS4sRkxhuQDGbnf0x4rL8TJM+pZScBiTeJQ
	k8udLCn6SnJIhvujpeKEIhsTc2d7KmAXARqGFcbXrZoZfRnZs2bvx9stgs+KReTUK4OD2REl+DU
	JdUBk2xxWFXcyGgS6Hm1gmkUCJ7ElW5s13VxEWtrSNkj940wnrRfkFY2uIo7TSQ5J3aO1Hqvt+0
	cqawaviYgi0UJIs/WnloVg0C8d3hDo5OSsG4n8PxYW5XfWQAyW9qNj88PJEcmSmwitf+PXZWiQW
	Q5A8oTimo+7HX3AIlA5rfUAYAJOvdVSo5lx4ogirA/02GJOIkR+Iqq/MboUgCQBm2iVAqkvYiQv
	zxhs3ZK59lxLItL0sDQ7sXh15/kLC3Bd37Z1CcrnnVy8Bx0G6Keak4Gvz5mU1fLLxkjDiljvBEY
	ugN3p3/m9WPqHG67ebVIEQPQdBXo0h7XgasMj/UIXrPfH96MwoLhMQ7hy7cycJDv3mv1QCBUswA
	IA2a6011i7fh2v0jEbq9ZaV/USRAo+Gr3OJB+7/fLG9CGeW9kJAAKEq1SRUPQ1Ok8kNyrJCDQ8q
	yG+pLBWX03v+qOQJ1AKq2Cm3wu8G4c0aI7MmP8NTNPgATtrtGNj+G39+U4j+d25x7PNBgHNu51P
	xJ8n9cMREWzOnWT002PjUhq4DsziA1st+VsbYn68EYTMg
X-Received: by 2002:a05:6102:5106:b0:7c1:e804:3c91 with SMTP id ada2fe7eead31-7d072c398bdmr931456137.8.1793384151354;
        Fri, 30 Oct 2026 11:15:51 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:50 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v4 5/6] RDMA/irdma: Support UMEM attribute for CQ creation
Date: Fri, 30 Oct 2026 18:15:11 +0000
Message-ID: <20261030181512.2056056-6-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
 drivers/infiniband/hw/irdma/verbs.c | 132 +++++++++++++++++++++++-----
 1 file changed, 111 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 9f4905fdb791..41e56ab8aa6d 100644
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
@@ -2872,6 +2959,9 @@ static int irdma_create_user_cq(struct ib_cq *ibcq,
 	if (err_code)
 		return err_code;
 
+	if (attr->cqe > rf->max_cqe * 2)
+		return -EINVAL;
+
 	if (udata->outlen < IRDMA_CREATE_CQ_MIN_RESP_LEN)
 		return -EINVAL;
 
-- 
2.56.0.317.g454f8302e1-goog

