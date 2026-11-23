Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415252;
	b=ch5KwtXR91/9G8FbqlCo9mEBuB2IyCqZkvIpo0YI2fL71M7N54tUfzqwqRcYU7XQAHol
	 YlxMYuK3MYA4qowA1BXblY8vEY4JM3DQUTjBtG/l9GQIPoArYWuXkYzRBR2hyIehrPVVw
	 9+EJQCX4CpREzWlwxQPX8SVFZFbnwef9/YYH+mjt63OD7BivxobyfAJnmKSDsiqsyPnXw
	 JY7oPpsmBQcUnvtRGvIH5mP4Q0ib6YU3Xp+I2kRyOGIZV2A1DpZtOsEJqPd0eLhQIr6y0
	 7Ti6YpZwBJwOHQerwbiL9w8+0R7zDdb8B/FID7IfSegD6pX5Lv+qOYQ1Qfd6DYvw5vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415252;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-Originating-IP:X-CM-SenderInfo;
	bh=L5Q9oIOcaOtMe8TZNV9p5sp1Kzg2vsNigmrFS0WpWbc=;
	b=jF4+KOy8NioSY3ELSXg3HL5OWN4s9OeQ0ycN6Fxgb1oa4Vr4JTPjO0RW+qTxVwAerop6
	 i3zYtbaUVw0Ru7aaDr0vHxsTZMv4kDuxLV+hvX7/NNA5Hxv0vMGc7G02cNAxF1NvxgJ6l
	 6TkJzJnxudCeUagFabtnaAylCU3lyFuZEKdw6o4xRoLnjeWBtZTAOsPWDGWZ/EmDI/2nh
	 k1SQDtfBK3iDXzWO+5jiu/6QInX+4qBP1Lserhl5VCJsYJWun+xKxWjv1IRwdFvg45h1y
	 N7qT1ZgQMvJcnCqQwci5mgwtlGHkbNBxTgEQ6qePlXbvgV2RXrj4APbvZf1V2A/K3YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LW9VL1cL;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204C606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5204C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LW9VL1cL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=L5Q9oIOcaOtMe8TZNV9p5sp1Kzg2vsNigmrFS0WpWbc=;
	b=LW9VL1cLExMkXY5/E8VOKZkIzik8dUJoCMr+oKoNi43a4LrHFlmnIKkFhHsnJY
	QvJxu+ZRQGjIiDyaQ3T47C2DmvsVCq4QIfPXnyD4CQQfCo5bXcRZSoDX6wc+PJtO
	uvojVaRhKF9MPMXbyUvBKN6IdRgPyjBkgR2xf1qu8yWzg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDHH0O73ANr_5LVHg--.57762S2;
	Mon, 23 Nov 2026 14:27:08 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH] RDMA/mlx5: Remove redundant kernel CQ resize code
Date: Mon, 23 Nov 2026 14:26:41 +0800
Message-Id: <20261123062641.1964605-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDHH0O73ANr_5LVHg--.57762S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtF4xGr43urWDCw48Kw15Jwb_yoW3GFW7pa
	y3J3W5Kr4UGFy8WrsYkrZ0qws8KwsYy3yqqrW0y34fJ3s8JrsxtF4rKryIvFWrtryDWry2
	yrsrXwnYkr45XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRqYLQUUUUU=
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7RwCoWsD3LwWWAAA3U

Commit ce68351be075 ("RDMA: Clarify that CQ resize is a user‑space
verb") made resize operation only used for user-space. Thus some
data structure is redundant and some code is dead code.

Remove redundant code to simplify the resize function.

Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 176 ++++-----------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 -
 2 files changed, 22 insertions(+), 155 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 55ffd7d4de51..9baec6071a18 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -74,11 +74,6 @@ static void *get_cqe(struct mlx5_ib_cq *cq, int n)
 	return mlx5_frag_buf_get_wqe(&cq->buf.fbc, n);
 }
 
-static u8 sw_ownership_bit(int n, int nent)
-{
-	return (n & nent) ? 1 : 0;
-}
-
 static void *get_sw_cqe(struct mlx5_ib_cq *cq, int n)
 {
 	void *cqe = get_cqe(cq, n & cq->ibcq.cqe);
@@ -478,17 +473,8 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	rmb();
 
 	opcode = get_cqe_opcode(cqe64);
-	if (unlikely(opcode == MLX5_CQE_RESIZE_CQ)) {
-		if (likely(cq->resize_buf)) {
-			free_cq_buf(dev, &cq->buf);
-			cq->buf = *cq->resize_buf;
-			kfree(cq->resize_buf);
-			cq->resize_buf = NULL;
-			goto repoll;
-		} else {
-			mlx5_ib_warn(dev, "unexpected resize cqe\n");
-		}
-	}
+	if (unlikely(opcode == MLX5_CQE_RESIZE_CQ))
+		mlx5_ib_warn(dev, "unexpected resize cqe\n");
 
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
 	if (!*cur_qp || (qpn != (*cur_qp)->trans_qp.base.mqp.qpn)) {
@@ -1263,83 +1249,6 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	return 0;
 }
 
-static int resize_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
-			 int entries, int cqe_size)
-{
-	int err;
-
-	cq->resize_buf = kzalloc_obj(*cq->resize_buf);
-	if (!cq->resize_buf)
-		return -ENOMEM;
-
-	err = alloc_cq_frag_buf(dev, cq->resize_buf, entries, cqe_size);
-	if (err)
-		goto ex;
-
-	init_cq_frag_buf(cq->resize_buf);
-
-	return 0;
-
-ex:
-	kfree(cq->resize_buf);
-	return err;
-}
-
-static int copy_resize_cqes(struct mlx5_ib_cq *cq)
-{
-	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
-	struct mlx5_cqe64 *scqe64;
-	struct mlx5_cqe64 *dcqe64;
-	void *start_cqe;
-	void *scqe;
-	void *dcqe;
-	int ssize;
-	int dsize;
-	int i;
-	u8 sw_own;
-
-	ssize = cq->buf.cqe_size;
-	dsize = cq->resize_buf->cqe_size;
-	if (ssize != dsize) {
-		mlx5_ib_warn(dev, "resize from different cqe size is not supported\n");
-		return -EINVAL;
-	}
-
-	i = cq->mcq.cons_index;
-	scqe = get_sw_cqe(cq, i);
-	scqe64 = ssize == 64 ? scqe : scqe + 64;
-	start_cqe = scqe;
-	if (!scqe) {
-		mlx5_ib_warn(dev, "expected cqe in sw ownership\n");
-		return -EINVAL;
-	}
-
-	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
-		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & (cq->resize_buf->nent - 1));
-		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
-		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
-		memcpy(dcqe, scqe, dsize);
-		dcqe64->op_own = (dcqe64->op_own & ~MLX5_CQE_OWNER_MASK) | sw_own;
-
-		++i;
-		scqe = get_sw_cqe(cq, i);
-		scqe64 = ssize == 64 ? scqe : scqe + 64;
-		if (!scqe) {
-			mlx5_ib_warn(dev, "expected cqe in sw ownership\n");
-			return -EINVAL;
-		}
-
-		if (scqe == start_cqe) {
-			pr_warn("resize CQ failed to get resize CQE, CQN 0x%x\n",
-				cq->mcq.cqn);
-			return -ENOMEM;
-		}
-	}
-	++cq->mcq.cons_index;
-	return 0;
-}
-
 int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		      struct ib_udata *udata)
 {
@@ -1352,9 +1261,9 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	__be64 *pas;
 	unsigned int page_offset_quantized = 0;
 	unsigned int page_shift;
+	unsigned long page_size;
 	int inlen;
 	int cqe_size;
-	unsigned long flags;
 
 	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
 		pr_info("Firmware does not support resize CQ\n");
@@ -1372,34 +1281,21 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		return 0;
 
 	mutex_lock(&cq->resize_mutex);
-	if (udata) {
-		unsigned long page_size;
-
-		err = resize_user(dev, cq, entries, udata, &cqe_size);
-		if (err)
-			goto ex;
-
-		page_size = mlx5_umem_find_best_cq_quantized_pgoff(
-			cq->resize_umem, cqc, log_page_size,
-			MLX5_ADAPTER_PAGE_SHIFT, page_offset, 64,
-			&page_offset_quantized);
-		if (!page_size) {
-			err = -EINVAL;
-			goto ex_resize;
-		}
-		npas = ib_umem_num_dma_blocks(cq->resize_umem, page_size);
-		page_shift = order_base_2(page_size);
-	} else {
-		struct mlx5_frag_buf *frag_buf;
+	err = resize_user(dev, cq, entries, udata, &cqe_size);
+	if (err)
+		goto ex;
 
-		cqe_size = 64;
-		err = resize_kernel(dev, cq, entries, cqe_size);
-		if (err)
-			goto ex;
-		frag_buf = &cq->resize_buf->frag_buf;
-		npas = frag_buf->npages;
-		page_shift = frag_buf->page_shift;
+	page_size = mlx5_umem_find_best_cq_quantized_pgoff(cq->resize_umem,
+							   cqc, log_page_size,
+							   MLX5_ADAPTER_PAGE_SHIFT,
+							   page_offset, 64,
+							   &page_offset_quantized);
+	if (!page_size) {
+		err = -EINVAL;
+		goto ex_resize;
 	}
+	npas = ib_umem_num_dma_blocks(cq->resize_umem, page_size);
+	page_shift = order_base_2(page_size);
 
 	inlen = MLX5_ST_SZ_BYTES(modify_cq_in) +
 		MLX5_FLD_SZ_BYTES(modify_cq_in, pas[0]) * npas;
@@ -1411,11 +1307,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	}
 
 	pas = (__be64 *)MLX5_ADDR_OF(modify_cq_in, in, pas);
-	if (udata)
-		mlx5_ib_populate_pas(cq->resize_umem, 1UL << page_shift, pas,
-				     0);
-	else
-		mlx5_fill_page_frag_array(&cq->resize_buf->frag_buf, pas);
+	mlx5_ib_populate_pas(cq->resize_umem, 1UL << page_shift, pas, 0);
 
 	MLX5_SET(modify_cq_in, in,
 		 modify_field_select_resize_field_select.resize_field_select.resize_field_select,
@@ -1441,31 +1333,10 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	if (err)
 		goto ex_alloc;
 
-	if (udata) {
-		cq->ibcq.cqe = entries - 1;
-		ib_umem_release(cq->buf.umem);
-		cq->buf.umem = cq->resize_umem;
-		cq->resize_umem = NULL;
-	} else {
-		struct mlx5_ib_cq_buf tbuf;
-		int resized = 0;
-
-		spin_lock_irqsave(&cq->lock, flags);
-		if (cq->resize_buf) {
-			err = copy_resize_cqes(cq);
-			if (!err) {
-				tbuf = cq->buf;
-				cq->buf = *cq->resize_buf;
-				kfree(cq->resize_buf);
-				cq->resize_buf = NULL;
-				resized = 1;
-			}
-		}
-		cq->ibcq.cqe = entries - 1;
-		spin_unlock_irqrestore(&cq->lock, flags);
-		if (resized)
-			free_cq_buf(dev, &tbuf);
-	}
+	cq->ibcq.cqe = entries - 1;
+	ib_umem_release(cq->buf.umem);
+	cq->buf.umem = cq->resize_umem;
+	cq->resize_umem = NULL;
 	mutex_unlock(&cq->resize_mutex);
 
 	kvfree(in);
@@ -1476,10 +1347,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 
 ex_resize:
 	ib_umem_release(cq->resize_umem);
-	if (!udata) {
-		free_cq_buf(dev, cq->resize_buf);
-		cq->resize_buf = NULL;
-	}
+	cq->resize_umem = NULL;
 ex:
 	mutex_unlock(&cq->resize_mutex);
 	return err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d..3d9532143c84 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -583,7 +583,6 @@ struct mlx5_ib_cq {
 	/* protect resize cq
 	 */
 	struct mutex		resize_mutex;
-	struct mlx5_ib_cq_buf  *resize_buf;
 	struct ib_umem	       *resize_umem;
 	int			cqe_size;
 	struct list_head	list_send_qp;
-- 
2.25.1

