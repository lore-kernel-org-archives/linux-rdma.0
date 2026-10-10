Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFB613A258
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791661720; cv=none; b=GuYI0xQPjzMc1VICZ1oANOjxlEz589SWdnNGHGPO4U0h0HlrQJTSPeOl1lUO0kR+3JprUCmqZGuTPyC6vAvbL/A0MpgmrzRVfb9r2HOylEmUW2SXmjZHmR8/SWqY+G8EbeksMcyJYGa9nXrsdnC9WxYMPh4+qHGQH5cY4xO9NRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791661720; c=relaxed/simple;
	bh=VkCsvfSpwpgmvI8t9rWbEHv2AyMJh0d6PhMqG12ruZA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jfTIiZCO9I5cAnSw8Pfvm1YIM/3F2Y31+QGHi5Q/yBLoirTLMXReHsnqLopBB6aM1BGMf5TCWgD6AdI5nOKF6XU1oaUNpnzCTDME2VafHl/LUlZo+koZs8S7skMRN2AmK2EYtYPhjvKDX8g8mWmmhKow7QUhlP6xSmfwj5n2yh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OO0l6B8E; arc=none smtp.client-ip=209.85.219.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OO0l6B8E"
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91b4bf686ceso31373766d6.3
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 12:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791661717; x=1792266517; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+7MNjtT7H15ywIdmVqoXmn4VNBxc0pc+0rkZRjL6Kqc=;
        b=OO0l6B8ECzb0kFUiu1B7roSGrCXl7zyouE00/nTZ9Om/m0GSkQwsP9KjOF0tOXs4dn
         jL22azZu9ccqdBGhSF2xhVrrvpt5nGUNt5Dj8Ums90N1fmBsH++5IDnF9ikdKF6mrnuU
         nHYtT/IVFvKkiAB4oxVdPh9OR0429Y3Yyq4r6w1HwaZqJL380xfy1KwsPAS6vcmnSQQr
         9WVtZzWdwRlurRnq0zp06eVwY4K0T2pUBqNuE3GHNq1nYqTILvWDGLE7rsq/0zWenTfI
         IIhOlIM+Kgt4t3Nn5++G6XIjzXDrDYaUv9GdW4W+Z/fjo2wDHP+odYzZx+nBH91zOhti
         fWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791661717; x=1792266517;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7MNjtT7H15ywIdmVqoXmn4VNBxc0pc+0rkZRjL6Kqc=;
        b=P7Xh5Tekql5qh5SVVzwGo/7bgAJ/Rhg9nQc1peB7NBeTFLcROjklHnWO7Dk/ehOYxk
         O4D77J23247+ujDfW2tam7V7P8ElVIf4/Jjyw5Sy3htShwqxvZysQqTZ9+rR/C2G6aUM
         nBNV5zORtAw8/nUS3nh6VPuWgxns/mHzcWukUei8MVuHkcsjZRbVCKOWgMCIfva5SBDS
         8F0dHMv1/kOPzhFij3Zl2/C9BD3ALv/9t497P17MMKgWzcpV2Zdf13tVExQKO+mBxolJ
         k4nrz1BO4K8QG34wkKeVwh0PqPUSJKvbBbRgMBWWQCEzlGJPRvo9bz75KLOxJI0DA67Z
         i0tw==
X-Gm-Message-State: AFq9FYJIBLNToRcVf3gvFG6+wO1aBzL9LbqkowanR6dnAy5BiT8YxImO
	9YIUJJvHSovpaoG+TOalN/+h+71s7b+vCu/X3qCqXjgwqdC3+nSt81XfhuRPc3KvvIoXoutVAad
	xI642L3IngQ==
X-Received: from qkcbk7-n2.prod.google.com ([2002:a05:620a:72c7:20b0:93c:4264:eb51])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:a2cf:10b0:93e:c12c:f142
 with SMTP id af79cd13be357-93ec12d0865mr602016985a.76.1791661717014; Sat, 10
 Oct 2026 12:48:37 -0700 (PDT)
Date: Sat, 10 Oct 2026 19:48:32 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261010194832.2415477-1-jmoroni@google.com>
Subject: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE alloc
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The original logic would attempt to allocate PBLEs, then would
check whether the region was contiguous _after_, and if so,
would free the PBLEs and use a direct mapping instead.

These unnecessary temporary PBLE allocations can technically
fail (PBLEs are a finite resource), which can cause an MR
registration failure even if the region is contiguous and
should have succeeded.

Fix this by checking whether the region is contiguous before
allocating any PBLEs, and use the ib_umem_is_contiguous
helper while we're at it.

Ring MRs still have their own logic. That will be addressed next.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 50 +++--------------------------
 drivers/infiniband/hw/irdma/verbs.h |  1 +
 2 files changed, 5 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..7ea256e640fa 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2917,42 +2917,6 @@ static bool irdma_check_mem_contiguous(u64 *arr, u32 npages, u32 pg_size)
 	return true;
 }
 
-/**
- * irdma_check_mr_contiguous - check if MR is physically contiguous
- * @palloc: pbl allocation struct
- * @pg_size: page size
- */
-static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
-				      u32 pg_size)
-{
-	struct irdma_pble_level2 *lvl2 = &palloc->level2;
-	struct irdma_pble_info *leaf = lvl2->leaf;
-	u64 *arr = NULL;
-	u64 *start_addr = NULL;
-	int i;
-	bool ret;
-
-	if (palloc->level == PBLE_LEVEL_1) {
-		arr = palloc->level1.addr;
-		ret = irdma_check_mem_contiguous(arr, palloc->total_cnt,
-						 pg_size);
-		return ret;
-	}
-
-	start_addr = leaf->addr;
-
-	for (i = 0; i < lvl2->leaf_cnt; i++, leaf++) {
-		arr = leaf->addr;
-		if ((*start_addr + ((u64)i * pg_size * PBLE_PER_PAGE)) != *arr)
-			return false;
-		ret = irdma_check_mem_contiguous(arr, leaf->cnt, pg_size);
-		if (!ret)
-			return false;
-	}
-
-	return true;
-}
-
 /**
  * irdma_setup_pbles - copy user pg address to pble's
  * @rf: RDMA PCI function
@@ -3417,22 +3381,13 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 	u8 lvl;
 	int err;
 
-	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
+	lvl = iwmr->is_contig ? PBLE_LEVEL_0 : PBLE_LEVEL_1 | PBLE_LEVEL_2;
 	iwmr->access = access;
 
 	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
 	if (err)
 		return err;
 
-	if (lvl) {
-		err = irdma_check_mr_contiguous(&iwpbl->pble_alloc,
-						iwmr->page_size);
-		if (err) {
-			irdma_free_pble(iwdev->rf->pble_rsrc, &iwpbl->pble_alloc);
-			iwpbl->pbl_allocated = false;
-		}
-	}
-
 	if (create_stag) {
 		stag = irdma_create_stag(iwdev);
 		if (!stag) {
@@ -3487,6 +3442,8 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 	pgsz_bitmap = (reg_type == IRDMA_MEMREG_TYPE_MEM) ?
 		iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
 
+	iwmr->is_contig = ib_umem_is_contiguous(region);
+	/* Call best_pgsz after is_contiguous to restore correct umem->iova. */
 	iwmr->page_size = ib_umem_find_best_pgsz(region, pgsz_bitmap, virt);
 	if (unlikely(!iwmr->page_size)) {
 		kfree(iwmr);
@@ -3846,6 +3803,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 	iwmr->region = region;
 	iwmr->ibmr.iova = virt;
 	iwmr->ibmr.pd = pd;
+	iwmr->is_contig = ib_umem_is_contiguous(region);
 	iwmr->page_size = ib_umem_find_best_pgsz(region,
 				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
 				virt);
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index a1651641eb71..e4dffe3f191d 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -112,6 +112,7 @@ struct irdma_mr {
 	int access;
 	bool is_hwreg:1;
 	bool dma_mr:1;
+	bool is_contig:1;
 	u16 type;
 	u32 page_cnt;
 	u64 page_size;
-- 
2.56.0.385.gd3acb90ef8-goog

