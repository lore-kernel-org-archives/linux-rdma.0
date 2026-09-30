Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 243871E1A3D;
	Wed, 30 Sep 2026 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790730412; cv=none; b=COpKfj3VLDXdytHiQRqs333TiKZY7LMoEI9CKXsS7ZNj6OVAG0oDw5/2q4h5OyKQ/hMLmoCVfDgGC5LmT9/RAijAwaoo21/tJhIPDy7xd8QRA6QijgfY32UQAtCG6FrSp0krGHDWLcfBtJqRmj1rrwCdXEu0coDubSMgVxOX3Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790730412; c=relaxed/simple;
	bh=uapeVomnLxNxJLHUaPzS6XmUPUbQYfYIGHZE0ZTcqYo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IxeqhqaYCws9F7Z49S1balvn7+ziKTabW/IjQQ/A6uYJY67fPTCXUmncgqEM5vAwGobEZVzt0+UKnkJDQVeQEiaS5GNjQxIYKqPlXLN3GQ//Fi68dMdPbOvIwSqosFIrdyY6jVotUgwpZf4ufbUBANPKKK8JglY9d+joeOBy0uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=L/uwWo7Y; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="L/uwWo7Y"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Eli
 Cohen <eli@dev.mellanox.co.il>, Roland Dreier <roland@purestorage.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] RDMA/mlx5: Fix destination index when resizing a CQ
Date: Wed, 30 Sep 2026 09:06:30 +0800
Message-ID: <20260930010630.2797-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc12.internal.baidu.com (172.31.3.22) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1790730400;
	bh=40if35n6NlVqKY9auMBmOLh12IWT5zUWspmcFV67IMM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=L/uwWo7YnRd3YUxoEhnJ4GvsgoLrXOjkptiHrMBNtRgfcM1Fwxybt1IzJFtk/+i4y
	 09W/47VNZghmyHSzFhGKdKNAak1aptb3Op/CMU/k0fyEQKBxk9YHuyhP2OSGG2wL9h
	 b2vpDMLurQlN/QymZZIfN+YVrt6ff1jBY4D4PFOj4YQKWWrPexT1050j5vGieldmPs
	 +Mk+iFd3YOTPxuavCzonj8kKjQ+/Krz7qLY2AtCfwLflyJ0xB0zkMFzNdkc+AOuCoo
	 jYMlBdiAyMn/oZo55idkgLj0HQfQyfkykC4f+QOBy6+byOWvwe1evbpD5wma79Tj0f
	 4Midpk/+D5kIA==

From: Li RongQing <lirongqing@baidu.com>

copy_resize_cqes() uses the absolute consumer index to copy pending
CQEs into the resized CQ buffer. The destination slot must wrap at
resize_buf->nent, but the code applies a bitwise AND with nent itself.

CQ sizes are rounded up to a power of two, so nent has only one bit
set. Masking with nent therefore produces either zero or nent instead
of an index in the range [0, nent). When it produces nent,
mlx5_frag_buf_get_wqe() accesses one entry beyond the resized CQ buffer
and the following memcpy() can corrupt memory.

Use modulo nent to calculate the destination slot and keep it within
the resized CQ.

Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: replace & with %

 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index dc457fa..fc4ee1c 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1319,7 +1319,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) % cq->resize_buf->nent);
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.9.4

