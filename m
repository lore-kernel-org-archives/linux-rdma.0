Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E02BDC2F;
	Wed, 24 Jun 2026 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312547; cv=none; b=k87faDKIfKRfei+sOkQbNmNDocICheAeOpTCHXfWYaIDUNnCm9NrtbzdA4jLu01I5e5EL0i3i/6/lOtNbYQj94BUm8Jd2XXwFQno92I4fh9368qKhl+1frdKSN8GAXzo2dkrBDfbZ4BO/Do6+th1P6Tbs3OyxdkR114EeeTueRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312547; c=relaxed/simple;
	bh=i00klzCP9CwLXMYKZNmuASfnbmTqXSmjU6VkBZEQ2LE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XXg3GxZ9VsZyb6H93A1An2w7WuEPe805xkrkxR5yCLxsqQRg96H8EmVbV2D7RUA7PIZvwNu6Q3u47e3YX7X70D19olwbA4A+yy2d/U/msSpUZqEUnRzc+JHjPN0kNUtgLq+jTLNGvfoLbM5BlwueDKc0BT9CR4bsaB7CkuNIZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=itb.spb.ru; spf=pass smtp.mailfrom=itb.spb.ru; dkim=pass (1024-bit key) header.d=itb.spb.ru header.i=@itb.spb.ru header.b=P/1r03dX; arc=none smtp.client-ip=178.154.239.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=itb.spb.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itb.spb.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itb.spb.ru header.i=@itb.spb.ru header.b="P/1r03dX"
Received: from mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:ea2:0:640:ef77:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 0D388C0101;
	Wed, 24 Jun 2026 17:48:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net (smtp) with ESMTPSA id kmZg0cNgGGk0-HRq8mJA1;
	Wed, 24 Jun 2026 17:48:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itb.spb.ru; s=mail;
	t=1782312531; bh=Gz3lOv/CI79YjE1aN0wfylGlI3Iny8zFySyBDdhs1Tw=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=P/1r03dXoV5pEzF7MbonCIfV35Odh6IwmwDb0HcRgqDx5T6JGUQoo0NG01DpqmHz7
	 b6k5qOzAYpuf/Cba9OYTReLtsCeQGO96/8p9ufBXglknhXNDk9RuhCS6/E6GRIE8Ge
	 cfArRzqBQyH489aNaXwGAwjP1YILJH0NsQkLeSws=
Authentication-Results: mail-nwsmtp-smtp-production-main-52.klg.yp-c.yandex.net; dkim=pass header.i=@itb.spb.ru
From: Aleksandrova Alyona <aga@itb.spb.ru>
To: Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] RDMA/irdma: Prevent overflows in memory contiguity checks
Date: Wed, 24 Jun 2026 17:48:46 +0300
Message-Id: <20260624144846.61242-1-aga@itb.spb.ru>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irdma_check_mem_contiguous() and irdma_check_mr_contiguous() verify that
PBL entries describe physically contiguous memory ranges.

Both functions calculate byte offsets using 32-bit operands. For example,
with 4 KiB pages, pg_size * pg_idx overflows 32-bit arithmetic when
pg_idx reaches 1048576. In the level-2 check, PBLE_PER_PAGE is 512, so
i * pg_size * PBLE_PER_PAGE overflows when i reaches 2048.

These values are reachable in the driver. For MRs, palloc->total_cnt
comes from iwmr->page_cnt, which is calculated by
ib_umem_num_dma_blocks(). The MR size is limited by IRDMA_MAX_MR_SIZE,
so a 4 GiB MR with 4 KiB pages can reach page_cnt of 1048576. PBLE
resources do not exclude this value either: for gen3, the limit is based
on avail_sds * MAX_PBLE_PER_SD, and MAX_PBLE_PER_SD is 0x40000, so 4 SDs
are enough for 1048576 PBLEs.

Cast one operand to u64 before the multiplications so that the offset
calculations are performed in 64-bit arithmetic.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Aleksandrova Alyona <aga@itb.spb.ru>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 17086048d2d7..ab55f674cb63 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2819,7 +2819,7 @@ static bool irdma_check_mem_contiguous(u64 *arr, u32 npages, u32 pg_size)
 	u32 pg_idx;
 
 	for (pg_idx = 0; pg_idx < npages; pg_idx++) {
-		if ((*arr + (pg_size * pg_idx)) != arr[pg_idx])
+		if ((*arr + ((u64)pg_size * pg_idx)) != arr[pg_idx])
 			return false;
 	}
 
@@ -2852,7 +2852,7 @@ static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
 
 	for (i = 0; i < lvl2->leaf_cnt; i++, leaf++) {
 		arr = leaf->addr;
-		if ((*start_addr + (i * pg_size * PBLE_PER_PAGE)) != *arr)
+		if ((*start_addr + ((u64)i * pg_size * PBLE_PER_PAGE)) != *arr)
 			return false;
 		ret = irdma_check_mem_contiguous(arr, leaf->cnt, pg_size);
 		if (!ret)
-- 
2.26.2

