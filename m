Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703222;
	b=X4LiEe9P5rEDf+PSkrpFfn+anWnaJvFYfcln/UMyzhUgjgkw2Lxx01vvr7JYbsKUTqwL
	 UuVez2dY+VCeViZ1frkX5ox1o0vG9s7Y2p1PFVgs62Rb78cA0McOMjHc1arvUBqoXW8Mc
	 xWvQ0SrXQjjp1ix16NLMSgIUo2qUu9+yDqpn9w23DHvsz+pYQJXyhGZ3NOMi7EyY22Ni5
	 a8GPiS10VUd5vIDST5AIUP9q8MJhJJZp+j5zsbyYRSuNicYCZvqiL9fhqSzhmCusd1BLC
	 bL8KtBz7X7ViayKzpOmas4jaEaRl7khodXhiEZWT39u374835OuTRtMDw8psfXKa3BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=RhSggV/u6u5pkNL6r5JzWnnZjhn/vQo5UbJPODeoZkI=;
	b=fukqVyKPeCQJ+cxvV/w/a5B7b3VK/dAqLv5xtGT2lfdFBvh+pEJnPZl2fJa3fC+csuox
	 Kiteyoefb6kCcLlW8g58W97vSLKrCkuFs6SWg3WMQlBZOMp1TZQFhsmadjsZaRRuNwMzp
	 EHb6V9/Yi1wargkITv+NDRtcKgc0L/N3pPnfgJ4qXrd7qybculrHFScI7LQ4nryK9ur0m
	 VsRX5GjH3mg9fVrvvPAku/nhkWrNc0pOFzkoxOesxUUfUwgvOT1CddQAvvlVx+kMqYKba
	 5Ft49k/N/IOnqYzeP6EwpI/2aS+/YvwzxhM5JgyM7W8wvsyq1zimmTudHKZsVin/cXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=psakn2Iq;
	arc=none smtp.remote-ip=209.85.128.199
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D81606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 21:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30D81606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=psakn2Iq
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8b0cfe694c3so4700877b3.2
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792703221; x=1793308021; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RhSggV/u6u5pkNL6r5JzWnnZjhn/vQo5UbJPODeoZkI=;
        b=psakn2IqCtQ3ZXWx25XiHa2NK/BJqQO2n81nyQizveK7k9fMzzPVFaIZnYCpWhfj/I
         sct7c6XXo76HIcmetkQG80Fd28nuIMjMpeECi/izhW82xP0hjZ2sj+os/LqgAa46V59g
         zeWu1HD1p6c7WBJsZ6z7VTtcbENYcpcJ1BUmxgb+1Loz8klsjxC00plD8X7ZAX9jGky4
         gKwe1IrAGGCVZPJIZ/Ktx53ye1GvvkHyFOywJbexLJ27DMb4+fVYet317ISI0vXLvMlK
         ENccA2ZDhqp8lgYcGm1oozcEmbXrPs9vaF65MQAY3/ntApGyEzrj1Kz9vFncu1J2TOo6
         nfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703221; x=1793308021;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RhSggV/u6u5pkNL6r5JzWnnZjhn/vQo5UbJPODeoZkI=;
        b=CtykanhXcWeZ14/EYti1CdPn/8+yVHCJq9Xxk+yxbfTivNjuhU7aNLfw6Z7fcOAPt2
         MlrCE1ZFNwP0ySTaeZjtcSV6DSOuNqWAJeixdzKlwfOCGl9YSStd44u7G4PUeBIv6h3m
         +R06CdOpvNjAaEWC2k5jFsBIvBVAPpQm6EbF7KHckga9cpWz4nx1cfnE8W7Lu9cnOBbW
         2Vd0i2P3D3KBZjjpsGS+w/SLw/f94oMhyvprTEKv+iWLEHmZf9EiPR28uH2jVWwHCbvO
         QE/6hZ9LH2pZPq1NPKQ/RuQktwqgPJPyFz1T9xKyW/slJ4czRZvJC2VL7O5pXGrRqcuG
         BYPg==
X-Gm-Message-State: AFq9FYIuufnAi82maaDmfDIrhPgf72SEuBLq+s6jwWvE5+wEG212b0+6
	tvoFIAv2MV9d4ZAOsxlHWVRZRep5xk7UEpO5UmbgA3hj1LUVNQ+0x9tTvzk+Vrh94Ubg5F8BxR9
	t4HxCeJa5qg==
X-Received: from yxak9-n2.prod.google.com ([2002:a53:c049:0:20b0:677:afb4:b918])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690e:4853:b0:679:bec4:ad7
 with SMTP id 956f58d0204a3-67a35c1c27bmr154352d50.55.1792703221060; Thu, 22
 Oct 2026 14:07:01 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:06:50 +0000
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
Message-ID: <20261022210650.1182000-3-jmoroni@google.com>
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Fix paged PBLE and virtual AEQ for
 PAGE_SIZE > 4K
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>, 
	Leah Li <leahlijuan@google.com>
Content-Type: text/plain; charset="UTF-8"

HMC page descriptors and the virtual AEQ PBL always assume 4K
HW pages, but irdma_map_vm_page_list() returns one DMA address
per PAGE_SIZE page and irdma_pble_get_paged_mem() sizes the chunk
as PAGE_SIZE * pg_cnt.

This breaks when PAGE_SIZE is greater than 4K. For example, with
a 64K PAGE_SIZE, the second HW page points to vaddr+64K whereas
the driver assumes it to be at vaddr+4096, etc.

It also ends up using an incorrect chunk size which causes each
paged chunk to claim 16x more PBL entries than what actually exist.

Fix these issues by taking into account the potential difference
between the HW page size (4K) and the system PAGE_SIZE during
allocation and mapping (so on a 64K kernel, each page ends up
populating 16 PDs, etc.).

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Tested-by: Leah Li <leahlijuan@google.com>
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/hw.c    |  4 ++--
 drivers/infiniband/hw/irdma/utils.c | 22 +++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index fbb8fb47d0d1..1d57b3c9f490 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -700,7 +700,7 @@ static void irdma_destroy_cqp(struct irdma_pci_f *rf)
 static void irdma_destroy_virt_aeq(struct irdma_pci_f *rf)
 {
 	struct irdma_aeq *aeq = &rf->aeq;
-	u32 pg_cnt = DIV_ROUND_UP(aeq->mem.size, PAGE_SIZE);
+	u32 pg_cnt = DIV_ROUND_UP(aeq->mem.size, IRDMA_HW_PAGE_SIZE);
 	dma_addr_t *pg_arr = (dma_addr_t *)aeq->palloc.level1.addr;
 
 	irdma_unmap_vm_page_list(&rf->hw, pg_arr, pg_cnt);
@@ -1479,7 +1479,7 @@ static int irdma_create_virt_aeq(struct irdma_pci_f *rf, u32 size)
 	if (!aeq->mem.va)
 		return -ENOMEM;
 
-	pg_cnt = DIV_ROUND_UP(aeq->mem.size, PAGE_SIZE);
+	pg_cnt = DIV_ROUND_UP(aeq->mem.size, IRDMA_HW_PAGE_SIZE);
 	status = irdma_get_pble(rf->pble_rsrc, &aeq->palloc, pg_cnt, true);
 	if (status) {
 		vfree(aeq->mem.va);
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 290ad02ed657..3efc4125bb59 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2199,20 +2199,24 @@ int irdma_map_vm_page_list(struct irdma_hw *hw, void *va, dma_addr_t *pg_dma,
 			   u32 pg_cnt)
 {
 	struct page *vm_page;
-	int i;
+	dma_addr_t dma;
+	u32 i, j;
 	u8 *addr;
 
 	addr = (u8 *)(uintptr_t)va;
-	for (i = 0; i < pg_cnt; i++) {
+	for (i = 0; i < pg_cnt; i += IRDMA_HW_PAGES_PER_PAGE) {
 		vm_page = vmalloc_to_page(addr);
 		if (!vm_page)
 			goto err;
 
-		pg_dma[i] = dma_map_page(hw->device, vm_page, 0, PAGE_SIZE,
-					 DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(hw->device, pg_dma[i]))
+		dma = dma_map_page(hw->device, vm_page, 0, PAGE_SIZE,
+				   DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(hw->device, dma))
 			goto err;
 
+		for (j = 0; j < IRDMA_HW_PAGES_PER_PAGE && i + j < pg_cnt; j++)
+			pg_dma[i + j] = dma + j * IRDMA_HW_PAGE_SIZE;
+
 		addr += PAGE_SIZE;
 	}
 
@@ -2225,9 +2229,9 @@ int irdma_map_vm_page_list(struct irdma_hw *hw, void *va, dma_addr_t *pg_dma,
 
 void irdma_unmap_vm_page_list(struct irdma_hw *hw, dma_addr_t *pg_dma, u32 pg_cnt)
 {
-	int i;
+	u32 i;
 
-	for (i = 0; i < pg_cnt; i++)
+	for (i = 0; i < pg_cnt; i += IRDMA_HW_PAGES_PER_PAGE)
 		dma_unmap_page(hw->device, pg_dma[i], PAGE_SIZE, DMA_BIDIRECTIONAL);
 }
 
@@ -2254,7 +2258,7 @@ void irdma_pble_free_paged_mem(struct irdma_chunk *chunk)
 /**
  * irdma_pble_get_paged_mem -allocate paged memory for pbles
  * @chunk: chunk to add for paged memory
- * @pg_cnt: number of pages needed
+ * @pg_cnt: number of HW (4K) pages needed
  */
 int irdma_pble_get_paged_mem(struct irdma_chunk *chunk, u32 pg_cnt)
 {
@@ -2265,7 +2269,7 @@ int irdma_pble_get_paged_mem(struct irdma_chunk *chunk, u32 pg_cnt)
 	if (!chunk->dmainfo.dmaaddrs)
 		return -ENOMEM;
 
-	size = PAGE_SIZE * pg_cnt;
+	size = pg_cnt * IRDMA_HW_PAGE_SIZE;
 	va = vmalloc(size);
 	if (!va)
 		goto err;
-- 
2.56.0.218.g1ec904b173-goog

