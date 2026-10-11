Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B22A2D94AF
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681100; cv=none; b=QbCh6c7K7CgmIVD1jePs+RmYt2VIqqq9y4sferZoV0pUK72bs9HcNNB790cahQUYh7wtu68PJwNQB7YPDPoCzNwI8QL/6wxiFNf00/qhrMSoohjz1OMJDoukPVWQiBfL9i3pT4dys1k/cfGbr5fja35x8oSwPH2QwYcxb5AAJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681100; c=relaxed/simple;
	bh=Jd9TDUW7MtPMHubKz6vTXi5FG4agSXog70jUIjozroI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4wymDUxubqAOvW77VmDx8XviNLLlpW3G2Bzy6apWhamQxyvifabzJY5MZPnKGSJxaEkzDlxQzTiKnce0KI3OVqBGljYbjA17YKtZnrYUEHEBfW+gOM96QTxjI2TDmGw0lTVRQHdTMpi0EBZt8PhjovpKsvFMA5ghz/ooygkeRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=D9N9gOPz; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="D9N9gOPz"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ab37e44643so4531117b3.0
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 18:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1791681098; x=1792285898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QxVYkCol0mo3SRxFqyvvpN4DEwbY/JfjR8JOwwtRCcE=;
        b=D9N9gOPzqrMrDyLTzx4k3+e4KQoBKHkHQIcojNOSZ4pt0HoPztU9XED2lVqppiabRM
         KAio5ZJIGjCLFNgq4DhVyfkDP8GIR5aeEXMhPBe/VZrgf7bARIB7VtrqWAyzP4vXKAq5
         J6CEY8uP3gJFkUdJ/vSVrRb0khUKrWPw+PyjUK8DhCBZjV+rXuxv0eKku9xzXtqHeDj8
         MAQeOXOGe9GPDU/9/FmWtWKOrSUWCG/E4TDmzWhJ2RyzcoOffpbOghN8+P7A0518g8rw
         ifpCscDd3RiFKUaNQhEoyfvY4zILiKb/MXhBg2xwR7KEeDXLoLsUFsENCwwL+fyfZwnN
         /h/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791681098; x=1792285898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QxVYkCol0mo3SRxFqyvvpN4DEwbY/JfjR8JOwwtRCcE=;
        b=mZXXJqKwiaVEI58317yRoSubArlaKZAlxVqdx6WSElbhS7oLzX69Iahfpbr4ZQuLBP
         m8Q175RchurkXhal3KiIFGr0DaW74aKyROj/wFjUo9WzWlnFz+k3mQ+jvAuB9fSXbaPx
         yLEa2uVskM38AmvBnW7fMK7TsyvykbjvRzD5towBT1wSv07EGa6W8uqu1V4XUBsAYEyY
         +xK3E4YzfFqr3wHq5KleNCpzrX+mialoNGu261gioGbkLzd4gd2DfCLug83cAV7wyG5E
         +bH4CmHuIMmgLh6tSTEaMMctLR/vWazwTOLKIhGc+wFjQs4WEJ99Dqco13JkqtYdaCUe
         iM4w==
X-Gm-Message-State: AFq9FYIyPHN3Q7Hz70XMii6YJMsA5nfGhXBZRyuoWUF/nmrFX7ZLjNK6
	58oadlx5yxv+McVsDywHsSRehM6ZAys4B/03ManBKn5TOD9SrPZaNLjxk71F0S3l/xWm
X-Gm-Gg: AYBFou1jqdYfdrAmtfne5Px/V0c7fJai+9QFmJ1WkCE3sL9Hupoem/UrcPsXoGt5rlW
	OQe2a9qUE5DggSPw8pH3oCInrpnCCivtmQKcsBo9zjcsQJKeFGOA5rBrzqiHSLmRHWUVU7EVtJL
	1S/AwWT+p0MU/zsTtm7hOFIVmbA5ar6sG5ncg3e6w/iEePlXAdxiuarh50v1VjBodm19w9AdVvK
	Sf0wa6IRLMoYCKG72RNvGvH/GJEdNzY3Hk6VBccA5RENhoeWRoyIAjqQ4duO+Ktzdxr1dVdlzTc
	w1uV7HOyHe2HuN+4OyYj5ySb+nYErQJEv2wz2HNZKtbO8meJtTphln2O3jOTg4Qd6CszJeBQuTv
	GkIbHaEsJefbGL9M/tZqnvZwSYSVyY4byggDlM4OXPi+SoUmMklwRIRMv9BbSDKeo7OUcoiWNHc
	IGu033JAv1Uqwue2nKaLe6WaSBGcLLFLTmN67K48Lfv8+n7uu1z+GEQSPtl8TRAgD0rzG9zw1AB
	mPz8yuUVnIEnDuQxhjTVAyxSwBsJ64728uqpqsVR43NZHLNVUkQy0HfIGgGF77XLnD+qnGkUdwc
	9tubTSetRg==
X-Received: by 2002:a05:690c:e3ea:b0:8ac:dbb9:2203 with SMTP id 00721157ae682-8b07edb00a1mr20263737b3.71.1791681098009;
        Sat, 10 Oct 2026 18:11:38 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b07f263bc8sm21311817b3.45.2026.10.10.18.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 18:11:36 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next 5/5] RDMA/irdma: Support UMEM attribute for SRQ creation
Date: Sun, 11 Oct 2026 01:10:22 +0000
Message-ID: <20261011011022.1445352-6-dhu@x6u.co>
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
for SRQ by `UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via
`ib_umem_get_attr()`.

Set up hardware pble directly from the pinned SRQ
umem via `irdma_setup_q_pbl_from_umem()`.

Proper umem and pble cleanup, and error unwind are
added into existing `irdma_srq_free_rsrc()` upon
SRQ destruction.

We maintain backward compatibility for the legacy
2-step registration if the UMEM attribute is not
provided.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 68 ++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index e4a02a6b2a11..274c76badd2e 100644
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
@@ -2414,6 +2421,7 @@ static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct ib_udata *udata,
 				 struct uverbs_attr_bundle *attrs)
 {
+	struct irdma_srq_uk_init_info *ukinfo = &info->srq_uk_init_info;
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
 	struct irdma_srq_mr *srqmr;
@@ -2429,14 +2437,49 @@ static int irdma_setup_umode_srq(struct irdma_device *iwdev,
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
+
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
 
-	iwsrq->iwpbl = iwpbl;
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
@@ -2604,7 +2647,12 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
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

