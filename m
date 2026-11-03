Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.2.5.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716090;
	b=ciq60UJU2LU8Mr7ChclhDOHePCCdLFSDRx7pvfqD6y7oCVWfN9PgITCr33UIWMhGxW26
	 Gv2ZqnuWJG8F5JfgKtq9v6byexqshBVB61npKCDA1+248+iDguAEUZ+MtyGY6aGAcBeNz
	 gVqcB7/ZSe9cu5YoJS8JBcsm/5AUajgVklqBZwEFc/DTRH8x63rwwn/hHLA9R5W1NNKjc
	 OM86UhYCk4PHFFtg4bbkOrAt9YOzHH2OuWlaNDFpDwAgUhAbUYpvttSdNg7H1mVgGmey8
	 TaQV34pOsBc6UzrwPCkqKieFUep/37D+Wu1Wx+ZQ1GGBD7IjDAxxnGhJsPEcEhKO/Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716090;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ccATpapPbTgEfZ1P+cWb/MajiGhbQxL2uaUWAgOO/tE=;
	b=iP5Te7sWZVVUXeVwbEmrs2HM/PlIhZW7vCJgRyChI3SRqT8rwZBgepCVrpFWjh6K4Rnu
	 Grtfz95E48j6rNmV67C+lpiLypYi0CTnB02jyN06rWJtcle3qQmEK70T1x+G9XzC8TMw/
	 cAw96Ua9S1VcLFiALFX7yqHxi0mY/DLN9jq9bmEb/7RBtnYJ3e+hn+4e9vaP2sdz4ZrdV
	 8ejOcHwbXXYHxKO3LrZiqeTDeOlL1eNpg/cEvA2kKK5ydC+aJ3vLLvesPKIiATtWaNOoJ
	 5+nmMaLO/K3rbJxor2etlonRTXN9WMsOITGl+40ltWTJJ8/lJuBkzv+JHCO6gNwjxNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.uni-tuebingen.de;
	spf=pass smtp.mailfrom=student.uni-tuebingen.de;
	dkim=pass header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=Gxr2ulRr;
	arc=none smtp.remote-ip=134.2.5.213
Received: from mx03.uni-tuebingen.de (mx03.uni-tuebingen.de [134.2.5.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BB9606A332;
	Tue,  3 Nov 2026 14:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4BB9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=Gxr2ulRr
Received: from localhost.localdomain (u-251-c108.eap.uni-tuebingen.de [134.2.251.108])
	by mx03.uni-tuebingen.de (Postfix) with ESMTPSA id C082D20C4D6F;
	Tue,  3 Nov 2026 15:28:06 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx03.uni-tuebingen.de C082D20C4D6F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-tuebingen.de;
	s=20211202prod; t=1793716086;
	bh=ccATpapPbTgEfZ1P+cWb/MajiGhbQxL2uaUWAgOO/tE=;
	h=From:To:Cc:Subject:Date:From;
	b=Gxr2ulRrIHG+ICVQZeDO86O97PcxofrzVJc5+ZjEPvhevMCg9L1IHB6yvJqdHYc03
	 803R9UaBmya+A7EHlc9lQUVK5ydUegbfon1ZXwdNctOB4nq1zXscEul1voqLZ+XQuu
	 vnLxu8ZspaHwRosZX43c8yL6kUBSH6HvqvF4ia1UiEEQirLmaEs61b7hqOOWrt4NBY
	 sJm+2j1ohW/lxB4aZ4LXqpV7hKcdTZ/bN+oPgW7SYWyRMOtAbiFXL9irfse95r3rOs
	 XWlTuLzHvszblV3UCB5DAQhsdXEikY1UZmnbZ23e7PN+qHp5VtzHhqgQfcHgg87e0w
	 dAdigP+jZEcsQ==
From: 0z5a <dezhen.lu@student.uni-tuebingen.de>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>,
	stable@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation for pages >= 4G
Date: Tue,  3 Nov 2026 15:28:04 +0100
Message-ID: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
X-Mailer: git-send-email 2.50.1
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

From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>

devx_umem_find_best_pgsize() computes the page size in an unsigned long
but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
in an unsigned int. When the DMA mapping of the umem is contiguous and
aligned to 4 GiB or more, and the umem length is a multiple of that
size, ib_umem_find_best_pgoff() selects a page size >= 2^32. Since the
value is a power of two, the truncation turns it into 0 and the
registration fails with -EINVAL.

The umem log_page_size field is 5 bits wide on top of
MLX5_ADAPTER_PAGE_SHIFT, so the command can encode these page sizes.

Seen on two GH200 nodes (ConnectX-7, firmware 32.38.3056 and
32.43.1014) with a dma-buf exported from cudaMalloc memory: registering
4 GiB or 8 GiB umems at 4 GiB-aligned offsets of the dma-buf fails with
EINVAL every time, while 2 GiB umems at the same offsets and
ibv_reg_dmabuf_mr() of the same ranges succeed. Restricting the user
pgsz_bitmap to <= 2 GiB makes all of them succeed.

Other large physically contiguous buffers, such as a 16 GiB hugetlb
page on an arm64 kernel with 64K base pages, should hit the same path.

Use unsigned long for the page size, as commit f0c2427412b4
("RDMA/mlx5: Fix page_size variable overflow") already did for the MR
paths.

The bug was found by an AI coding assistant (Claude Opus 5.5, Anthropic)
during an audit of 32-bit truncations of page sizes and offsets in
drivers/infiniband/core and drivers/infiniband/hw/mlx5. The assistant
also wrote the reproducer and this patch. The reproducer was run on the
GH200 nodes described above.

Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
Cc: stable@vger.kernel.org
Signed-off-by: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
---

Notes:
    Testing notes:
    - The failures above were reproduced with the DOCA-OFED 26.01 mlx5_ib,
      whose devx_umem_find_best_pgsize() is identical to upstream; I do not
      have root on these hosts, so I could not load a patched module.
    - So I have not verified that CREATE_UMEM accepts log_page_size values
      for pages >= 4 GiB. If it does not, capping pgsz_bitmap at 2^31 in
      devx_umem_find_best_pgsize() is the alternative fix.
    - Compile-tested on v7.4-rc1 (arm64 defconfig + MLX5_INFINIBAND, W=1).
    - A standalone reproducer (dma-buf from cuMemGetHandleForAddressRange()
      plus mlx5dv_devx_umem_reg_ex(), sweeping offsets) is available on
      request.

 drivers/infiniband/hw/mlx5/devx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dc..2277160d9 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2294,8 +2294,8 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 	return 0;
 }
 
-static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
-					       unsigned long pgsz_bitmap)
+static unsigned long devx_umem_find_best_pgsize(struct ib_umem *umem,
+						unsigned long pgsz_bitmap)
 {
 	unsigned long page_size;
 
@@ -2333,7 +2333,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 				   int access)
 {
 	unsigned long pgsz_bitmap;
-	unsigned int page_size;
+	unsigned long page_size;
 	__be64 *mtt;
 	void *umem;
 	int ret;
-- 
2.43.0

