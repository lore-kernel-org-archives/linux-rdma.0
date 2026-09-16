Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741AD4D6C45
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579953; cv=none; b=RuKfi6QzS7SKIkUG+PJ6sRKWDU8mxsqRrvqmF4c8+/GIGM2BYBDpDc7QS74P+u/UUOZbNfcZP18p171W4RG5srWUEbOWNNsdWvwXrXoIVzDy2X9gR0kVJzE5valZHU9Jzm91yVV+gNWu/Mp5SUSE+/JYPNEHmBvTWYr+NeqA5qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579953; c=relaxed/simple;
	bh=8TBo8PHWNCMVTmabKZeGC/DM626St3QN9MUdXhOwn3s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XawnG0Kmc+NxKXJMbhiek74yabF+25mZSvzH9+vv3P/b806jKk130LqKgvLT2zCzMIHpvnyxpKmhZ+lcmhTwvNSDVQfnJyojeYASSs7QYOnYYlX1hmdkyK8vs94DgUTFhg7LTIKxUst+m+lcui/JuB+GiR6EM2HyzN0CrGZ410M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jbongio.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QterpgnT; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jbongio.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QterpgnT"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8699b293a80so6443864b3a.0
        for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 10:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789579941; x=1790184741; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9Pw1imJYMEMmVAhRZuyxpxkx9si5cuo0QT1oArcJvVk=;
        b=QterpgnTvtWBxFv2iwOPg0AuZaqMdvYn6RjemHiBY+a8TSgH8Xu8pP4N4EB6eRWMP8
         c72oFZykT/+DTzWUKDJB9vWc4frVGll3qAd5cU6Dgkn59Wz+RLHsuhVZKAU+t6HGdZ27
         hsk4o4xX0h0IsjVgUKgwQRNSrEsxLOHZVnpFv7kbR1eDF5FAipHMUs1ZOuC0HX+kse4F
         3UqUebst68orgTep49mpNI8boB/Ju2cpatKFAIOSuYYEXYXBvy3GENnpYG6YxmiPfTpi
         HqZdLW98JvvvS9jMez11zoUz+2VS7qo+PKduvHsfi5mt2OdNUCzwxvNRX1OyPTtUwxmU
         Gtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789579941; x=1790184741;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Pw1imJYMEMmVAhRZuyxpxkx9si5cuo0QT1oArcJvVk=;
        b=mxIh+X4+Bc0FeHkGn/GZiRozNnlEdAQtR1HS7weI+PideGHr7UOorE0J/iLkLH5rCL
         VQ69aMsnbMDHK8Qs/f1qNNcm/volLO5SvLNzEeg4g4MruwgSR6Swy0fTkCaziuISxzX7
         c38qEg8DaHeP3TkEKN36pxENSN4c3YiYHn+ZgVsfHcJ+N2iC+kz6aB4MOYu4x3MiRxIG
         5esCBPa6QtRwCsT/iVuRPkcbAqnmNpH00TZl2x18bnSozyPWqquM3GhbXqtK/zmuR5MT
         fdPBw0zuDbe5x7CtDoQwav6yoN+uwYGKLUpA93zL36+dYJB8vSJq5JFVA4EfaFvvytv/
         tk4g==
X-Gm-Message-State: AFuF++lQiFkWaopgQSHwt0whN5ELyfv9mW4pqyaa3ai4oLuB0HjdRMMy
	+hTbIp+NMhLuYotPndNmYfNmCsRXcg1LJ7KZukHJWaqEGR8GwyE6f+y/d+Xi1R7QUynGijH26ud
	pIknKfjTh4A==
X-Received: from pfll12.prod.google.com ([2002:a05:6a00:158c:b0:868:a216:da18])
 (user=jbongio job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:170c:b0:870:c2db:da53
 with SMTP id d2e1a72fcca58-8723a49bcf4mr6947040b3a.23.1789579940509; Wed, 16
 Sep 2026 10:32:20 -0700 (PDT)
Date: Wed, 16 Sep 2026 17:32:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260916173203.2555458-1-jbongio@google.com>
Subject: [PATCH] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
From: Jeremy Bongio <jbongio@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, jmoroni@google.com, 
	Jeremy Bongio <jbongio@google.com>
Content-Type: text/plain; charset="UTF-8"

During VM live migration or when registering large memory regions
(e.g., guest memory >= 256 GB backed by 4 KiB pages), get_lvl2_pble()
calculates total leaves exceeding ~131,072. The memory required for
lvl2->leafmem.va exceeds 4 MiB (sizeof(*leaf) * total > 5.24 MiB).

Because kzalloc() requires physically contiguous pages, requests larger
than MAX_PAGE_ORDER (4 MiB on x86_64) fail and trigger a warning:

  WARNING: CPU: 123 PID: 119906 at mm/page_alloc.c:5997 __alloc_frozen_pages_noprof+0x50c/0x1050
  Call Trace:
   <TASK>
   alloc_frozen_pages_noprof+0xc0/0x240
   ___kmalloc_large_node+0x3d/0xd0
   __kmalloc_large_node_noprof+0x1b/0x90
   __kmalloc_noprof+0x254/0x660
   get_lvl1_lvl2_pble+0xbc/0x270 [irdma]
   irdma_get_pble+0x44/0xc0 [irdma]
   irdma_setup_pbles+0x46/0x1d0 [irdma]
   irdma_reg_user_mr_type_mem+0x41/0x230 [irdma]
   irdma_reg_user_mr+0x194/0x1c0 [irdma]
   ib_uverbs_reg_mr+0x1b0/0x2c0 [ib_uverbs]

The leafmem array is purely host software tracking structures (struct
irdma_pble_info) and does not require physically contiguous memory.

Switch the allocation from kzalloc() to kvzalloc() and free it with
kvfree() so that requests exceeding MAX_PAGE_ORDER fall back to
virtually contiguous memory via vmalloc.

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Assisted-by: LLM
Signed-off-by: Jeremy Bongio <jbongio@google.com>
---
 drivers/infiniband/hw/irdma/pble.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index 28dfad7f940c..5380cfbfec21 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -330,7 +330,7 @@ static void free_lvl2(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	if (root->addr)
 		irdma_prm_return_pbles(&pble_rsrc->pinfo, &root->chunkinfo);
 
-	kfree(lvl2->leafmem.va);
+	kvfree(lvl2->leafmem.va);
 	lvl2->leaf = NULL;
 }
 
@@ -358,7 +358,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	lvl2->leaf_cnt = total;
 
 	lvl2->leafmem.size = (sizeof(*leaf) * total);
-	lvl2->leafmem.va = kzalloc(lvl2->leafmem.size, GFP_KERNEL);
+	lvl2->leafmem.va = kvzalloc(lvl2->leafmem.size, GFP_KERNEL);
 	if (!lvl2->leafmem.va)
 		return -ENOMEM;
 
@@ -367,7 +367,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo, &root->chunkinfo,
 				       total << 3, &root->addr, &fpm_addr);
 	if (ret_code) {
-		kfree(lvl2->leafmem.va);
+		kvfree(lvl2->leafmem.va);
 		lvl2->leaf = NULL;
 		return -ENOMEM;
 	}
-- 
2.55.0.1082.g2b9226bbc0-goog

