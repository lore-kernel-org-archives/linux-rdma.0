Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703219;
	b=tZ2garVP/s50ukh5oUkyd6ae8jHebgEgdCMdBOvUkeVmB6hmo1uTq3t8d2qH24zv9Qa3
	 s1KYU07ZPdmGRF/lyk00AowvVbtQGF0BNO9VrwZAIrZX2f0OKGGUAGZPRFX0Q08Ru+WCk
	 tJYkWvIpnEGuwwAkMqlncu5wdGTtWFl6pant8LE7hQk8BWokToekPVIWV2nlb3WtAZ16o
	 tBWoiwmbUsB3x/MGIBktD3YdmUkfhmx25ab0Gnyoxm2iKuW2erenttwiCVZAff76ocx6R
	 XQtq8kGRvvd/8coE+Yjdh2aiVWgZD1UXAUluykDxYUpyjeksRosOlfmCl+amyTVGE3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703219;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=m5fD7ko5ukqhgGqkCjH25hDt4PZN+9Tqz9EFEUUpkoc=;
	b=2ckjgAKA3x5YshGcwA5Nsq61S/lEF+pjmWsxXK7AOXdqGrQrZ/xSh/85Mg/K367cN6DI
	 v8kSQbko7Jys030K8MobIIAiEV0xb252BZ2OqhczsTkGN0mHdja7r4U/4EaXRlJItFZtt
	 pvtg72HyTdDWFMrT1a5M/ntnTCvG5nOJgmhXspEzA4S5OZ8B1nzVXPmZSNHhW/LcDyjAK
	 0EceDwciqUNSChOJUY6+tmHIIonXGRJ0qSWiq2GydLZWNncZbMPo0jNZiB8FI6/n0XsGU
	 co9oB2jsJGb4loOxgzrpyvEY9sziMD+oDeowsqnKrXUtRGWb21APMyP0VzG/ENfTQXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FYgL8mCH;
	arc=none smtp.remote-ip=209.85.160.199
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2F7606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 21:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F2F7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FYgL8mCH
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5351f1b26e6so2568141cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792703217; x=1793308017; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m5fD7ko5ukqhgGqkCjH25hDt4PZN+9Tqz9EFEUUpkoc=;
        b=FYgL8mCHleyMo29buKtvB1E1xEf8pxUTSKUUHfc4oOLVfdWjQQ70qcK1f9I8Qf+wxm
         7AiSwO0NrN77mG8WAu7LwH2pYFlprqaD5hHr+0qMIUnuW1z+LhOferB8178N5RP4K+Ih
         dX1bklColRSieDetB62fDjLhCw0Rl394YkwvrGORHq3wkkXaFtAP1yOkPy84G0jkLnTH
         oWSwwH4fZd82kXL9nhjRp4tacXMBBLbKiVVJY9j2A6V6WHFzz6SAAlHsfGCDql3OsX6s
         fqF0bOMkcS45AsFmhfAAkXlweSNDuePxXLfV05H27ud/W7luvMkskC1l/mXD9Z3Coz9P
         QqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703217; x=1793308017;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m5fD7ko5ukqhgGqkCjH25hDt4PZN+9Tqz9EFEUUpkoc=;
        b=ucwdOlrQ1ITlEjCjvkvOPQK/47+2N/L3AhEwAk0zCttNmkHtswzPO3dOt3LJfYET+P
         qFgzbUVtEfqoCxV0gIc8jg2J3ZD5/qmxP6Q2dj6PEuVyBUuTOHcbyx5kva+DOHjR3ukG
         Fx4xB+agZ2MvUebuBF8vtcZGAwpHzgMdddsDy+nVlnHWYGAF4e9w4ZXoVy7ylGOv+Lyy
         45MPJu//+m046qQ+Ym81GdJNQXwpboX0LweeEX6cndyaqZQK7x5Ev2Zthec6FTZZvCuL
         jimXi3AlE0SNHkPezCNVu8m7fJr2HizewUTvVw8NUQdqo4B4GAmdCGJ6CU92Fp+hYYdT
         FP4Q==
X-Gm-Message-State: AFq9FYLNur9oNltXNZ8aVX90y2IvUDdA/sHvazjfJ6UEkwa/ZzsKCsjG
	+nQeOj7dzKwuzwgRWK1yO7ezK/cNug8WNfqFD0mVfKkkJ3lr88webB16dHkY9AUduhAWVNl+rgm
	IHKdzPFftaw==
X-Received: from qtyf11.prod.google.com ([2002:a05:622a:114b:b0:535:2805:c0a6])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:622a:5a17:b0:533:9686:a051
 with SMTP id d75a77b69052e-536c2803575mr1272341cf.21.1792703217347; Thu, 22
 Oct 2026 14:06:57 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:06:49 +0000
In-Reply-To: <20261022210650.1182000-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261022210650.1182000-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022210650.1182000-2-jmoroni@google.com>
Subject: [PATCH rdma-next 1/2] RDMA/irdma: Fix FRWR logic for PAGE_SIZE > 4K
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>, 
	Leah Li <leahlijuan@google.com>
Content-Type: text/plain; charset="UTF-8"

The HW only supports 1G, 2M, and 4K page sizes, but some ULPs
pass PAGE_SIZE to ib_map_mr_sg(), and PAGE_SIZE can be some
multiple of 4K (64K arm kernels, etc.). The HW can still support
these scenarios, but we must force it to use 4K pages. The
max_fast_reg_page_list_len and page_cnt during MR allocation
must also be scaled to accommodate for the additional PBLEs
that will be used when ib_sg_to_pages() ends up producing
more pages than what would have otherwise been required with
the original page size. It is worth noting that this change
avoids this over-allocation/cracking in the off chance that
a 1G or 2M PAGE_SIZE is ever used; it's only applicable when
PAGE_SIZE is some power of 2 multiple of 4K that is not
currently supported by HW.

This was discovered by encountering SMMU faults when running
kernel NFS/RDMA on a 64K kernel, which was due to the page
list holding PAGE_SIZE entries while the WQE was indicating
4K, so HW was translating every access after the first 4K
incorrectly.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Tested-by: Leah Li <leahlijuan@google.com>
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/ctrl.c  |  4 +++-
 drivers/infiniband/hw/irdma/defs.h  |  1 +
 drivers/infiniband/hw/irdma/verbs.c | 36 +++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 1c2ad5773b9f..ef8627f070ce 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1703,8 +1703,10 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 		page_size = IRDMA_PAGE_SIZE_1G;
 	else if (info->page_size == 0x200000)
 		page_size = IRDMA_PAGE_SIZE_2M;
-	else
+	else if (info->page_size == 0x1000)
 		page_size = IRDMA_PAGE_SIZE_4K;
+	else
+		return -EINVAL;
 
 	sq_info.wr_id = info->wr_id;
 	sq_info.signaled = info->signaled;
diff --git a/drivers/infiniband/hw/irdma/defs.h b/drivers/infiniband/hw/irdma/defs.h
index d6a3152959dd..eb9179664884 100644
--- a/drivers/infiniband/hw/irdma/defs.h
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -159,6 +159,7 @@ enum irdma_protocol_used {
 
 #define IRDMA_HW_PAGE_SIZE	4096
 #define IRDMA_HW_PAGE_SHIFT	12
+#define IRDMA_HW_PAGES_PER_PAGE	(PAGE_SIZE >> IRDMA_HW_PAGE_SHIFT)
 #define IRDMA_CQE_QTYPE_RQ	0
 #define IRDMA_CQE_QTYPE_SQ	1
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c91c55917de9..9443e9732c4a 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2,6 +2,21 @@
 /* Copyright (c) 2015 - 2021 Intel Corporation */
 #include "main.h"
 
+/**
+ * irdma_fmr_pages_per_page() - HW pages needed per PAGE_SIZE page in an FRWR.
+ * @dev: sc device
+ *
+ * If PAGE_SIZE is one of the HW supported page sizes, then it can be directly
+ * used. Otherwise, we need to break PAGE_SIZE into multiple HW (4K) pages.
+ */
+static u32 irdma_fmr_pages_per_page(struct irdma_sc_dev *dev)
+{
+	if (PAGE_SIZE & dev->hw_attrs.page_size_cap)
+		return 1;
+
+	return IRDMA_HW_PAGES_PER_PAGE;
+}
+
 /**
  * irdma_query_device - get device attributes
  * @ibdev: device pointer from stack
@@ -58,7 +73,8 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->max_mcast_grp = rf->max_mcg;
 	props->max_mcast_qp_attach = IRDMA_MAX_MGS_PER_CTX;
 	props->max_total_mcast_qp_attach = rf->max_qp * IRDMA_MAX_MGS_PER_CTX;
-	props->max_fast_reg_page_list_len = IRDMA_MAX_PAGES_PER_FMR;
+	props->max_fast_reg_page_list_len =
+		IRDMA_MAX_PAGES_PER_FMR / irdma_fmr_pages_per_page(&rf->sc_dev);
 	props->max_srq = rf->max_srq - rf->used_srqs;
 	props->max_srq_wr = IRDMA_MAX_SRQ_WRS;
 	props->max_srq_sge = hw_attrs->uk_attrs.max_hw_wq_frags;
@@ -3208,12 +3224,16 @@ static struct ib_mr *irdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 				    u32 max_num_sg)
 {
 	struct irdma_device *iwdev = to_iwdev(pd->device);
+	u32 pages_per_page = irdma_fmr_pages_per_page(&iwdev->rf->sc_dev);
 	struct irdma_pble_alloc *palloc;
 	struct irdma_pbl *iwpbl;
 	struct irdma_mr *iwmr;
 	u32 stag;
 	int err_code;
 
+	if (max_num_sg > IRDMA_MAX_PAGES_PER_FMR / pages_per_page)
+		return ERR_PTR(-EINVAL);
+
 	iwmr = kzalloc_obj(*iwmr);
 	if (!iwmr)
 		return ERR_PTR(-ENOMEM);
@@ -3233,7 +3253,12 @@ static struct ib_mr *irdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 	iwpbl->iwmr = iwmr;
 	iwmr->type = IRDMA_MEMREG_TYPE_MEM;
 	palloc = &iwpbl->pble_alloc;
-	iwmr->page_cnt = max_num_sg;
+	/* Some ULPs pass PAGE_SIZE to ib_map_mr_sg() but PAGE_SIZE can be some
+	 * multiple of 4K that the HW does not natively support. We can work
+	 * around this by cracking the larger page into multiple 4K pages, but
+	 * page_cnt needs to be scaled.
+	 */
+	iwmr->page_cnt = max_num_sg * pages_per_page;
 	/* Use system PAGE_SIZE as the sg page sizes are unknown at this point */
 	iwmr->len = max_num_sg * PAGE_SIZE;
 	err_code = irdma_get_pble(iwdev->rf->pble_rsrc, palloc, iwmr->page_cnt,
@@ -3297,8 +3322,15 @@ static int irdma_set_page(struct ib_mr *ibmr, u64 addr)
 static int irdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 			   int sg_nents, unsigned int *sg_offset)
 {
+	struct irdma_device *iwdev = to_iwdev(ibmr->device);
 	struct irdma_mr *iwmr = to_iwmr(ibmr);
 
+	/* HW only supports 4K, 2M and 1G pages, but some ULPs pass PAGE_SIZE
+	 * which can be some multiple of 4K that we do not support, so force 4K.
+	 */
+	if (!(ibmr->page_size & iwdev->rf->sc_dev.hw_attrs.page_size_cap))
+		ibmr->page_size = SZ_4K;
+
 	iwmr->npages = 0;
 
 	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, irdma_set_page);
-- 
2.56.0.218.g1ec904b173-goog

