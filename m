Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 32677459AE7
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812462; cv=none; b=AIyFjuyBNXg0AuHDpqof9P0qPDpe9mZrnTXKjcqmL5ASh/+9zauet8Lv8pWoRwQ6rHeFpEL7u252I4K85wgLmsf6xe6bKX5CI94riN9NhsNj71adov5JvTb3jhrNIDmXXQ0aTxSSVXEPQT7xCo8HIK9GSu60FPDNJobrMCl/dNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812462; c=relaxed/simple;
	bh=gcWfYM+J+BcrXIQ6gNv5E/D31yOl31mzR+OAwaH/8Ws=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eEVDhfFIIQHfYKNQGMjSBiHuVrCszBXQ/Wp1fpLfODKVyt+oIqZSKCiAU6eVDpmNR85/Y+65mSqWeHf0VLetkOSUuwrLlu+i4O7jrzFJoSXXXjNVFZAiF+vzspjt/inNNyXKLZbWWzv342F/TwrmNSt6LMALKQWBC8afzeIevFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=Bsai6/DA; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="Bsai6/DA"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Fix CQ resize destination index mask
Date: Sat, 19 Sep 2026 18:07:16 +0800
Message-ID: <20260919100716.2221-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc7.internal.baidu.com (172.31.50.51) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789812445;
	bh=yFpjNfEig+9fu/2pTz7OZF4HX80466Z45zDNG6Dx1YE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=Bsai6/DABzN5nwMJne76axNYhUqE0OmRxLmYcFcq0HK9JBZkZy8T/JCZK+Geyoj43
	 URCNdtDertmvTP4l2kO5l83DeX+ZW7zMsyZgia+w9hqMFBqQTzuh1LBzUBRCY+iHqo
	 e9v0qO1suNPfv/M+h7uk7fuDn2rUyrGnVbY/QAp+UzhXaH+6Km1KKXzW0t9DUQroLM
	 Pd+DVAXn5+2ej3RUk8Ir8/cfM/qI2TXnL86nAvRsdttQNeaXzcJhKsE4FCns8tfj2n
	 Gg3LaLpv/CAXqR4g0Zt6nbzsTCQWnqaV7PomczCK1mP/VF98Puo4/M5w/tQjkkCVqE
	 LZKIBnmPmodfw==

From: Li RongQing <lirongqing@baidu.com>

In copy_resize_cqes, the destination CQE index is computed as
(i + 1) & cq->resize_buf->nent, but resize_buf->nent is the power-of-two
entry count, so the mask only yields 0 or nent -- and nent is one past the
last valid slot. The following memcpy then writes out of bounds.

Use (nent - 1) as the wrap mask, consistent with get_sw_cqe which masks
against cq->ibcq.cqe (the nent - 1 value).

Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b0b1177..5bd5227 100644
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

