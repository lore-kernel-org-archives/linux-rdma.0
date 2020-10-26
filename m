Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC21EC55178
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6FF2463C
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603718809;
	bh=cJ7n2feNsFLBiYZWwvMdbfFPSxrBI/OATA69ri+W2hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k4oSf/D8UmzgF2I6Sm5euk+idSl/T39Rt3JD4+dqahFr9PjYgz4P4NTJJoGgRMAb/
	 cj23zsQBsAd/WdBOfrY0IYDXGtRIwM8DGLfN25th0F+eOJTjr3yL+RaclYLPFTLnpI
	 Z/d/1qScmdUVKQZUKx67B5UIg74VwlOYP7KrZYaE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769750AbgJZN0s (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769503AbgJZN0s (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:26:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B884207DE;
        Mon, 26 Oct 2020 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603718807;
        bh=cJ7n2feNsFLBiYZWwvMdbfFPSxrBI/OATA69ri+W2hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsieHTPqTHeOxM1shbhssThLy617uVloX1smEfDNoIVohGvJ+NpNcJvihBIpbLpHD
         mcEtQL3que+Yh730q7Fk0Tg6ZEhLOZWJQHBaHmEubcf/jr869urXQ8eV5y+iFWFB5h
         aL8qG2TdK8+q8oTUyVCkDQaemYBzCFsv/ekidJ50=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 2/6] RDMA/mlx5: Use ib_umem_find_best_pgoff() for SRQ
Date:   Mon, 26 Oct 2020 15:26:31 +0200
Message-Id: <20201026132635.1337663-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026132635.1337663-1-leon@kernel.org>
References: <20201026132635.1337663-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

SRQ uses a quantized and scaled page_offset, which is another variation of
ib_umem_find_best_pgsz(). Add mlx5_umem_find_best_quantized_pgoff() to
perform this calculation for each mailbox. A macro shows how the
calculation is directly connected to the mailbox format.

This new routine replaces the limited mlx5_ib_cont_pages() and
mlx5_ib_get_buf_offset() pairing which would reject valid configurations
rather than adjust the page_size to make it work.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mem.c     | 45 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 15 ++++++++++
 drivers/infiniband/hw/mlx5/srq.c     | 20 ++++++-------
 3 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 92e7621ec858..9f8f9e55bceb 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -107,6 +107,51 @@ void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 	}
 }
 
+/*
+ * Compute the page shift and page_offset for mailboxes that use a quantized
+ * page_offset. The granulatity of the page offset scales according to page
+ * size.
+ */
+unsigned long __mlx5_umem_find_best_quantized_pgoff(
+	struct ib_umem *umem, unsigned long pgsz_bitmap,
+	unsigned int page_offset_bits, u64 pgoff_bitmask, unsigned int scale,
+	unsigned int *page_offset_quantized)
+{
+	const u64 page_offset_mask = (1 << page_offset_bits) - 1;
+	unsigned long page_size;
+	u64 page_offset;
+
+	page_size = ib_umem_find_best_pgoff(umem, pgsz_bitmap, pgoff_bitmask);
+	if (!page_size)
+		return 0;
+
+	/*
+	 * page size is the largest possibile page size.
+	 *
+	 * Reduce the page_size, and thus the page_offset and quanta, until the
+	 * page_offset fits into the mailbox field. Once page_size < scale this
+	 * loop is guaranteed to terminate.
+	 */
+	page_offset = ib_umem_dma_offset(umem, page_size);
+	while (page_offset & ~(u64)(page_offset_mask * (page_size / scale))) {
+		page_size /= 2;
+		page_offset = ib_umem_dma_offset(umem, page_size);
+	}
+
+	/*
+	 * The address is not aligned, or otherwise cannot be represented by the
+	 * page_offset.
+	 */
+	if (!(pgsz_bitmap & page_size))
+		return 0;
+
+	*page_offset_quantized =
+		(unsigned long)page_offset / (page_size / scale);
+	if (WARN_ON(*page_offset_quantized > page_offset_mask))
+		return 0;
+	return page_size;
+}
+
 int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
 {
 	u64 page_size;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a31daf7253be..769a0b0738cd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -91,6 +91,21 @@ __mlx5_page_offset_to_bitmask(unsigned int page_offset_bits,
 		__mlx5_page_offset_to_bitmask(                                 \
 			__mlx5_bit_sz(typ, page_offset_fld), 0))
 
+unsigned long __mlx5_umem_find_best_quantized_pgoff(
+	struct ib_umem *umem, unsigned long pgsz_bitmap,
+	unsigned int page_offset_bits, u64 pgoff_bitmask, unsigned int scale,
+	unsigned int *page_offset_quantized);
+#define mlx5_umem_find_best_quantized_pgoff(umem, typ, log_pgsz_fld,           \
+					    pgsz_shift, page_offset_fld,       \
+					    scale, page_offset_quantized)      \
+	__mlx5_umem_find_best_quantized_pgoff(                                 \
+		umem,                                                          \
+		__mlx5_log_page_size_to_bitmap(                                \
+			__mlx5_bit_sz(typ, log_pgsz_fld), pgsz_shift),         \
+		__mlx5_bit_sz(typ, page_offset_fld),                           \
+		GENMASK(31, order_base_2(scale)), scale,                       \
+		page_offset_quantized)
+
 enum {
 	MLX5_IB_MMAP_OFFSET_START = 9,
 	MLX5_IB_MMAP_OFFSET_END = 255,
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index dd6e42d3d175..898a6cac023a 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -51,8 +51,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 		udata, struct mlx5_ib_ucontext, ibucontext);
 	size_t ucmdlen;
 	int err;
-	int page_shift;
-	u32 offset;
+	unsigned int page_offset_quantized;
+	unsigned int page_size;
 	u32 uidx = MLX5_IB_DEFAULT_UIDX;
 
 	ucmdlen = min(udata->inlen, sizeof(ucmd));
@@ -85,22 +85,22 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 		return err;
 	}
 
-	mlx5_ib_cont_pages(srq->umem, ucmd.buf_addr, 0, &page_shift);
-	err = mlx5_ib_get_buf_offset(ucmd.buf_addr, page_shift,
-				     &offset);
-	if (err) {
+	page_size = mlx5_umem_find_best_quantized_pgoff(
+		srq->umem, srqc, log_page_size, MLX5_ADAPTER_PAGE_SHIFT,
+		page_offset, 64, &page_offset_quantized);
+	if (!page_size) {
 		mlx5_ib_warn(dev, "bad offset\n");
 		goto err_umem;
 	}
 
-	in->pas = kvcalloc(ib_umem_num_dma_blocks(srq->umem, 1UL << page_shift),
+	in->pas = kvcalloc(ib_umem_num_dma_blocks(srq->umem, page_size),
 			   sizeof(*in->pas), GFP_KERNEL);
 	if (!in->pas) {
 		err = -ENOMEM;
 		goto err_umem;
 	}
 
-	mlx5_ib_populate_pas(srq->umem, 1UL << page_shift, in->pas, 0);
+	mlx5_ib_populate_pas(srq->umem, page_size, in->pas, 0);
 
 	err = mlx5_ib_db_map_user(ucontext, udata, ucmd.db_addr, &srq->db);
 	if (err) {
@@ -108,8 +108,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 		goto err_in;
 	}
 
-	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
-	in->page_offset = offset;
+	in->log_page_size = order_base_2(page_size) - MLX5_ADAPTER_PAGE_SHIFT;
+	in->page_offset = page_offset_quantized;
 	in->uid = (in->type != IB_SRQT_XRC) ?  to_mpd(pd)->uid : 0;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
-- 
2.26.2

