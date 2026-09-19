Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830EF3B52EE
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812921; cv=none; b=qtDi+KPEPrJdsow/xnyzifDU6FuZMT5MrdlvXPQzjsYK2V9raZR2/mDwmDSfvrYQQMBGI4te5o6yU4hobVq0saMBCM0uxO7hbHCo7LaGT4TK/Vxa2PNE1d9btuPvPfWQh3mftk5e8iZqH3olkmikredkNnHNbxmtrMa3KycEjys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812921; c=relaxed/simple;
	bh=shgvDmPKsjcmSlI0MOtrnNmu6ia/4EAbsIaM6SYKlW0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=URZX84oI07N95sOScej/yWMlZQ0vZPb2VNVCu+eOYq7l5n6dfyNuDj1s76aJxn2k0CHVFAxdpPZVQTnysZ8UPkKf9ytrHUuDPT/CQrSmiBPiYz/PkFbxKeMUFDWk3E8alp9SKRUpA3PLAu4qK1zSadq7CIoeYfxk0Yfj0VIyRkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=DKaAsnrU; arc=none smtp.client-ip=220.181.3.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="DKaAsnrU"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Sat, 19 Sep 2026 18:08:48 +0800
Message-ID: <20260919100848.2442-1-lirongqing@baidu.com>
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
	s=selector1; t=1789812538;
	bh=aD3piTCvX2VEuWrsU728PVN6KFTWqKMJXFV/3wF//bk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=DKaAsnrUI6zJQAubSKwTd8gFuI3Q6N5VqcFXfJNZ1ESavnqIMsRUhYhDD+QAn9/Qt
	 ELLjWkVCmfWIYaDf5d2ivQVxhtQJCaAVpGJl5m86lz+/ZifGPyO6RWvWN3uRBMulaK
	 iM/hofH/DNa8OunAqQMhqN3Ev14K/hHBrRe2xQFpd2Q+9a6aRwA9DQzilzPWA589Fp
	 1hzKGVOPHOfPU28Kl/c+sw50oU3z1/oH/2af9Ke9pvgrr52y17A+N7rZEHmE4Twwm5
	 rmUXUg3XJlSC6fcn/CRO3jCOfn7IgtRhLCgZXZDD9yuHwqpFVxK5grYHH4oKP7bDFz
	 AZ+lQLZkDkxfQ==

From: Li RongQing <lirongqing@baidu.com>

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index fca9e1d..bb2c603 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -927,6 +927,7 @@ static noinline_for_stack int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.9.4

