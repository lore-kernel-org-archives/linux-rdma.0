Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC66B4DA541
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791994911; cv=none; b=p0kps0Fqk5Ic5ma7U51CuLiOYAX0Z6VDQ3SGP+LLr19oiCbIccS+Xos7uCQuZtQIinOVPRhpxAzIWtjFrLIGJXlz6O9onbmr5aO4xzCbFFddC25kvSC9CACgbSgJMWEQBRx15umb9gq5rhduKTDYRnKaXEEXYc4ZKyn/ZNXeFB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791994911; c=relaxed/simple;
	bh=YaV26/2g4MIbNy8OVOcQ3gSuLu4exvYPqBDzWFenlYE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oAScFr0fgDyY4fGKQEJ5fqja9M2r21jmJCWzqH+2/hYq4EU4UPKirBSmSWAelOMULLgRzRbZ9Dh0+jQTseMZp7fo1yYRZv+uYuOTCsIEhxRw1XvBTsvzXTPt35fpNHZFIBqVOnIur1VUDS1PE/CpR9+rC+KwjSbs8/LvLB7NMr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rWsiLygn; arc=none smtp.client-ip=209.85.222.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rWsiLygn"
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ca9b53afaso1177099385a.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791994906; x=1792599706; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MWltUAVwzuhWmwawPa9gIDNonJ5+TZ8HT4d8bCNfDmE=;
        b=rWsiLygnq7J4NM7jE7foeLBGEOFkxLdQ0J0We5L30Jn2P8IbPcsV2HRdT6LEfBbIpT
         aNCCDNA5gsk1tnuHYQ8SzP032DSQmne45qN49CV9FaQjV6N/iEB270GVMdnD4sjlJRrQ
         /OQQeKk1zVW9Hy6N145+BPePKigYCrbAJAV3w4xwVSqXPlB1HiyXUmI2FDFPYhQVI3Wq
         mI9WUywmv5lZItSBfHL7vBeVUL5SofZr1mN0X87RHleGP3PIJS+UK1tQTUCZB0ahwI1L
         iWyjnaQlz/0XLuJweRumeFPti4KopT2yvxvTv2bu9XFR910IGqUY1n7Mo6vDwULv9+2+
         Cw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791994906; x=1792599706;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MWltUAVwzuhWmwawPa9gIDNonJ5+TZ8HT4d8bCNfDmE=;
        b=vqcQ4xkLyYkH4ejvVrKsbwBKGKhutLw1xXwed+3XBR1a5g1K7yo4eKpzh9gEtYh3Ch
         IxCaFaTrUMP4dqla6PXskgcwNR94JdmN0utmpkzlwZu42i6oaUbBPACNRwapgdQ9qblc
         AChRq/dnxS5ynzagKMiN5Wo9wef2ZfjopwC6JfouDVDpX+WI0gvvGCVCaVVQXGqOc0eG
         RCCxA7JY0bT4fyOeHTamVyM9yv1orRvnT3mUtx05n5h5ZgoE0SEZO1W5CJhFtKDbbYJ8
         NYobz3nXyILY1TMEhoZ95ZUQukqoFGtat+JxBTbJIpQycMnRYK60vtPxSEhuHHdaj7eo
         I3fQ==
X-Gm-Message-State: AFq9FYJsCstAtC/mngfVfsnPl5G6574McYRc7tGj1iiJb53QhOe6rknC
	nNlBE5ium2riZthcRXWrqZkl3PsNB6lroz7CSLj+eRiDclZ41K4a9RmqjTYacGQ5I5bxOtB3WBq
	JUHoDi1i3gQ==
X-Received: from qvbl16-n2.prod.google.com ([2002:a0c:e090:0:20b0:91b:64e7:a499])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:1991:b0:93b:db80:e0cf
 with SMTP id af79cd13be357-93ebd281acbmr2727152785a.60.1791994906140; Wed, 14
 Oct 2026 09:21:46 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:21:44 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261014162144.4053279-1-jmoroni@google.com>
Subject: [PATCH rdma-next v2] RDMA/irdma: Check MR contiguity before PBLE alloc
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
allocating any PBLEs. This also provides an opportunity to
consolidate some of the rereg_mr logic and use the existing
ib_umem_is_contiguous() helper.

Tested on GEN3 HW with a test program that does an extensive
sweep of MR size/alignment/hugepage combinations, but most
importantly, first/last byte reachable and -1/+1 unreachable
when using contig regions with both aligned and unaligned start
addresses, plus a kprobe on irdma_get_pble() to ensure we're
actually hitting the new path.

Ring MRs still have their own logic. That will be addressed next.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
Changes in v2:
- Skip the ib_umem_find_best_pgsz() call if we already know the
  region is contiguous (Jason)
- Move MEM MR page size/PBLE handling into irdma_reg_user_mr_type_mem()
  and drop the is_contig flag added in v1
- Drop the now-unused pgaddrmem[0] store in irdma_setup_pbles()
- Add test description

 drivers/infiniband/hw/irdma/verbs.c | 97 +++++++++--------------------
 1 file changed, 29 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..f89c8516c57c 100644
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
@@ -2989,9 +2953,6 @@ static int irdma_setup_pbles(struct irdma_pci_f *rf, struct irdma_mr *iwmr,
 
 	irdma_copy_user_pgaddrs(iwmr, pbl, pbl_len, level);
 
-	if (lvl)
-		iwmr->pgaddrmem[0] = *pbl;
-
 	return 0;
 }
 
@@ -3413,24 +3374,33 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 {
 	struct irdma_device *iwdev = to_iwdev(iwmr->ibmr.device);
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
+	struct ib_umem *region = iwmr->region;
 	u32 stag = 0;
-	u8 lvl;
 	int err;
 
-	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
 	iwmr->access = access;
 
-	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
-	if (err)
-		return err;
-
-	if (lvl) {
-		err = irdma_check_mr_contiguous(&iwpbl->pble_alloc,
+	if (ib_umem_is_contiguous(region)) {
+		/* HW needs a valid page size even without PBLEs, so use 4K. It
+		 * behaves like a PBLE-backed region where the PBA must be page
+		 * aligned. HW takes the page offset from the lower 12 VA bits.
+		 */
+		iwmr->page_size = SZ_4K;
+		iwmr->pgaddrmem[0] = ALIGN_DOWN(ib_umem_start_dma_addr(region),
 						iwmr->page_size);
-		if (err) {
-			irdma_free_pble(iwdev->rf->pble_rsrc, &iwpbl->pble_alloc);
-			iwpbl->pbl_allocated = false;
-		}
+	} else {
+		iwmr->page_size = ib_umem_find_best_pgsz(region,
+				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
+				iwmr->ibmr.iova);
+		if (unlikely(!iwmr->page_size))
+			return -EOPNOTSUPP;
+
+		iwmr->page_cnt = ib_umem_num_dma_blocks(region,
+							iwmr->page_size);
+		err = irdma_setup_pbles(iwdev->rf, iwmr,
+					PBLE_LEVEL_1 | PBLE_LEVEL_2);
+		if (err)
+			return err;
 	}
 
 	if (create_stag) {
@@ -3466,10 +3436,8 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 					 struct ib_pd *pd, u64 virt,
 					 enum irdma_memreg_type reg_type)
 {
-	struct irdma_device *iwdev = to_iwdev(pd->device);
 	struct irdma_pbl *iwpbl;
 	struct irdma_mr *iwmr;
-	unsigned long pgsz_bitmap;
 
 	iwmr = kzalloc_obj(*iwmr);
 	if (!iwmr)
@@ -3483,18 +3451,21 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 	iwmr->ibmr.device = pd->device;
 	iwmr->ibmr.iova = virt;
 	iwmr->type = reg_type;
+	iwmr->len = region->length;
+	iwpbl->user_base = virt;
 
-	pgsz_bitmap = (reg_type == IRDMA_MEMREG_TYPE_MEM) ?
-		iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
+	/* Page size and count are calculated in irdma_reg_user_mr_type_mem()
+	 * for MEM type MRs.
+	 */
+	if (reg_type == IRDMA_MEMREG_TYPE_MEM)
+		return iwmr;
 
-	iwmr->page_size = ib_umem_find_best_pgsz(region, pgsz_bitmap, virt);
+	iwmr->page_size = ib_umem_find_best_pgsz(region, SZ_4K, virt);
 	if (unlikely(!iwmr->page_size)) {
 		kfree(iwmr);
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	iwmr->len = region->length;
-	iwpbl->user_base = virt;
 	iwmr->page_cnt = ib_umem_num_dma_blocks(region, iwmr->page_size);
 
 	return iwmr;
@@ -3833,7 +3804,6 @@ static int irdma_hwdereg_mr(struct ib_mr *ib_mr)
 static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 				u64 virt)
 {
-	struct irdma_device *iwdev = to_iwdev(iwmr->ibmr.device);
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	struct ib_pd *pd = iwmr->ibmr.pd;
 	struct ib_umem *region;
@@ -3846,17 +3816,8 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 	iwmr->region = region;
 	iwmr->ibmr.iova = virt;
 	iwmr->ibmr.pd = pd;
-	iwmr->page_size = ib_umem_find_best_pgsz(region,
-				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
-				virt);
-	if (unlikely(!iwmr->page_size)) {
-		err = -EOPNOTSUPP;
-		goto err;
-	}
-
 	iwmr->len = region->length;
 	iwpbl->user_base = virt;
-	iwmr->page_cnt = ib_umem_num_dma_blocks(region, iwmr->page_size);
 
 	err = irdma_reg_user_mr_type_mem(iwmr, iwmr->access, false);
 	if (err)
-- 
2.56.0.385.gd3acb90ef8-goog

