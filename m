Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.2.5.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716049;
	b=vWcPjNzhB8N42/0bCdZUGSkKkbDXykLvv5EXeSrr5cCk4qO7sGuFSNUxA6lLHh+OTSpj
	 50E9hST9j1AZ5wg2m5YSyCu+aqKCRsm4oRb2xaWP6uqHeGdKY9nw2R2oa6XxHm1pPT7ox
	 FrqgH/uXPJcrmnO/3O2rdTj0uddJwTGZaZ2pRLMkNGUrFeEc9E7qShukRdeqT3HbExeE5
	 bUVzgXJ1OjlL/jatyK2jqnM3CZo59WT8LEY73XlYh0MK+iRE5obIdZT9IdWGPMF+xsi1l
	 iValooK8p5i7H4oBR/2Y13U6gZsd6+2M/C3TqS2XLjPsdl4dqjuTJ59M/atU3A58nJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716049;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ccATpapPbTgEfZ1P+cWb/MajiGhbQxL2uaUWAgOO/tE=;
	b=SKrcG37ZFJb8Fh0IqtK8IuHnd3wJwCeubxK2TutewpqjNCsb8Ms2mmEUH2HhXCLQBP5A
	 ZfxBjzPjOJytp8J3ZIELlbkP73AT1WOh9mg85IcJejuMttHQuarLEUH5fIwBCukylirBM
	 fHmVs1Pt/vqMoJ2n3d3PSr0170JT4QnwO2WAOOhKnwdsyzPI+Llt5XfAaqD304/HQXMjW
	 7vUQybena2Z/Zmj2NepbPv3ghpqt8G5fn/UO/LvG7yZgn2XF1td6XbsVDTvMuhmrbLeBF
	 VLdK8qW+krfPrq9ps9cxkK4+ffEVL9qw1XVaWmqXrspSaI614J27Inmv47LdD30MyXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.uni-tuebingen.de;
	spf=pass smtp.mailfrom=student.uni-tuebingen.de;
	dkim=pass header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=PxHzAkHh;
	arc=none smtp.remote-ip=134.2.5.213
Received: from mx03.uni-tuebingen.de (mx03.uni-tuebingen.de [134.2.5.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB2E606A327;
	Tue,  3 Nov 2026 14:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BB2E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=PxHzAkHh
Received: from localhost.localdomain (u-251-c108.eap.uni-tuebingen.de [134.2.251.108])
	by mx03.uni-tuebingen.de (Postfix) with ESMTPSA id 5547120C4D72;
	Tue,  3 Nov 2026 15:27:19 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx03.uni-tuebingen.de 5547120C4D72
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-tuebingen.de;
	s=20211202prod; t=1793716039;
	bh=ccATpapPbTgEfZ1P+cWb/MajiGhbQxL2uaUWAgOO/tE=;
	h=From:To:Cc:Subject:Date:From;
	b=PxHzAkHh/fmxvyEjMmGb+SpJtcHersuWjrVBHdYD8SS4DBV5s02E2pCYgZENrigkF
	 f2Asc5YAKjqDkbOqtbXQNCaEn+jKbxgKsCZULQ2gW5VsrHzzEIFumw2mebHa0tJsIE
	 MiM14lygy372a7O0x0KbQA522laVKee6Exlh+qtCnvtMXmvUf31Or6EELNOqUX5W0U
	 htBUXNFmWLow5euXWpXb1nfKiQQ7nLu5EuAVGiBfNWkk99K9nbx/piUVdTrAZ/IyWb
	 OBFYrGg9Jq2cxIIhwBDGoTNguSAgiv+ml9O59eBt9KoO9O8BufUds6/T5YJRT7fAd9
	 J1YJQC+fTmhVw==
From: 0z5a <dezhen.lu@student.uni-tuebingen.de>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>,
	stable@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation for pages >= 4G
Date: Tue,  3 Nov 2026 15:27:09 +0100
Message-ID: <20261103142709.66179-1-dezhen.lu@student.uni-tuebingen.de>
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

