Received: from outbound.baidu.com (mx13.baidu.com [220.181.3.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 5878B3F86FB
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789812510; cv=none; b=DDL0tx4954QI6A9lax052WcC7LzqSu2hQ4/ZpUKJgJitJ/rfJuScYb9bxb3LVCVTItONneb6UIbKpTrwnoC/PNfOnscmhF3WUBwD31Ws5LajuVZ5Byq15teCq9qRONbzKqhkFOjnpyWfcMsiArv3G3zIS5SKVLbbNzU87ZV2i2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789812510; c=relaxed/simple;
	bh=fUiA5QMN4Z0xbRQ7UX/h/N794Ccbx82D1zdVIbvZxCg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j6VjkMpHkkskGTYJmARgzGlw+9BI37KNYIlkZa2PJ4UM9686wlfTtrrR8JUm8VqG9b4qTA1RB29cykXJNuxii9GF1Y0BQZWsjJhs4dAeyoJtqn6iojk7ysxwTVAU4DihVKTTCnvbzfMl3lOSj7M83SrPTbS50/TNcCRmYaKN4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=N4iKAVWG; arc=none smtp.client-ip=220.181.3.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="N4iKAVWG"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Check SIG_ERR CQE mkey lookup before dereferencing
Date: Sat, 19 Sep 2026 18:08:06 +0800
Message-ID: <20260919100806.2320-1-lirongqing@baidu.com>
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
	s=selector1; t=1789812494;
	bh=r38Gbf9CsabjDZRIdhtVt2BpYH7eOkFjXmlKOlCCeG8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=N4iKAVWGML8w6/YhzpoHNeQdV5b2Ccj64vzV+LYGKHCFA8ZwIw74lTpWTXFUHq9dz
	 TvCF/T9sc68JjQ2C/agVVYFOCM9KS9vRQw2XABpLgvnMv51XW5oTvT6/pAe6IpEZxZ
	 pwAmMXip9GtwUzcbzn1HVo8q4xz6k//3oaHNtOjKQ2DrmBNeNwFhoWTAV1R+JStQ62
	 NU9ZkwJ9Pe5VRP8kquCumopN40bNRMkt81rKKlQ1meJFfXFihpAE66O48Z4Knfzuti
	 FwEfU2qEfcxaHSqEh4dYt4OL3pb4Hplgk65iA1Uod1LLt2RaxXHv0cn3yIqid7rQP3
	 lTjW5Si9+KfPA==

From: Li RongQing <lirongqing@baidu.com>

In mlx5_poll_one, a MLX5_CQE_SIG_ERR completion looks up the signature
context in dev->sig_mrs via xa_load() but dereferences the result without
a NULL check. If the corresponding MR has been concurrently deregistered
(which removes the xarray entry without holding the CQ lock), xa_load()
returns NULL and the subsequent get_sig_err_item(sig_err_cqe, &sig->err_item)
crashes in atomic context under xa_lock.

Add a NULL check that drops the lock, logs a warning, and repolls.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 49b4bf1..b0b1177 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -563,6 +563,13 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 		xa_lock(&dev->sig_mrs);
 		sig = xa_load(&dev->sig_mrs,
 				mlx5_base_mkey(be32_to_cpu(sig_err_cqe->mkey)));
+		if (!sig) {
+			xa_unlock(&dev->sig_mrs);
+			mlx5_ib_warn(dev, "CQN: 0x%x Got SIGERR on unknown mkey: 0x%x\n",
+				     cq->mcq.cqn,
+				     be32_to_cpu(sig_err_cqe->mkey));
+			goto repoll;
+		}
 		get_sig_err_item(sig_err_cqe, &sig->err_item);
 		sig->sig_err_exists = true;
 		sig->sigerr_count++;
-- 
2.9.4

