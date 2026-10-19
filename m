Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47B3DEAE3
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 05:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792386455; cv=none; b=ZJ1nDgf04bFTPv7bNbci7HAd/j1tv/gc99yywZ08CtY4D484JM+qiqnygIwDJql6EGU09oXlicgS83km0kbUr/E+t9SZVmN+oQS4PFM0pfUWQ6fGZKjhVEUaA1BAVVuryTr6Ngs3DrMsgMoxoxgl2fh++frA99dIZlI7UTb5FoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792386455; c=relaxed/simple;
	bh=TXByOWQCV/7eMLylbB3vZyVyvnBxCGdpkEtiBJ8HIws=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CFIgBrbZlwLYiyusCXd5yDc6RQC838pBbFeCxFZaIgZK+3EV69xps6sfae9OK8p6Dk5aqQmS5IxwGwXeuXYtmXPN45MNHq30hE445Y7veDjRmcqQPGQp8g4lMNU2ZtbOxjR3IoTv7kmxhq8GE1TE3bh5T0YTKF9ADmxI3PsBTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=GJM8b4tL; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="GJM8b4tL"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Eli
 Cohen <eli@dev.mellanox.co.il>, Roland Dreier <roland@purestorage.com>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v3] RDMA/mlx5: Fix CQ resize destination index mask
Date: Mon, 19 Oct 2026 13:05:03 +0800
Message-ID: <20261019050503.2313-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc7.internal.baidu.com (172.31.3.17) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1792386311;
	bh=aDfPN9ktqxgHZE9ycW2UF8f5j5mWePyVnripHfV0ctc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=GJM8b4tL9SleA0kZj9VGvoLV6bh52Z8KnKBO3+T+EWmK/ZdChmA/UAaaZ8tl+tP4G
	 CPXB+2NNCCvt2vFV03V2pBl57kep1wa+Zx4+66rkSQ1j57UH6rPnGgSO2KeMrBULGL
	 EJXSPHHZ71m/wjSh6QQRF+MD7P69vqJ6u3AhkrHl4FO0+FwI02iuzIIqqHWOMCkUja
	 mJxah0uTXN3ap192X/Gd7Mb5nTNwAs1xMPkccAzy3m9GHhhrB6lS3gWYxLNBsei20N
	 SC/HndPMhuppg3VIO4zV0pcGI+0NCkGqQLd/dcYe9s77EEfL1iEyXzbzyoj0G7UFxl
	 +LNrmCoEwiBQA==

From: Li RongQing <lirongqing@baidu.com>

In copy_resize_cqes, the destination CQE index is computed as
(i + 1) & cq->resize_buf->nent, but resize_buf->nent is produced by
roundup_pow_of_two(), so it is a power of two with exactly one bit set.
Masking with a single-bit value can only yield 0 or nent itself. The
buffer has nent entries, so valid indices are 0 .. nent - 1 and nent is
one past the last slot; whenever the masked result is nent the following
memcpy writes one entry out of bounds.

Use (nent - 1) as the wrap mask instead. For a power-of-two nent,
(i + 1) & (nent - 1) is the correct modulo-nent reduction, keeping the
index within [0, nent - 1]. This matches get_sw_cqe(), which addresses
the CQ buffer via n & cq->ibcq.cqe, where cq->ibcq.cqe == entries - 1 is
exactly the nent - 1 wrap mask.

Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Changes in v3:
 Restore the v1 implementation, using (nent - 1) as the wrap mask.

Changes in v2:
 Use modulo (%) instead of a bitmask to wrap the destination CQE index.

 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index dc457fa..3ade85d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1319,7 +1319,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.9.4

