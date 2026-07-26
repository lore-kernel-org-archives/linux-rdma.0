Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71437FF43
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785064550; cv=none; b=hc6/n0Dj9NED99csi2BMMNGIDeBnbbJLqehLVN5MXdeq5uwgkBECGRi3ZaWplErS44k+RimWAKbYVnb8AggWqReMEo3OK/ZKzpGPuPjSwLosH/eKGBjEdmmsDKKkiBumNbakc8kSFbcxNTWFhCVomNc/rQpm56EvkUyFoGRNiO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785064550; c=relaxed/simple;
	bh=8RsCZR+VoFurI31BtqiGlUYsavIn/awV/oIDLGXfZr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n1ZqSgsS49tf0eIIDVPQ9IugPs1iHMDTXHcY+lwKlYWbdiXmrhuMqD9r48ywOfngfqJDQwMeThD3/H7v7Lfk+aZLPQfTh6iO5yF5yVtKUCHFE1PBQTn3erzt0TGcA2eCKUoewgpkhIGtN+fTdz9fvWJXNUOvCOiYuxofDhvIlpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3nHUwc9; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3nHUwc9"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso1070608a12.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785064549; x=1785669349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EN2awGJ26EUaMbYJ+eJ4wz6UCVhlC5pZ4u6LtnOUmYo=;
        b=V3nHUwc9I2hlK2SPwlI9Nalw8w0hn/3ULy8fjYIoV5iV5M6a85rDblVMURCiG1qYmd
         xybDlBNNSwp7nEf2cFB+p/ImGIcBWiyf3XqPWE3ic6ctIOu1jVBaPcqJ/gCI3ugouyCQ
         k8kGS7sGt6HSeLNwyYSzXZnfAcBdaGtjAckzP82P3m4qJasl6VSItBGsehFEhE2vNyNF
         cVp/H9kS1wQ5AMGsWpjRJVKAFJvJBhM5Em3jmFi0ADKrNA0u69+q9YnEYq1doIS7OS7j
         wUMiCmpizKtR04wHXI9F1jdUa0tP4BggS6UBYO5y2/x1KDbu1v2nLrEU9JGxPf4a2+1s
         ER/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785064549; x=1785669349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EN2awGJ26EUaMbYJ+eJ4wz6UCVhlC5pZ4u6LtnOUmYo=;
        b=guQ8hQJHPqqM05lZe2IMptV5LvA/nNxFsDrroh6FkCxNxbLBN7tM6EssSrA2tgkkgv
         BqvyYcdhJ1yoLbtdmULOB2Z1UTqsaSL+4tykA5BxTu0Hv7dVRa8NrsKmKqCY++hcFsll
         OakiQg4VchMOdTlaXslrQR706RhTftpznmuXBLem3H9vPPPlGnDVxAU2VeAcUTqGXfJb
         Q+FexqxG0ISBPNilv2UPwucTK218MVcbQe0NcuV2+BvVqAWvZ1bzzQfktogVI04br5PH
         rMvz1ibgPuIvmnVQNvGGoRRS47HgEz75Ietr2wg1NTYkV87FmPVgM7oYD9dlpTXIlUxL
         lXxQ==
X-Gm-Message-State: AOJu0Ywkxbz6kwF+1L0Yz6ddGDaqc4UEny15gSaVvDEx3RVuObjRvKzw
	cUsSRKiDeeZjCOjnsdvjT0DmtvWh6/jdiwLiFVJvJ5IIlZxP0ZALsWIl9RM/Vnm2JUg=
X-Gm-Gg: AR+sD10cJWKhpdpwyN7BEq2i+0FZgvgOQkzplSB1RYZKWKHzeWDTs7hI8DkVTmF9+Rc
	1q32K7RWm0M/Ff74mbSvxMuM/Q/CpSJACBUf+bdcYxyfv6pmNwmT4mIpGTKKZ0dZQ4A9gqjeeC2
	tyodrdklMyDvF8ilprFsR7trNILxsAOpLFDM+X8lyxEufJIYajjEGEUjmF6t2ZdbQag8/wkxrpA
	4EWCHPs8wv98/6b08F7cFNG5FZHz4Zw+r8Fjp2+ROvspjjY6hpE8WpuK8e1bF/vFVVzkS2vALIj
	scagVJhMScBgLarBQIBnLcBxawLEGzfGT0S06Fyk4ELLcj3AASTVeq0IA1ePzBtwMp0hF7TDhKn
	rSQg0rSVMl53rT6OFY0yl/xFpD0G2lhTmjYqfDMPPUA36+mtbwrksNVliE4dGuht5+OdFdCNYSx
	M1qwp7aA/G7z+/CEaFk7lAe8iLhp0BMdthmUdZ8w==
X-Received: by 2002:a05:6a21:7107:b0:3c3:66c5:68cc with SMTP id adf61e73a8af0-3c67d9d578bmr4366600637.21.1785064548770;
        Sun, 26 Jul 2026 04:15:48 -0700 (PDT)
Received: from kimi-bug-hunter.. ([47.84.186.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e1285sm21486468eec.5.2026.07.26.04.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:15:48 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Hongqiang Luo <wanbafv@gmail.com>,
	Xinyu Ma <mmmxny@gmail.com>,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Rui Ding <threonine42@gmail.com>,
	Miao Zhao <muel@nova.gal>
Subject: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
Date: Sun, 26 Jul 2026 19:15:30 +0800
Message-ID: <20260726111533.1037819-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
pages") dropped the access permission test from rxe_check_pagefault()
and left only HMM_PFN_VALID. A page faulted in read-only, for example
a page-cache folio behind a PROT_READ file mapping, then satisfies the
check and ODP write operations (RDMA WRITE, RDMA READ response, SEND
payload, atomics) modify it through kmap without ever breaking CoW.

An unprivileged user can register an ODP MR over such a mapping and
have incoming RDMA traffic overwrite the page cache of a file it only
holds O_RDONLY, including /etc/passwd or setuid binaries. This is the
same primitive class as Dirty COW and CVE-2022-2590.

mlx5 has the missing invariant: its ODP path sets the device write bit
only for pfns that carry HMM_PFN_WRITE. Restore it in rxe by requiring
HMM_PFN_WRITE in rxe_check_pagefault() for every operation except
RXE_PAGEFAULT_RDONLY. A write to a non-writable VMA now fails the one
fault attempt with -EPERM from hmm_vma_fault() instead of re-faulting
forever. For a writable VMA the fault breaks CoW and the write lands
in the private page.

Keep pmem flushes on the read-only check. arch_wb_cache_pmem() never
modifies memory, and the FLUSH access bits do not make the umem
writable, so classifying flushes as writes would make every flush
against a flush-only MR fail.

Fixes: 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO pages")
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
Reported-by: Rui Ding <threonine42@gmail.com>
Reported-by: Miao Zhao <muel@nova.gal>
Tested-by: Hongqiang Luo <wanbafv@gmail.com>
Tested-by: Xinyu Ma <mmmxny@gmail.com>
Tested-by: Zhanbo Ye <cainyzb@gmail.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ff904d5e54a73..174bb2efc3c6a 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -124,19 +124,23 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 }
 
 static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
-				       int length)
+				       int length, bool write)
 {
 	bool need_fault = false;
+	u64 access = HMM_PFN_VALID;
 	u64 addr;
 	int idx;
 
+	if (write)
+		access |= HMM_PFN_WRITE;
+
 	addr = iova & (~(BIT(umem_odp->page_shift) - 1));
 
 	/* Skim through all pages that are to be accessed. */
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 
-		if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
+		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
 		}
@@ -159,6 +163,7 @@ static unsigned long rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
 static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u32 flags)
 {
 	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	bool write = !(flags & RXE_PAGEFAULT_RDONLY);
 	bool need_fault;
 	int err;
 
@@ -167,7 +172,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 
 	mutex_lock(&umem_odp->umem_mutex);
 
-	need_fault = rxe_check_pagefault(umem_odp, iova, length);
+	need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
 	if (need_fault) {
 		mutex_unlock(&umem_odp->umem_mutex);
 
@@ -177,7 +182,7 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 		if (err < 0)
 			return err;
 
-		need_fault = rxe_check_pagefault(umem_odp, iova, length);
+		need_fault = rxe_check_pagefault(umem_odp, iova, length, write);
 		if (need_fault) {
 			mutex_unlock(&umem_odp->umem_mutex);
 			return -EFAULT;
@@ -339,8 +344,9 @@ int rxe_odp_flush_pmem_iova(struct rxe_mr *mr, u64 iova,
 	int err;
 	u8 *va;
 
+	/* A flush never modifies memory; read-only access suffices. */
 	err = rxe_odp_map_range_and_lock(mr, iova, length,
-					 RXE_PAGEFAULT_DEFAULT);
+					 RXE_PAGEFAULT_RDONLY);
 	if (err)
 		return err;
 
-- 
2.43.0

