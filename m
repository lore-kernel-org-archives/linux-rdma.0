Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D909E3B42F2
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635530; cv=none; b=ep4Zjjycsgf02uxeNQrm2A1swgDVKuJPHE1jitr0sqh7hftA0KByzUQxBYO++5+p00MH/TSiWVkklVCqxqAYqjPf6dsn3X3OuEO+gWnvjoRTfG7mCFGjNl0NlmO/kv6TdBk9GAS8CJUZP/A5dWyLdctKm48Q7aeE29sEx1fSTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635530; c=relaxed/simple;
	bh=AU7rKR9kVFjjgxCSo7G51qONy3OYnrZXclyW6OIJDiE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z8R/GWcehCnNKZuq1ZpC5OoSy2Ye3wfuzu9zaTupVYN2vEqrt8Phq3C/bTO1ePgSkiQ0hpGO5jKVXw9qx8FL0d1Ex0cPHdAUoEWKESB3RveOPnw3+GBIBfoK7zIQ+E5VkvOXrySNCLAiPrdeYdJJeGKfj3I6uYqWKEOmDHrxeIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=LSxpgTKY; arc=none smtp.client-ip=220.181.3.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="LSxpgTKY"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Maor
 Gottlieb <maorg@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Thu, 17 Sep 2026 16:54:19 +0800
Message-ID: <20260917085419.1792-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc3.internal.baidu.com (172.31.3.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789635267;
	bh=M2h6AjnAuCTHWGEPimy4x3l5rrAc59S3hQwn0ggeYM4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=LSxpgTKYYl7rqIVRor5kv3j50+7L81zNrYHEAbsaXoJAt+A8/gbj4JgBrtirG2HIL
	 xfFITtjIzobZJikW/G5A2HJL2heZy+3rKNs2JQ9qk4ec+v5/cge0SNllZpd4S+rxCq
	 5jzq+8VBaqSDXG+QDM5CEprDdXLmufeTlQ2ewbvRHqKSwc6kJuwcg5YullI1WdWjjW
	 yu7DcnZhbbnN7ptwr/JoPzANJtm6Su0vP6FEBBJai4+rRLJs2G4aMm2UV3nA0PwErb
	 4fJ40OI/3T457EUyDIbya5gEXzTKX1Rahl+eO2uvkzpGAApUiBFutRYtI/z/fDBTaD
	 i34PIYWCWL/FA==

From: Li RongQing <lirongqing@baidu.com>

The steering anchor resources are shared between anchors with the same
priority and are protected by rule_goto_table_ref.

When steering anchor creation succeeds but uverbs_copy_to() fails, the
error path drops the reference acquired for the new anchor. However, it
unconditionally calls mlx5_steering_anchor_destroy_res(), even when
other anchors are still using the shared resources.

This can destroy the shared flow table, flow groups, and rules while
existing anchors still hold references to them, resulting in a
use-after-free when those anchors are subsequently cleaned up.

Only destroy the shared resources when dropping the reference makes
rule_goto_table_ref zero, consistent with the existing cleanup path.

Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steering anchor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index e27826c..034ab55 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3056,8 +3056,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	return 0;
 
 destroy_res:
-	--ft_prio->anchor.rule_goto_table_ref;
-	mlx5_steering_anchor_destroy_res(ft_prio);
+	if (!--ft_prio->anchor.rule_goto_table_ref)
+		mlx5_steering_anchor_destroy_res(ft_prio);
 put_flow_table:
 	put_flow_table(dev, ft_prio, true);
 free_obj:
-- 
2.9.4

