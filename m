Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384154;
	b=REM2cYcmIaZrnnUwz9D3DfFfjW74ZbGI5iy0Mh9CVRAh/naOht+wF86dM/XrDQwJ8xWV
	 pOD4NDDL/PbStklZ4xFKKpej6It1qL7LIaGl+89ZXI+JwyS3oucp46tfWGKwJOFWOzCp0
	 2kUJ5gxhnSiaPa2BCkCrXUcr2ifjvoJV3S/+DdEvWSme9mFzgi8dzrrpKrTGEOtGbPglw
	 xbQQKvmtZEUCKbFIF1c2ZsEHgRXh5DuM0jv9OW33UDmWcJHFxs3QuCywKXmPvYBpAS1wq
	 hdXaVmzcO8AASHZVd/aC/H7D0FfQ2LE5eOIPeMMf4zfk9Woqx4YNHfiFeELGVmN4mUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384154;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L7ar4WAN3UXBnRdyQx7m5lT8b0DpMHKQHo9PR1aXr18=;
	b=IUEThzdnqiHk5nXa2XO2c2MUAHwEj14zL4SvDOyuRex1urqCNhAANVec0yiusu4NJB6I
	 2MIggoQ8s2BSndyqTcOhZmJX760ZcSDUqIE9VBZFgsXewzeYrQGCtb8GM5xPtlkokCdXQ
	 5nAPAr5xbsm8MgwMHylat7poS2prBJwPKJxgDz8LVA0HIrDILYfCt0GGTc+27DAKj80iB
	 YyX0ZmbJtNogwSSQYPx9dw+uLZC58K03k8SxWhpwz02FZaxWp5IubAQq2juz6LIMqAPe5
	 qGeKUrPmleIDwE+NdoffpMvMSB5OanHpEW8ZQmQOmhBC55rfM4wVwP4TCUa+NgWB9Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=hbxUTMQ7;
	arc=none smtp.remote-ip=209.85.221.175
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFC660A2615
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBFC660A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=hbxUTMQ7
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eac7220e9cso415185e0c.3
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384153; x=1793988953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7ar4WAN3UXBnRdyQx7m5lT8b0DpMHKQHo9PR1aXr18=;
        b=hbxUTMQ7hWfx+LOb8VX+BpQxWFc9WMPuPr93teTZjtIPrghQ9fo/HVj4pzgvEGrpNa
         qQLmXqS72FYsC5SPNH7DP4kzffMykrnk+kQ2sb5H5kFGlepFdG94xSkVjBKbrop8L0+1
         TJxxJx/7DTFigUsdYRAuqZGkCKG0ndRWQ0CTXkA5vmxi1bPWjo+P3T2zdoauYMNwOLKt
         BSjhRco7jMLjsfdMcc2KQpnHoBoofmIucIqNqkKH25YG7fzi8QIt4EDeBccAOFXrnlDy
         MafdUwezpfrimWYlklzLz8q9SIezWc42ltyZ3YA0Ihn8AGiVr9pnZIxxbv+zTxFTHJaJ
         aZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384153; x=1793988953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L7ar4WAN3UXBnRdyQx7m5lT8b0DpMHKQHo9PR1aXr18=;
        b=Om9VhUyKxV74LqvffLeXtqPz2bN8fyMXG5LP4w4ysjJEe79eDf26MPnKhRj5uZnaBa
         aHanpKHlxrMZAgT9OH3vNOEfZq9tiFnHb5EI4fbhCFM39/IHKEgBjg4YgtRlqFbiwNcU
         vowOHwj25vmQcPsdqVu8uJgStvQwJTL0OJvtMAhUA3kYAJgpXJnhkP8WR8AhtkMf8PAw
         oft7Gz3iHZOXJ3/iG3ai+3nM4GGrY2GD2XBJR9XnfRVAhuVvvZqDZb4SUrBzDPkQxY3h
         dfsQiLWFV6piE1cBDTLmFrHKzhLyEtorxGWpmGAMifunHdzyBK3kf2IKNATjJD9IiHYS
         nFoQ==
X-Forwarded-Encrypted: i=1; AKwUvByaZlMcN1rc9XjIA0BsMFEudTUrLwUR9kTzbcxO62TPQhg2qxps2ju5xBd5gkhlgQZL07uZaTYOiPoa@vger.kernel.org
X-Gm-Message-State: AFq9FYLUotVUrdQTQ4nNfjEq75NUMsY/b+UKpsBW6C5F+1rYfo5J69/W
	iDxUxyTlqZa69e5szLdLL5r7Bp1o1cWLfAFiDxhkeoomPicHDOkckdrcb5nmWzA2O6wt
X-Gm-Gg: AYBFou1tf4QhD6praoFwAyQQFINlKVeAz6eRvaICZDw7um2NzM+1QwZhfpxrycqg5Jb
	+PjbcPHzrsQ4UTme7gGOn1e9WIZFHLFkU4O3k6pGofHvzY54Absh03nDIuI5iVM+gYG6fcyrLqx
	ny96qOOHt11jtEA4NSQCdRs5rtigVsuHC5oM+BBljAoKnTOgHW/Dep2AcTvi9uIujHw+ZRM3fa7
	Dric0X8xzW2RCgmZjvDHeXHeYze0JEzw7WfSzUSHekqt/7X6fnJiLGG2KBpkZ+s7t3R1E86f078
	W0H1cRj6Xxu1b61yl+bjI4PYP9PeeSke3k8W5lej0/fuEjbmBylHGVlOE11rZnEmeCa+zkHuH50
	ygRaX2W7UGfHX2LTE9WDPA6WKywXnG4xY0huOrGLV6BzJyqQ2pigw/bQ2GG6/ZURRegMBNHknaG
	RcfJnXUFWH3Bvf2BM1Km1YZfRgS3a1KQ1ntlfzH80AUZo1QpkUd3KCnelcJlArzffUA2JY1kHBr
	2IjnoZNeVFuq5+1JjBrm0Zz+LyUkkZxwVSfKXYpnG0owkfcXNXtbbzaIwWgtpIFw8LVRxUNXo8Z
	6zNmLbww7bHlFE/Wq+nkneleyyAd+LOD4eCAg2lwxp1CWNj40VeQtWQ04wougzStrzv3T0Eq8x6
	LWWaajYDeG8YOb1gvuq0J5JhzrQWhpYkN6d9SDlUWsGE=
X-Received: by 2002:a05:6102:8097:b0:7c3:3890:6076 with SMTP id ada2fe7eead31-7d0725cfd65mr1551425137.6.1793384152685;
        Fri, 30 Oct 2026 11:15:52 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:52 -0700 (PDT)
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
Subject: [PATCH rdma-next v4 6/6] RDMA/irdma: Support UMEM attribute for SRQ creation
Date: Fri, 30 Oct 2026 18:15:12 +0000
Message-ID: <20261030181512.2056056-7-dhu@x6u.co>
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
index 41e56ab8aa6d..7e8a5e481730 100644
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
2.56.0.317.g454f8302e1-goog

