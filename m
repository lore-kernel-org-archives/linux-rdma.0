Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5128D3E6DC3;
	Sat, 13 Jun 2026 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781365169; cv=none; b=bdVlWObMaLmRUFYUou8GlPgow6lHyJrsKvQYTA65e/OmpG555EHGSp9CXVKCKQLbl1F6zRQNqL/LfQVfOx639oIAcBws25pplJtwdK/mXEEvnTuVd/tba5rmg3hnkejaBTe/lkT2ilzquHE1Lvqu89gPyjqJMruEDqYQ7DdD4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781365169; c=relaxed/simple;
	bh=wK9nd7hGDITrzN771wJwUfFBO0Kqaf23UTKlXZLLWEo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AUF+1/cs+AwmBQcSai7c5vzN1YDu4FUcigIuvjsyluisHeEhQ/jDflGAUm3BVP40uMt5Qy9LL9fkfjZN+oWCmbNaNoDnlCW09yvfATE1KdvdkyxRo7+Xynu1IVIyaasAQGzr6GuAv3qIqHzuy19VAod2YFlHDy11qrpYV59yshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=TFUV1jbv; arc=none smtp.client-ip=111.202.115.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="TFUV1jbv"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] net/mlx5: Fix wrong register access in mlx5_query_mtppse()
Date: Sat, 13 Jun 2026 23:36:54 +0800
Message-ID: <20260613153654.1810-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1781365027;
	bh=1aM+qwEa/lPgurpfZKYSK4XhUTnqYDz39XEwr1nvZR8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=TFUV1jbvl90S5PeP07bvs279UrWib31VTpIZriLw37hZcFqzL76pQLmIR/sMMSsr1
	 FxWoqlokJp4bY6IHSvscduTLR9Rldn6q+flNRJoJmMlTwwHmY4h8VGPk8fOKaqOk8p
	 XDr+QwUEzMB9Vbj6sOyxY1Eg1V9U4x5ab4Dhu3CTENqp4u0M7cXEJRLCgQoPaMemtx
	 YV1/nnG5tJzqeMadGyKWtAphZwx4gFiAE1W2e+WvtUKOESeh7xTHBptiHtoISZmJwQ
	 gOlf6WWug85Rb5QpuZA7+SOoMYrWnxCsYrXQ+rDMi2BQcU7bMNKuM0ZWem30K2ZhDT
	 YFazKO/gZEOKg==

From: Li RongQing <lirongqing@baidu.com>

In mlx5_query_mtppse(), the result of mtppse_reg query should be read
from the output buffer 'out', not the input buffer 'in'. The function
currently reads event_arm and event_generation_mode from 'in', which
contains the uninitialized query parameters rather than the actual
register values.

Fix by reading from the correct buffer 'out'.

Fixes: f9a1ef720e9e ("net/mlx5: Add MTPPS and MTPPSE registers infrastructure")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index ee8b976..2ab6a6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -921,8 +921,8 @@ int mlx5_query_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 *arm, u8 *mode)
 	if (err)
 		return err;
 
-	*arm = MLX5_GET(mtppse_reg, in, event_arm);
-	*mode = MLX5_GET(mtppse_reg, in, event_generation_mode);
+	*arm = MLX5_GET(mtppse_reg, out, event_arm);
+	*mode = MLX5_GET(mtppse_reg, out, event_generation_mode);
 
 	return err;
 }
-- 
2.9.4

